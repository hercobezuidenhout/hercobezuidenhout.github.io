---
title: Building Teamtjie - Initial Commit
date: 2026-07-24
categories: []
tags: []
---

Teamtjie has been in production for a couple of months now. During this time, I have learned a lot and it is time to give Teamtjie the rebuild it deserves.

### Why rebuild?

Good question. 

In 2022, I built an app called [Doinfine](https://doinfine.app) which has gone through many iterations and changes. During its time, it gained some features which were very much team culture related and not fines. It grew to a point where I decided to split it into two apps.

1. Doinfine
2. Teamtjie

Doinfine would focus on managing fines between friends and Teamtjie would double down in team culture.

With this split, Teamtjie stayed on Doinfine's original codebase and Doinfine was rewritten as a new NextJS app.

> BTW, a full Doinfine rebuild is coming as well. Mostly the same reasons.

I then deployed Teamtjie in its current state to test the market and see if people would enjoy this app. 

Today, I have decided that it is time for Teamtjie to get a proper rebuild and build an app that focuses on team culture.

### Tech Stack

The architecture will be focused on hosted solutions with the option of self-hosting in the future.

- **NextJS** - powering the frontend and API. Deliberatly going with JavaScript instead of TypeScript. Personal preference, really.
- **Supabase** - backend as a service. Database, authentication and storage all in one solution. Easy to integrate with and can be self-hosted if needed.
- **Vercel** - Good starting point to get something up and running quickly. Unfortunately, can't be self-hosted but the deployment workflows will be custom so that a Docker-based solution can be implemented in the future when necessary.
- **BaseUI** - Component library but unstyled. Previously, Teamtjie used ChakraUI but I would like to apply my own styles using Tailwind without having to build common components from scratch.
- **Tailwind CSS** - Will be using this for styles.
- **Novu** - Open source notification system. Will use this for push notifications. Can be self-hosted when necessary.
- **Resend**  - Email service. Will use this to send emails from the application where necessary.
- **Paystack** - Payment Gateway for South African businesses.
- **Prisma ORM** - ORM to decouple the app from Supabase database.

There are some smaller dependencies and npm packages which this project will use but these are the main ones.

### Getting started with NextJS

The first step is to create a new NextJS app and install the npm packages.

```
npx create-next-app@latest


herco@Hercos-Mac-mini teamtjie-new % npx create-next-app@latest
✔ What is your project named? … teamtjie
✔ Would you like to use the recommended Next.js defaults? › No, customize settings
✔ Would you like to use TypeScript? … No / Yes
✔ Which linter would you like to use? › Biome
✔ Would you like to use React Compiler? … No / Yes
✔ Would you like to use Tailwind CSS? … No / Yes
✔ Would you like your code inside a `src/` directory? … No / Yes
✔ Would you like to use App Router? (recommended) … No / Yes
✔ Would you like to customize the import alias (`@/*` by default)? … No / Yes
✔ Would you like to include AGENTS.md to guide coding agents to write up-to-date Next.js code? … No / Yes
Creating a new Next.js app in /Users/herco/Projects/teamtjie-new/teamtjie.

Using npm.

Initializing project with template: app-tw 


Installing dependencies:
- next
- react
- react-dom

Installing devDependencies:
- @biomejs/biome
- @tailwindcss/postcss
- tailwindcss
```

The above sets up the base scaffolding for the NextJS project.

```
.
├── app
│   ├── favicon.ico
│   ├── globals.css
│   ├── layout.js
│   └── page.js
├── biome.json
├── jsconfig.json
├── next.config.mjs
├── package-lock.json
├── package.json
├── postcss.config.mjs
├── public
│   ├── file.svg
│   ├── globe.svg
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
└── README.md

3 directories, 16 files
```

### Adding Git

The project doesn't have git set up yet so that is the next logical step. Git is installed on my machine so all I need to do is run `git init` and git will do its magic.

```
herco@Hercos-Mac-mini teamtjie % git init   
hint: Using 'master' as the name for the initial branch. This default branch name
hint: will change to "main" in Git 3.0. To configure the initial branch name
hint: to use in all of your new repositories, which will suppress this warning,
hint: call:
hint:
hint:   git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint:   git branch -m <name>
hint:
hint: Disable this message with "git config set advice.defaultBranchName false"
Initialized empty Git repository in /Users/herco/Projects/teamtjie-new/teamtjie/.git/
herco@Hercos-Mac-mini teamtjie % 
```

Now I am not a big fan of the `master` branch so I am going to rename it to `main` instead.

```
git branch -m main
```

With that done, I now see my changes in git so time for the first commit.

```
git add .
git commit -m "init: Teamtjie"
```

### Adding Teamtjie touch

I now have a basic NextJS scaffold to work with. I still need to clean up some of the generated files and code. Then it is time to install the project's first dependencies being Base UI.

A quick landing page and then the first deployment.

I will start by removing the example code that was generated and then installing the first three `npm` modules.

1. BaseUI
2. React Query
3. Prisma

I installed the above modules.

```bash
npm i @base-ui/react @tanstack/react-query

npm install prisma tsx @types/pg --save-dev

npm install @prisma/client @prisma/adapter-pg dotenv pg

npx prisma init --output ../app/generated/prisma
```

### Design

The new Teamtjie will have a different design. Playing around with some things.

![TeamtjieNewDesign.png](/assets/TeamtjieNewDesign.png)

The focus is on growth and team health.

> This also means I am planning a new feature called Growth Plans which will allow a user to set up a growth plan for people in the team and track that plan.

## Built for self-hosting

While I am not targeting enterprise clients, the one thing that does stop enterprise clients from using this is where the data lives. So I will be designing it this time with that in mind.

In the current tech stack, the database can easily be switched to a local version since this project uses Prisma ORM to connect to the database so by simply passing in a different connection string to the environment variables, you have your own database. 

The kicker comes in with Supbase auth and storage.

So instead of having the app rely on Supabase auth and storage directly, I am going to extract that logic into an API using NextJS `route.ts` files which will be called by both the frontend and server actions. This will enable developers to specify their own APIs in the environment variables when self-hosting.

Self-hosting will also be enabled through a Docker image.

Of course.