import axios from 'axios';
import { stringify } from 'querystringify';
import Queue from 'bull';
import chalk from 'chalk';
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();
let allPostsSaved = [];

const searchUrl = 'https://oauth.reddit.com/search.json?sort=best';
const save_subreddit_url_batch = 'http://localhost:1234/subredditBatch';
const save_reddit_posts_url = 'http://localhost:1234/redditPosts';
const moderateAPIKey = '9cdcc7071736c76cc32ce205690c13f4';

const redditQueue = new Queue('reddit-search', 'redis://127.0.0.1:6379', {
    limiter: {
        max: 1,
        duration: 10000
    }
});

async function updateToxicityScore(queryId, toxicityScore) {
    const saveToxicityUrl = 'http://localhost:1234/saveToxicity'; // Adjust the URL if necessary

    try {
        const response = await axios.post(saveToxicityUrl, {
            queryId: queryId,
            toxicityScore: toxicityScore
        });

        if (response.status === 200) {
            console.log(`Updated toxicity score for query ID: ${queryId}`);
        } else {
            console.error(`Failed to update toxicity score for query ID: ${queryId}`);
        }
    } catch (error) {
        console.error(`Error updating toxicity score for query ID: ${queryId}`, error);
    }
}

async function assessToxicity(text) {
    try {
        const data = {
            token: moderateAPIKey,
            text: text
        };

        const response = await axios.post('https://api.moderatehatespeech.com/api/v1/moderate/', data, {
            headers: {
                'Content-Type': 'application/json'
            }
        });

        return response.data;
    } catch (error) {
        console.error('Error assessing toxicity:', error.response ? error.response.data : error);
        return null;
    }
}

redditQueue.on('failed', (job, err) => {
    console.error('Reddit Job failed:', job.id);
});

redditQueue.on('completed', (job, result) => {
    console.log('Reddit Job completed ID = ', job.id);
});

redditQueue.process(1, async (job) => {
    console.log('Processing Reddit job...' + job.id);
    const { access_token, query } = job.data;
    return await searchReddit(access_token, query);
});

async function authenticate(client_id, client_secret, username, password) {
    const auth_url = 'https://www.reddit.com/api/v1/access_token';
    const headers = {
        'Authorization': 'Basic ' + Buffer.from(client_id + ':' + client_secret).toString('base64'),
        'User-Agent': 'Program415/1.0 by /u/DisciplesOfZerksis',
        'Content-Type': 'application/x-www-form-urlencoded'
    };

    const data = stringify({
        grant_type: 'password',
        username: username,
        password: password
    });

    const response = await axios.post(auth_url, data, { headers });
    return response.data.access_token;
}

async function retrieveComments(access_token, post) {
    const headers = {
        'Authorization': `Bearer ${access_token}`,
        'User-Agent': 'Program415/1.0 by /u/DisciplesOfZerksis'
    };
    const commentsUrl = `https://oauth.reddit.com/r/${post.data.subreddit}/comments/${post.data.id}.json`;
    try {
        const response = await axios.get(commentsUrl, { headers });
        if (response.status === 200) {
            // Process top-level comments and their replies recursively
            return processComments(response.data[1].data.children);
        }
    } catch (err) {
        console.error(`Failed to retrieve comments for post ID: ${post.data.id}`, err);
    }
    return [];
}

function processComments(comments) {
    let processedComments = [];
    for (let comment of comments) {
        processedComments.push(comment.data);
        if (comment.data.replies) {
            processedComments.push(...processComments(comment.data.replies.data.children));
        }
    }
    return processedComments;
}


