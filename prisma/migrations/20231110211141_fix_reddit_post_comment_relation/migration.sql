/*
  Warnings:

  - A unique constraint covering the columns `[trackId]` on the table `Query` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "RedditComment" DROP CONSTRAINT "RedditComment_postId_fkey";

-- AlterTable
ALTER TABLE "RedditComment" ALTER COLUMN "postId" SET DATA TYPE TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Query_trackId_key" ON "Query"("trackId");

-- AddForeignKey
ALTER TABLE "RedditComment" ADD CONSTRAINT "RedditComment_postId_fkey" FOREIGN KEY ("postId") REFERENCES "RedditPost"("redditId") ON DELETE RESTRICT ON UPDATE CASCADE;
