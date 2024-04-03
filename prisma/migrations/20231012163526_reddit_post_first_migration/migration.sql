/*
  Warnings:

  - You are about to drop the `post` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `redditpost` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "post";

-- DropTable
DROP TABLE "redditpost";

-- CreateTable
CREATE TABLE "RedditPost" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT,

    CONSTRAINT "RedditPost_pkey" PRIMARY KEY ("id")
);
