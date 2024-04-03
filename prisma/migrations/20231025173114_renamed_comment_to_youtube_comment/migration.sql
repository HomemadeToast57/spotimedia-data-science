/*
  Warnings:

  - You are about to drop the `Comment` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_videoId_fkey";

-- DropTable
DROP TABLE "Comment";

-- CreateTable
CREATE TABLE "YoutubeComment" (
    "id" SERIAL NOT NULL,
    "commentId" TEXT NOT NULL,
    "videoId" TEXT NOT NULL,
    "commenterId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "publishedAt" TIMESTAMP(3) NOT NULL,
    "likeCount" INTEGER NOT NULL,
    "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "YoutubeComment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "YoutubeComment_commentId_key" ON "YoutubeComment"("commentId");

-- AddForeignKey
ALTER TABLE "YoutubeComment" ADD CONSTRAINT "YoutubeComment_videoId_fkey" FOREIGN KEY ("videoId") REFERENCES "YoutubeVideo"("videoId") ON DELETE RESTRICT ON UPDATE CASCADE;
