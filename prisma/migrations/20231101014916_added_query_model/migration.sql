-- AlterTable
ALTER TABLE "RedditPost" ADD COLUMN     "queryId" INTEGER;

-- AlterTable
ALTER TABLE "YoutubeVideo" ADD COLUMN     "queryId" INTEGER;

-- CreateTable
CREATE TABLE "Query" (
    "id" SERIAL NOT NULL,
    "trackId" TEXT NOT NULL,
    "query" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Query_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "RedditPost" ADD CONSTRAINT "RedditPost_queryId_fkey" FOREIGN KEY ("queryId") REFERENCES "Query"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YoutubeVideo" ADD CONSTRAINT "YoutubeVideo_queryId_fkey" FOREIGN KEY ("queryId") REFERENCES "Query"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Query" ADD CONSTRAINT "Query_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES "SpotifyTrack"("trackId") ON DELETE RESTRICT ON UPDATE CASCADE;
