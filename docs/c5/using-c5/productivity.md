---
title: Productivity
description: The Kanban board — watch, manage, and organize the work your agents are doing, from To do to Done.
order: 3
keywords:
  - kanban
  - kanban board
  - task board
  - board
  - columns
  - to do
  - in progress
  - blocked
  - review
  - done
  - drag and drop
  - sub-tasks
  - pending sub-tasks
  - task queue
  - task orchestration
  - agent network
  - virtual office
---

# Productivity

Productivity is the task board — a **Kanban** board. Every job your agents are doing shows
up here as a card, so you can see the whole picture at once.

The tabs at the top of the page switch between four views of the same work:

| Tab                    | What it shows                                                   |
| ---------------------- | --------------------------------------------------------------- |
| **Kanban**             | The board: one card per task, in columns from **To do** to **Done**. |
| **Task Orchestration** | How a task's steps connect and where each one stands.           |
| **Agent Network**      | Your agents, and the work passing between them.                 |
| **Virtual Office**     | Your agents at work in a 3D office, with a small Kanban board on the wall. |

## The Kanban board

Work moves across columns from left to right as it goes:

| Column       | What it means                                     |
| ------------ | ------------------------------------------------- |
| **To do**    | Lined up and waiting to start.                    |
| **In progress** | An agent is working on it right now.           |
| **Blocked**  | The work stopped before it passed. The card says why. |
| **Review**   | The work passed C5's final check and waits for you to approve it. |
| **Done**     | Finished. Results are in your Library.            |

For work your agents do, **Review** means the work passed. C5 moves a task there once its
final check has passed the work, while **Automated Review** is off; with it on, work that
passes goes straight to **Done**. Open the task to approve or deny it (see below).

**Blocked** means the work stopped before it passed. When C5 stops it, the card says why. If
C5 needs a decision from you, the card asks for it: write a note, then click **Approve** or
**Reject**. Otherwise it shows the reason. A long one is cut to two lines: point at it or tap
it to read the rest, or open the task to see it in full under **Why this is blocked**.

You can drag cards between columns to change what happens next. Move something into
**To do** to queue it up, or out of the way if you changed your mind.

A card with **AI Enabled** off is work for people, and it stays where you put it. Drag one
into **In progress** and it stays there until someone moves it; C5 no longer sends it back
to **To do** after a few idle minutes. A card with **AI Enabled** on that sits in **In
progress** with nothing running is still moved back to **To do**, so C5 can start it again.

