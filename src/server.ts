import express, { Request, Response } from 'express';
import 'dotenv/config';
import {
    PrismaClient,
    RedditPost,
    YoutubeComment,
    YoutubeVideo,
} from '@prisma/client';
import cors from 'cors';
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);

type PostSaveResult =
    | { status: 'success'; data: RedditPost }
    | { status: 'error'; error: string; data: any };

type YTSaveVideoResult =
    | { status: 'success'; data: YoutubeVideo }
    | { status: 'error'; error: string; data: any };

type YTSaveCommentResult =
    | { status: 'success'; data: YoutubeComment }
    | { status: 'error'; error: string; data: any };

const results: PostSaveResult[] = [];

const prisma = new PrismaClient();
const NODE_SERVER_PORT = process.env.NODE_SERVER_PORT;

const app = express();

app.use(express.json({ limit: 52428800 }));

app.use(express.json());
app.use(cors());


app.get('/', (req: Request, res: Response) => {
    console.log('Server is up.');
    res.send('Server is up.');
});

app.post('/saveToxicity', async (req: Request, res: Response) => {
    const { queryId, toxicityScore } = req.body;

    if (typeof queryId !== 'number' || typeof toxicityScore !== 'number') {
        return res.status(400).json({ error: 'Invalid request data.' });
    }

    try {
        const updatedQuery = await prisma.query.update({
            where: {
                id: queryId,
            },
            data: {
                toxicityRatio: toxicityScore,
            },
        });
        console.log("Updated Toxicity for Query: " + queryId + ", with Toxicity: " + toxicityScore);
        res.status(200).json(updatedQuery);
    } catch (error) {
        console.error(`Failed to save toxicity score for query ID: ${queryId}`, error);
        res.status(500).json({ error: 'Failed to save the toxicity score.' });
    }
});

app.get('/redditDailyCounts', async (req: Request, res: Response) => {
    console.log("Reddit Graph Count Hit.");
    const queries = await prisma.query.findMany({
        where: {
            id: {
                gte: 184
            }
        },
        include: {
            redditPosts: true
        },
        orderBy: {
            id: 'asc'
        }
    });

    let chunkedCounts: { [key: number]: number } = {};

    queries.forEach(query => {
        const chunkIndex = Math.floor((query.id - 184) / 50);
        if (!chunkedCounts[chunkIndex]) {
            chunkedCounts[chunkIndex] = 0;
        }
        chunkedCounts[chunkIndex] += query.redditPosts.length;
    });

    const labels = Object.keys(chunkedCounts).map(key => {
        const numericKey = parseInt(key);
        return `Queries ${184 + numericKey * 50}-${183 + (numericKey + 1) * 50}`;
    });
    const data = Object.values(chunkedCounts);
    res.send({
        data: data,
        labels: labels,
    })

    // res.send(`
    //     <html>
    //         <head>
    //             <title>Reddit Daily Counts</title>
    //             <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    //             <style>
    //                 body, html {
    //                     margin: 0;
    //                     height: 80%;
    //                     display: flex;
    //                     justify-content: center;
    //                     align-items: center;
    //                 }
    //                 #redditDailyChart {
    //                     width: 75%;
    //                     height: 75%;
    //                 }
    //             </style>
    //         </head>
    //         <body>
    //             <canvas id="redditDailyChart"></canvas>
    //             <script>
    //                 const ctx = document.getElementById('redditDailyChart').getContext('2d');
    //                 const labels = ${JSON.stringify(labels)};
    //                 const data = ${JSON.stringify(data)};

    //                 new Chart(ctx, {
    //                     type: 'bar',
    //                     data: {
    //                         labels: labels,
    //                         datasets: [{
    //                             label: 'Number of Reddit Posts per Query Block',
    //                             data: data,
    //                             backgroundColor: 'orange',
    //                             borderColor: 'orange',
    //                             borderWidth: 1
    //                         }]
    //                     },
    //                     options: {
    //                         scales: {
    //                             y: {
    //                                 beginAtZero: true
    //                             }
    //                         },
    //                         responsive: true,
    //                         maintainAspectRatio: false
    //                     }
    //                 });
    //             </script>
    //         </body>
    //     </html>
    // `);
});

