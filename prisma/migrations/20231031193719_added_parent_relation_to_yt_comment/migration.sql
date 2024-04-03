/*
  Warnings:

  - You are about to drop the column `content` on the `YoutubeComment` table. All the data in the column will be lost.
  - Added the required column `commenterName` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `textContent` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `textDisplay` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "YoutubeComment" DROP COLUMN "content",
ADD COLUMN     "commenterName" TEXT NOT NULL,
ADD COLUMN     "parentId" TEXT,
ADD COLUMN     "textContent" TEXT NOT NULL,
ADD COLUMN     "textDisplay" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "YoutubeComment" ADD CONSTRAINT "YoutubeComment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "YoutubeComment"("commentId") ON DELETE SET NULL ON UPDATE CASCADE;
