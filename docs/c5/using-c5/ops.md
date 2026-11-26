---
title: Budgets & costs
description: Set spending limits and see exactly where your money goes.
order: 6
---

# Budgets & costs

**Ops** is where you keep an eye on the money. It answers one question: what is this
costing me, and where is it going? The limits themselves live in **Settings › Budget**;
Ops shows what is being spent against them.

## Why budgets matter

Agents use SI models, and most models cost money per use. An agent working on a big job
can make many calls. Without a limit, a runaway task could spend more than you meant to.

Budgets stop that. You set a ceiling, and C5 will not go past it.

## Setting a budget

The **Hard Budget Cap** is **on from the start, at $10 a month**, resetting on the 1st. To
change it:

1. Go to **Settings › Budget**.
2. In the **Hard Budget Cap** panel, set the **Spend Limit** in US dollars, then choose the
   period — daily, weekly, monthly or yearly — and the day it starts again. **0** means no
   limit. The switch turns the cap off altogether.
3. Under **Per-Task Budget Guards**, the button beside **Max Cost per Task** reads
   **Block** or **Notify**. It decides what the Hard Budget Cap does too: **Block** (the
   default) pauses new work at the cap, and **Notify** only tells you.
4. Click **Save**.

**Ops › Token Budget** then shows what is being used and spent against it.

**Per-Task Budget Guards** also limit each task on its own: **Max Tokens per Task**, **Max
Duration per Task** and **Max Cost per Task**. A task that passes one is paused (or, set to
**Notify**, carries on and you get a notification).

The Hard Budget Cap counts the whole install, whichever [workspace](/c5/configuration/workspaces)
the spending came from.

### How the cap counts

