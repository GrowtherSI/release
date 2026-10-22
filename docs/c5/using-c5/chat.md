---
title: Chat
description: Talk to your agents, hand off work, and share files.
order: 2
---

# Chat

Chat is where you tell C5 what you need. You type in plain words. C5 figures out the
rest.

## Asking for something

Type what you want and press enter. You do not need special words or a set format.
These all work:

> Summarize these three reports and tell me where they disagree.

> Find every place in my project that still uses the old company name.

> Draft a reply to this email. Keep it short and friendly.

C5 reads your request, makes a plan, and starts working. You will see the plan before
the work begins, so you always know what is about to happen.

The card that shows it also holds the task's options, such as **Tools**, **Orchestration**,
**Auto Review**, the task type and the priority. C5 suggests a task type from what you
wrote. Once you pick one yourself, a suggestion that arrives later leaves your pick alone,
and the card keeps what you chose if you reload the page or come back to the chat.

## Bringing back something you sent

Press **↑** in the message box to bring back the last thing you sent, the same way a
terminal brings back your last command. Press it again to keep going further back, and
**↓** to come forward again.

If you were part-way through writing something when you pressed ↑, it is not lost. Press
↓ past your newest message, or press **Esc**, and your half-written message comes back.

Each agent keeps its own list, and the list is still there tomorrow. ↑ only reaches for
your history when the cursor is on the first line of the box, so it goes on moving the
cursor normally while you are editing a longer message.

## Words that change how the work runs

Plain sentences are still all you need. But when you want to be precise, some words tell
C5 *how* to do the job rather than what the job is. Put them at the **beginning** or the
**end** of your message. C5 takes them out of the task description automatically, so the
task still reads cleanly afterwards.

| Say this                                                                      | And C5 will                                                     |
| ----------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `P1` to `P5`, or `Priority 1` to `Priority 5`                                 | Set how important the task is. P1 is the highest.               |
| `Urgent`, `Critical`, `ASAP`, `drop everything`, `highest priority`           | Set it to P1 and move it to the front of the queue.             |
| `Automate this`, `auto-review`, `run it automatically`, `automate the review` | Skip the approval step and let the task finish on its own.      |
| `Draft this`, `Dry run`, `Plan only`, `Draft mode`, `Just plan`               | Make the plan and stop there, before doing any of it.           |
| `Silent`, `Quietly`, `No notifications`, `Don't ping me`                      | Not tell you when it finishes.                                  |
| `Deep thinking`, `Think hard`, `Take your time`, `Thorough analysis`          | Spend longer thinking the problem through.                      |
| `Orchestrate`, `Coordinate`, `Enable AI` — or `No AI`, `AI off`               | Turn the multi-agent pipeline on, or off, for this one message. |
| `Tool use`, `Tools`, `Use tools`                                              | Let the agent use its tools on this task.                       |
| `Use QMD`, `Enable QMD`, `Target: /path`, `Tag: #name`                        | Give the task your memory-search knowledge base to work from.   |

You can combine them:

> Make a healthy meal plan, deep thinking P2

> Draft this: move the old invoices into an archive folder. Quietly.

The **question-mark** button at the top of the chat lists the whole set, including some
spellings not shown here. For what QMD is, see [Memory search](/c5/tools/memory-search).

## Commands

Typing a command runs something straight away instead of starting a conversation about
it. The **terminal** button at the top of the chat lists them, and `/c5 help` prints the
same list into the conversation.

| Command                              | What it does                                                |
| ------------------------------------ | ----------------------------------------------------------- |
| `/c5 tasks`                          | List the active tasks in your workspace.                    |
| `/c5 view [num]`                     | Show one task in detail, including what it has cost so far. |
| `/c5 status`                         | Show how your agents and queue are doing.                   |
| `/c5 subscribe [num]`                | Get that task's progress in the chat as it happens.         |
| `/c5 pause [num]`                    | Stop an active task and move it back to To Do.              |
| `/c5 review [num] approve` or `deny` | Approve or turn down a task that is waiting on you.         |
| `/c5 task [description]`             | Create a task yourself, with no agent planning it.          |
| `/c5 orch [description]`             | Create a task and let the agents plan and run it.           |
| `/c5 help`                           | List the commands.                                          |