app.get('/redditCommentsDailyCounts', async (req: Request, res: Response) => {
    // get all queries greater than or equal to 184
    let queries = await prisma.query.findMany({
        where: {
            id: {
                gte: 184,
            }
        },
        include: {
            redditPosts: {
                select: {
                    post: {
                        select: {
                            _count: {
                                select: {
                                    comments: true
                                }
                            }
                        }
                    }
                },
            }
        },
    });

    let chunkedCounts: { [key: number]: number } = {};

    for (let query of queries) {
        let commentsCount = 0;
        for (let queryOnRedditPost of query.redditPosts) {
            commentsCount += queryOnRedditPost.post._count.comments;
        }

        commentsCount += commentsCount;


        const chunkIndex = Math.floor((query.id - 184) / 50);

        if (!chunkedCounts[chunkIndex]) {
            chunkedCounts[chunkIndex] = 0;
        }

        chunkedCounts[chunkIndex] += commentsCount;
    }

    const labels = Object.keys(chunkedCounts).map(key => {
        const numericKey = parseInt(key);
        return `Queries ${184 + numericKey * 50}-${183 + (numericKey + 1) * 50}`;
    });

    const data = Object.values(chunkedCounts);

    res.send(`
        <html>
            <head>
                <title>Reddit Comments Daily Counts</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    body, html {
                        margin: 0;
                        height: 80%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    #redditDailyChart {
                        width: 100%;
                        height: 100%;
                    }
                </style>
            </head>
            <body>
                <canvas id="redditDailyChart"></canvas>
                <script>
                    const ctx = document.getElementById('redditDailyChart').getContext('2d');
                    const labels = ${JSON.stringify(labels)};
                    const data = ${JSON.stringify(data)};

                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Number of Reddit Comments per Query Block',
                                data: data,
                                backgroundColor: 'orange',
                                borderColor: 'orange',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            },
                            responsive: true,
                            maintainAspectRatio: false
                        }
                    });
                </script>
            </body>
        </html>
    `);
}
);



app.get('/youtubeDailyCounts', async (req: Request, res: Response) => {
    const queries = await prisma.query.findMany({
        where: {
            id: {
                gte: 184
            }
        },
        include: {
            youtubeVideos: true
        },
        orderBy: {
            id: 'asc'
        }
    });

    let chunkedCounts: { [key: number]: number } = {};

    queries.forEach(query => {
        const chunkIndex = Math.floor((query.id - 184) / 50);
        if (!chunkedCounts[chunkIndex]) {
            chunkedCounts[chunkIndex] = 0;
        }
        chunkedCounts[chunkIndex] += query.youtubeVideos.length;
    });

    const labels = Object.keys(chunkedCounts).map(key => {
        const numericKey = parseInt(key);
        return `Queries ${184 + numericKey * 50}-${183 + (numericKey + 1) * 50}`;
    });
    const data = Object.values(chunkedCounts);

    res.send({
        data: data,
        labels: labels,
    })

    // res.send(`
    //     <html>
    //         <head>
    //             <title>YouTube Daily Counts</title>
    //             <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    //             <style>
    //                 body, html {
    //                     margin: 0;
    //                     height: 80%;
    //                     display: flex;
    //                     justify-content: center;
    //                     align-items: center;
    //                 }
    //                 #redditDailyChart {
    //                     width: 100%;
    //                     height: 100%;
    //                 }
    //             </style>
    //         </head>
    //         <body>
    //             <canvas id="youtubeDailyChart"></canvas>
    //             <script>
    //                 const ctx = document.getElementById('youtubeDailyChart').getContext('2d');
    //                 const labels = ${JSON.stringify(labels)};
    //                 const data = ${JSON.stringify(data)};

    //                 new Chart(ctx, {
    //                     type: 'bar',
    //                     data: {
    //                         labels: labels,
    //                         datasets: [{
    //                             label: 'Number of Youtube Posts per Query Block',
    //                             data: data,
    //                             backgroundColor: 'red',
    //                             borderColor: 'red',
    //                             borderWidth: 1
    //                         }]
    //                     },
    //                     options: {
    //                         scales: {
    //                             y: {
    //                                 beginAtZero: true
    //                             }
    //                         },
    //                         responsive: true,
    //                         maintainAspectRatio: false
    //                     }
    //                 });
    //             </script>
    //         </body>
    //     </html>
    // `);
    console.log("YouTube Graph Count Hit.");
});

