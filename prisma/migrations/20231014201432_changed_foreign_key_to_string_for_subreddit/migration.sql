-- DropForeignKey
ALTER TABLE "RedditPost" DROP CONSTRAINT "RedditPost_subreddit_id_fkey";

-- AlterTable
ALTER TABLE "RedditPost" ALTER COLUMN "subreddit_id" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "RedditPost" ADD CONSTRAINT "RedditPost_subreddit_id_fkey" FOREIGN KEY ("subreddit_id") REFERENCES "Subreddit"("name") ON DELETE RESTRICT ON UPDATE CASCADE;
