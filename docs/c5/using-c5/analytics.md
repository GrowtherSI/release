---
title: Analytics
description: Charts that show how well your agents are doing over time.
order: 7
---

# Analytics

Analytics answers one question: **is this working?**

Productivity shows you what is happening now. Analytics shows you the pattern over
weeks and months.

## What you can see

The Analytics area has several views. Each one looks at your agents from a different
angle:

| View               | What it tells you                                              |
| ------------------ | -------------------------------------------------------------- |
| **Intell**         | Performance insights across your agents' work.                  |
| **Agents**         | Which agents finish their work well, and which struggle.        |
| **SubAgents**      | How well work splits up when a job gets divided.                |
| **Skills**         | Which skills get used.                                          |
| **Recipes**        | Which recipes get used, and how they compare with planning from scratch. |
| **Prompts**        | Which kinds of requests get good results.                       |
| **Accountability** | Each agent's penalties, autopsies and quality over the last day, as a leaderboard. |
| **Autonomy**       | How much work finished without needing you.                     |
| **Quality**        | How often work comes out right the first time.                  |
| **Classifier**     | How the [classifier](/c5/tools/local-classifier) does against the usual model, its gate's history and its calibration. Needs permission to view Settings; see [Analytics › Classifier and Labs › Classifier](/c5/tools/local-classifier#analytics-classifier-and-labs-classifier). |
| **Resilience**     | How well the system recovers when something goes wrong.         |
| **Retro**          | What the Retrospective Loop found and proposed.                 |
| **Rework**         | How often work had to be done twice.                            |
| **Tools**          | Which tools get used most, and which ones fail.                 |

## Reading the charts

Most charts show a line over time. What matters is the **direction**, not any one day.

- **Going up on quality and autonomy** means things are getting better.
- **Going up on rework** means something changed for the worse.
- **A sudden jump** usually points at a change you made — a new model, a new setting, a
  new kind of task — but it can also be a change in C5 itself.

If you spot a change, look at what you did around that date, and at what C5 changed. For
example, from v327 analyst steps are graded on a checklist of their own (quality rubric
v4) instead of the researcher's, whose markers the analyst is never asked for. On the one
install measured, the analyst's average score rose from about 20 to about 40: many outputs
scored the same and some rose a lot. The analyst's prompt-variant scores and running
average started again on the new scale. **Rework › Improvement Timeline** records the change
as a _rubric cutover_; no other chart marks it.

## When one check fails almost every step

Each graded step is scored against a checklist (the role's quality rubric). When nearly
every step of a role fails the same check, the check may not fit what that role is asked to
do — which is how the analyst came to score F on every step before it had its own rubric.

So every night at 23:55 C5 looks at each role scored in the last 30 days: at its last 20
scored steps on its current rubric. When at least 10 of them are scored on one check and at
least 90% of those fail it, administrators get a notification, **Scoring check: <role> steps
fail "<check>" almost every time**, saying how many failed. Nothing is changed: the scores
stand until the rubric or the role's instructions are corrected.

It is raised once for each role, check and rubric version, and does not come back once
acknowledged. A notification you delete is raised again the next night if the check still
fails. A night C5 is not running at 23:55 is skipped.

## Getting better over time

C5 learns from how you use it. As it sees more of your work, it gets better at it. The
Analytics charts are where you watch that happen.

If you connect to [Mothership](/c5/mothership/overview), your setup also benefits from
what works well across the whole Growther community, not just your own history.

## Using this day to day

You do not need to read Analytics often. Check in when:

- **Something feels slower or worse** — compare this week to last.
- **You changed a setting** — see whether it helped.
- **You are deciding what to automate next** — look at what already works well.
- **Costs went up** — pair this with [Budgets](/c5/using-c5/ops) to find the cause.

## What is not here

Analytics measures your own setup, on your own machine. These numbers are yours. They
are not shared with anyone unless you choose to connect to Mothership, and even then
what is shared is limited — see [Privacy](/c5/mothership/privacy).
