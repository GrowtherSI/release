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

## What each action does

- **Create Task** — C5 makes a new task from your instructions and works on it. It shows up
  on the [board](/c5/using-c5/productivity) like any other task.
- **Use Recipe** — the same, but the task follows a [recipe](/c5/using-c5/labs#recipes) you
  pick.
- **Send Request** — C5 sends your request to the model and delivers its answer as a
  notification.

When you choose **Use Recipe**, a recipe picker appears beside the three buttons. It says
**No Recipe** until you pick one, and **Save Schedule** stays greyed out until you do. If C5
has not made any recipes yet, no picker appears — use **Create Task** instead.

Each task a **Use Recipe** schedule makes uses the newest version of its recipe at the time
that task starts. If the recipe has been deleted, the task is planned from scratch.

If you edit a **Use Recipe** schedule whose recipe has since been deleted, the picker says
**No Recipe**, but **Save Schedule** still works. Its tasks go on being planned from scratch
until you pick another recipe.

Up to v341, a **Use Recipe** schedule made nothing when it ran. A repeating one made in one of
those versions needs nothing from you: it makes its first task at its next run (once you
resume it, if it is paused). A one-off that one of those versions marked **Completed** made
nothing either. Editing it will not make it run, so if you still want it, make a new one with
**New Schedule**.

## Running recipes after each task

A **Create Task** or **Use Recipe** schedule can line up follow-up recipes, just like a task
can. Each task the schedule makes gets the list. Once that task's work is approved, its
recipes start, using what the task just made.

1. In **Add Schedule** or **Edit Schedule**, find **Post-Completion Recipes**, below the task
   options. It is the same editor you use on a task.
   While the list is empty, the note at the bottom of the editor follows your **Serial** /
   **Parallel** choice: it says _in serial order_ or _in parallel order_.
2. Open **Select a recipe to trigger after completion...**, pick a recipe and click
   **Add Recipe**. Do this for each recipe you want, then drag them into order. If C5 has not
   made any recipes yet, the list says **No proven recipes available yet** and there is
   nothing to add.
3. Choose **Serial** to run them one after another, or **Parallel** to start them all at
   once. Once recipes are on the list, the line under them starts with **Serial order:** or
   **Parallel fan-out:** to match.
4. Click **Save Schedule**.

**Auto Review** decides when they start. It is on for a new schedule. With it on, the
badge at the top of the editor says **Triggers after Automated deliverables approval**, and
the recipes start as soon as C5's review passes the task. Turn it off and the badge says
**HITL** in place of **Automated**: the recipes wait until you approve the task. See
[Human review (HITL)](/c5/using-c5/hitl).

Each follow-up task gets the same review setting as the scheduled task. With **Auto Review**
off, every follow-up task waits for your approval too, and in **Serial** the next recipe
does not start until you approve the one before it. A schedule with three serial recipes then
needs four approvals each time it runs, so turn on **Auto Review** for work you want to run
unattended.

Each follow-up task shows up on the board as its own task, named
_[Recipe: recipe name] scheduled task's title_. See
[Watching the chain and jumping between tasks](/c5/using-c5/productivity#watching-the-chain-and-jumping-between-tasks)
to follow it, and [If a chain stops](/c5/using-c5/productivity#if-a-chain-stops) to get it
going again.

**Options** and **Recipe Bundles** work the same as on a task. See
[Running recipes after a task finishes](/c5/using-c5/productivity#running-recipes-after-a-task-finishes).

Changing the list changes the tasks the schedule makes from then on. A task it already made
keeps its own list, which you can still change on that task until it is **Done**.

Every follow-up recipe is one more task each time the schedule runs, so it adds to what the
schedule costs.

**Send Request** schedules cannot have follow-up recipes. A request just sends back an answer,
with nothing to approve. If you switch a schedule to **Send Request**, its follow-up recipes
are dropped when you save.

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
- [How a scheduled AI agent fits the rest of your week](https://growther.si/scheduled-ai-agent) — the
  plain-words guide on growther.si: what to schedule, and the trade-offs against cron.
