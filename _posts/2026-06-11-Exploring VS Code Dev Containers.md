---
title: Exploring VS Code Dev Containers
date: 2026-06-11
categories: []
tags: []
---

I have been a software engineer for more than 5 years. Professionally. I have freelanced for a good 3 years before joining my first company. So let's say in total, I have been building software for people for 8 years.

If we want to measure since I *started writing code*, well I wrote my first C# program which was a mobile game with Unity in 2016 so that would mean that I have been writing code for about 10 years.

All this time, and I have yet to understand what Docker is.

## The VS Code Problem

VS Code is an incredible text editor (yes, I said it. Text editor. No, it is not an IDE. Let's not get into that right now.) and what makes it great is that you can virtually write any program in it. Whether that program is Java or Kotlin or C# or JavaScript.

It. Doesn't. Matter

Moreover, you can install extensions that essentially add functionality to your VS Code instance. From small git blame annotations to massive unit testing frameworks!

The thing is that each project still needs its own set of dependencies installed and its own collection of extensions to really make VS Code work for that project.

After a while, you end up with a VS Code set up so wild that you find yourself factory resetting your entire machine just to get a clean VS Code again.

And so it repeats.

> While writing this piece, I realized that the whole factory reset thing might just be me. I don't know.

## Enter dev containers

The concept of containers and dev containers isn't specific to VS Code. VS Code simply offers some extensions that make working with containers while developing incredibly easy and useful.

With VS Code Dev Containers, you can spin up the project in a Docker container. The container then installs all of the dependencies and VS Code extensions you might need for that specific project. It also opens a new VS Code window that is focused purely on that container.

Beautiful.

But what does this mean in practice?

Well, with containers, my *main VS Code instance* only has about 5 or 6 extensions installed. Most of them being related to getting VS Code dev containers working.

When I need to work on a Rust project, I can clone the repo, open it in a dev container and start writing code without having to install any specific extensions (because they are configured as part of the dev container) and without having to install Rust or any dependencies it might need like PostgreSQL and Kafka.

Same goes for a Java project or a C# project or a NextJS project.

The tech stack doesn't matter.

## Docker

So here is the kicker: VS Code Dev Containers are Docker containers.

This means that you can use Dockerfiles and `docker-compose.yaml` to really beef up your dev container setup.

So while I am learning how to use VS Code Dev Containers, I am also starting to understand how docker works.

And it is actually brilliant.

