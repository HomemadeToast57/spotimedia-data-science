/*
  Warnings:

  - You are about to drop the column `author_fullname` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `created_at` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `is_archived` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `is_video` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `link_flair_text` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `num_comments` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `over_18` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `reddit_id` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `subreddit_id` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `subreddit_subscribers` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `text_content` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `total_awards_received` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `upvote_ratio` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `view_count` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `album_id` on the `SpotifyAlbum` table. All the data in the column will be lost.
  - You are about to drop the column `artist_id` on the `SpotifyAlbum` table. All the data in the column will be lost.
  - You are about to drop the column `cover_url` on the `SpotifyAlbum` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `SpotifyAlbum` table. All the data in the column will be lost.
  - You are about to drop the column `release_date` on the `SpotifyAlbum` table. All the data in the column will be lost.
  - You are about to drop the column `total_tracks` on the `SpotifyAlbum` table. All the data in the column will be lost.
  - You are about to drop the column `artist_id` on the `SpotifyArtist` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `SpotifyArtist` table. All the data in the column will be lost.
  - You are about to drop the column `cover_url` on the `SpotifyPlaylist` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `SpotifyPlaylist` table. All the data in the column will be lost.
  - You are about to drop the column `owner_name` on the `SpotifyPlaylist` table. All the data in the column will be lost.
  - You are about to drop the column `playlist_id` on the `SpotifyPlaylist` table. All the data in the column will be lost.
  - You are about to drop the column `album_id` on the `SpotifyTrack` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `SpotifyTrack` table. All the data in the column will be lost.
  - You are about to drop the column `duration_ms` on the `SpotifyTrack` table. All the data in the column will be lost.
  - You are about to drop the column `preview_url` on the `SpotifyTrack` table. All the data in the column will be lost.
  - You are about to drop the column `track_id` on the `SpotifyTrack` table. All the data in the column will be lost.
  - You are about to drop the column `analysis_url` on the `SpotifyTrackAudioFeatures` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `SpotifyTrackAudioFeatures` table. All the data in the column will be lost.
  - You are about to drop the column `duration_ms` on the `SpotifyTrackAudioFeatures` table. All the data in the column will be lost.
  - You are about to drop the column `time_signature` on the `SpotifyTrackAudioFeatures` table. All the data in the column will be lost.
  - You are about to drop the column `track_id` on the `SpotifyTrackAudioFeatures` table. All the data in the column will be lost.
  - The primary key for the `SpotifyTracksInPlaylists` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `playlist_id` on the `SpotifyTracksInPlaylists` table. All the data in the column will be lost.
  - You are about to drop the column `track_id` on the `SpotifyTracksInPlaylists` table. All the data in the column will be lost.
  - You are about to drop the column `active_user_count` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `banner_img` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `community_icon` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `display_name` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `header_img` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `icon_img` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `public_description` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `subreddit_type` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `whitelist_status` on the `Subreddit` table. All the data in the column will be lost.
  - You are about to drop the column `comment_id` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `commenter_id` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `like_count` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `published_at` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `video_id` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `channel_id` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `channel_title` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `crawled_at` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `published_at` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `video_id` on the `YoutubeVideo` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[redditId]` on the table `RedditPost` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[albumId]` on the table `SpotifyAlbum` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[artistId]` on the table `SpotifyArtist` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[playlistId]` on the table `SpotifyPlaylist` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[trackId]` on the table `SpotifyTrack` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[trackId]` on the table `SpotifyTrackAudioFeatures` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[displayName]` on the table `Subreddit` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[commentId]` on the table `YoutubeComment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[videoId]` on the table `YoutubeVideo` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `authorFullname` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `createdAt` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isArchived` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isVideo` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numComments` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `over18` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `redditId` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subredditId` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subredditSubscribers` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `totalAwardsReceived` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `upvoteRatio` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `albumId` to the `SpotifyAlbum` table without a default value. This is not possible if the table is not empty.
  - Added the required column `artistId` to the `SpotifyAlbum` table without a default value. This is not possible if the table is not empty.
  - Added the required column `releaseDate` to the `SpotifyAlbum` table without a default value. This is not possible if the table is not empty.
  - Added the required column `totalTracks` to the `SpotifyAlbum` table without a default value. This is not possible if the table is not empty.
  - Added the required column `artistId` to the `SpotifyArtist` table without a default value. This is not possible if the table is not empty.
  - Added the required column `ownerName` to the `SpotifyPlaylist` table without a default value. This is not possible if the table is not empty.
  - Added the required column `playlistId` to the `SpotifyPlaylist` table without a default value. This is not possible if the table is not empty.
  - Added the required column `albumId` to the `SpotifyTrack` table without a default value. This is not possible if the table is not empty.
  - Added the required column `durationMs` to the `SpotifyTrack` table without a default value. This is not possible if the table is not empty.
  - Added the required column `trackId` to the `SpotifyTrack` table without a default value. This is not possible if the table is not empty.
  - Added the required column `analysisUrl` to the `SpotifyTrackAudioFeatures` table without a default value. This is not possible if the table is not empty.
  - Added the required column `durationMs` to the `SpotifyTrackAudioFeatures` table without a default value. This is not possible if the table is not empty.
  - Added the required column `timeSignature` to the `SpotifyTrackAudioFeatures` table without a default value. This is not possible if the table is not empty.
  - Added the required column `trackId` to the `SpotifyTrackAudioFeatures` table without a default value. This is not possible if the table is not empty.
  - Added the required column `playlistId` to the `SpotifyTracksInPlaylists` table without a default value. This is not possible if the table is not empty.
  - Added the required column `trackId` to the `SpotifyTracksInPlaylists` table without a default value. This is not possible if the table is not empty.
  - Added the required column `activeUserCount` to the `Subreddit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `displayName` to the `Subreddit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `iconImg` to the `Subreddit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `publicDescription` to the `Subreddit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subredditType` to the `Subreddit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `commentId` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `commenterId` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `likeCount` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `publishedAt` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `videoId` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `channelId` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `channelTitle` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `publishedAt` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `videoId` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "RedditPost" DROP CONSTRAINT "RedditPost_subreddit_id_fkey";

-- DropForeignKey
ALTER TABLE "SpotifyAlbum" DROP CONSTRAINT "SpotifyAlbum_artist_id_fkey";

-- DropForeignKey
ALTER TABLE "SpotifyTrack" DROP CONSTRAINT "SpotifyTrack_album_id_fkey";

-- DropForeignKey
ALTER TABLE "SpotifyTrackAudioFeatures" DROP CONSTRAINT "SpotifyTrackAudioFeatures_track_id_fkey";

-- DropForeignKey
ALTER TABLE "SpotifyTracksInPlaylists" DROP CONSTRAINT "SpotifyTracksInPlaylists_playlist_id_fkey";

-- DropForeignKey
ALTER TABLE "SpotifyTracksInPlaylists" DROP CONSTRAINT "SpotifyTracksInPlaylists_track_id_fkey";

-- DropForeignKey
ALTER TABLE "YoutubeComment" DROP CONSTRAINT "YoutubeComment_video_id_fkey";

-- DropIndex
DROP INDEX "RedditPost_reddit_id_key";

-- DropIndex
DROP INDEX "SpotifyAlbum_album_id_key";

-- DropIndex
DROP INDEX "SpotifyArtist_artist_id_key";

-- DropIndex
DROP INDEX "SpotifyPlaylist_playlist_id_key";

-- DropIndex
DROP INDEX "SpotifyTrack_track_id_key";

-- DropIndex
DROP INDEX "SpotifyTrackAudioFeatures_track_id_key";

-- DropIndex
DROP INDEX "Subreddit_display_name_key";

-- DropIndex
DROP INDEX "YoutubeComment_comment_id_key";

-- DropIndex
DROP INDEX "YoutubeVideo_video_id_key";

-- AlterTable
ALTER TABLE "RedditPost" DROP COLUMN "author_fullname",
DROP COLUMN "crawled_at",
DROP COLUMN "created_at",
DROP COLUMN "is_archived",
DROP COLUMN "is_video",
DROP COLUMN "link_flair_text",
DROP COLUMN "num_comments",
DROP COLUMN "over_18",
DROP COLUMN "reddit_id",
DROP COLUMN "subreddit_id",
DROP COLUMN "subreddit_subscribers",
DROP COLUMN "text_content",
DROP COLUMN "total_awards_received",
DROP COLUMN "upvote_ratio",
DROP COLUMN "view_count",
ADD COLUMN     "authorFullname" TEXT NOT NULL,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "createdAt" INTEGER NOT NULL,
ADD COLUMN     "isArchived" BOOLEAN NOT NULL,
ADD COLUMN     "isVideo" BOOLEAN NOT NULL,
ADD COLUMN     "linkFlairText" TEXT,
ADD COLUMN     "numComments" INTEGER NOT NULL,
ADD COLUMN     "over18" BOOLEAN NOT NULL,
ADD COLUMN     "redditId" TEXT NOT NULL,
ADD COLUMN     "subredditId" TEXT NOT NULL,
ADD COLUMN     "subredditSubscribers" INTEGER NOT NULL,
ADD COLUMN     "textContent" TEXT,
ADD COLUMN     "totalAwardsReceived" INTEGER NOT NULL,
ADD COLUMN     "upvoteRatio" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "viewCount" INTEGER;

-- AlterTable
ALTER TABLE "SpotifyAlbum" DROP COLUMN "album_id",
DROP COLUMN "artist_id",
DROP COLUMN "cover_url",
DROP COLUMN "crawled_at",
DROP COLUMN "release_date",
DROP COLUMN "total_tracks",
ADD COLUMN     "albumId" TEXT NOT NULL,
ADD COLUMN     "artistId" TEXT NOT NULL,
ADD COLUMN     "coverUrl" TEXT,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "releaseDate" TEXT NOT NULL,
ADD COLUMN     "totalTracks" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "SpotifyArtist" DROP COLUMN "artist_id",
DROP COLUMN "crawled_at",
ADD COLUMN     "artistId" TEXT NOT NULL,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "SpotifyPlaylist" DROP COLUMN "cover_url",
DROP COLUMN "crawled_at",
DROP COLUMN "owner_name",
DROP COLUMN "playlist_id",
ADD COLUMN     "coverUrl" TEXT,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "ownerName" TEXT NOT NULL,
ADD COLUMN     "playlistId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "SpotifyTrack" DROP COLUMN "album_id",
DROP COLUMN "crawled_at",
DROP COLUMN "duration_ms",
DROP COLUMN "preview_url",
DROP COLUMN "track_id",
ADD COLUMN     "albumId" TEXT NOT NULL,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "durationMs" INTEGER NOT NULL,
ADD COLUMN     "previewUrl" TEXT,
ADD COLUMN     "trackId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "SpotifyTrackAudioFeatures" DROP COLUMN "analysis_url",
DROP COLUMN "crawled_at",
DROP COLUMN "duration_ms",
DROP COLUMN "time_signature",
DROP COLUMN "track_id",
ADD COLUMN     "analysisUrl" TEXT NOT NULL,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "durationMs" INTEGER NOT NULL,
ADD COLUMN     "timeSignature" INTEGER NOT NULL,
ADD COLUMN     "trackId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "SpotifyTracksInPlaylists" DROP CONSTRAINT "SpotifyTracksInPlaylists_pkey",
DROP COLUMN "playlist_id",
DROP COLUMN "track_id",
ADD COLUMN     "playlistId" TEXT NOT NULL,
ADD COLUMN     "trackId" TEXT NOT NULL,
ADD CONSTRAINT "SpotifyTracksInPlaylists_pkey" PRIMARY KEY ("trackId", "playlistId");

-- AlterTable
ALTER TABLE "Subreddit" DROP COLUMN "active_user_count",
DROP COLUMN "banner_img",
DROP COLUMN "community_icon",
DROP COLUMN "crawled_at",
DROP COLUMN "display_name",
DROP COLUMN "header_img",
DROP COLUMN "icon_img",
DROP COLUMN "public_description",
DROP COLUMN "subreddit_type",
DROP COLUMN "whitelist_status",
ADD COLUMN     "activeUserCount" INTEGER NOT NULL,
ADD COLUMN     "bannerImg" TEXT,
ADD COLUMN     "communityIcon" TEXT,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "displayName" TEXT NOT NULL,
ADD COLUMN     "headerImg" TEXT,
ADD COLUMN     "iconImg" TEXT NOT NULL,
ADD COLUMN     "publicDescription" TEXT NOT NULL,
ADD COLUMN     "subredditType" TEXT NOT NULL,
ADD COLUMN     "whitelistStatus" TEXT;

-- AlterTable
ALTER TABLE "YoutubeComment" DROP COLUMN "comment_id",
DROP COLUMN "commenter_id",
DROP COLUMN "crawled_at",
DROP COLUMN "like_count",
DROP COLUMN "published_at",
DROP COLUMN "video_id",
ADD COLUMN     "commentId" TEXT NOT NULL,
ADD COLUMN     "commenterId" TEXT NOT NULL,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "likeCount" INTEGER NOT NULL,
ADD COLUMN     "publishedAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "videoId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "YoutubeVideo" DROP COLUMN "channel_id",
DROP COLUMN "channel_title",
DROP COLUMN "crawled_at",
DROP COLUMN "published_at",
DROP COLUMN "video_id",
ADD COLUMN     "channelId" TEXT NOT NULL,
ADD COLUMN     "channelTitle" TEXT NOT NULL,
ADD COLUMN     "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "publishedAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "videoId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "RedditPost_redditId_key" ON "RedditPost"("redditId");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyAlbum_albumId_key" ON "SpotifyAlbum"("albumId");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyArtist_artistId_key" ON "SpotifyArtist"("artistId");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyPlaylist_playlistId_key" ON "SpotifyPlaylist"("playlistId");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyTrack_trackId_key" ON "SpotifyTrack"("trackId");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyTrackAudioFeatures_trackId_key" ON "SpotifyTrackAudioFeatures"("trackId");

-- CreateIndex
CREATE UNIQUE INDEX "Subreddit_displayName_key" ON "Subreddit"("displayName");

-- CreateIndex
CREATE UNIQUE INDEX "YoutubeComment_commentId_key" ON "YoutubeComment"("commentId");

-- CreateIndex
CREATE UNIQUE INDEX "YoutubeVideo_videoId_key" ON "YoutubeVideo"("videoId");

-- AddForeignKey
ALTER TABLE "RedditPost" ADD CONSTRAINT "RedditPost_subredditId_fkey" FOREIGN KEY ("subredditId") REFERENCES "Subreddit"("name") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YoutubeComment" ADD CONSTRAINT "YoutubeComment_videoId_fkey" FOREIGN KEY ("videoId") REFERENCES "YoutubeVideo"("videoId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTrack" ADD CONSTRAINT "SpotifyTrack_albumId_fkey" FOREIGN KEY ("albumId") REFERENCES "SpotifyAlbum"("albumId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTrackAudioFeatures" ADD CONSTRAINT "SpotifyTrackAudioFeatures_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES "SpotifyTrack"("trackId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyAlbum" ADD CONSTRAINT "SpotifyAlbum_artistId_fkey" FOREIGN KEY ("artistId") REFERENCES "SpotifyArtist"("artistId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTracksInPlaylists" ADD CONSTRAINT "SpotifyTracksInPlaylists_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES "SpotifyTrack"("trackId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTracksInPlaylists" ADD CONSTRAINT "SpotifyTracksInPlaylists_playlistId_fkey" FOREIGN KEY ("playlistId") REFERENCES "SpotifyPlaylist"("playlistId") ON DELETE RESTRICT ON UPDATE CASCADE;