> **Pause is a stop, not a hold**
> `/c5 pause` cancels the task's run rather than freezing it. The task goes back to To Do
> and starts from the beginning when you pick it up again.

With `/c5 task` and `/c5 orch` you can add:

- `-autoreview` — skip the approval step
- `-intent` — go through the Intent Wizard first, to sharpen a vague request
- `-tools` — let the agent use its tools
- `-think` — deep thinking
- `-i` — interactive: C5 asks you a few questions before it creates the task

> /c5 orch -autoreview Write a haiku on cats

You can use `-tools` and `-think` on their own for an ordinary chat message, with no task
created:

> /c5 -tools -think What changed in this file last week?

## Watching the work

As your agents work, Chat shows you what they are doing. You will see:

- The steps in the plan, and which one is happening now
- Each tool the agent uses, and what it got back
- Any question the agent needs you to answer

Nothing is hidden. If you ever wonder why C5 did something, the answer is right there in
the conversation.

## Sharing files

You can attach files to a message. Drag them onto the chat box or click the paperclip.

C5 can read most common file types — documents, spreadsheets, PDFs, images, code, and
plain text. Once a file is attached, you can ask questions about it or ask for changes.

> **Tip**
> Attach the file first, then ask your question. That way the agent has everything it
> needs from the start.

## Talking instead of typing

Click the small microphone at the left of the chat box, say what you want, and click it
again to stop. Your words appear as text where you can read them over before you send.

A ring around the microphone moves with your voice while you talk, so you can tell it is hearing
you before you speak a whole paragraph into nothing.

C5 can also read replies back to you — hover a reply and press the speaker button. The
**megaphone** switch on the right-hand edge of the chat does it for every new reply automatically.
It is off to begin with, which is deliberate: a long reply narrating itself in a shared office is
not a pleasant surprise.

Both work out of the box with a built-in option that never sends anything off your computer, so
there is nothing to set up first. Nothing listens until you press the microphone. See
[Voice](/c5/using-c5/voice) if you want a paid provider, or want to turn the built-in ones off.

## Stopping work

If an agent is heading in the wrong direction, you can stop it. Click **Stop** and it
stops taking new steps right away.

Stop is a brake, not an undo. Anything already done stays done — a file that was written
is still written, an email that was sent is still sent. If a step needs reversing, ask
for that as its own task.

You can then correct course and start again. Just say what was wrong.

## When C5 asks first

Some actions are risky — deleting files, spending money, sending things outside your
computer. C5 stops and asks you before it does any of them.

You will see a clear message telling you exactly what the agent wants to do. You can
allow it once, allow it every time, or say no.

You control where that line sits. See [Permissions](/c5/security/permissions).

## Picking up where you left off

Chats are saved. Close C5, come back tomorrow, and your conversation is still there with
all its history. Agents remember what you talked about — not just the transcript on your
screen, but the context behind it. Restart your computer, update C5, switch which model
you are using mid-conversation: the thread carries on where it left off.

If your computer restarts or the power goes out in the middle of a job, C5 picks the work
back up when it starts again. You do not lose your place.

### Long conversations

You can keep digging into one subject for as long as you like. Once a thread gets long,
C5 quietly keeps a running summary of the earlier part and holds the most recent
exchanges word for word, so the agent still knows what you originally asked about forty
questions ago.

This happens in the background, after a reply is sent — it never makes you wait.

You will see it when it does. A small **Condensing** badge appears in the chat header
while it runs, and hovering it explains what is happening. It also leaves a line in the
activity feed afterwards, alongside the tool calls, so you can look back and see when
your conversation was condensed rather than wondering.

If you would rather it did not happen at all, turn off context compaction in Settings.

## Getting better results

A few habits make a big difference:

- **Say what "done" looks like.** "A one-page summary with three bullet points" beats
  "summarize this."
- **Give it the files.** Attach what you have instead of describing it.
- **Say what to avoid.** "Do not change anything in the test folder" saves you a cleanup.
- **Start small.** Try a small version first, see how it goes, then ask for the big one.

## Where to go next

- [Productivity](/c5/using-c5/productivity) — watch longer jobs on a board.
- [Schedules](/c5/using-c5/schedules) — have this happen on its own every week.
- [Library](/c5/using-c5/library) — find the files your agents made.
- [Voice](/c5/using-c5/voice) — talk to C5 instead of typing.
