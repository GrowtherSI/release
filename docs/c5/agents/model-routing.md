---
title: Choosing models
description: Match the right SI model to the right job to balance quality, speed, and cost.
order: 4
---

# Choosing models

A **model** is the SI brain an agent thinks with. C5 does not lock you into one. You can
use several, and let different jobs use different ones.

## Why this matters

Models differ in three ways that pull against each other:

- **How capable they are.** Stronger models handle harder problems.
- **How fast they are.** Smaller models answer quicker.
- **What they cost.** Stronger usually costs more per use.

Using the strongest model for everything works, but you pay for power you do not need on
simple jobs. Using the cheapest for everything saves money until it gets something
important wrong.

The answer is to match the model to the job.

## A simple approach

| Kind of work                              | What to use             |
| ----------------------------------------- | ----------------------- |
| Sorting, labeling, simple formatting      | A small, fast model     |
| Everyday writing and summarizing          | A mid-range model       |
| Hard reasoning, tricky analysis, planning  | Your strongest model    |
| Bulk repetitive work                      | A local model, if you can |

C5 sets sensible defaults so this works reasonably well before you touch anything.

## Changing the defaults

1. Go to **Settings**.
2. Open the model routing section.
3. Choose which model handles which kind of work.
4. Save.

You can also set a single model for everything if you prefer simplicity over savings.

## Running models on your own machine

You can run models locally instead of paying a service. Local models:

- **Cost nothing per use** once set up
- **Keep everything on your computer** — nothing leaves at all
- **Keep working offline**
- **Are usually less capable** than the best paid models
- **Need a reasonably powerful computer**

A common setup is local models for routine work and a paid model for the hard parts.
See [Model providers](/c5/configuration/model-providers) for how to connect one.

## When a model is unavailable

Providers have outages. When one is down, C5 can fall back to another model rather than
stopping. You choose the order it tries.

This is worth setting up if you rely on schedules that run while you are not watching.

## Watching the cost

The [Ops](/c5/using-c5/ops) charts break spending down by model. If one line dominates,
that is where to look first — often a job is using a stronger model than it needs.

> **Tip**
> Change one thing at a time and check [Analytics](/c5/using-c5/analytics) afterwards.
> If quality holds steady on a cheaper model, keep the saving. If it drops, put it back.
