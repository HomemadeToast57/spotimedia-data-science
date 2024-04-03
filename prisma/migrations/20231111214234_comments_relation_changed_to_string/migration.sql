-- DropForeignKey
ALTER TABLE "RedditComment" DROP CONSTRAINT "RedditComment_parentCommentId_fkey";

-- AlterTable
ALTER TABLE "RedditComment" ALTER COLUMN "parentCommentId" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "RedditComment" ADD CONSTRAINT "RedditComment_parentCommentId_fkey" FOREIGN KEY ("parentCommentId") REFERENCES "RedditComment"("redditId") ON DELETE SET NULL ON UPDATE CASCADE;
