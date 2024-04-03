#!/usr/bin/ts-node
import axios from 'axios';
import { getToken, getPlaylistTracks } from './spotify.mjs'
import { initializeRedditCrawler } from './reddit.mjs';
import { initializeYoutubeCrawler } from './youtube.mjs';
import dotenv from 'dotenv';
import chalk from 'chalk';
import Queue from 'bull';

dotenv.config();

const spotifyClientId = "8a4ea36d00e1499c946d713f64ea54d3";
const spotifyClientSecret = "82a441d2966844ac896060c5ad0cb775";

const crawlQueue = new Queue('crawler-queue', 'redis://127.0.0.1:6379');

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

const buildQuery = (song) => {
    const query = `${song.songName} ${song.artistName}`;
    return query;
};

const saveQuery = async (query) => {
    const url = "http://localhost:1234/saveQuery";
    try {
        const response = await axios.post(url, {query: query});
        return response.data.query.id;
    } catch (error) {
        console.error("Error saving query:", error);
        throw error;
    }
};

const initializeAllCrawlers = async () => {
    const spotifyToken = await getToken(spotifyClientId, spotifyClientSecret);
    const playlistId = '37i9dQZEVXbLRQDuF5jeBp';

    let songs = await getPlaylistTracks(spotifyToken, playlistId);
    songs = songs.slice(0, 3);
    
    for (let song of songs) {
        let query = {
            trackId: song.trackId,
            query: buildQuery(song),
            createdAt: new Date(),
        }

        query.id = await saveQuery(query);  
        console.log(chalk.blue(`Initializing crawler for ${query.query}...`));
        // const [youtubeJob, redditJob] = await Promise.all([
        //     initializeYoutubeCrawler(query),
        //     initializeRedditCrawler(query)
        // ]);
        const [redditJob] = await Promise.all([
            initializeRedditCrawler(query)
        ]);
        sleep(5000);
        console.log("\n\n");
    }

    console.log("All Queries add to their queues.")
};

crawlQueue.process('initialize-crawlers', async (job, done) => {
    await initializeAllCrawlers();
    done();
});

crawlQueue.add('initialize-crawlers', {});

console.log("Scheduled crawler job added to the queue.");
