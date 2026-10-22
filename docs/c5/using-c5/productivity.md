---
title: Productivity
description: Watch, manage, and organize the work your agents are doing.
order: 3
---

# Productivity

Productivity is the task board. Every job your agents are doing shows up here, so you can
see the whole picture at once.

## The board

Work moves across columns from left to right as it goes:

| Column       | What it means                                     |
| ------------ | ------------------------------------------------- |
| **To do**    | Lined up and waiting to start.                    |
| **In progress** | An agent is working on it right now.           |
| **Blocked**  | Stuck. Usually waiting for you to answer something. |
| **Done**     | Finished. Results are in your Library.            |

You can drag cards between columns to change what happens next. Move something into
**To do** to queue it up, or out of the way if you changed your mind.

## Looking inside a task

Click any card to open it. Inside you will find:

- **The plan** — every step, and which ones are finished
- **The work** — what each agent did and what came back
- **The cost** — how much this task has used so far
- **The files** — anything made along the way
- **The history** — a full record of what happened, in order

This is the place to look when you want to know *why* something turned out the way it
did.

**A task waiting for review** shows **Human Review Required** inside it. Enter your
reasoning, then choose **Approve** or **Deny**. The ruling is offered to someone with
**Edit** on **Sidebar: HITL Button & Modal** in **Settings › Access** who is also the task's
owner or an administrator. A task an agent or C5 itself created has no owner, so anyone
with that permission can rule on it. Anyone else sees why instead of the buttons: _Needs
HITL edit permission to approve or reject tasks._, or _Only this task's owner or an
administrator can approve or reject it._ See [Human review (HITL)](/c5/using-c5/hitl).

When you edit a task, the title, description and reasoning boxes each have a small microphone.
Click it, say what you mean, and click again to stop — your words land in the box so you can read
them over before saving. Reasoning is the one people dictate most: it is the field where you are
explaining yourself rather than naming something, and it is quicker said than typed. See
[Voice](/c5/using-c5/voice).

## Tasks with steps inside steps

Big jobs get broken into smaller ones. A task can have child tasks under it, and those
can have their own children.

On the board, a parent card shows how many of its children are done. Open it to see them
all. This is how one sentence from you can turn into twenty small pieces of work that
run at the same time.

## Seeing your agents work together

The **Agent Network** view draws your agents as a picture. Lines connect agents that are
passing work to each other, and they light up as work moves.

It is a fast way to spot a bottleneck — if everything is pointing at one busy agent, you
will see it right away.

## Keeping things organized

As you use C5 more, the board fills up. A few ways to keep it under control:

- **Filter** by status, agent, or date using the controls at the top.
- **Tag** related work so you can pull it up together later. See
  [Tags](/c5/configuration/tags).
- **Group by project** so client work stays separate from your own.
- **Archive** finished work you no longer need to see.

## Changing what happens next

You are not stuck with the plan C5 made. You can:

- **Reorder** the queue by dragging cards
- **Pause** a task and come back to it
- **Cancel** a task you no longer want
- **Retry** a task that failed, after you fix what caused it

## Pausing everything

**Master Pause**, the pause button in the page header, halts all new AI task steps, for
everyone using this C5. Its tooltip says _Halt all new AI task steps. Click to pause._, and
while it is on the button glows red: _AI orchestration is halted. Click to resume._ Click it
again to resume.

It is for administrators, and for anyone given **Edit** on **Orchestration Master Pause
Button** in **Settings › Access**, which is enough on its own. For anyone else it is greyed
out, with _Needs the Orchestration Master Pause permission (Settings › Access)._ in its
tooltip. Permission to change other settings does not include it. If C5 refuses the change,
the button goes back to how it was.

## When something fails

Failed tasks turn red and move to **Blocked**. Open the card and C5 tells you what went
wrong in plain words.

Most failures are simple: a missing API key, a file that moved, a spending limit reached.
Fix the cause and click **Retry**.

If a task keeps failing, see [Common issues](/c5/troubleshooting/common-issues).

## Where to go next

- [Schedules](/c5/using-c5/schedules) — run work on a timer.
- [Ops](/c5/using-c5/ops) — set spending limits.
- [Analytics](/c5/using-c5/analytics) — see how your agents are trending.
