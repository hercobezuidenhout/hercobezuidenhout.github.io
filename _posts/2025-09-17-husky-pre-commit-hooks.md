---
title: Husky - Working with pre-commit hooks
date: 2025-09-17
categories:
  - General
  - Update
tags:
  - personal
  - announcement
description: Add a short description for the new post
pin: false
---

## Husky - Working with pre-commit hooks

The other day, I tried pushing a commit but my commit failed. When expecting the logs, I found something like this:

```bash
~/sandbox/husky-example$ git commit -m "Keep calm and commit"

> husky-example@1.0.0 test
> echo "Error: no test specified" && exit 1

Error: no test specified
husky - pre-commit script failed (code 1)
```

I was quite confused because in my mind, I did not run any tests? I simply tried to commit. So why was the codebase trying to run tests when I try to commit.

The answer was a tool called [husky](https://typicode.github.io/husky/).

Let's dive straight into it.

### What is Husky really?

Husky is a Git-hook manager for Node projects. It let's you easily manage Git hooks like `pre-commit` and `pre-push` in a Node.js project with an `npm` package.

It is important to note that Git hooks is not something husky invented. Git hooks is a feature provided by git. They are scripts which git automatically runs after a specific event.

By default, Git creates these hooks inside `.git/hooks` but they are disabled and not version controlled. They only live on your local machine.

So with Husky, it is easy to configure, share and version-control Git hooks. 
