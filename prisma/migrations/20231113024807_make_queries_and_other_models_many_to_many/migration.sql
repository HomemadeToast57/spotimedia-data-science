/*
  Warnings:

  - You are about to drop the column `queryId` on the `RedditPost` table. All the data in the column will be lost.
  - You are about to drop the column `queryId` on the `YoutubeVideo` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "RedditPost" DROP CONSTRAINT "RedditPost_queryId_fkey";

-- DropForeignKey
ALTER TABLE "YoutubeVideo" DROP CONSTRAINT "YoutubeVideo_queryId_fkey";

-- AlterTable
ALTER TABLE "RedditPost" DROP COLUMN "queryId";

-- AlterTable
ALTER TABLE "YoutubeVideo" DROP COLUMN "queryId";

-- CreateTable
CREATE TABLE "QueriesOnRedditPosts" (
    "queryId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,

    CONSTRAINT "QueriesOnRedditPosts_pkey" PRIMARY KEY ("queryId","postId")
);

-- CreateTable
CREATE TABLE "QueriesOnYoutubeVideos" (
    "queryId" INTEGER NOT NULL,
    "videoId" INTEGER NOT NULL,

    CONSTRAINT "QueriesOnYoutubeVideos_pkey" PRIMARY KEY ("queryId","videoId")
);

-- AddForeignKey
ALTER TABLE "QueriesOnRedditPosts" ADD CONSTRAINT "QueriesOnRedditPosts_queryId_fkey" FOREIGN KEY ("queryId") REFERENCES "Query"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QueriesOnRedditPosts" ADD CONSTRAINT "QueriesOnRedditPosts_postId_fkey" FOREIGN KEY ("postId") REFERENCES "RedditPost"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QueriesOnYoutubeVideos" ADD CONSTRAINT "QueriesOnYoutubeVideos_queryId_fkey" FOREIGN KEY ("queryId") REFERENCES "Query"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QueriesOnYoutubeVideos" ADD CONSTRAINT "QueriesOnYoutubeVideos_videoId_fkey" FOREIGN KEY ("videoId") REFERENCES "YoutubeVideo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
