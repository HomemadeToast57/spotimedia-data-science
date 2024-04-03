/*
  Warnings:

  - Added the required column `commenterProfileImageUrl` to the `YoutubeComment` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "YoutubeComment" ADD COLUMN     "commenterProfileImageUrl" TEXT NOT NULL;
