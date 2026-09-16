---
title: Tour of C5
description: A short tour of every area in the C5 app and what each one is for.
order: 1
---

# Tour of C5

C5 has a menu down the left side. Each item opens a different area of the app. This page
gives you a one-line idea of what each area is for, so you know where to look.

You do not need all of these to get work done. Most people live in **Chat**,
**Productivity**, and **Library**. The rest is there when you want it.

## The main areas

| Area             | What it is for                                                  |
| ---------------- | --------------------------------------------------------------- |
| **Overview**     | Your home screen. A quick look at everything happening right now. |
| **Productivity** | The task board. Watch and manage the work your agents are doing.  |
| **Schedules**    | Set up work that repeats, like a weekly report.                   |
| **Chat**         | Talk to your agents and hand them new work.                       |
| **Library**      | Your finished files, notes, projects, and deliverables.           |
| **Ops**          | Budgets, spending limits, and goals.                              |
| **Labs**         | Try out improvements before you use them for real.                |
| **Analytics**    | Charts about how well your agents are doing over time.            |
| **Security**     | Threats that were blocked and risk settings. See [Permissions](/c5/security/permissions). |
| **Monitor**      | System health — is everything running the way it should be?       |

## The manage areas

Lower down the menu you will find settings-style areas:

| Area           | What it is for                                                    |
| -------------- | ----------------------------------------------------------------- |
| **Tags**       | Labels you can put on work to keep it organized.                   |
| **Fleet**      | Run extra agents side by side in their own separate spaces.        |
| **Context**    | The standing instructions and background info your agents work from. |
| **Workspaces** | Group work by team or client, and sign finished work.              |
| **Settings**   | Model providers, security rules, and how C5 behaves.               |

## The profile menu

In the top-right corner of the app, clicking your avatar opens the profile menu:

| Option       | What it is for                                                                                                                     |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| **Users**    | Switch between configured user profiles or set up a new user.                                                                      |
| **Profile**  | Open your profile settings to configure your display name, avatar icon, and authentication credentials (passkey, password, or PIN). |
| **Lock**     | Invalidate your active session immediately and return to the sign-in card in place, keeping running tasks active while securing your station. |
| **Sign out** | Sign out of C5 and return to the sign-in card.                                                                                     |

## The sidebar options menu

At the bottom of the left navigation sidebar, the **Options** menu (`⋯`) provides quick access to server lifecycle controls:

| Option | What it is for |
| --- | --- |
| **Restart** | Reboots the C5 backend server cleanly. Dirty buffers are flushed and your browser reconnects automatically without needing a manual reload. |
| **Quit** | Gracefully shuts down the C5 backend server and closes active connections. |
| **Start C5** | When the server is offline or shut down, replaces Restart and Quit with a green **Start C5** button to launch or wake the server in one click. |

## Overview: your home screen

**Overview** is the first thing you see when you open C5. It answers "what is going on
right now?" at a glance:

- How many tasks are running, waiting, and finished
- What your agents are working on this minute
- What you have spent today and how that compares to your budget
- Anything that needs your attention, like a task waiting for your approval

If something looks wrong, Overview is where you will notice it first. Click any card to
jump to the full area behind it.

## How the areas fit together

Here is the normal path work takes through C5:

1. You ask for something in **Chat**, or a **Schedule** kicks off on its own.
2. The work shows up in **Productivity**, where you can watch each step.
3. Your agents follow the rules you set in **Settings** and **Security**.
4. Spending is counted against the limits you set in **Ops**.
5. Finished work lands in your **Library**.
6. **Analytics** and **Monitor** tell you how it all went.

## Where to go next

Most areas have their own page in these docs, and the rest are covered in
[Security & Privacy](/c5/security/permissions) and
[Configuration](/c5/configuration/settings). Start with the ones you will use most:

- [Productivity](/c5/using-c5/productivity) — the task board.
- [Chat](/c5/using-c5/chat) — how to ask for things well.
- [Library](/c5/using-c5/library) — where your results live.
