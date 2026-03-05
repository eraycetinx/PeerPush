export const typeDefs = `#graphql
  scalar Date

  # Define ENUMS
  enum VoteType{
    UPVOTE
    DOWNVOTE
  }

  # First define the models
  type User {
    uuid: String!
    username: String!
    email: String!
    score: Int!
    reviewCount: Int!
    biography: String!
    followersCount: String!
    followingCount: String!
    createdAt: Date!
  }

  type Review {
    uuid: String!
    content: String!
    commitUuid: String!
    upVoteCount: Int!
    downVoteCount: Int!
    createdAt: Date!

    user: User!
    commit: Commit!
    votes: [Vote!]!
  }

  type Vote {
    uuid: String!
    userUuid: String!
    reviewUuid: String!
    vote: VoteType!
    createdAt: Date!

    user: User!
    review: Review!
  }

  type Repository {
    uuid: String!
    ownerUuid: String!
    name: String!
    fullName: String!
    description: String
    defaultBranch: String!
    pushedAt: Date
    createdAt: Date!
    updatedAt: Date!

    owner: User!

  }

  type Commit {
    uuid: String!
    repoUuid: String!
    userUuid: String
    sha: String!
    message: String!
    authorName: String!
    authorEmail: String!
    branch: String!
    committedAt: Date!
    createdAt: Date!
    updatedAt: Date!

    user: User!
    repository: Repository!
  }

  type Follow {
    uuid: String!
    followerUserUuid: String!
    followedUserUuid: String!
    createdAt: Date!

    follower: User!
    following: User!
  }

  type Query {
    book: String!
  }

  type Mutation {
    book: String!
  }
`