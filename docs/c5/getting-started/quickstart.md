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
> Once running, you rarely need to return to your terminal. Click the **Options** menu (`⋮`) at the bottom of the left sidebar to **Restart** or **Quit** C5 anytime. If the server is ever stopped or offline, that same menu (and the offline recovery screen) gives you a green **Start C5** button to wake or launch C5 back up in one click.

## Step 2 — Set up your profile

The first time you open C5, it greets you with **Welcome to Growther.si C5**. A short
video, **Quick Tutorials Overview**, opens on top of it to show you how C5's video
tutorials work (see [Video tutorials](#video-tutorials) below). Watch it, or close it and
pick **Remind me next visit** or **Dismiss**.

1. Click **Setup Profile**, or click anywhere on the welcome screen.
2. Enter your name and choose an icon.
3. Choose how you sign in: a passkey, a password, a PIN, or none.
4. Save your profile.

Next, the **Growther.si C5 Onboarding** window walks you through the rest, one step at a
time: **Introduction**, **LLM Integration** (pick one or more AI providers, on your own
computer or in the cloud), **Agent** (name your main agent and set its rules), and
**Review Settings**. Click **Next** to move on, and **Finish** at the end.

## Step 3 — Connect a model

C5 needs a **model** to think with. A model is the SI brain behind your agents. C5 does
not lock you into one — you choose.

**Finish** in the onboarding window brings you straight to **Settings › Integrations**.
You can come back here at any time:

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

## Step 4 — Ask for something

Go to **Chat** and type a task in plain words. Try something small and real, like:

> Read the notes in my Documents folder and write me a one-page summary.

Press **Enter**. A **Create Task** card appears in the chat with your request and its
options.

1. Click **Skip** to use your words as they are. (Or click **Intent Wizard** to let C5 help
   you sharpen the request first — see
   [The Intent Wizard](/c5/using-c5/chat#sharpening-a-request-with-the-intent-wizard).)
2. Click **Auto Create**.

C5 will then:

1. Read what you asked for.
2. Make a plan and break it into steps.
3. Do the steps, asking you before it does anything risky.
4. Hand you the finished result.

You will see it working as it goes. Nothing is hidden.

## Step 5 — Watch the work happen

Open **Productivity** in the left menu while your task runs. You will see your task as a
card on the **Kanban** board, moving from column to column as it goes: waiting, working,
done.

Click any task to open it. You can see the steps, the tools used, and how much it cost.

## Step 6 — Pick up your results

Finished work lands in the **Library**. Open it and you will find your summary saved
there, along with any files that were made along the way.

## What just happened

You gave C5 one sentence. It turned that into a plan, did the work with a team of
agents, showed you every step, and saved the result. That is the basic loop. Everything
else in C5 builds on it.

## Video tutorials

C5 has short videos that show you around. The first time you open a page or window that
has one, a small box appears in the bottom-right corner — _Chat tutorial available_, for
example, with a **Watch Chat Tutorial** button.

- **Watch** plays the video in a large window, with notes under it. When the video ends,
  click **Complete**.
- **Not now?** Click the **×** on the box and choose **Remind me next visit** to see it
  the next time you come to that page, or **Dismiss** to stop it appearing.
- **Closing a video early** asks _Close tutorial?_ Choose **Remind me next visit** or
  **Dismiss**.

To watch one again, or one you dismissed:

1. Open the **Options** menu (`⋮`) at the bottom of the left sidebar.
2. Click **Tutorials**. The window lists the tutorials for the pages you can use, and how
   many you have completed.
3. Click a title to play it.

Click a tutorial's status icon to reset it, so its box appears again on your next visit,
or use **Reset all tutorials** to start over. C5 keeps track for each user separately.
Finish them all and a teal star appears in the sidebar; click it to open **Tutorials**
again.

## Try these next

- **Schedule it.** Want that summary every Monday morning? See
  [Schedules](/c5/using-c5/schedules).
- **Set your limits.** Put a cap on spending in [Budgets & costs](/c5/using-c5/ops).
- **Tighten the rules.** Decide what agents may do on their own in
  [Permissions](/c5/security/permissions).
- **Take the tour.** See what every part of the app does in
  [Tour of C5](/c5/using-c5/overview).
