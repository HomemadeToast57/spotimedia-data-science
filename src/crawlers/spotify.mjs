import axios from 'axios';

const getToken = async (clientId, clientSecret) => {
    const authString = `${clientId}:${clientSecret}`;
    const authBase64 = Buffer.from(authString).toString('base64');

    const url = "https://accounts.spotify.com/api/token";
    const headers = {
        "Authorization": `Basic ${authBase64}`,
        "Content-Type": "application/x-www-form-urlencoded"
    };
    const data = "grant_type=client_credentials";

    try {
        const response = await axios.post(url, data, { headers });
        return response.data.access_token;
    } catch (error) {
        console.error("Error fetching Spotify token:", error);
        throw error;  // If you want to propagate the error to the caller
    }
}

const getPlaylistTracks = async (accessToken, playlistId) => {

    const url = `https://api.spotify.com/v1/playlists/${playlistId}/tracks`;
    const headers = {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json"
    };

    try {
        const response = await axios.get(url, { headers });
        // Extract song names and artist names from the track objects
        const tracksInfo = response.data.items.map(item => {
            const track = item.track;
            return {
                trackId: track.id,
                songName: track.name,
                artistName: track.artists.map(artist => artist.name).join(', ')  // Join artist names if there are multiple
            };
        });
        return tracksInfo;
    } catch (error) {
        console.error("Error fetching playlist tracks:", error);
        throw error;  // If you want to propagate the error to the caller
    }
}

export { getToken, getPlaylistTracks };
