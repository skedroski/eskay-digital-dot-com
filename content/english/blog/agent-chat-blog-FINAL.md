---
title: "Why Internal Agentforce Shouldn't Be Chat-Based"
date: 2026-03-24
description: "A short description for the card preview"
image: "images/blog/my-first-post.jpg"  # optional
categories: ["AI"]
tags: ["agentic", "enterprise"]
draft: false
---

Most of Agentforce's GTM has been focused on customer-facing applications. Most of those use cases have also been chat-based — meaning the core channel of communication between man and machine is an embedded chat UI within a company's website or app.
It makes sense. It's how people are familiar with using AI. It's the lowest friction entry point for:

1. Consumers to understand its application
2. Buyers who need to see something tangible in a 30-minute demo

This isn't the same for Agentforce as a tool for internal use cases.

## Why Not Internal
### The UI just doesn't work.

When I walk into a dark room, I want the light to turn on. I do not want to take out my phone and type a command to my AI to make that happen. When a rep opens a Salesforce record, their mental model is task-oriented. They're on that page to do something specific. A chat window in that context is an interruption pattern inside a UI that wasn't designed for it.

A rep shouldn't have to know what to ask. They shouldn't have to remember that Agentforce exists and might know something useful. The agent should know when it has something worth saying and surface it contextually.

### The chat paradigm puts the cognitive burden on the rep. The right paradigm puts it on the system.

When a rep is inside Salesforce, they aren't there to "create", "imagine", or "think". A rep is there to perform specific tasks — updating a contract with additional products and terms, for example — or to get critical information in support of more cognitively complex work happening outside Salesforce, like pulling data for a PowerPoint deck. Most Salesforce users aren't expecting to do a lot of typing inside the platform. When we throw chat into the mix, it forces the user to stop and think: "what are you supposed to help me do again?" That's not right. The right pattern is ambient, contextual, and event-driven.

Event-driven means the agent is context-aware and listening to data sources to proactively inform the rep of critical information they need to know. This can come through via text, but is best leveraged within the Salesforce UI itself.

For example, we display LLM-generated overviews of contract field update history for specific roles and profiles. Reps and approvers within Salesforce-based contract processes shouldn't have to sift through fields of data that mean nothing to them. Now, when reps are approving contracts, they get a generated overview of who did what, when, and what they should do next.

## Making it real
We seek to create more "feed like" experiences by leveraging Agentforce to remove a lot of the noise. Now, when reps view an account record, they are no longer being blasted with 100 fields and 50 charts with names that make no sense. THey are being presented a curated list of the most important information to them. Agentforce is what's deciding what surfaces and when.

The goal shouldn't be to get reps to use Agentforce. The goal is to make Salesforce smarter. Chat was a detour.
Chat is a great interface for thinking. Salesforce isn't where reps go to think. Build accordingly.