app.get('/youtubeCommentsDailyCounts', async (req: Request, res: Response) => {
    // get all queries greater than or equal to 184
    const queries = await prisma.query.findMany({
        where: {
            id: {
                gte: 184
            }
        },
        select: {
            id: true,
            youtubeVideos: {
                select: {
                    video: {
                        select: {
                            _count: {
                                select: {
                                    comments: true
                                }
                            }
                        }
                    },
                }
            }
        },
        orderBy: {
            id: 'asc'
        }
    });

    let chunkedCounts: { [key: number]: number } = {};

    for (let query of queries) {
        let commentsCount = 0;
        for (let queryOnYoutubeVideo of query.youtubeVideos) {
            commentsCount += queryOnYoutubeVideo.video._count.comments;
        }

        const chunkIndex = Math.floor((query.id - 184) / 50);

        if (!chunkedCounts[chunkIndex]) {
            chunkedCounts[chunkIndex] = 0;
        }

        chunkedCounts[chunkIndex] += commentsCount;
    }

    const labels = Object.keys(chunkedCounts).map(key => {
        const numericKey = parseInt(key);
        return `Queries ${184 + numericKey * 50}-${183 + (numericKey + 1) * 50}`;
    });

    const data = Object.values(chunkedCounts);

    console.log(chunkedCounts);

    res.send(`
        <html>
            <head>
                <title>YouTube Comments Daily Counts</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    body, html {
                        margin: 0;
                        height: 80%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    #redditDailyChart {
                        width: 100%;
                        height: 100%;
                    }
                </style>
            </head>
            <body>
                <canvas id="youtubeDailyChart"></canvas>
                <script>
                    const ctx = document.getElementById('youtubeDailyChart').getContext('2d');
                    const labels = ${JSON.stringify(labels)};
                    const data = ${JSON.stringify(data)};

                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Number of Youtube Comments per Query Block',
                                data: data,
                                backgroundColor: 'red',
                                borderColor: 'red',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            },
                            responsive: true,
                            maintainAspectRatio: false
                        }
                    });
                </script>
            </body>
        </html>
    `);
});

// make an endpoint that shows a line graph of the total number of posts over time
app.get('/redditTotalCounts', async (req: Request, res: Response) => {
    const queries = await prisma.query.findMany({
        where: {
            id: {
                gte: 184
            }
        },
        select: {
            id: true,
            redditPosts: {
                select: {
                    post: {
                        select: {
                            crawledAt: true
                        }
                    }
                }
            }
        },
        orderBy: {
            id: 'asc'
        }
    });

    let chunkedCounts: { [key: number]: number } = {};

    queries.forEach(query => {
        const chunkIndex = Math.floor((query.id - 184) / 50);
        if (!chunkedCounts[chunkIndex]) {
            chunkedCounts[chunkIndex] = 0;
        }
        chunkedCounts[chunkIndex] += query.redditPosts.length;
    });

    const labels = Object.keys(chunkedCounts).map(key => {
        const numericKey = parseInt(key);
        return `Queries ${184 + numericKey * 50}-${183 + (numericKey + 1) * 50}`;
    });
    const data = Object.values(chunkedCounts);

    res.send(`
        <html>
            <head>
                <title>Reddit Total Counts</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    body, html {
                        margin: 0;
                        height: 80%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    #redditDailyChart {
                        width: 100%;
                        height: 100%;
                    }
                </style>
            </head>
            <body>
                <canvas id="redditDailyChart"></canvas>
                <script>
                    const ctx = document.getElementById('redditDailyChart').getContext('2d');
                    const labels = ${JSON.stringify(labels)};
                    const data = ${JSON.stringify(data)};

                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Number of Reddit Posts per Query Block',
                                data: data,
                                backgroundColor: 'orange',
                                borderColor: 'orange',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            },
                            responsive: true,
                            maintainAspectRatio: false
                        }
                    });
                </script>
            </body>
        </html>
    `);
    console.log("Reddit Graph Count Hit.");
}
);

