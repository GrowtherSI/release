---
title: Quickstart
description: Run your first C5 task in about five minutes.
order: 3
---

# Quickstart

This page walks you through your first real task. It takes about five minutes.

Before you start, make sure you have [installed C5](/c5/getting-started/installation).

## Step 1 — Start C5

```bash
growther
```

C5 prints the address it is running on. Open `http://localhost:4299` in your browser to
use the app.

> **Tip — Controlling C5 from your browser**
> Once running, you rarely need to return to your terminal. Click the **Options** menu (`⋯`) at the bottom of the left sidebar to **Restart** or **Quit** C5 anytime. If the server is ever stopped or offline, that same menu (and the offline recovery screen) gives you a green **Start C5** button to wake or launch C5 back up in one click.

## Step 2 — Connect a model

C5 needs a **model** to think with. A model is the AI brain behind your agents. C5 does
not lock you into one — you choose.

1. Go to **Settings**.
2. Open the **Integrations** tab.
3. Pick a provider and paste in your API key.
4. Click **Save**.

C5 checks the key right away and tells you if it works.

> **Note**
> Your API keys are stored encrypted on your own computer. They are never sent
> anywhere except to the provider you chose.

You can also run models on your own machine instead of using a paid service. See
[Model providers](/c5/configuration/model-providers).

## Step 3 — Ask for something

Go to **Chat** and type a task in plain words. Try something small and real, like:

> Read the notes in my Documents folder and write me a one-page summary.

Press enter. C5 will:

1. Read what you asked for.
2. Make a plan and break it into steps.
3. Do the steps, asking you before it does anything risky.
4. Hand you the finished result.

You will see it working as it goes. Nothing is hidden.

## Step 4 — Watch the work happen

Open **Productivity** in the left menu while your task runs. You will see your task on a
board, moving from column to column as it goes: waiting, working, done.

Click any task to open it. You can see the steps, the tools used, and how much it cost.

## Step 5 — Pick up your results

Finished work lands in the **Library**. Open it and you will find your summary saved
there, along with any files that were made along the way.

## What just happened

You gave C5 one sentence. It turned that into a plan, did the work with a team of
agents, showed you every step, and saved the result. That is the basic loop. Everything
else in C5 builds on it.

## Try these next

- **Schedule it.** Want that summary every Monday morning? See
  [Schedules](/c5/using-c5/schedules).
- **Set your limits.** Put a cap on spending in [Budgets & costs](/c5/using-c5/ops).
- **Tighten the rules.** Decide what agents may do on their own in
  [Permissions](/c5/security/permissions).
- **Take the tour.** See what every part of the app does in
  [Tour of C5](/c5/using-c5/overview).
