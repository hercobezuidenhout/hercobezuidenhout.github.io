---
title: Content Project Brief
date: 2025-09-17 21:29:00 +0200
categories: [Projects, Briefs]
tags: []
description: Automate your workflow: write in Notion, publish to your Jekyll blog, and generate AI-powered social posts—all in one system.
---

## Project Goal

Build an automated content workflow that allows content creators to write in Notion and have posts:  
1. Published to a Jekyll blog via GitHub pull requests  
2. Repurposed into social media posts using AI  
3. Automatically posted to social media on scheduled dates  

Notion acts as the single source of truth, Firebase handles the backend orchestration, and GitHub manages version control for the blog.

---

## Phase 1: Notion → Jekyll PR

**Objective:** Automatically turn a Notion page into a blog post in your Jekyll repository.

**Key Features:**
- Webhook triggers from Notion when a new post is ready
- Firebase Function fetches the Notion page content
- Converts Notion blocks into Markdown with YAML front matter
- Commits the post to a new branch in the Jekyll repo
- Opens a pull request in GitHub for review

**Benefits:**
- Streamlined content publishing
- Notion remains the CMS for all posts
- Eliminates manual Markdown editing and GitHub PR creation

---

## Phase 2: AI-Generated Social Snippets

**Objective:** Generate short-form social media content automatically from the blog post.

**Key Features:**
- Firebase AI integration (Vertex AI / OpenAI models) generates platform-specific snippets
- Generates content for Twitter/X, LinkedIn, Instagram, TikTok, etc.
- Stores generated snippets in Notion as linked pages or in a separate "Social Posts" database
- Optional scheduling metadata: `scheduled_date` and `status`

**Benefits:**
- Saves hours of manual social content creation
- Consistent branding and messaging across platforms
- Keeps all social content organized in Notion

---

## Phase 3: Automated Posting

**Objective:** Automatically post social content on scheduled dates.

**Key Features:**
- Firebase Scheduled Function queries due posts daily/hourly
- Posts content via respective platform APIs
- Updates Notion/Firestore with posting status and timestamps
- Error handling, logging, and alerts for failed posts
- Optional: analytics tracking and A/B content posting

**Benefits:**
- Fully hands-off social media management
- Ensures timely posting and content consistency
- Maintains audit trail in Notion

---

## Optional Phase 4: Analytics and Optimization

**Objective:** Track content performance and refine the AI/social pipeline.

**Key Features:**
- Pull engagement metrics from social platforms
- Store analytics back in Notion or Firestore
- Feed insights into AI prompts for future content generation

**Benefits:**
- Data-driven content strategy
- Continuous improvement in social engagement

---

## Technology Stack

- **CMS / Source:** Notion  
- **Backend & Orchestration:** Firebase Functions + Firestore  
- **AI:** Firebase AI / OpenAI / Vertex AI  
- **Blog Hosting:** GitHub Jekyll repo  
- **Version Control & PRs:** GitHub API (`octokit`)  
- **Social Posting:** Platform APIs (Twitter/X, LinkedIn, Instagram Graph API, TikTok)