app.get('/redditCommentsDailyCounts', async (req: Request, res: Response) => {
    // get all queries greater than or equal to 184
    const queries = await prisma.query.findMany({
        where: {
            id: {
                gte: 184
            }
        },
        include: {
            redditPosts: true
        },
        orderBy: {
            id: 'asc'
        }
    });

    let chunkedCounts: { [key: number]: number } = {};

    for (let query of queries) {
        let commentsCount = 0;
        for (let queryOnRedditPost of query.redditPosts) {
            // get each post
            let posts = await prisma.redditPost.findMany({
                where: {
                    id: queryOnRedditPost.postId
                },
                include: {
                    comments: true
                }
            });

            for (let post of posts) {
                commentsCount += post.comments.length;
            }
        }

        const chunkIndex = Math.floor((query.id - 184) / 50);

        if (!chunkedCounts[chunkIndex]) {
            chunkedCounts[chunkIndex] = 0;
        }

        chunkedCounts[chunkIndex] += commentsCount;
    }

    const labels = Object.keys(chunkedCounts).map(key => {
        const numericKey = parseInt(key);
        return `Queries ${184 + numericKey * 50}-${183 + (numericKey + 1) * 50}`;
    });

    const data = Object.values(chunkedCounts);

    res.send(`
        <html>
            <head>
                <title>Reddit Comments Daily Counts</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    body, html {
                        margin: 0;
                        height: 80%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    #redditDailyChart {
                        width: 100%;
                        height: 100%;
                    }
                </style>
            </head>
            <body>
                <canvas id="redditDailyChart"></canvas>
                <script>
                    const ctx = document.getElementById('redditDailyChart').getContext('2d');
                    const labels = ${JSON.stringify(labels)};
                    const data = ${JSON.stringify(data)};

                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Number of Reddit Comments per Query Block',
                                data: data,
                                backgroundColor: 'orange',
                                borderColor: 'orange',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            },
                            responsive: true,
                            maintainAspectRatio: false
                        }
                    });
                </script>
            </body>
        </html>
    `);
});

app.post('/redditPosts', async (req: Request, res: Response) => {
    const { query, posts, num_posts, crawled_at } = req.body;
    // console.log(req.body)

    if (posts.length !== num_posts) {
        return res.status(400).json({
            error: 'Mismatch between num_posts and actual number of posts.',
        });
    }

    console.log(query.id);

    const results: PostSaveResult[] = [];
    for (let post of posts) {
        // console.log(post)
        try {
            const savedPost = await prisma.redditPost.upsert({
                where: { redditId: post.data.name },
                update: {
                    subredditId: post.data.subreddit_id,
                    author: post.data.author,
                    authorFullname: post.data.author_fullname,
                    title: post.data.title,
                    textContent: post.data.selftext,
                    ups: post.data.ups,
                    downs: post.data.downs,
                    upvoteRatio: post.data.upvote_ratio,
                    totalAwardsReceived: post.data.total_awards_received,
                    score: post.data.score,
                    viewCount: post.data.view_count,
                    linkFlairText: post.data.link_flair_text,
                    subredditSubscribers: post.data.subreddit_subscribers,
                    over18: post.data.over_18,
                    createdAt: post.data.created,
                    url: post.data.url,
                    domain: post.data.domain,
                    isArchived: post.data.archived,
                    isVideo: post.data.is_video,
                    permalink: post.data.permalink,
                    numComments: post.data.num_comments,
                    media: post.data.media?.toString(),
                    crawledAt: new Date(),
                    queries: {
                        create: {
                            queryId: query.id,
                        },
                    },
                },
                create: {
                    redditId: post.data.name,
                    subredditId: post.data.subreddit_id,
                    author: post.data.author,
                    authorFullname: post.data.author_fullname,
                    title: post.data.title,
                    textContent: post.data.selftext,
                    ups: post.data.ups,
                    downs: post.data.downs,
                    upvoteRatio: post.data.upvote_ratio,
                    totalAwardsReceived: post.data.total_awards_received,
                    score: post.data.score,
                    viewCount: post.data.view_count,
                    linkFlairText: post.data.link_flair_text,
                    subredditSubscribers: post.data.subreddit_subscribers,
                    over18: post.data.over_18,
                    createdAt: post.data.created,
                    url: post.data.url,
                    domain: post.data.domain,
                    isArchived: post.data.archived,
                    isVideo: post.data.is_video,
                    permalink: post.data.permalink,
                    numComments: post.data.num_comments,
                    media: post.data.media?.toString(),
                    crawledAt: new Date(),
                    queries: {
                        create: {
                            queryId: query.id,
                        },
                    },
                },
            });

            // console.log(savedPost);
            results.push({ status: 'success', data: savedPost });

            // console.log(results);
        } catch (error) {
            console.log(
                `Failed to save post ${post.data.id} with subreddit id ${post.data.subreddit_id}`,
            );

            if (error instanceof Error) {
                results.push({
                    status: 'error',
                    error: error.message,
                    data: post,
                });
            } else {
                results.push({
                    status: 'error',
                    error: 'Unknown error',
                    data: post,
                });
            }
        }
    }

    res.status(200).json({ results, crawled_at });
});

