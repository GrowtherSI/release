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
  the **HITL Signoff Queue** sound (_New item waiting for review in HITL._), which you can
  change under **Settings › Alerts**.
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
Locks**, opens the window. **View** opens it and lists what waits there; with **View** off
the button does nothing. **Edit** is what most decisions in it need: approving or rejecting
a task, **Run Retrospective Analysis**, and **Mute Noise** and **Unmute**. With **Edit** off
the window opens read-only. **Chat Pipeline Runner** plays no part. Administrators always
pass. Three tabs follow other rules, the ones C5 itself applies to their decisions:

- **Rules** and **Training**: their buttons are for an administrator at the machine running
  C5. Anyone else, and any device paired through Remote Control, sees the lists without
  them, whatever their HITL permission.
- **Variants** follows the **Variants** row under **Labs** in **Settings › Access**, not
  this one: its **View** lists the proposed variants, and its **Edit** approves or rejects
  them, with or without **Edit** here.

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
| **Variants** | Anyone who may use the window; its lists need **View** on **Labs › Variants** | Proposed changes to how agents work, and the variants already kept |
| **Analysis** | Anyone who may use the window | The Retrospective Loop |
| **Rules** | Anyone who may use the window | Review rules C5 proposed, and the rule book in force |
| **Training** | Anyone who may use the window | Defects C5 found in past steps, to confirm or reject |
| **Errors** | Anyone who may use the window | The Auto-Suppression Ledger of repeating errors |

## Tasks

Each paused task shows what it is waiting on. Write a review note, then choose **Approve** or
**Reject**; neither is offered until the note has text. Without **Edit**, the note box is
greyed out and says _Needs HITL edit permission to approve or reject tasks._ With more than
one task waiting, **Approve All (N)** approves them together, after you add a note to each.
Once the last task is decided, the window closes itself after a short countdown.

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
- **A check cut short by a restart is not a block.** The call is refused, to be safe, but
  nothing is listed: the step runs again at the next start, and is checked then.

A guardian block's row in the notification list's **Tool Activity** opens this tab, for an
administrator who is not on a paired device.

**If the list cannot be loaded**, the tab says why instead of showing an empty list. An
administrator without a second factor reads _Only an administrator with multi-factor
authentication can review guardian blocks._, followed by how to add one (_Add a passkey to
your profile — that is what counts as MFA here — then try again._, or your identity
provider's advice for a directory account). On a paired device it reads _You can review
guardian blocks only on the machine running C5._, and for an account that is no longer an
administrator _Only an administrator can review guardian blocks._ A session that expired
says _Your session has expired. Sign in again to load guardian blocks._

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

## Variants

**Pending Harness Evolutions (N)** lists the proposed changes to how an agent works, each a
**Variant Proposal** naming the file it changes, the agent's role and the kind of change;
**Stable Variants (N)** lists those already kept. **Approve** keeps a proposal and **Reject**
reverts it, each after you confirm. Both are offered to administrators and to anyone with
**Edit** on the **Variants** row under **Labs** in **Settings › Access**; that row's grant
alone is enough, without the Labs page's own.

Without **View** on that row, the tab reads nothing and says _Harness variants need the Labs
› Variants view permission. An administrator can grant it in Settings › Access._ An **Edit**
grant on the row counts as **View** too.

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
lists those in force. Approve a proposal to put it in force, or reject it. These buttons,
and the tab's others, are for an administrator at the machine running C5: anyone else sees
both lists without them.

**A proposal nobody reviews for 30 days expires.** Every night at 23:55, and at the start of
each Retrospective Loop, C5 expires the proposals still waiting 30 days after they were made,
including those adopted from the fleet. An expired proposal leaves the list, the badge and
its notification, but it is kept, never deleted. If C5 was off, asleep or restarting at
23:55, the pass runs once when C5 next starts, or within the hour if it was already
running, and never twice in one day.

## Training

**Pending Defect Confirmation (N)** lists the defects C5 found in past steps, for an
administrator at the machine to **Confirm Defect** or **Reject** (anyone else sees the list
without them); **Verified Training Signal Dataset (N)**
holds the confirmed ones. A finding about a step that has since been pruned can no longer be
judged, so it expires, on the same nightly pass. Answering one that expired while the tab was
open is refused: its card leaves the list, and the reason stays above the list: _This
finding expired: the step it asks about was pruned, so it can no longer be judged. Nothing
was changed._ Where the expired finding stood for a group of similar ones, the next finding
in the group takes its place.

## Errors

The **Auto-Suppression Ledger** lists the errors that keep coming back. **Mute Noise** hides
one as noise: later occurrences are discarded. **Unmute** brings it back. Both need **Edit**
on the window, as its other decisions do; without it the ledger still shows each error and
its status, with neither button. Muting and unmuting also count as answers for the
classifier's **Alert triage**, when C5 triaged that alert while Alert triage was recording.

## Going back to an earlier version

Versions before v327 do not know that a rule proposal or a finding expired. After going back
to one, the expired ones come back into its **Rules** and **Training** queues.

A rule you approve after going back to an earlier version stays in force when you update
again: C5 clears its old expiry at start-up, so it is listed under **Active Rule-Book** as
before. Only proposals nobody reviewed stay expired.

## Related

- [Classifier](/c5/tools/local-classifier) — what the questions in Teach the classifier and
  Guardian blocks measure
- [Permissions](/c5/security/permissions) — what agents may do without asking
- [Settings](/c5/configuration/settings) — the access permissions and the alert sounds
