---
title: Monitor
description: Check that C5 itself is healthy and running well.
order: 9
---

# Monitor

Monitor is about C5 itself, not about your work. It answers: is everything running the
way it should be?

Most of the time you will never open this page. When something feels wrong, this is
where you look.

## What it shows

| Tab          | What it tells you                                             |
| ------------ | -------------------------------------------------------------- |
| **Summary**  | One screen with the overall state of things.                    |
| **Health**   | Whether each part of C5 is responding normally.                 |
| **Queueing** | How much work is waiting, and whether it is moving.             |
| **Database** | The state of your stored data, its size, and its backups.       |
| **Security** | Recent blocked actions and anything unusual.                    |

## Reading the health view

Each part gets a simple state:

- **Green** — working normally.
- **Yellow** — slow or struggling, but still going.
- **Red** — not working. Something needs attention.

Click any item that is not green. C5 explains what it means and usually what to do.

## When work seems stuck

Open **Queueing**. It shows how many tasks are waiting and how fast they are moving.

A queue that is long but shrinking is fine — it is just busy. A queue that is not moving
at all points at something blocking, usually a missing API key, a spending limit, or a
task waiting for your approval.

## Self-healing

C5 is built to fix itself where it can. If your browser closes, your internet drops, an
SI provider goes down, or the power goes out, C5 keeps track of what it was doing and
picks up where it left off when things come back.

Its data storage repairs, backs up, and recovers itself too. Monitor is where you can
see that this happened.

This means "something went wrong" usually does not mean "start over."

## Disk space

The **Database** tab shows how much room your data takes up. It grows as you use C5 —
history, files, and backups all add up.

If space gets tight, you can shorten how long old history is kept. See
[Backups and recovery](/c5/security/backups).

## When to worry

Open Monitor when:

- Work is much slower than usual
- Tasks are queued but nothing is starting
- You saw an error you did not understand
- You are running low on disk space

Otherwise, leave it alone. A quiet Monitor page is a good sign.

For specific problems and their fixes, see
[Common issues](/c5/troubleshooting/common-issues).