async function searchReddit(access_token, query) {
    const headers = {
        'Authorization': `Bearer ${access_token}`,
        'User-Agent': 'Program415/1.0 by /u/DisciplesOfZerksis'
    };
    let response;
    
    let limitPerQuery = 500;
    let currPostCount = 0;
    let after = -1;
    
    let posts = [];
    

    let toxicCount = 0;
    let itemCount = 0;
    while (after !== null && currPostCount < limitPerQuery) {
        
        const params = {
            q: query.query,
            limit: Math.min(100, limitPerQuery - currPostCount),
        };

        if (after === -1) {
            response = await axios.get(searchUrl, { headers, params });
        } else {
            response = await axios.get(`${searchUrl}&after=${after}`, { headers, params });
        }

        if (response.status === 429) {
            // wait a minute and try again
            console.log("Rate limited. Waiting 60 seconds...");
            await new Promise(resolve => setTimeout(resolve, 60000));
            continue;
        }   

        const data = response.data;
        posts = data.data.children;
        after = data.data.after;
        

        const subredditNames = posts.map(post => post.data.subreddit);

        const nonIndexedSubredditsResponse = await axios.post("http://localhost:1234/checkSubredditsIndexed", { names: subredditNames });
        const nonIndexedSubreddits = nonIndexedSubredditsResponse.data.nonIndexed;


        const subredditDataList = [];
        for (const subreddit of nonIndexedSubreddits) {
            const subreddit_url = `https://oauth.reddit.com/r/${subreddit}/about.json`;
            const subreddit_data = await axios.get(subreddit_url, { headers, params });
            if (subreddit_data.status === 200) {
                const subreddit_data_json = subreddit_data.data.data;
                subreddit_data_json.crawled_at = Math.floor(Date.now() / 1000);
                if (subreddit_data_json) {
                    subredditDataList.push(subreddit_data_json);
                }
            }
        }

        if (subredditDataList.length > 0) {
            console.log("Saving subreddits to database...");
            await axios.post(save_subreddit_url_batch, { names: subredditDataList });
        }

        // concat the set of the post ids to the set of all posts saved
        allPostsSaved = [...new Set([...allPostsSaved, ...posts.map(post => post.data.id)])];
        const payload = {
            query: query,
            posts: posts,
            num_posts: posts.length,
            crawled_at: Math.floor(Date.now() / 1000)
        };
        
        const save_posts_req = await axios.post(save_reddit_posts_url, payload);
        if (save_posts_req.status === 200) {
            console.log("Success! Saved a batch of posts!");
        }

        for (let post of posts) {
            // Retrieve comments for the post
            if (post.textContent) {
                const result = await assessToxicity(post.textContent);
                if (result && result.class === "flag") {
                    toxicCount++;
                }
                itemCount++;
            }

            let comments = await retrieveComments(access_token, post);

            // Prepare comments for saving
            const formattedComments = comments.map(comment => ({
                redditId: comment.name,
                postId: post.data.name,
                author: comment.author,
                authorFullname: comment.author_fullname,
                textContent: comment.body,
                ups: comment.ups,
                downs: comment.downs, // Assuming this field is available
                score: comment.score,
                isArchived: comment.archived,
                createdAt: comment.created_utc,
                permalink: comment.permalink,
                numReplies: comment.replies ? comment.replies.data.children.length : 0,
                parentId: comment.parent_id.split("_")[0] === "t3" ? null : comment.parent_id,
            }));

            // Save comments to the database
            try {
                await axios.post('http://localhost:1234/redditComments', { comments: formattedComments });
                console.log(`Saved comments for post ID ${post.data.name}`);
                for (const comment of formattedComments) {
                    if (comment.textContent) {
                        const result = await assessToxicity(comment.textContent);
                        if (result && result.class === "flag") {
                            toxicCount++;
                        }
                        itemCount++;
                    }
                }
            } catch (err) {
                console.error(`Error saving comments for post ID ${post.data.id}:`, err);
            }
        }

        currPostCount += posts.length;
    }

    const redditQueryToxicity = itemCount > 0 ? toxicCount / itemCount : 0
    //Save toxicity to endpoint
    await updateToxicityScore(query.id, redditQueryToxicity);
    console.log(redditQueryToxicity);
    return { numPosts: currPostCount };
}

const initializeRedditCrawler = async (query) => {
    const client_id = 'lVDgfk9fDrwttt11n1QSnQ';
    const client_secret = 'tiLPzOvStxUw38LEeRmm78rddC_djQ';
    const username = 'DisciplesOfZerksis';
    const password = 'CS415RedditCrawler';

    const access_token = await authenticate(client_id, client_secret, username, password);
    
    console.log(chalk.yellowBright(`Searching Reddit for: ${query.query}...`));

    let job = redditQueue.add({
        access_token: access_token,
        query: query,
    });

    return job;
}

export { initializeRedditCrawler };