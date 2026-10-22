---
title: Human review (HITL)
description: The HITL window, where C5 waits for a person — tasks paused for your sign-off, the guardian's blocked tool calls, the questions that teach the classifier, and the review queues of C5's self-improvement.
order: 11
---

# Human review (HITL)

Some things C5 will not decide alone. A task can pause until someone signs it off, the
guardian can block an agent's tool call, and C5's self-improvement proposes rules and
training examples that a person confirms. All of them wait in one place: the **HITL**
(human-in-the-loop) window.

## Opening it

The window opens from the **clipboard** button at the bottom of the sidebar, between the
**Options** menu (`⋯`) and the notification bell. Hover it for a summary (_3 pending items
require your review._, or _No pending approvals — pipeline is running autonomously._) and a
row for each tab with something waiting; a row opens its tab. A click on the button opens
the window, **HITL: Human-in-the-Loop Signoffs**, on its **Tasks** tab. Escape, or a click
outside it, closes it.

The button carries up to two counts:

- **The amber count** is the number of HITL notifications waiting in **Tasks**, **Rules**,
  **Variants**, **Training**, **Analysis** and **Errors** (_99+_ above 99). A new one plays
  the **HITL Signoff Queue** sound, which you can change under **Settings › Alerts**.
- **The grey count**, on the button's lower corner, is for administrators only, and never on
  a paired device. It counts the questions that teach the classifier: those waiting in
  **Teach the classifier**, and the calls in **Guardian blocks** whose verdict can count
  toward the classifier's evaluation. A **+** means a list holds more than the tab shows. It
  is never added to the amber count and never plays a sound, because these questions hold up
  no work. Hover it for **Questions waiting** and the tabs that have some; a click opens the
  first of them. It is hidden while no model answers the classifier's questions, and it is
  read again every five minutes and when you close the window.

### Who can use it

The **Sidebar: HITL Button & Modal** permission, under **Settings › Access › Feature
Locks**, decides who may use the window: with **View** off the button does nothing, and with
**Edit** off the window opens read-only. The window also needs **View** on **Chat Pipeline
Runner**, and approving or rejecting a task needs **Edit** on both. Administrators always
pass.

**Guardian blocks** and **Teach the classifier** are for administrators, and never on a
device paired through [Remote Control](/c5/remote-control/overview). The account needs a
second factor (a passkey, or a sign-in your identity provider marks as multi-factor), unless
the install was set up without any sign-in. On an install bound beyond this machine
(`GROWTHER_BIND_HOST`), an administrator signed in from another computer's browser sees them
too: what counts is the role, not where the browser runs.

## The tabs

| Tab | Who sees it | What waits there |
| --- | --- | --- |
| **Tasks** | Anyone who may use the window | Tasks paused for a person's sign-off |
| **Guardian blocks** | Administrators | Tool calls the guardian refused, waiting for a verdict |
| **Teach the classifier** | Administrators, while something is asked | Questions whose answers measure the [classifier](/c5/tools/local-classifier) |
| **Evaluations** | Anyone who may use the window | How C5's review rules have classified recent runs |
| **Variants** | Anyone who may use the window | Proposed changes to how agents work, and the variants already kept |
| **Analysis** | Anyone who may use the window | The Retrospective Loop |
| **Rules** | Anyone who may use the window | Review rules C5 proposed, and the rule book in force |
| **Training** | Anyone who may use the window | Defects C5 found in past steps, to confirm or reject |
| **Errors** | Anyone who may use the window | The Auto-Suppression Ledger of repeating errors |

## Tasks

Each paused task shows what it is waiting on. Write a review note, then choose **Approve** or
**Reject**; neither is offered until the note has text. With more than one task waiting,
**Approve All (N)** approves them together, after you add a note to each. Once the last task
is decided, the window closes itself after a short countdown.

## Guardian blocks

The **guardian** checks agents' tool calls before they run. When it refuses one, the block
waits here for a person's verdict: **Guardian blocks awaiting review (N)**. It gates nothing —
the call has already been refused — but your verdict is the only human judgement of
whether the guardian was right.

- **One card per call.** A call the guardian blocked several times is one card, and one
  verdict reviews every block of it: _3 blocks on 2 calls: a call blocked more than once is
  answered once._