The cap adds up everything spent since the current period began, by this machine's own
calendar: a daily cap starts again at local midnight, a weekly or monthly one on the day you
chose, wherever in the world the machine is. Every day's spending counts, the classifier's
questions to a model your provider bills included, and **Ops › Token Budget** shows the same
days: today's use, the last 7 and 30 days, and the month. So do the spending figures on the
provider cards in **Settings › Integrations** and the token costs in the
[ROI reports](/c5/using-c5/schedules#roi-trackers-system-audits). A swarm agent's spending
is filed under the local day too; what earlier versions filed for it under the UTC day stays
there, so around midnight a day can hold a little of its neighbour's.

> **Note**
> Up to v329 the cap counted the wrong days in two ways. The installed app filed each day's
> use under a date written the American way (`10/22/2026`), which the cap could not put in
> order: it left out most of that spending, could count some older days in every period,
> and **Ops › Token Budget** showed nothing for today. And in a time zone ahead of UTC — most
> of Europe, Asia and Australia — every period began a day early, so a daily cap also counted
> yesterday's spending. Both are fixed. On the first start after updating, C5 refiles the use earlier
> versions recorded that way under the right day, so it shows again and counts in the right
> period.

### The voice budget is separate

Speech has its own limit, in the **Voice Spending Limit** panel on **Settings › Budget**,
below the Hard Budget Cap. Speech spending does not count toward the Hard Budget Cap. It is
separate on purpose: voice is charged by the minute of audio and by the character of speech
read aloud, which is a different shape of spending from the work your agents do, and most
people want a much smaller ceiling on it.

It works the same way as the main cap: a switch, an amount, and a choice of daily, weekly,
monthly or yearly, resetting on the day you pick. It is **on from the start at $10 a month**,
and only an administrator at the machine can change it. An optional per-person limit stops one
account using up everyone's allowance. C5 works out what a request will cost *before*
making it, and skips a paid provider rather than going over.

### Voice Spend

The **Voice Spend** section of **Ops › Token Budget**, below the usage and cost cards and just
above **System Automation Budget**, shows what speech has cost. Choose **7 days**, **30 days** or **90 days** at its top right.

- **Spent this period**, against the limit, as a meter that warns from 80% and says when the
  limit is reached. If the limit is switched off, it says so. The limit counts the whole
  install; when your workspace spent less than that, the line under the figure says how much
  was yours.
- **Spend per day**, split into speech-to-text and read-aloud.
- **Where it went**: by provider, by where it came from (dictation, read-aloud, attachments,
  voice notes, agents), and, for administrators, by person. Spend recorded before this
  tracking existed shows as **Before tracking**.

Two things never count against it:

- **The built-in on-device engine is free**, so it keeps working even when the voice budget is
  spent. If you want dictation that cannot be interrupted by a limit, put that provider first.
- **Silence is never sent.** A recording with nothing in it is discarded in the browser and
  costs nothing.

See [Voice](/c5/using-c5/voice) for the providers themselves.

## What happens at the limit

C5 does not just stop dead. At the limit, it pauses new work and tells you clearly what
happened (with **Notify** chosen, it only tells you).

Nothing is lost. Paused work waits. Raise the limit or wait for the next period, and it
picks up again.

> **Tip**
> Set your first budget low — lower than you think you need. It is easy to raise later,
> and a low ceiling teaches you what things actually cost.

## Seeing where money went

The **Token Budget** tab breaks spending down several ways:

- **Cost Accounting** — **Today's Cost**, the **30-Day Average**, **Month-to-Date Cost** and
  **YTD Actual Cost**.
- **Token Usage Heatmap** — use by hour over the past 7 days, so you can see when the busy
  times are.
- **Cost Per Task** — the tokens each recent task used.
- **Coordinator Split** — how much of the use went through each coordinator.
- **Top Agent Consumers** — which agents use the most.
- **System Automation Budget** — what C5's own background work used.
- **Voice Spend** — what speech cost (see above).

## Whose numbers you see

Ops shows **your own workspace**: the spending and history of the work done there.
Administrators have an **All workspaces** switch in the page header (the stacked layers icon on
a narrower window). Turn it on to see every workspace on this install combined. It is off until
you turn it on, and C5 remembers the choice in this browser. The same switch is on
[Labs](/c5/using-c5/labs#whose-results-you-see) and [Analytics](/c5/using-c5/analytics).

## Other things in Ops

| Tab          | What it is for                                                     |
| ------------ | ------------------------------------------------------------------ |
| **Token Budget** | What is being used and spent, and where it went: by day, task, coordinator and agent, plus voice. See [Seeing where money went](#seeing-where-money-went). |
| **Triage**   | Queue health at a glance: pending jobs, background jobs waiting for a gap in real work (and how many expired unrun after 7 days), saga rollbacks, how effective triage briefs are, and a forecast of budget impact. |
| **Memory**   | What C5 has remembered from your past work.                         |
| **Audit**    | A record of what happened and when, including what C5 did about stuck runs. See [Audit trail](/c5/security/audit-trail). |
| **Learning** | Reward signals by agent and gate, so you can see which prompts and routes are improving. |
| **Classifier** | How the [classifier](/c5/tools/local-classifier) is doing: its decisions, its speed, the calls it replaced and the labels waiting. **Whose answers** switches between the built-in model's record and a chosen model's. Only accounts that may view Settings see it. |
| **Errors**   | Problems that came up, grouped so you can spot patterns. **Cluster Merge Candidates** lists groups that look like the same error; merging one into another, or dismissing the pair, needs **Edit** on **Sidebar: HITL Button & Modal** in **Settings › Access**, and anyone else sees the list without those buttons. |

**Background LLM Jobs**, on **Triage**, counts the background improvement work waiting for a
gap in real work — delegation autopsies, skill crystallisation, sparring matches — and how
many expired: a job still waiting after 7 days expires without running. It is read when
you open Ops.

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
| **Retrospective Loop** | 50 completed tasks | **Violet star** | Analyzes failed tasks to suggest new review rules and compare rule similarity. You review them in [Human review (HITL)](/c5/using-c5/hitl#rules); one nobody reviews for 30 days expires. |
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
usage. The Retrospective Loop's switch there needs **Edit** on **Sidebar: HITL Button &
Modal** in **Settings › Access**. The Recipes In Use star takes you to **Labs › Recipes** instead, because it does
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
- **Know what runs in the background.** C5 improves itself in the gaps between real work —
  autopsies of delegated work, skill crystallisation, sparring matches, alert triage — and
  that work uses tokens too, on the models in the **System Priority** column of **Settings ›
  Integrations › Coordinator Priority**. It waits while chats, tasks or schedules hold the
  models, and the prompt optimizer waits as well. At a global cost cap set to block,
  background jobs stay queued, and expire after 7 days.

## Where to go next

- [Labs](/c5/using-c5/labs) — recipes, skills, and prompt variants.
- [Analytics](/c5/using-c5/analytics) — track agent performance over time.
- [Settings](/c5/configuration/settings) — full configuration map.