A sub-task that orchestration created waits in its own block under **To do** until you
approve it. See [Sub-tasks](#sub-tasks).

## Creating a task

1. Click **New Task** at the top right of the page.
2. Give the task a title and describe the work.
3. Click **Create Task**.

You can also create a task from [Chat](/c5/using-c5/chat#asking-for-something).

### The Intent Wizard in the task window

The **Intent Wizard** under the description of a new task helps you turn a short
description into a clear brief: what to do, how and why, what to leave out, and what a good
result looks like. It works the same way as on the
[Create Task card in Chat](/c5/using-c5/chat#sharpening-a-request-with-the-intent-wizard).
The button can be clicked once the description has some text in it, while **Intent
Wizard** is on in **Settings › Budget** (it is to begin with).

1. Click **Intent Wizard**. C5 fills in **Depth (What/How/Why)** and **Exclusions (What
   to avoid)** from what you wrote. Change anything you like.
2. Click **Next** to have C5 rewrite the description. **Skip** puts your answers into the
   description as they are, and the **×** closes the wizard.
3. While C5 works, the wizard says **Enhancing Intent** (or **Queued** while it waits its
   turn), and the description cannot be edited.
4. Read the new description over, change it if you want, and click **Create Task**.

While the description is being rewritten, or an attached image is still being described,
**Create Task** shows moving dots and waits. Point at it for the reason: _Waiting for the
intent enhancement to finish_, or _Waiting for the image analysis to finish_.

**Abort**, beside **Enhancing Intent**, stops the rewrite for good. Your description goes
back to what it was before you clicked **Next**, and C5 does not try that rewrite again: an
answer that arrives late from it is ignored.

If something goes wrong:

- **You reload the page, or C5 restarts.** The wizard picks up where it was: it finishes,
  or says what went wrong. **Abort** still puts your earlier description back.
- **The rewrite fails.** The wizard says why, with **Retry** and **Abort**.
- **A budget cap is holding it.** The wizard says _Held by the budget cap — Abort to create
  the task without enhancement_. Click **Abort**, then **Create Task**.

### The readiness check

Before a new task is created, C5 takes a quick look at its title and description to see
whether they say enough for the work to start well. The check runs whether **AI Enabled**
is on or off. While it runs, **Create Task** shows a few moving dots, and pointing at it
says _Checking task description readiness_. It gives up after 90 seconds at most.

If the description looks thin, a box opens under the button: **More detail recommended**,
a short reason, and a list of what seems to be missing. You choose what happens next:

- **Edit** closes the box so you can add detail. So does **Esc**, or simply typing in the
  title or description. Click **Create Task** again when you are ready, and C5 checks the
  new text.
- **Intent Wizard** opens the wizard to sharpen the description with you. It is offered
  when the wizard is available and you have not used it on this task yet.
- **Create Anyway** creates the task as it is. C5 does not ask again about the same text.
- **Cancel** asks first: _Cancel task creation?_ _This task has not been created yet.
  Cancelling now will discard it._ **Keep** goes back; **Discard** throws the new task away.

The check never stops you creating a task. If it cannot get an answer — the model is busy
or offline, or it takes too long — the task is created as if the check had passed. A
description the Intent Wizard has already sharpened, and that you have not changed since,
is usually not checked again.

The same check runs when you click **Auto Create** on a task card in
[Chat](/c5/using-c5/chat#asking-for-something), with the same box and the same choices.

### Images and files you attach

When an agent works on a step, it is given the task's attached images, with a few limits
so a request is never too big for the model to accept:

- At most **five images** per step, and about **1.5 MB** of images in all. An image sent
  twice counts once. Large images are scaled down to fit within 1024 × 1024 pixels first.
- Images beyond the limit are not sent, but the agent is told their names, so it knows they
  are on the task.
- Steps that plan or check the work are told the images' names instead of being sent the
  images themselves.
- Other files, such as PDFs and documents, are passed on as text where C5 can read them,
  up to 12,000 characters each, and never as images.

If a model still refuses a request because of the images in it, C5 tries that step once
more with the images left out (the agent is told their names), so the work can carry on.

### Picking a recipe

Under **Recipe**, pick one of your [recipes](/c5/using-c5/labs#recipes), and the task
follows it. Leave it on **— No Recipe (Standard Planning) —**, and C5 plans the work from
scratch. If the recipe you picked has been deleted by the time the work starts, C5 plans
from scratch instead.

If C5 knows a recipe that suits what you wrote, it suggests it under the picker, as
**Suggested recipe:** and the recipe's name. **Use** picks it; **Dismiss** hides the
suggestion.

If the picker is still there when you edit the task later, you can change the recipe and
click **Save**. Once the work has started, the picker is gone.

A recipe you chose on the **Create Task** card in [Chat](/c5/using-c5/chat#asking-for-something)
comes with you: click **User Defined** on the card, and the task window opens with that recipe
already chosen.

### If the pipeline hand-off fails

With **AI Enabled** and **Orchestration** both on, **Create Task** saves the task first, then
hands it to the pipeline. If that hand-off fails, you see _Task created, but its pipeline
hand-off failed. The pipeline will start on its own within a few minutes._

You do not need to do anything. The task is saved. If you created it in **To do**, C5 starts
its pipeline itself within a few minutes, as long as the task is still in **To do** with
**AI Enabled** on, and has not been archived or deleted. If you created it in another column,
its pipeline already started when you created it.

## Looking inside a task

Click any card to open it. Inside you will find:

- **The plan** — every step, and which ones are finished
- **The work** — what each agent did and what came back
- **The cost** — how much this task has used so far
- **The files** — anything made along the way
- **Post-completion recipes** — follow-up recipes that start automatically once this task's work is approved
- **The history** — a full record of what happened, in order

This is the place to look when you want to know *why* something turned out the way it
did.

### Opening a task's files

Once a task has made something, its card lists the files, with **Open Directory** for its working folder.
Anyone who can see a task can open its files and folder this way, not only administrators.
Files open on the computer running C5. If one cannot be opened, the card says why:

- _That file is no longer on disk, or is not one you can open._
- _That file is outside C5's working folder, so it cannot be opened from here._
- _Files open on the machine running C5, not from a remote device._ — you are using C5
  through [Remote Control](/c5/remote-control/overview).

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

## Sub-tasks

While it works on a task, orchestration can split part of the task into a **sub-task**: a
separate task on the board for one piece of the work. This only happens with **Create
Sub-Tasks** turned on in **Settings › General › Tasks**. It is **off** by default, and while
it is off, tasks are never split. See
[the Tasks panel](/c5/configuration/settings#general-the-tasks-panel).

Nothing a sub-task does starts without you. Every new sub-task waits for your approval.

### Telling a sub-task apart

A sub-task's id starts with `task_`, like many other tasks, so look at its id badge
instead: on a sub-task it is **yellow with black text**, on its card and in its task window.
Point at the badge and, under the usual _Click to copy Task ID_ line, it shows **Parent
task:** and the parent's title. Click the title to open the parent task. While you are
editing the sub-task, the parent's name is shown as plain text, so a click cannot throw
your changes away; **Save** or **Cancel** brings the link back.

If a link to a task cannot be opened — the task was removed, or it is not one you may see —
C5 says _That task is not available. It may have been removed, or you may not have access to
it._, and the window stays on what you had open.

### Pending sub-tasks

New sub-tasks wait in a separate block at the bottom of **To do**, headed **Pending
sub-tasks** with a count. The block only appears while there are sub-tasks in it, or while
you are dragging a sub-task.

Nothing in that block is picked up by orchestration. Agents cannot move a pending sub-task
either; only a person dragging it on the board can. Point at the block's heading or the
space between its cards (not at a card) to see a reminder of how it works.

### Approving a sub-task

Drag a sub-task up out of the block into **To do** to approve it. Approving does not start
it at once:

- **Sub-tasks are created with AI Enabled off.** An approved sub-task with AI still off
  stays in **To do** for people to work on.
- **With AI Enabled on,** an approved sub-task is picked up in the normal task order, like
  any other task waiting in **To do**.

To let agents do a sub-task, open it, turn **AI Enabled** on, and click **Save**. You can do
this while it is still pending; it then starts in the normal order once you approve it. On
a sub-task that is pending, or approved but not started yet, the **Orchestration** switch
follows **AI Enabled** and cannot be set on its own. The line under it says where the
sub-task stands: _On with AI Enabled. Waiting for approval — once moved into the upper To Do
area it is picked up by the normal task order._, or, once approved, _On with AI Enabled.
Approved — starts by the normal task order._

You can also drag a pending sub-task straight to another column. Dragged to **In
progress**, it is released for work there: with **AI Enabled** on, its work starts; with it
off, it stays in **In progress** for people.

### Stopping a sub-task

Drag a sub-task back into the **Pending sub-tasks** block, from **To do** or any other
column, to stop work on it. It stays stopped until someone drags it out again. A pending
sub-task asks for no sign-offs, and dragging one into the block withdraws any it was
waiting on; to decide it, drag it out first.

Only sub-tasks can go in the block. Normal tasks cannot be dropped there.

Turning **Create Sub-Tasks** off stops new sub-tasks from being made. Sub-tasks that already
exist stay where they are, pending ones included, until someone moves them.

### The To do count

The count beside **To do** counts tasks and sub-tasks separately. It shows one number when
only one kind is there (**0** when the column is empty), and two when both are: **3/2** means
three tasks and two sub-tasks. Sub-tasks you approved still count as sub-tasks. Point at
the count to see **Tasks: 3** and **Sub-Tasks: 2**, listing only the kinds that are there.

The **ⓘ** beside the page title explains the same rules under **💡 How Sub-Tasks Are
Approved**. That is the place to look on a phone, where the block's own reminder does not
appear.

## Running recipes after a task finishes

Sometimes finishing a task is only the first step. For example, one task might write a
social post and make an image for it. Once that post and image are ready, you might want a
recipe that posts to X.com and another recipe that posts to LinkedIn.

**Post-Completion Recipes** let you line up recipes on a task so they start automatically
as soon as the task's deliverables are approved — using the finished work and images the
task just made.

### When they start

Post-completion recipes wait until the task is approved and moves to **Done**:

- If **Automated Review** is on, the recipes start as soon as C5's review passes the work.
- If the task waits for your sign-off (**Human Review Required**), the recipes start right
  after you click **Approve**.

You can add, remove, or reorder post-completion recipes at any time before the task is
**Done**.

### Setting up a recipe list

When you open a task, the **Post-Completion Recipes** section shows any recipes already
lined up, or _No post-completion recipes configured for this task._ if none are set yet.

1. Open the task and click **+ Add Recipes** (or **Manage** if recipes are already set,
   or double-click the **Post-Completion Recipes** section, or click **Edit** at the top).
2. Under **Post-Completion Recipes**, open **Select a recipe to trigger after completion...**,
   pick a recipe and click **Add Recipe**.
3. Add as many recipes as you need.
4. Drag the handle on the left of any recipe — or use its up and down arrows — to put the
   list in the order you want. Click the trash button to take one off the list.
5. Click **Save**.

### Saving and reusing Recipe Bundles

If there is a set of follow-up recipes you use often — like posting to X.com, then
LinkedIn two hours later, then drafting a newsletter — you can save the whole setup as a
**Recipe Bundle** and apply it to future tasks in one click:

1. In the **Post-Completion Recipes** editor, click **Recipe Bundles** in the top-right
   corner of the section.
2. To save your current list (including its Serial or Parallel mode, custom notes, file
   filters, and wait timers), type a name in **Bundle name** and click **Save Bundle**.
3. On any future task, open **Recipe Bundles** and click **Apply** next to a saved bundle
   to load the entire chain right away.

### One after another, or all at once

Choose how the recipes run with the **Serial** and **Parallel** buttons at the top of the
section. The choice matters once your list has two or more recipes:

- **Serial** runs them one by one from top to bottom. Recipe 1 starts when your task
  is approved. Once Recipe 1 finishes and its work is approved, Recipe 2 starts next, and
  so on down the list.
- **Parallel** starts every recipe on the list at the same time as soon as your task is
  approved.

The editor follows the button you choose. Once recipes are on the list, the line under them
starts with **Serial order:** or **Parallel fan-out:**. While the list is still empty, the
example under the picker changes with it: with **Serial** it describes
_posting to X.com, then LinkedIn_ in serial order, and with **Parallel**,
_posting to X.com and LinkedIn_ in parallel order.

### Extra instructions, auto-matched file filters, and step delays

Click **Options** on any recipe in your list to tailor how that step runs:

- **Custom instructions / channel overrides** — write a short note for just that recipe.
  For example, tell your X.com recipe _"Keep it punchy and add 3 hashtags"_ and your
  LinkedIn recipe _"Use a warm, professional tone for founders."_
- **Deliverables to pass to this recipe (with Auto-match)** — by default (**All types**),
  C5 hands every approved piece of work and image from the task to the recipe. When you
  add a recipe whose purpose is clear (such as a social graphic post, a code deployment,
  or a design review), C5 automatically pre-selects the matching file types (**Document**,
  **Code**, **Design**, or **Image**) and marks them **Auto-matched**. You can click any
  filter pill to change the selection, or click **Auto-match** to restore C5's suggested
  file types.
- **Step Delay Offset (Wait Before Trigger)** — if you want a pause before a recipe
  starts (for example, waiting **+2 hours** after an X.com post before publishing on
  LinkedIn, or **+24 hours** before sending a follow-up summary), pick a delay from the
  dropdown (**Immediate**, **+15 minutes**, **+30 minutes**, **+1 hour**, **+2 hours**,
  **+4 hours**, **+12 hours**, or **+24 hours**).

### Watching the chain and jumping between tasks

On the board, any card that has post-completion recipes — or was started by one — wears a
small **Chain** badge:

- **Chain 2** (indigo) — 2 recipes are lined up and waiting for this task to finish.
- **Chain 1/2** (amber) — step 1 of 2 is running now.
- **Chain 2/2 ✓** (green) — every recipe in the chain has finished.
- **Chain 1/2 !** (red) — the chain stopped and needs your attention.

Inside the task, the **Post-Completion Recipes** section shows which step is running and
gives you one-click buttons — **Jump to Triggered Task**, **Parent Task**, and **Root
Task** — so you can hop straight from the original task to the follow-up tasks it created,
and back again.

When a recipe step is waiting on a **Step Delay** timer, the task shows a **Chain
scheduled** badge along with the time the next recipe is set to start. If you do not want
to wait, click **Run Now** to skip the timer and start that recipe immediately.

### If a chain stops

If a recipe in the chain cannot start (for example, because that recipe was deleted) or a
step in a serial chain fails, the chain stops and tells you why in plain words. Once you
fix the problem, open the task and click **Resume Chain** to start the stopped step and
keep the rest of the chain going.

## Seeing your agents work together

The **Agent Network** view draws your agents as a picture. Lines connect agents that are
passing work to each other, and they light up as work moves.

It is a fast way to spot a bottleneck — if everything is pointing at one busy agent, you
will see it right away.

## Keeping things organized

As you use C5 more, the board fills up. A few ways to keep it under control:

- **Archive** finished work you no longer need to see. **Archived** on the board (_Show
  archived tasks_) opens the archived tasks, and **Filter archived…** finds one again.
- **Deleted** tasks have a drawer of their own (_Show deleted tasks_), with **Filter
  deleted…**, for those allowed to see it.
- **Scheduled** work is hidden until you ask for it: _Show scheduled requests_ puts it on
  the board.
- **Tag** related work so you can pull it up together later. See
  [Tags](/c5/configuration/tags).
- **Put tasks in a project** so client work stays separate from your own. See
  [Projects](/c5/using-c5/library#projects).

## Changing what happens next

You are not stuck with the plan C5 made. You can:

- **Reorder** the queue by dragging cards
- **Pause** a task and come back to it
- **Cancel** a task you no longer want
- **Retry** a task that failed, after you fix what caused it

## The LLM Queue badge

The small badge in the page header, beside the title, is the **LLM Queue**: how many agents
are running right now against how many may run at once, for example **2/3**. Its dot is the
queue's health — green while agents are working, grey while nothing is queued, yellow while
a step is waiting to retry, red when a step has been stuck for longer than your stalled-job
timeout, and grey again while **Master Pause** is on.

When a paid provider is first in **Task Priority**, the badge shows one pair per kind of
provider, each behind an icon: a **server** for local models and gateways (OpenClaw, Hermes
Agent, PicoClaw, LM Studio, Ollama), a **cloud** for paid providers. So **⛁ 1/1 · ☁ 0/2**
means one local agent running of one allowed, and none of two cloud agents. The two
allowances are the **Concurrent Agents** and **Cloud Concurrent Agents** sliders in
**Settings › General** — see [Settings](/c5/configuration/settings#general-how-many-agents-run-at-once).

Hover the badge for the detail: a row per kind of provider named after its slider, and
**Active Agent Slots**, one line per running agent with the provider serving it, the
server or cloud icon beside it, its role, and the step it is on. A gateway always shows
under the server icon, because that is the allowance it counts against — a gateway may
still forward a request to a paid model. Administrators also get a restart button here
for stalled steps.

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

- [Chat](/c5/using-c5/chat) — hand your agents new work in plain words.
- [Library](/c5/using-c5/library) — pick up what your finished tasks made.
- [Schedules](/c5/using-c5/schedules) — run work on a timer.
- [Ops](/c5/using-c5/ops) — set spending limits.
- [Analytics](/c5/using-c5/analytics) — see how your agents are trending.
