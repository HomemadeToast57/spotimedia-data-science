-- CreateTable
CREATE TABLE "POST" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "published" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "POST_pkey" PRIMARY KEY ("id")
);
