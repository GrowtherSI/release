---
title: Schedules
description: Set up work that runs on its own, on a timer you choose.
order: 4
---

# Schedules

A schedule is work that runs on its own. You set it up once, and C5 does it again and
again without you asking.

## Good things to schedule

- A summary of your week, every Friday afternoon
- A check on your inbox each morning
- A report pulled together on the first of the month
- A nightly tidy-up of a folder

If you find yourself asking for the same thing over and over, make it a schedule.

## Making one

1. Go to **Schedules**.
2. Click **New Schedule**.
3. Choose what it does — **Use Recipe**, **Create Task** or **Send Request** — and write
   what you want done, the same way you would in Chat.
4. Pick when it should run.
5. Save.

That is it. C5 takes it from there.

## Picking when it runs

You can choose simple timing in plain words — every day, every Monday, every hour, the
first of each month.

If you need something more exact, you can write a **cron** pattern. Cron is a short way
of describing a repeating time. You do not need to learn it unless you want to.

| You want                | Cron pattern  |
| ----------------------- | ------------- |
| Every day at 9 in the morning | `0 9 * * *`   |
| Every Monday at 8       | `0 8 * * 1`   |
| Every hour              | `0 * * * *`   |
| First day of the month  | `0 9 1 * *`   |

C5 shows you the next few run times before you save, so you can check you got it right.

## Watching them run

Each schedule has a history. You can see:

- When it last ran
- Whether it worked or failed
- How long it took
- What it produced

Click any run to open it like a normal task and see every step.

## Pausing and stopping

You can pause a schedule and turn it back on later. Pausing keeps the setup and the
history — it just stops running for now.

Deleting removes the schedule. Work it already finished stays in your Library.

## If a run fails

A failed run does not stop the schedule: it runs again at its next normal time. Open the
failed run to see what went wrong. Common causes are an expired API key or a spending
limit that was already used up.

**A Send Request schedule tries again sooner.** When its request to the model fails, or
comes back empty, C5 tries it again about a minute later, up to 5 attempts in all. If the
fifth fails too, it gives up on that occurrence, and the schedule's recipients get
**Scheduled Request Failed: <title>**, _Giving up after 5 attempts. Last error: …_ The
attempts before that send no notification.

**Each occurrence starts one run.** A scheduled task is started once for each time it is
due; versions before v327 could start two or three runs of the same occurrence.

> **Tip**
> Set up an alert so you hear about failures right away instead of finding out later.
> See [Settings](/c5/configuration/settings).

## ROI Trackers & System Audits

At the top of the Schedules page, C5 includes built-in **ROI Trackers**. These run automated
audits of your system's productivity, agent performance, and cost savings over regular
intervals.

### Cadences

| Tracker | When it runs | What it measures |
| --- | --- | --- |
| **Weekly** | Every Sunday at midnight | 7-day activity compared to the prior week. |
| **Monthly** | 1st of every month at midnight | Monthly deliverables, success rates, and cost deltas. |
| **Quarterly** | 1st of Jan, Apr, Jul, Oct | 3-month efficiency trends and total output. |
| **Yearly** | January 1st at midnight | Annual executive summary of total tasks and local token savings. |

### How to use them

- **Pause or Resume** — Click **Pause** on any tracker you do not need right now. Pausing keeps your historical numbers intact.
- **Run & Notify** — Click **Run & Notify** to run an audit immediately and send an executive summary to your in-app notifications.
- **View Output** — Click **View Notification Output** on any card to read the latest audit payload directly in the panel.

Each report shows your completed tasks, deliverables, agent success rates, tool usage, and
an estimate of money saved by running models locally for free.

## Things to watch out for

- **Costs add up.** A schedule that runs every hour runs 720 times a month. Set a budget
  in [Ops](/c5/using-c5/ops) before you build a busy schedule.
- **Your computer has to be on.** C5 runs on your machine. If it is asleep, the schedule
  waits. C5 will catch up when it wakes.
- **Start slow.** Run something daily for a week before you move it to hourly.

## Dictating a schedule

The title, description and instructions boxes each have a small microphone. Click it, say what you
want the schedule to do, and click again to stop — the words land in the box so you can read them
over before saving.

The date and time controls have no microphone. Picking a date is faster with the calendar than by
describing it, and a misheard date is the kind of mistake you only notice after a run happens at
the wrong hour.

See [Voice](/c5/using-c5/voice) for turning it on.

## Where to go next

- [Budgets & costs](/c5/using-c5/ops) — spending limits and cost tracking.
- [Analytics](/c5/using-c5/analytics) — charts showing agent quality over time.
- [Recipes](/c5/using-c5/labs) — save repeating jobs in Labs.