- **What a card shows.** **Blocked** and the tool's name, the agent's role, the task, the run
  and the time; then **Why it was blocked**, **What the guardian was shown**, **Full
  arguments** and **Workspace**. Secrets in the text are shown as `«REDACTED:…»`, and text
  that could not be checked for secrets is not shown at all.
- **Your verdict.** **Confirm block** (it was right to refuse) or **Dismiss** (a false alarm).
  C5 asks you to confirm, then records the verdict as a human label: unsafe for a confirmed
  block, safe for a dismissed one. These verdicts are what **Tool-call safety** is measured
  against (see [Teaching it](/c5/tools/local-classifier#teaching-it)). They cover only calls
  the guardian blocked.
- **A second look** is a call the guardian allowed but the classifier rated unsafe. It is
  raised only where Tool-call safety is allowed to act, which this version does not offer
  (Tool-call safety only records), so you are unlikely to see one. Its card reads **Second look:** and the tool,
  shows **Why it was allowed**, and offers **Confirm unsafe** or **Dismiss**.
- **Blocks from before C5 recorded the guardian's decisions** cannot teach anything, so C5
  closes them at start-up without a verdict, and they leave the list.

A guardian block's row in the notification list's **Tool Activity** opens this tab, for an
administrator who is not on a paired device.

## Teach the classifier

The questions that measure the classifier: **Categories to check** (a task's categories to
confirm), **Step outputs to rate** (how good a step's output was, on five levels), and **Tool
calls to check** (whether a tool call the guardian allowed was safe). None of them shows what
the classifier answered, so your answer cannot lean towards it. Each list shows up to 20 at
a time, and **Skip** hides a question from you for a week.

The tab is there only while some model answers the classifier's questions and has something
to ask. Opened from **Ops › Classifier**, or from the grey count, it waits for its questions
to load, and says why if they cannot be read. See
[Teaching it](/c5/tools/local-classifier#teaching-it) for what each question shows and how
its answer counts.

## Analysis

**Run Retrospective Analysis** runs the Retrospective Loop now: it looks back over past runs
for problems the review rules missed, measures how well each rule works, and proposes new
rules. It needs **Edit** on the window. The result reads _Loop completed._ with what was
proposed, audited and expired, for example _Loop completed. Proposed 0 new rules. Audited 1
rule: 15 outside the 14-day activation window. Expired 409 findings whose step was pruned and
1,740 rule proposals unreviewed for 30 days._

When more than 500 jobs are waiting in C5's queue, the loop does not run: _Loop not run.
Skipped: the job queue is backlogged (1,740 pending jobs), so nothing was proposed, audited or
expired._ Run it again once the queue has drained.

## Rules

**Pending Human Approval (N)** lists the review rules C5 proposed; **Active Rule-Book (N)**
lists those in force. Approve a proposal to put it in force, or reject it.

**A proposal nobody reviews for 30 days expires.** Every night at 23:55, and at the start of
each Retrospective Loop, C5 expires the proposals still waiting 30 days after they were made,
including those adopted from the fleet. An expired proposal leaves the list, the badge and
its notification, but it is kept, never deleted. The nightly pass runs only while C5 is
running at that time; a night it is off is not made up.

## Training

**Pending Defect Confirmation (N)** lists the defects C5 found in past steps, for an
administrator to **Confirm Defect** or **Reject**; **Verified Training Signal Dataset (N)**
holds the confirmed ones. A finding about a step that has since been pruned can no longer be
judged, so it expires, on the same nightly pass. Answering one that expired while the tab was
open is refused: _This finding expired: the step it asks about was pruned, so it can no
longer be judged. Nothing was changed._ Reopen the tab to refresh the list.

## Errors

The **Auto-Suppression Ledger** lists the errors that keep coming back. **Mute Noise** hides
one as noise: later occurrences are discarded. **Unmute** brings it back. Muting and unmuting also count as answers for the classifier's **Alert
triage**, when C5 triaged that alert while Alert triage was recording.

## Going back to an earlier version

Versions before v327 do not know that a rule proposal or a finding expired. After going back
to one, the expired ones come back into its **Rules** and **Training** queues.

## Related

- [Classifier](/c5/tools/local-classifier) — what the questions in Teach the classifier and
  Guardian blocks measure
- [Permissions](/c5/security/permissions) — what agents may do without asking
- [Settings](/c5/configuration/settings) — the access permissions and the alert sounds
