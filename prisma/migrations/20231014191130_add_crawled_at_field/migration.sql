/*
  Warnings:

  - Added the required column `crawled_at` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `crawled_at` to the `Subreddit` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "RedditPost" ADD COLUMN     "crawled_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Subreddit" ADD COLUMN     "crawled_at" TIMESTAMP(3) NOT NULL;
