---
title: Labs
description: Try changes safely before you use them for real work.
order: 8
---

# Labs

Labs is the safe place to try things. Changes you make here do not touch your real work
until you decide they should.

Think of it as a workshop next to your office. You can take something apart in the
workshop without stopping the work happening next door.

## What Labs is for

- Testing a change before it affects your daily work
- Comparing two ways of doing the same job
- Building a reusable set of steps for something you do often
- Keeping useful abilities in one place

## What is inside

| Tab            | What it is for                                                    |
| -------------- | ----------------------------------------------------------------- |
| **Evolution**  | A record of what improved over time.                               |
| **Factorial**  | Structured tests that compare options fairly.                      |
| **Classifier** | A what-if for the [classifier](/c5/tools/local-classifier)'s confidence threshold. It changes nothing. Shown to accounts that may view Settings. |
| **Variants**   | Different versions of a setup, so you can compare them.            |
| **Skills**     | Specific abilities your agents can use.                            |
| **Recipes**    | Saved sets of steps for jobs you do again and again.               |

## Recipes

A recipe is a plan for a job, kept so it can be repeated. You do not write them —
C5 writes them for you, from work that went well. When a task finishes with a
strong result, C5 distils the sequence of agents that produced it; when the same
sequence proves itself across several tasks, that shape is kept too.

The kinds of job this tends to produce a recipe for:

- A weekly report that always pulls from the same places
- A review checklist you apply to every document
- A set-up routine you run at the start of each project

You choose when to use one. Pick a recipe in Chat when you create a task, in the
task editor on the board, or put one on a timer with
[Schedules](/c5/using-c5/schedules). If what you have written closely matches a
task an existing recipe came from, C5 will point that recipe out beside the
picker — as a suggestion you can take or ignore, never as a decision made for
you.

Each recipe is then judged on results. C5 compares the runs it planned against
what similar tasks score when planned from scratch, and shows the difference on
this tab and in [Analytics](/c5/using-c5/analytics). A recipe that turns out to
do worse than planning from scratch stops being suggested. One that has not been
used enough to say shows nothing rather than a score, because no evidence is not
the same as a bad result.

## Skills

A skill is a specific thing an agent knows how to do. Skills are how you teach C5
something particular to your work — the way your team formats reports, the steps your
process requires, the rules a certain client expects.

You can turn skills on and off. An agent only uses the ones that are switched on.

Because a skill is instructions your agents follow, every skill is scanned before it can
be used, and one with a serious finding is switched off automatically. See
[Skill safety](/c5/security/skill-safety) for what is checked and what is not.

## Comparing options

When you are not sure which of two approaches is better, do not guess. Set them up as
variants and let C5 run both, then look at the results side by side.

This is more reliable than trying one, feeling good about it, and moving on. Small
differences are hard to see by eye but easy to see in a comparison.

> **Note**
> Comparisons need a few runs before they mean anything. One good result can be luck.

A variant's scores start again when the way its role is graded changes. From v327 the
analyst is graded on a rubric of its own, so after updating, the analyst's variants show
**—** under **Avg Score** and **Win Rate** until steps graded the new way score them; their
**Runs** are kept. See [Analytics](/c5/using-c5/analytics#reading-the-charts).

## Evolution

Evolution follows how C5's improvements progress, including what is shared with the
[Mothership](/c5/mothership/overview). A defect C5 found in a past step cannot be confirmed
once that step has been pruned, so it expires (see
[Human review](/c5/using-c5/hitl#training)). When nothing else is shared or on its way, the
sharing panel can say so: _2 findings expired unconfirmed because the steps they ask about
were pruned, so there is nothing to share._ Sharing counts are shown only to an
administrator, on the machine running C5.

## Classifier

**What a threshold would do** shows what the classifier would do at a confidence threshold
(τ) you pick: the decisions it would cover, the tasks it would answer alone, the error it
would make and the calls to the usual model it would replace a week. **Evidence budget**
says how many questions it is asked a week and how many have been labelled so far. Nothing
you do here changes anything: a kind of decision acts on the threshold its promotion gate
measured. See [When it starts to act](/c5/tools/local-classifier#when-it-starts-to-act).

### Automated promotion

Once your system reaches 100 completed tasks, C5 can automatically promote top-performing
prompt variants into production using learned reward models. See
[Self-improvement milestones](/c5/using-c5/ops) for how this milestone unlocks.

## Should you use Labs?

Not at first. Get comfortable with Chat, Productivity, and Library before you come here.

Labs becomes useful once you notice yourself repeating work, or once you want to
improve results rather than just get them.

## Where to go next

- [Budgets & costs](/c5/using-c5/ops) — spending limits and self-improvement milestones.
- [Schedules](/c5/using-c5/schedules) — run a recipe automatically.
- [Analytics](/c5/using-c5/analytics) — see whether a change actually helped.