app.post('/subreddit', async (req: Request, res: Response) => {
    try {
        console.log(req.body.title);
        const subreddit = await prisma.subreddit.upsert({
            where: { name: req.body.name },
            update: {
                displayName: req.body.display_name,
                title: req.body.title,
                publicDescription: req.body.public_description,
                subscribers: req.body.subscribers,
                activeUserCount: req.body.active_user_count,
                created: req.body.created,
                description: req.body.description,
                url: req.body.url,
                bannerImg: req.body.banner_img,
                communityIcon: req.body.community_icon,
                over18: req.body.over18,
                lang: req.body.lang,
                whitelistStatus: req.body.whitelist_status,
                subredditType: req.body.subreddit_type,
                headerImg: req.body.header_img,
                iconImg: req.body.icon_img,
                crawledAt: new Date(),
            },
            create: {
                displayName: req.body.display_name,
                title: req.body.title,
                publicDescription: req.body.public_description,
                subscribers: req.body.subscribers,
                activeUserCount: req.body.active_user_count,
                name: req.body.name,
                created: req.body.created,
                description: req.body.description,
                url: req.body.url,
                bannerImg: req.body.banner_img,
                communityIcon: req.body.community_icon,
                over18: req.body.over18,
                lang: req.body.lang,
                whitelistStatus: req.body.whitelist_status,
                subredditType: req.body.subreddit_type,
                headerImg: req.body.header_img,
                iconImg: req.body.icon_img,
                crawledAt: new Date(),
            },
        });
        res.status(200).json(subreddit);
    } catch (error) {
        res.status(500).json({ error: 'Failed to save the subreddit.' });
    }
});

app.post('/subredditBatch', async (req: Request, res: Response) => {
    const names = req.body.names;
    if (!req.body.names || req.body.names.length === 0) {
        return res.status(400).json({ error: 'Subreddit names are required.' });
    }
    try {
        for (let subredditJson of names) {
            try {
                const subreddit = await prisma.subreddit.upsert({
                    where: {
                        displayName: subredditJson.display_name,
                    },
                    update: {
                        title: subredditJson.title,
                        publicDescription: subredditJson.public_description,
                        subscribers: subredditJson.subscribers,
                        activeUserCount: subredditJson.active_user_count,
                        name: subredditJson.name,
                        created: subredditJson.created,
                        description: subredditJson.description,
                        url: subredditJson.url,
                        bannerImg: subredditJson.banner_img,
                        communityIcon: subredditJson.community_icon,
                        over18: subredditJson.over18,
                        lang: subredditJson.lang,
                        whitelistStatus: subredditJson.whitelist_status,
                        subredditType: subredditJson.subreddit_type,
                        headerImg: subredditJson.header_img,
                        iconImg: subredditJson.icon_img,
                        crawledAt: new Date(),
                    },
                    create: {
                        displayName: subredditJson.display_name,
                        title: subredditJson.title,
                        publicDescription: subredditJson.public_description,
                        subscribers: subredditJson.subscribers,
                        activeUserCount: subredditJson.active_user_count,
                        name: subredditJson.name,
                        created: subredditJson.created,
                        description: subredditJson.description,
                        url: subredditJson.url,
                        bannerImg: subredditJson.banner_img,
                        communityIcon: subredditJson.community_icon,
                        over18: subredditJson.over18,
                        lang: subredditJson.lang,
                        whitelistStatus: subredditJson.whitelist_status,
                        subredditType: subredditJson.subreddit_type,
                        headerImg: subredditJson.header_img,
                        iconImg: subredditJson.icon_img,
                        crawledAt: new Date(),
                    },
                });
                res.status(200).json({ message: 'all good' });
            } catch (error) {
                continue;
            }
        }
    } catch (error) {
        res.status(500).json({ error: 'Failed to save the subreddit.' });
    }
});

