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

Some text here