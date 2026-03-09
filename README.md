# PeerPush

PeerPush is a developer social platform where developers' code is reviewed.

## Getting started

### 1. Cloning the project

First you should fork repository.

Clone the project to your local computer:

```bash
# Download Repository
git clone https://github.com/eraycetinx/PeerPush.git
# Move into repository
cd PeerPush
```

Install dependencies.

```bash
npm install
```

### 2. Setting up `.env` files

Duplicate `.env.example` files and rename them as `.env`.

### 3. Prisma Setup and Database Configuration

Move to `db/prisma` folder.

```bash
cd db
```

Generate artifacts. (e.g. Prisma Client)

```sh
npm run prisma:generate
```

Make a Prisma migration.

```sh
npm run prisma:migrate
```
