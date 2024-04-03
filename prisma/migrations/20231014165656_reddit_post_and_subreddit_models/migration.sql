/*
  Warnings:

  - You are about to drop the column `content` on the `RedditPost` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[reddit_id]` on the table `RedditPost` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `author` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `author_fullname` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `created_at` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `domain` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `downs` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `is_archived` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `is_video` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `num_comments` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `over_18` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `permalink` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `reddit_id` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `score` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subreddit_id` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subreddit_subscribers` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_awards_received` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `ups` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `upvote_ratio` to the `RedditPost` table without a default value. This is not possible if the table is not empty.
  - Added the required column `url` to the `RedditPost` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "RedditPost" DROP COLUMN "content",
ADD COLUMN     "author" TEXT NOT NULL,
ADD COLUMN     "author_fullname" TEXT NOT NULL,
ADD COLUMN     "created_at" INTEGER NOT NULL,
ADD COLUMN     "domain" TEXT NOT NULL,
ADD COLUMN     "downs" INTEGER NOT NULL,
ADD COLUMN     "is_archived" BOOLEAN NOT NULL,
ADD COLUMN     "is_video" BOOLEAN NOT NULL,
ADD COLUMN     "link_flair_text" TEXT,
ADD COLUMN     "media" TEXT,
ADD COLUMN     "num_comments" INTEGER NOT NULL,
ADD COLUMN     "over_18" BOOLEAN NOT NULL,
ADD COLUMN     "permalink" TEXT NOT NULL,
ADD COLUMN     "reddit_id" INTEGER NOT NULL,
ADD COLUMN     "score" INTEGER NOT NULL,
ADD COLUMN     "subreddit_id" INTEGER NOT NULL,
ADD COLUMN     "subreddit_subscribers" INTEGER NOT NULL,
ADD COLUMN     "text_content" TEXT,
ADD COLUMN     "total_awards_received" INTEGER NOT NULL,
ADD COLUMN     "ups" INTEGER NOT NULL,
ADD COLUMN     "upvote_ratio" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "url" TEXT NOT NULL,
ADD COLUMN     "view_count" INTEGER;

-- CreateTable
CREATE TABLE "Subreddit" (
    "id" SERIAL NOT NULL,
    "display_name" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "public_description" TEXT NOT NULL,
    "subscribers" INTEGER NOT NULL,
    "active_user_count" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "created" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "banner_img" TEXT,
    "community_icon" TEXT,
    "over18" BOOLEAN NOT NULL,
    "lang" TEXT NOT NULL,
    "whitelist_status" TEXT,
    "subreddit_type" TEXT NOT NULL,
    "header_img" TEXT,
    "icon_img" TEXT NOT NULL,

    CONSTRAINT "Subreddit_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Subreddit_display_name_key" ON "Subreddit"("display_name");

-- CreateIndex
CREATE UNIQUE INDEX "Subreddit_name_key" ON "Subreddit"("name");

-- CreateIndex
CREATE UNIQUE INDEX "RedditPost_reddit_id_key" ON "RedditPost"("reddit_id");

-- AddForeignKey
ALTER TABLE "RedditPost" ADD CONSTRAINT "RedditPost_subreddit_id_fkey" FOREIGN KEY ("subreddit_id") REFERENCES "Subreddit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
