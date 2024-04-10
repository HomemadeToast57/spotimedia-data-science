import axios from 'axios';
import Queue from 'bull';
import chalk from 'chalk';

const maxVideoResults = 100;
const maxCommentResults = 100;
let numUnits = 0;

const apiKey = 'XXX';

const baseUrl = 'https://www.googleapis.com/youtube/v3/';

const youtubeVideoQueue = new Queue(
    'youtube-video-search',
    'redis://127.0.0.1:6379',
    {
        limiter: {
            max: 1,
            duration: 300000,
        },
    },
);

youtubeVideoQueue.on('failed', (job, err) => {
    console.error('YouTube Job failed:', job.id);
});

youtubeVideoQueue.on('completed', (job, result) => {
    console.log('YouTube Job completed ID = ', job.id);
    console.log(`Current number of units used: ${numUnits}`);
});

youtubeVideoQueue.process(1, async (job) => {
    console.log('Processing YouTube job...' + job.id);
    const { query } = job.data;
    const searchResults = await searchVideos(query.query);

    if (searchResults.data.items.length > 0) {
        await saveVideos(searchResults, query);

        let videoInfoList = getVideoInfo(searchResults);

        for (let video of videoInfoList) {
            const commentsResponse = await getComments(video.id, apiKey);
            await saveComments(commentsResponse);

            console.log(`Comments fetched and saved for video: ${video.id}`);
        }

        return videoInfoList;
    } else {
        console.log('No videos found. (Or we messed up...)');
        return null;
    }
});

const searchVideos = async (query) => {
    let videosResponse = {
        data: {
            items: [],
        },
    };

    const searchUrl = `${baseUrl}search`;
    const params = {
        q: query,
        type: 'video',
        part: 'id,snippet',
        maxResults: maxVideoResults,
        key: apiKey,
    };

    try {
        const response = await axios.get(searchUrl, { params });
        numUnits += 100;

        videosResponse.data.items = response.data.items;
        return videosResponse;
    } catch (error) {
        console.error('Error searching videos:', error);
        return videosResponse;
    }
};

const getComments = async (videoId) => {
    let commentsResponse = {
        data: {
            items: [],
        },
        videoId: videoId,
    };

    let pageToken = '';
    let remaining = maxCommentResults;

    const fetchComments = async (pageToken) => {
        let params = {
            videoId: videoId,
            textFormat: 'plainText',
            order: 'relevance',
            part: 'id,replies,snippet',
            maxResults: remaining > 100 ? 100 : remaining, 
            key: apiKey,
            pageToken: pageToken,
        };

        let commentsUrl = `${baseUrl}commentThreads`;

        let response = await axios.get(commentsUrl, { params });
        numUnits += 1;
        return response.data;
    };

    try {
        do {
            let result = await fetchComments(pageToken);

            result.items.forEach((commentThread) => {
                commentsResponse.data.items.push(
                    commentThread.snippet.topLevelComment,
                );

                if (commentThread.replies && commentThread.replies.comments) {
                    commentThread.replies.comments.forEach((reply) => {
                        reply.snippet.parentId = commentThread.id; 
                        commentsResponse.data.items.push(reply);
                    });
                }
            });

            pageToken = result.nextPageToken;
            remaining -= result.pageInfo.resultsPerPage;
        } while (pageToken && remaining > 0);
    } catch (error) {
        console.error('Failed to fetch comments:', error.message);
    }

    return commentsResponse;
};

const saveVideos = async (videosResponse, query) => {
    const saveVideosURL = 'http://localhost:1234/youtubeVideos';

    const payload = {
        query: query,
        videos: videosResponse.data.items,
        numVideos: videosResponse.data.items.length,
        crawledAt: new Date(),
    };

    const response = await axios.post(saveVideosURL, payload);
    return response.data;
};

const saveComments = async (commentsResponse) => {
    const saveCommentsURL = 'http://localhost:1234/youtubeComments';

    const payload = {
        comments: commentsResponse.data.items,
        crawledAt: new Date(),
        videoId: commentsResponse.videoId,
    };

    const response = await axios.post(saveCommentsURL, payload);
    return response.data;
};

const getVideoInfo = (searchResults) => {
    const videoInfo = searchResults.data.items.map((item) => {
        return {
            id: item.id.videoId,
            title: item.snippet.title,
        };
    });
    return videoInfo;
};

const initializeYoutubeCrawler = async (query) => {
    console.log(chalk.red(`Searching YouTube for: ${query.query}...`));
    let job = await youtubeVideoQueue.add({ query });
    return job;
};

export { initializeYoutubeCrawler };

