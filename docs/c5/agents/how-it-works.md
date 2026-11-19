---
title: How work gets done
description: What happens between asking for something and getting it back.
order: 1
---

# How work gets done

When you ask C5 for something, a lot happens before you get an answer. This page
explains it in plain terms, so the system is not a mystery box.

## The short version

1. **You ask.** One sentence is enough.
2. **C5 makes a plan.** It works out the steps needed.
3. **The work is split up.** Big jobs become smaller jobs.
4. **Agents do the work.** Several can work at the same time.
5. **The results are checked.** Work is reviewed before you see it.
6. **You get the result.** Along with a record of how it was made.

## Why more than one agent

One helper doing everything in order is slow, and it is easy for it to lose the thread
on a long job.

C5 uses a team instead. One part of the system plans and keeps track. Others do the
actual work. Because they work at the same time, a job that would take an hour in a
straight line can finish much faster.

It also means each worker has a small, clear job. A worker with one clear job does it
better than a worker juggling ten.

## Planning

Before anything happens, C5 works out what the job actually needs. It writes this down
as a plan you can read.

You can look at the plan before the work starts. If it is heading the wrong way, say so
and it will plan again. This is much cheaper than letting it finish and starting over.

## Splitting the work

Big tasks become smaller ones. Those can become smaller still, if needed.

This is why one sentence from you can turn into twenty items on the
[Productivity](/c5/using-c5/productivity) Kanban board. Each one is small enough to check and
fix on its own.

## Checking the work

Work is reviewed before it reaches you. If something does not hold up, it goes back to
be done again rather than being handed over broken.

This is why C5 sometimes takes a little longer than you expect — it is checking. You
generally get fewer wrong answers as a result.

### What "passed" means

A task is only finished after **two** checks agree:

1. **The reviewer's verdict.** A reviewing agent reads the work against what you asked
   for. If your task lists several requirements, each one gets its own verdict. One
   failed requirement sends the work back, even if the reviewer liked the rest.
2. **The completion audit.** C5 then checks the facts for itself: the files the work
   says it made really exist, and every requirement you wrote is covered.

A task moves to **Done** only when both pass. The audit runs for trusted agents too:
trust skips the click asking for your approval, not the checks.

If your requirements contradict each other (say, "no more than 500 words" and "at least
2,000 words" for the same piece), C5 adds a comment to the task saying so, so you can fix
the request instead of watching it retry.

### Proof the work was not changed

Every step C5 runs is sealed with a fingerprint linked to the step before it. A task's
shield (on its card, and as a badge at the top of its details) shows what that chain
says; hover the card's shield for the explanation:

| Badge | Meaning |
| --- | --- |
| **VALID CHAIN** | Every step's seal checks out. |
| **UNVERIFIED** | Not checked yet, or something changed since the last check. C5 re-checks it shortly. |
| **INVALID CHAIN** | A step's content no longer matches its seal. |
| Grey shield | The run has no seals to check. |

C5 keeps every seal a step has ever had and will not let one be edited or deleted while
its run exists, so the history behind the badge cannot be quietly rewritten.

## When something goes wrong

Things do go wrong: a website is down, a file moved, a model has a bad moment. C5 is
built to expect this.

- A step that fails is retried.
- If it keeps failing, what happens next depends on the run's autonomy level:
  - **Levels 1 to 3** (you asked to stay in the loop): the task stops in **Blocked** and
    a sign-off asks you what to do. C5 never hands it to an unsupervised team behind
    your back.
  - **Levels 4 and 5**: the run already works on its own, so a recovery team takes over
    and you still get the sign-off to review.
- A task that is waiting on you, or on an agent that is still working, is never marked
  as dead and failed while it waits.
- Nothing half-finished is passed off as done.
- A very long input (a big pasted document, for example) no longer stops a step. C5 gives
  that step more room, up to what the model can actually read. If it still does not fit,
  C5 keeps the beginning and end of your input and marks clearly where it cut.
- If the whole system stops — even a power cut — work resumes from where it was.

## How big a team a task gets

C5 sizes the team to the job. A quick question gets one agent; a simple task gets at most
two; a standard one at most three; larger jobs get more. Words like "build", "implement"
or "deploy" count toward a bigger team, so "build a hello-world app and deploy it" is not
mistaken for small talk. If a plan asks for more agents than the size allows, C5 drops
the repeats but always keeps the agent that produces the final result.

## Watching it happen

You are never locked out. At any point you can:

- Read the plan
- See which step is running
- See what each agent did and what came back
- Stop everything
- Change direction and start again

Nothing is hidden. If you want to know why C5 did something, the record is there.

## Where to go next

- [How C5 learns](/c5/agents/how-c5-learns) — how it gets better at your work over time.
- [Your agent fleet](/c5/agents/fleet) — running more agents at once.
- [Context](/c5/agents/context) — giving your agents standing instructions.
- [Choosing models](/c5/agents/model-routing) — which SI brain does what.
