---
title: Context
description: Give your agents standing instructions and background they always know.
order: 3
---

# Context

**Context** is what your agents already know before you ask them anything. It is the
background you would give a new coworker on their first day.

Without it, you end up repeating yourself. With it, you say what you want once and it
sticks.

## What to put in it

Good context is the stuff that is true every time:

- **Who you are.** "I run a two-person design studio."
- **How you like things.** "Keep writing short. No exclamation marks."
- **Where things live.** "Client work is in the Clients folder."
- **What to avoid.** "Never change anything in the archive folder."
- **Words you use.** What your team means by a term that might mean something else
  elsewhere.

## What to leave out

- **One-off details.** If it only matters for today's task, just say it in Chat.
- **Anything secret you would not write down.** Context is kept as plain text files on
  your machine, and agents read it every time they work. Keys and passwords belong in
  [Settings](/c5/configuration/settings), which is built for them.
- **Long documents.** Attach those to a chat instead. Context is for standing
  instructions, not reference material.

## Editing it

1. Go to **Context**.
2. Under **Agent**, pick the agent you are editing. It starts at the main agent. If you use
   more than one local coordinator (OpenClaw and Hermes Agent), choose one under
   **Coordinator** first.
3. Open a file from the list. **Context** holds who the agent is and who you are, **Memory**
   what it has remembered, and **Operational** its working files and skills. Files inside a
   folder open read-only.
4. Write in plain words. Sentences are fine — you do not need a special format.
5. Click **Save**.

Changes apply to new work right away. Work already running keeps the context it started
with, so nothing changes under its feet mid-task.

Agents are shared by the whole install, so the Context page shows their files only in the
**Default** [workspace](/c5/configuration/workspaces).

## Shared and per-agent

There are two levels:

- **Shared context** — the files every agent starts from.
- **Per-agent context** — an agent's own copy of a file, with extra instructions for the
  kind of job it does.

The list shows an agent's own copy of a file when it has one, and the shared file when it
does not. Saving a file writes that agent's own copy, so the other agents are not changed.

## Writing context that works

Be direct and concrete.

Instead of "be professional", write "no slang, no emoji, and always use the client's
full company name."

Instead of "be careful with files", write "never delete a file — move it to the Old
folder instead."

The more specific you are, the less you will need to correct later.

> **Tip**
> When you catch yourself correcting the same thing twice, that correction belongs in
> context.

## Keeping it tidy

Context is read every time your agents work. A short, sharp context works better than a
long rambling one. Review it every so often and cut what no longer applies.
