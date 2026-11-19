---
title: How C5 learns
description: How C5 works out which prompts, skills and helpers do your work best, and why it can be trusted.
order: 5
---

# How C5 learns

C5 gets better at your work the more it does. It tries small variations, keeps score of
what actually worked, and leans on what has proven itself. This page explains how that
scoring works, so you know what C5 is and is not concluding from your results.

## It counts, it does not guess

Every time a variation of a prompt (a "variant") is used and its work is graded, C5
records two plain numbers: **how many times it was graded**, and **how many of those it
did well**. Decisions are made from those counts, never from a running average.

Why it matters: an average that drifts with the last few results can make a good prompt
look bad after one unlucky day, and an untested prompt look as good as a proven one.
Counts do not. Five good results out of five is weaker evidence than ninety out of a
hundred, and C5 treats it that way.

## New ideas get a fair trial

A new variant starts as **unmeasured**, not as zero. C5 gives unmeasured variants a fair
share of trials until there is enough evidence either way, then shifts toward the ones
that win. It never retires something that simply has not been tried yet.

A variant is retired only when the evidence says, with high confidence, that it wins less
than 15% of the time. A newer variant replaces its parent only when it is clearly better
over at least ten graded trials each.

> **After this update**, existing variants start again as unmeasured, because the old
> averages cannot be honestly turned back into counts. For a short while C5 explores more
> evenly before it settles. Nothing is lost: the variants themselves are all kept.

## Two kinds of evidence, kept apart

C5 learns from two different signals:

- **The grade** a reviewer gives the work.
- **Whether a review was right**: did a reviewer that passed work let a real problem
  through, or did it send good work back for nothing?

These are counted separately, so one never distorts the other. When a review turns out
to have been wrong, the blame goes to the reviewer that actually made that decision, once
per decision.

## Skills: suggestions, not surprises

C5 tracks which skills help which kinds of agent, taking into account which other skills
were used alongside them, so a skill is not credited for a companion's work.

When a skill is clearly helping an agent role, C5 now **suggests** adding it to that
role. You get a notification and decide. It no longer adds skills to roles by itself,
because those assignments are yours to make.

Earlier versions did add some skills to roles automatically. After this update, an
administrator gets one notification listing the assignments that look like they were made
that way, so you can review them. Nothing is removed for you; keep the ones you want.

## Trusted specialists go first

C5 keeps a trust score for each specialist, built from how its past work was judged. When
the planner chooses who does a step, specialists are listed most trusted first. Nobody is
left off the list, and the planner still picks. A small share of tasks keeps the old order
on purpose, so C5 can tell whether listing by trust actually helps.

## Every choice is recorded

Whenever C5 picks between options (which prompt variant, which helper service), it
records what it picked, the odds it gave each option at that moment, and what actually
ran. That record is what lets C5, and you, check later whether a choice was a good one,
without having to guess what it was thinking at the time.

## Sharing with the fleet

If you are connected to the [Mothership](/c5/mothership/overview), C5 can share prompts
that have proven themselves, and try ones other deployments have proven. The same rules
apply in both directions:

- C5 only shares a prompt backed by real graded results.
- A shared prompt is published to the fleet only when the combined evidence is
  confidently positive. The order results arrive in never changes the verdict.
- Anything that fails C5's privacy screen is never used, and that decision is reported
  back so the fleet stops offering it.
- Prompts offered for a **trial** arrive switched off; you turn them on. A trial you
  never switch on is reported as declined after a week, so the fleet offers it to
  someone else.
- A fleet prompt that has already proven itself can be switched on automatically (the
  default), and C5 switches it back off and restores what it replaced if your own results
  show it doing worse.

## Where to go next

- [How work gets done](/c5/agents/how-it-works) — the checks every task goes through.
- [Settings › Learning](/c5/configuration/settings#learning) — tune the learning pipeline.
- [Human review](/c5/using-c5/hitl) — where variants and rules can be reviewed by hand.