app.get('/isSubredditIndexed', async (req: Request, res: Response) => {
    const { name } = req.query;

    if (!name) {
        return res.status(400).json({ error: 'Subreddit name is required.' });
    }

    try {
        const subreddit = await prisma.subreddit.findUnique({
            where: {
                displayName: name as string,
            },
        });

        console.log(subreddit ? 'subreddit exists' : "subreddit doesn't exist");
        console.log(name);
        if (subreddit) {
            res.status(200).json({ isIndexed: true });
        } else {
            res.status(200).json({ isIndexed: false });
        }
    } catch (error) {
        res.status(500).json({ error: 'Internal server error.' });
    }
});

app.post('/checkSubredditsIndexed', async (req: Request, res: Response) => {
    const names: string[] = req.body.names;

    // if (!names || names.length === 0) {
    //     return res.status(400).json({ error: 'Subreddit names are required.' });
    // }

    try {
        const indexedSubreddits = await prisma.subreddit.findMany({
            where: {
                displayName: {
                    in: names,
                },
            },
        });

        const indexedNames = indexedSubreddits.map((s) => s.displayName);
        const nonIndexedNames = names.filter(
            (name) => !indexedNames.includes(name),
        );

        res.status(200).json({ nonIndexed: nonIndexedNames });
    } catch (error) {
        res.status(500).json({ error: 'Internal server error.' });
    }
});

app.post('/youtubeVideo', async (req: Request, res: Response) => {
    try {
        const video = await prisma.youtubeVideo.create({
            data: {
                videoId: req.body.id,
                title: req.body.title,
                description: req.body.description,
                publishedAt: req.body.published_at,
                channelId: req.body.channel_id,
                channelTitle: req.body.channel_title,
                crawledAt: new Date(req.body.crawled_at),
            },
        });
        res.status(200).json(video);
    } catch (error) {
        res.status(500).json({ error: 'Failed to save the video.' });
    }
});

// endpoint for youtubeVideos
app.post('/youtubeVideos', async (req: Request, res: Response) => {
    const { query, videos, numVideos, crawledAt } = req.body;

    if (videos.length !== numVideos) {
        return res.status(400).json({
            error: 'Mismatch between num_videos and actual number of videos.',
        });
    }

    const results: YTSaveVideoResult[] = [];
    for (let video of videos) {
        try {
            const savedVideo = await prisma.youtubeVideo.upsert({
                where: { videoId: video.id.videoId },
                update: {
                    title: video.snippet.title,
                    description: video.snippet.description,
                    publishedAt: video.snippet.publishedAt,
                    channelId: video.snippet.channelId,
                    channelTitle: video.snippet.channelTitle,
                    crawledAt: crawledAt,
                    queries: {
                        create: {
                            queryId: query.id,
                        },
                    },
                },
                create: {
                    videoId: video.id.videoId,
                    title: video.snippet.title,
                    description: video.snippet.description,
                    publishedAt: video.snippet.publishedAt,
                    channelId: video.snippet.channelId,
                    channelTitle: video.snippet.channelTitle,
                    crawledAt: crawledAt,
                    queries: {
                        create: {
                            queryId: query.id,
                        },
                    },
                },
            });
            results.push({ status: 'success', data: savedVideo });
        } catch (error) {
            if (error instanceof Error) {
                results.push({
                    status: 'error',
                    error: error.message,
                    data: video,
                });
            } else {
                results.push({
                    status: 'error',
                    error: 'Unknown error',
                    data: video,
                });
            }
        }
    }
    console.log(results);
    res.send('Success, saved ' + results.length + ' videos.');
});

