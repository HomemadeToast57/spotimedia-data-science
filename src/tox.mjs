import { PrismaClient } from '@prisma/client';
import axios from 'axios';

// Manually specify the connection details
const prisma = new PrismaClient({
    datasources: {
        mydb: {
            url: 'postgresql://postgres:postgres@spotimedia_db:5432/mydb?schema=public?connect_timeout=30&pool_timeout=30&socket_timeout=30'
        }
    }
});

async function testConnection() {
    try {
        const count = await prisma.query.count();
        console.log(`Successfully connected to the database. Record count: ${count}`);
        return true;
    } catch (error) {
        console.error('Failed to connect to the database:', error);
        return false;
    }
}

// async function fetchRedditPosts() {
//     return await prisma.query.findMany({
//         select: {
//             id: true,
//             query: true,
//             redditPosts: true,
//             // Include other fields from the Query model that you want to retrieve
//         }
//     });

//     console.log("Fetched posts");
// }

// async function fetchYoutubePosts() {
//     return await prisma.query.findMany({
//         select: {
//             id: true,
//             query: true,
//             youtubeVideos: true,
//             // Include other fields from the Query model that you want to retrieve
//         }
//     });

//     console.log("Fetched posts");
// }

async function assessToxicity(text, apiKey) {
    try {
        const data = {
            token: apiKey,
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

async function fetchQueries() {
    return await prisma.query.findMany({
        select: {
            id: true,
            query: true,
            redditPosts: {
                select: {
                    post: {
                        select: { 
                            textContent: true,
                            comments: {
                                select: { textContent: true }
                            }
                        }
                    }
                }
            },
            youtubeVideos: {
                select: {
                    video: {
                        select: { 
                            description: true,
                            comments: {
                                select: { textContent: true }
                            }
                        } 
                    }
                }
            }
        }
    });
}

async function calculateToxicityScoreForQuery(query, apiKey) {
    let toxicCount = 0;
    let itemCount = 0;

    // Process Reddit posts and their comments
    for (const redditPost of query.redditPosts) {
        // Assess the post
        if (redditPost.post.textContent) {
            const result = await assessToxicity(redditPost.post.textContent, apiKey);
            if (result && result.class === "flag") {
                toxicCount++;
            }
            itemCount++;
        }
        // Assess each comment
        for (const comment of redditPost.post.comments) {
            if (comment.textContent) {
                const result = await assessToxicity(comment.textContent, apiKey);
                console.log(result.class);
                if (result && result.class === "flag") {
                    toxicCount++;
                }
                itemCount++;
            }
        }
    }

    for (const youtubeVideo of query.youtubeVideos) {
        // Assess the video description
        if (youtubeVideo.video.description) {
            const result = await assessToxicity(youtubeVideo.video.description, apiKey);
            if (result && result.class === "flag") {
                toxicCount++;
            }
            itemCount++;
        }
        // Assess each comment
        for (const comment of youtubeVideo.video.comments) {
            if (comment.textContent) {
                const result = await assessToxicity(comment.textContent, apiKey);
                if (result && result.class === "flag") {
                    toxicCount++;
                }
                itemCount++;
            }
        }
    }

    // Calculate the toxicity score as the proportion of toxic content
    return itemCount > 0 ? toxicCount / itemCount : null;
}

    
async function main() {
    const queries = await fetchQueries();
    const apiKey = '9cdcc7071736c76cc32ce205690c13f4';
    // const toxic = await assessToxicity("why are we having all these people from shithole countries coming here", apiKey);
    // const toxic1 = await assessToxicity("The conservative punditocracy was always anti Trump.", apiKey);

    for (const query of queries) {
        const toxicityScore = await calculateToxicityScoreForQuery(query, apiKey);
        if(toxicityScore == null){
            console.log(`Query ID: ${query.id}\nQuery Name: ${query.query}\nAverage Toxicity Score: No Posts to Test on.\n\n`);
        }else{
            console.log(`Query ID: ${query.id}\nQuery Name: ${query.query}\nAverage Toxicity Score: ${toxicityScore}%\n\n`);
        }
    }
}

main()
    .catch(e => {
        throw e
    })
    .finally(async () => {
        await prisma.$disconnect()
    });
