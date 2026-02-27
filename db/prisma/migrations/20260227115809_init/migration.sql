/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.
  - You are about to alter the column `email` on the `User` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(70)`.
  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[uuid]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[username]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `password` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `username` to the `User` table without a default value. This is not possible if the table is not empty.
  - The required column `uuid` was added to the `User` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.

*/
-- CreateEnum
CREATE TYPE "VoteType" AS ENUM ('UPVOTE', 'DOWNVOTE');

-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_authorId_fkey";

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "id",
DROP COLUMN "name",
ADD COLUMN     "biography" VARCHAR(160) NOT NULL DEFAULT '',
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "followersCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "followingCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "password" VARCHAR(64) NOT NULL,
ADD COLUMN     "reviewCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "score" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "username" VARCHAR(30) NOT NULL,
ADD COLUMN     "uuid" VARCHAR(64) NOT NULL,
ALTER COLUMN "email" SET DATA TYPE VARCHAR(70),
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("uuid");

-- DropTable
DROP TABLE "Post";

-- CreateTable
CREATE TABLE "Review" (
    "uuid" VARCHAR(64) NOT NULL,
    "content" TEXT NOT NULL,
    "userUuid" VARCHAR(64) NOT NULL,
    "commitUuid" VARCHAR(64) NOT NULL,
    "upVoteCount" INTEGER NOT NULL DEFAULT 0,
    "downVoteCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Vote" (
    "uuid" VARCHAR(64) NOT NULL,
    "userUuid" VARCHAR(64) NOT NULL,
    "reviewUuid" VARCHAR(64) NOT NULL,
    "vote" "VoteType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Vote_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Repository" (
    "uuid" VARCHAR(64) NOT NULL,
    "ownerUuid" VARCHAR(64) NOT NULL,
    "githubUuid" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "description" TEXT,
    "defaultBranch" TEXT NOT NULL,
    "pushedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Repository_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Commit" (
    "uuid" VARCHAR(64) NOT NULL,
    "repoUuid" VARCHAR(64) NOT NULL,
    "userUuid" VARCHAR(64),
    "sha" VARCHAR(40) NOT NULL,
    "message" TEXT NOT NULL,
    "authorName" VARCHAR(100) NOT NULL,
    "authorEmail" VARCHAR(100) NOT NULL,
    "branch" VARCHAR(100) NOT NULL,
    "committedAt" TIMESTAMP(6) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Commit_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Follow" (
    "uuid" VARCHAR(64) NOT NULL,
    "followerUserUuid" VARCHAR(64) NOT NULL,
    "followedUserUuid" VARCHAR(64) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Follow_pkey" PRIMARY KEY ("uuid")
);

-- CreateIndex
CREATE UNIQUE INDEX "Review_uuid_key" ON "Review"("uuid");

-- CreateIndex
CREATE INDEX "Review_userUuid_idx" ON "Review"("userUuid");

-- CreateIndex
CREATE INDEX "Review_commitUuid_idx" ON "Review"("commitUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Review_userUuid_commitUuid_key" ON "Review"("userUuid", "commitUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Vote_uuid_key" ON "Vote"("uuid");

-- CreateIndex
CREATE INDEX "Vote_userUuid_idx" ON "Vote"("userUuid");

-- CreateIndex
CREATE INDEX "Vote_reviewUuid_idx" ON "Vote"("reviewUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Vote_userUuid_reviewUuid_key" ON "Vote"("userUuid", "reviewUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Repository_uuid_key" ON "Repository"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Repository_githubUuid_key" ON "Repository"("githubUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Repository_fullName_key" ON "Repository"("fullName");

-- CreateIndex
CREATE INDEX "Repository_ownerUuid_idx" ON "Repository"("ownerUuid");

-- CreateIndex
CREATE INDEX "Repository_githubUuid_idx" ON "Repository"("githubUuid");

-- CreateIndex
CREATE INDEX "Commit_repoUuid_idx" ON "Commit"("repoUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Commit_repoUuid_sha_key" ON "Commit"("repoUuid", "sha");

-- CreateIndex
CREATE UNIQUE INDEX "Follow_uuid_key" ON "Follow"("uuid");

-- CreateIndex
CREATE INDEX "Follow_followerUserUuid_idx" ON "Follow"("followerUserUuid");

-- CreateIndex
CREATE INDEX "Follow_followedUserUuid_idx" ON "Follow"("followedUserUuid");

-- CreateIndex
CREATE UNIQUE INDEX "Follow_followerUserUuid_followedUserUuid_key" ON "Follow"("followerUserUuid", "followedUserUuid");

-- CreateIndex
CREATE UNIQUE INDEX "User_uuid_key" ON "User"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE INDEX "User_username_idx" ON "User"("username");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_userUuid_fkey" FOREIGN KEY ("userUuid") REFERENCES "User"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_commitUuid_fkey" FOREIGN KEY ("commitUuid") REFERENCES "Commit"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vote" ADD CONSTRAINT "Vote_userUuid_fkey" FOREIGN KEY ("userUuid") REFERENCES "User"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vote" ADD CONSTRAINT "Vote_reviewUuid_fkey" FOREIGN KEY ("reviewUuid") REFERENCES "Review"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Repository" ADD CONSTRAINT "Repository_ownerUuid_fkey" FOREIGN KEY ("ownerUuid") REFERENCES "User"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commit" ADD CONSTRAINT "Commit_userUuid_fkey" FOREIGN KEY ("userUuid") REFERENCES "User"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commit" ADD CONSTRAINT "Commit_repoUuid_fkey" FOREIGN KEY ("repoUuid") REFERENCES "Repository"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followerUserUuid_fkey" FOREIGN KEY ("followerUserUuid") REFERENCES "User"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followedUserUuid_fkey" FOREIGN KEY ("followedUserUuid") REFERENCES "User"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;