app.post('/youtubeComments', async (req: Request, res: Response) => {
    const { comments, crawledAt, videoId, parentId } = req.body;

    console.error('PARENT ID: ' + parentId);

    const results: YTSaveCommentResult[] = [];

    for (let comment of comments) {
        try {
            const savedComment = await prisma.youtubeComment.upsert({
                where: { commentId: comment.id },
                update: {
                    crawledAt: crawledAt,
                    parentId: parentId || null,
                },
                create: {
                    commentId: comment.id,
                    videoId: videoId,
                    commenterId: comment.snippet.authorChannelId.value,
                    commenterName: comment.snippet.authorDisplayName,
                    commenterProfileImageUrl:
                        comment.snippet.authorProfileImageUrl,
                    textContent: comment.snippet.textOriginal,
                    textDisplay: comment.snippet.textDisplay,
                    publishedAt: comment.snippet.publishedAt,
                    likeCount: comment.snippet.likeCount,
                    crawledAt: crawledAt,
                    parentId: parentId || null,
                },
            });

            console.log('Saved comment:');
            console.log(savedComment);
            results.push({ status: 'success', data: savedComment });
        } catch (error) {
            if (error instanceof Error) {
                results.push({
                    status: 'error',
                    error: error.message,
                    data: comment,
                });
            } else {
                results.push({
                    status: 'error',
                    error: 'Unknown error',
                    data: comment,
                });
            }
        }
    }

    console.log(results);
    res.send('Success, saved ' + results.length + ' comments.');
});

app.post('/saveQuery', async (req: Request, res: Response) => {
    const { query, trackId, createdAt } = req.body.query;

    console.log(req.body.query);
    try {
        const savedQuery = await prisma.query.create({
            data: {
                trackId: trackId,
                query: query,
                createdAt: createdAt,
            },
        });

        console.log(savedQuery);
        res.status(200).json({ status: 'success', query: savedQuery });
    } catch (error) { }
});

app.post('/redditComments', async (req: Request, res: Response) => {
    // Extracting the necessary fields from the request body
    const { comments } = req.body;

    // Iterate over each comment in the request
    for (let comment of comments) {
        try {
            const savedComment = await prisma.redditComment.upsert({
                where: { redditId: comment.redditId },
                update: {
                    postId: comment.postId,
                    author: comment.author,
                    authorFullname: comment.authorFullname,
                    textContent: comment.textContent,
                    ups: comment.ups,
                    downs: comment.downs,
                    score: comment.score,
                    isArchived: comment.isArchived,
                    createdAt: comment.createdAt,
                    permalink: comment.permalink,
                    numReplies: comment.numReplies,
                    parentCommentId: comment.parentId,
                },
                create: {
                    redditId: comment.redditId,
                    postId: comment.postId,
                    author: comment.author,
                    authorFullname: comment.authorFullname,
                    textContent: comment.textContent,
                    ups: comment.ups,
                    downs: comment.downs,
                    score: comment.score,
                    isArchived: comment.isArchived,
                    createdAt: comment.createdAt,
                    permalink: comment.permalink,
                    numReplies: comment.numReplies,
                    parentCommentId: comment.parentId,
                },
            });

            results.push({ status: 'success', data: comment });

            console.log('Saved Reddit comment:');
        } catch (error) {
            console.log(
                `Error saving Reddit comment ${comment.redditId} with parentId ${comment.parentCommentId} and postId ${comment.postId}`,
            );
            // console.log(error);
        }
    }

    // console.log(results);
    res.status(200).json({
        message: 'Success, saved ' + results.length + ' comments.',
        results: results,
    });
});

app.listen(NODE_SERVER_PORT, () => {
    console.log(`Listening on port ${NODE_SERVER_PORT}.`);
});


app.get('/hello', async (req: Request, res: Response) => {
    res.json({
        message: "Hello"
    })
});