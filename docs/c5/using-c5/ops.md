---
title: Budgets & costs
description: Set spending limits and see exactly where your money goes.
order: 6
---

# Budgets & costs

**Ops** is where you keep an eye on the money. It answers one question: what is this
costing me, and where is it going?

## Why budgets matter

Agents use SI models, and most models cost money per use. An agent working on a big job
can make many calls. Without a limit, a runaway task could spend more than you meant to.

Budgets stop that. You set a ceiling, and C5 will not go past it.

## Setting a budget

1. Go to **Ops**.
2. Open the **Budget** tab.
3. Set a limit for the day, the week, or the month.
4. Save.

You can set limits for the whole system, or for one project.

### The voice budget is separate, and lives elsewhere

Speech has its own limit, in the **Voice Spending Limit** panel under **Settings → Budget** —
not on this page. It is separate on purpose: voice is charged by the minute of audio and by the
character of speech read aloud, which is a different shape of spending from the work your agents
do, and most people want a much smaller ceiling on it.

It works the same way as the main cap — a switch, an amount, and a choice of daily, weekly,
monthly or yearly, resetting on the day you pick. C5 works out what a request will cost *before*
making it and refuses rather than overshooting.

Two things never count against it:

- **The built-in on-device engine is free**, so it keeps working even when the voice budget is
  spent. If you want dictation that cannot be interrupted by a limit, put that provider first.
- **Silence is never sent.** A recording with nothing in it is discarded in the browser and
  costs nothing.

See [Voice](/c5/using-c5/voice) for the providers themselves.

## What happens at the limit

C5 does not just stop dead. As you get close, it warns you. At the limit, it pauses new
work and tells you clearly what happened.

Nothing is lost. Paused work waits. Raise the limit or wait for the next period, and it
picks up again.

> **Tip**
> Set your first budget low — lower than you think you need. It is easy to raise later,
> and a low ceiling teaches you what things actually cost.

## Seeing where money went

The Ops charts break spending down by:

- **Time** — today, this week, this month
- **Task** — which jobs cost the most
- **Model** — which SI models you are paying for

If a number looks wrong, click into it. You can follow the cost all the way down to the
task that caused it.

## Other things in Ops

| Tab          | What it is for                                                     |
| ------------ | ------------------------------------------------------------------ |
| **Budget**   | Spending limits and cost charts.                                    |
| **Triage**   | Things that need a decision from you.                               |
| **Errors**   | Problems that came up, grouped so you can spot patterns.            |
| **Audit**    | A record of what happened and when.                                 |
| **Memory**   | What C5 has remembered from your past work.                         |

## Self-improvement milestones

As your agents get real work done, C5 passes milestones. Most of them unlock an advanced
self-improvement feature, held back until there is enough history to be helpful rather
than guessing early and spending your budget on it. One of them simply marks the point
where something you have been doing has built up enough evidence to be worth reading.

When you reach a milestone, a star badge appears in the bottom left of your sidebar. Each
badge is independent — you will see whichever ones you have earned, in any order.

| Milestone | Unlocks at | Sidebar badge | What it means |
| --- | --- | --- | --- |
| **Recipes In Use** | 25 recipe uses | **Gold star** | Recipes have planned 25 tasks. Each one now carries a measured verdict on whether using it beat planning from scratch. |
| **Retrospective Loop** | 50 completed tasks | **Violet star** | Analyzes failed tasks to suggest new review rules and compare rule similarity. |
| **Reward Model Promotion** | 100 completed tasks | **Blue star** | Uses historical data to automatically promote experimental prompt variants when they beat the baseline. |

Note that the three count different things. The Retrospective Loop and Reward Model
milestones count **completed tasks**, so they arrive in that order as you work. Recipes
In Use counts **times a recipe was applied to a task** — something you start doing only
once you have recipes to apply — so it can arrive before either of the others, or long
after. Once earned, a badge stays earned.

### Tracking your progress

The two task-count milestones show their progress in **Settings › Budget**:

1. Go to **Settings**.
2. Open the **Budget** tab.
3. Look at the **Retrospective Loop** and **Reward Model Promotion** cards to see your current completed task count (e.g. `34/50` or `82/100`).

For **Recipes In Use**, the count you are watching is in **Analytics › Recipes**, under
**Blueprint Invocations** — the total number of times a recipe has been applied to a task.

Clicking a star tells you what it unlocked. The Retrospective Loop and Reward Model stars
take you to **Settings › Budget**, where you can turn either feature off to manage token
usage. The Recipes In Use star takes you to **Labs › Recipes** instead, because it does
not switch anything on — it marks the point where there is finally something to look at.

### Using recipes

Recipes are offered, never imposed. When you create a task — in Chat, or in the task
editor on the board — C5 compares what you have written against the tasks each recipe was
distilled from, and if one clearly fits it appears as a suggestion beside the recipe
picker. Taking it is up to you; ignoring it costs nothing.

Every recipe you apply is then measured. C5 compares the quality of the runs that recipe
planned against what tasks of the same complexity score when planned from scratch, and
shows the result on both **Labs › Recipes** and **Analytics › Recipes** as a figure like
`+12.4 vs from scratch`. A recipe with no measurement yet shows nothing at all rather
than a zero — no reuses means no verdict, which is not the same as a bad one. See
[Labs](/c5/using-c5/labs) for where recipes come from.

## Keeping costs down

A few habits help:

- **Use smaller models for simple work.** Not every task needs the most expensive
  option. See [Model providers](/c5/configuration/model-providers).
- **Be specific.** A clear request takes fewer tries than a vague one.
- **Check your schedules.** A frequent schedule is usually the biggest line on the bill.
- **Run models locally** for routine work, and save paid models for the hard parts.

## Where to go next

- [Labs](/c5/using-c5/labs) — recipes, skills, and prompt variants.
- [Analytics](/c5/using-c5/analytics) — track agent performance over time.
- [Settings](/c5/configuration/settings) — full configuration map.

