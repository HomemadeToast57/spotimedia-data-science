/*
  Warnings:

  - You are about to drop the column `commentId` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `commenterId` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `crawledAt` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `likeCount` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `publishedAt` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `videoId` on the `YoutubeComment` table. All the data in the column will be lost.
  - You are about to drop the column `channelId` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `channelTitle` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `crawledAt` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `publishedAt` on the `YoutubeVideo` table. All the data in the column will be lost.
  - You are about to drop the column `videoId` on the `YoutubeVideo` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[comment_id]` on the table `YoutubeComment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[video_id]` on the table `YoutubeVideo` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `comment_id` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `commenter_id` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `like_count` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `published_at` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `video_id` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `channel_id` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `channel_title` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `published_at` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `video_id` to the `YoutubeVideo` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "YoutubeComment" DROP CONSTRAINT "YoutubeComment_videoId_fkey";

-- DropIndex
DROP INDEX "YoutubeComment_commentId_key";

-- DropIndex
DROP INDEX "YoutubeVideo_videoId_key";

-- AlterTable
ALTER TABLE "RedditPost" ALTER COLUMN "crawled_at" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Subreddit" ALTER COLUMN "crawled_at" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "YoutubeComment" DROP COLUMN "commentId",
DROP COLUMN "commenterId",
DROP COLUMN "crawledAt",
DROP COLUMN "likeCount",
DROP COLUMN "publishedAt",
DROP COLUMN "videoId",
ADD COLUMN     "comment_id" TEXT NOT NULL,
ADD COLUMN     "commenter_id" TEXT NOT NULL,
ADD COLUMN     "crawled_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "like_count" INTEGER NOT NULL,
ADD COLUMN     "published_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "video_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "YoutubeVideo" DROP COLUMN "channelId",
DROP COLUMN "channelTitle",
DROP COLUMN "crawledAt",
DROP COLUMN "publishedAt",
DROP COLUMN "videoId",
ADD COLUMN     "channel_id" TEXT NOT NULL,
ADD COLUMN     "channel_title" TEXT NOT NULL,
ADD COLUMN     "crawled_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "published_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "video_id" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "SpotifyArtist" (
    "id" SERIAL NOT NULL,
    "artist_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "popularity" INTEGER NOT NULL,
    "genres" TEXT[],
    "crawled_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SpotifyArtist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpotifyTrack" (
    "id" SERIAL NOT NULL,
    "track_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "album_id" TEXT NOT NULL,
    "duration_ms" INTEGER NOT NULL,
    "popularity" INTEGER NOT NULL,
    "explicit" BOOLEAN NOT NULL,
    "preview_url" TEXT,
    "crawled_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SpotifyTrack_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpotifyTrackAudioFeatures" (
    "id" SERIAL NOT NULL,
    "track_id" TEXT NOT NULL,
    "analysis_url" TEXT NOT NULL,
    "duration_ms" INTEGER NOT NULL,
    "danceability" DOUBLE PRECISION NOT NULL,
    "energy" DOUBLE PRECISION NOT NULL,
    "key" INTEGER NOT NULL,
    "loudness" DOUBLE PRECISION NOT NULL,
    "mode" INTEGER NOT NULL,
    "speechiness" DOUBLE PRECISION NOT NULL,
    "acousticness" DOUBLE PRECISION NOT NULL,
    "instrumentalness" DOUBLE PRECISION NOT NULL,
    "liveness" DOUBLE PRECISION NOT NULL,
    "valence" DOUBLE PRECISION NOT NULL,
    "tempo" DOUBLE PRECISION NOT NULL,
    "time_signature" INTEGER NOT NULL,
    "crawled_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SpotifyTrackAudioFeatures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpotifyAlbum" (
    "id" SERIAL NOT NULL,
    "album_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "artist_id" TEXT NOT NULL,
    "release_date" TEXT NOT NULL,
    "total_tracks" INTEGER NOT NULL,
    "cover_url" TEXT,
    "crawled_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SpotifyAlbum_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpotifyPlaylist" (
    "id" SERIAL NOT NULL,
    "playlist_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "owner_name" TEXT NOT NULL,
    "public" BOOLEAN NOT NULL,
    "collaborative" BOOLEAN NOT NULL,
    "description" TEXT,
    "cover_url" TEXT,
    "crawled_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SpotifyPlaylist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpotifyTracksInPlaylists" (
    "track_id" TEXT NOT NULL,
    "playlist_id" TEXT NOT NULL,

    CONSTRAINT "SpotifyTracksInPlaylists_pkey" PRIMARY KEY ("track_id","playlist_id")
);

-- CreateTable
CREATE TABLE "_SpotifyArtistToSpotifyTrack" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyArtist_artist_id_key" ON "SpotifyArtist"("artist_id");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyTrack_track_id_key" ON "SpotifyTrack"("track_id");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyTrackAudioFeatures_track_id_key" ON "SpotifyTrackAudioFeatures"("track_id");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyAlbum_album_id_key" ON "SpotifyAlbum"("album_id");

-- CreateIndex
CREATE UNIQUE INDEX "SpotifyPlaylist_playlist_id_key" ON "SpotifyPlaylist"("playlist_id");

-- CreateIndex
CREATE UNIQUE INDEX "_SpotifyArtistToSpotifyTrack_AB_unique" ON "_SpotifyArtistToSpotifyTrack"("A", "B");

-- CreateIndex
CREATE INDEX "_SpotifyArtistToSpotifyTrack_B_index" ON "_SpotifyArtistToSpotifyTrack"("B");

-- CreateIndex
CREATE UNIQUE INDEX "YoutubeComment_comment_id_key" ON "YoutubeComment"("comment_id");

-- CreateIndex
CREATE UNIQUE INDEX "YoutubeVideo_video_id_key" ON "YoutubeVideo"("video_id");

-- AddForeignKey
ALTER TABLE "YoutubeComment" ADD CONSTRAINT "YoutubeComment_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "YoutubeVideo"("video_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTrack" ADD CONSTRAINT "SpotifyTrack_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "SpotifyAlbum"("album_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTrackAudioFeatures" ADD CONSTRAINT "SpotifyTrackAudioFeatures_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "SpotifyTrack"("track_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyAlbum" ADD CONSTRAINT "SpotifyAlbum_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "SpotifyArtist"("artist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTracksInPlaylists" ADD CONSTRAINT "SpotifyTracksInPlaylists_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "SpotifyTrack"("track_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpotifyTracksInPlaylists" ADD CONSTRAINT "SpotifyTracksInPlaylists_playlist_id_fkey" FOREIGN KEY ("playlist_id") REFERENCES "SpotifyPlaylist"("playlist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SpotifyArtistToSpotifyTrack" ADD CONSTRAINT "_SpotifyArtistToSpotifyTrack_A_fkey" FOREIGN KEY ("A") REFERENCES "SpotifyArtist"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SpotifyArtistToSpotifyTrack" ADD CONSTRAINT "_SpotifyArtistToSpotifyTrack_B_fkey" FOREIGN KEY ("B") REFERENCES "SpotifyTrack"("id") ON DELETE CASCADE ON UPDATE CASCADE;
