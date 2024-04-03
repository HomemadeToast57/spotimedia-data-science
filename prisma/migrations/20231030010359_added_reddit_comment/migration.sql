-- CreateTable
CREATE TABLE "RedditComment" (
    "id" SERIAL NOT NULL,
    "redditId" TEXT NOT NULL,
    "postId" INTEGER NOT NULL,
    "author" TEXT NOT NULL,
    "authorFullname" TEXT NOT NULL,
    "textContent" TEXT NOT NULL,
    "ups" INTEGER NOT NULL,
    "downs" INTEGER NOT NULL,
    "score" INTEGER NOT NULL,
    "isArchived" BOOLEAN NOT NULL,
    "createdAt" INTEGER NOT NULL,
    "permalink" TEXT NOT NULL,
    "numReplies" INTEGER NOT NULL,
    "parentCommentId" INTEGER,
    "crawledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RedditComment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "RedditComment_redditId_key" ON "RedditComment"("redditId");

-- AddForeignKey
ALTER TABLE "RedditComment" ADD CONSTRAINT "RedditComment_postId_fkey" FOREIGN KEY ("postId") REFERENCES "RedditPost"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RedditComment" ADD CONSTRAINT "RedditComment_parentCommentId_fkey" FOREIGN KEY ("parentCommentId") REFERENCES "RedditComment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
