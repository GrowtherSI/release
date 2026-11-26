---
title: Your agent fleet
description: Run more agents side by side, each in its own separate space.
order: 2
---

# Your agent fleet

Your **fleet** is the group of agents you have running. The Fleet page is where you see
them, add more, and check on their health.

## Why run several at once

More agents means more work happening at the same time. If you have five separate things
to do, five agents can do them together instead of one doing them in a row.

The limit is your computer and your budget, not C5.

## What is on the Fleet page

| Tab            | What it is for                                              |
| -------------- | ----------------------------------------------------------- |
| **Roster**     | Every agent you have, and what it is for.                    |
| **Deployment** | Each agent's own workspace: its changes, and merging or discarding them. |
| **Assignment** | Giving a group of agents a model, in one batch.              |
| **Health**     | How each agent is doing.                                     |

## Separate workspaces

Each agent can work in its own isolated space. Changes one agent makes do not disturb
another until you decide to bring the work together.

This matters most when agents are editing files. Without separation, two agents changing
the same file at the same time would collide and you would get a mess. With separation,
each works on its own copy and you review the results.

## Reviewing an agent's workspace

**Deployment** lists each agent's workspace, with how many changes it holds (or **Clean**) and
its latest saved change. On a workspace's card:

- **View Diff** shows what the agent changed.
- **Merge Request** offers those changes for merging, and gives you a link to the request.
- **Restore** throws away the changes the agent has not saved. C5 asks first, because this
  cannot be undone.

**Sync Workspaces**, at the top of the page, sets up a workspace for any agent that does not
have one yet.

Only administrators can use **View Diff**, **Merge Request**, **Restore** and **Sync
Workspaces**. The first three work only on agents whose most recent work was in the
administrator's own [workspace](/c5/configuration/workspaces).

## Changing an agent's picture

1. On **Roster**, click the agent's picture on its card. A pencil appears when you hover over it.
2. Click **Browse...** to choose an image, or remove the one it has.
3. For the main agent, you can also type the emoji that stands for it. It must be an emoji, not
   letters or numbers.
4. Click **Save**.

An agent with no image shows its emoji instead. Only administrators can change pictures.

## Giving agents a model

**Assignment** gives a group of agents a model in one batch:

1. **Select Agents** — tick the agents to change.
2. **Target Coordinator** — choose the provider or gateway that should serve them. A card
   that says **key rejected** or **no key** has a problem with C5's key for it; hover it to
   see which key, and where to fix it.
3. **Configure Model** — choose the model.
4. Click **Review Assignment**, then **Confirm & Save**.

Choosing an OpenRouter model,
or one on the **Local Provider** card, saves it into that provider's own settings, and C5
keeps everything else there as it was: price caps, provider limits and data collection. If
C5 cannot read those settings at that moment, it changes nothing and says so, for example
_Could not set M for OpenRouter: C5 could not read its current settings, so it changed
nothing._ Try again once the settings can be read. See
[OpenRouter routing settings](/c5/configuration/model-providers#openrouter-routing-settings).

## How many should you run?

How many agents work at the same time is set by **Concurrent Agents** and **Cloud Concurrent
Agents** in **Settings › General** (see
[how many agents run at once](/c5/configuration/settings#general-how-many-agents-run-at-once)).
Start with the default. Raise it when you actually see work waiting in the queue.

Signs you could use more:

- The queue on [Monitor](/c5/using-c5/monitor) stays long
- Tasks sit in "To do" for a long time before starting
- Your computer is not working hard

Signs you have too many:

- Your computer is slow at everything else
- Costs are climbing faster than work is finishing
- Agents are idle

> **Warning**
> Every running agent can spend money. Set a budget in [Ops](/c5/using-c5/ops) before
> you grow your fleet.

## Health

The Health tab shows whether each agent is working normally, struggling, or stopped.

An agent that keeps failing usually has a cause you can fix — a missing key, a permission
it does not have, a model that is unavailable. Click into it to see.

## Where to go next

- [How work gets done](/c5/agents/how-it-works) — the bigger picture.
- [Budgets](/c5/using-c5/ops) — keeping costs under control as you grow.
