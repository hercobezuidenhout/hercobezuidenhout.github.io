---
layout: post
title: "Understanding Docker & Kubernetes: A Beginner’s Guide"
date: 2025-03-05
tags: [learning]
---

### Introduction

I have recently been working with Docker & Kubernetes on one my projects (also Helm, ArgoCD, etc.) and I want to put some effort into understanding it more. Below is notes from what I have gathered so far. I will continue to post as I learn, experiment and fail.

### What is Docker?
Docker is a tool that allows you to package and run applications in **containers**. A container includes everything an app needs—code, libraries, and dependencies—so it works the same anywhere.  

### Key Docker Concepts 
- **Docker Image** 🏗️ → A blueprint/template for a container. It can be reused to create multiple containers.  
- **Docker Container** 📦 → A running instance of an image. It runs the app with its dependencies.  
- **Dockerfile** 📜 → A script that defines how to build a Docker image.  
- **Docker Compose** 🔄 → A tool to configure and manage multiple containers on a single machine using a `docker-compose.yml` file.  

### Docker vs. Kubernetes vs. Docker Compose

| Feature              | Docker Compose | Kubernetes |
|----------------------|---------------|-----------|
| **Purpose**         | Manages multiple containers on a single machine. | Orchestrates containers across multiple machines. |
| **Scalability**     | Limited to one machine. | Scales across clusters of servers. |
| **Complexity**      | Simple & easy to set up. | More complex but powerful. |
| **Use Case**        | Local development & small projects. | Large-scale, distributed applications. |

### Can Kubernetes Run on a Single Machine?
Yes! You can run Kubernetes on a single machine using **Minikube, K3s, or Kind**.  

### Can One Container Have Multiple Images?  
No, a **container runs from a single image**, but multiple containers can communicate with each other.  

### Final Thoughts
- **Use Docker** to containerize applications.  
- **Use Docker Compose** for managing multiple containers locally.  
- **Use Kubernetes** for scaling containers across multiple machines.  

By understanding these basics, you’ll be well on your way to mastering containerized applications! 🚀  