---
title: Computer use
description: Let an agent see your screen and control your mouse and keyboard.
order: 3
---

# Computer use

**Computer use** lets an agent look at your screen and control your mouse and keyboard,
the way a person would.

It is the most powerful thing C5 can do, and the one to be most careful with.

## When it is useful

Most work does not need it. Reach for computer use when a program has no other way in:

- An old desktop program with no way to connect to it
- A website that only works by clicking through it
- Copying information between two programs that do not talk to each other
- Anything where "just click these buttons in order" is the real task

If a tool or integration can do the job instead, use that. It is faster and safer.

## How it works

The agent takes a picture of your screen, decides what to do, then moves the mouse or
types. Then it looks again to see what happened, and repeats.

You watch it happen. It is not hidden or running invisibly in the background.

## Turning it on

Computer use is **off** until you turn it on.

1. Go to **Settings › Tools**.
2. Turn on **System Control** (_Permits agents to interact with the OS and GUI visually via
   MCP._) and press **Save**. It needs global **Tool Use** on; while that is off the switch
   is greyed out. Only an administrator at the machine running C5 can turn it on or off —
   a teammate who may change other settings, or a paired phone, is refused (see
   [Settings only an administrator can change](/c5/security/permissions#settings-only-an-administrator-can-change)).
   The panel under the switch shows how System Control stands; its policy is set on the
   **Guardrails** tab, under **Computer Use**.
3. In **Settings › Extensions**, leave its tools asking you, or set them to **Prompt** so
   they ask each time, even where you once chose **Always Allow**. See
   [Permissions](/c5/security/permissions).

Your operating system will also ask for permission the first time. That is normal — the
operating system protects screen access and input control by design.

## Staying in control

- **Approve each program.** An agent can only work with programs you allowed.
- **Watch it work.** You see every action as it happens.
- **Stop any time.** Click **Stop** and it ends. Note that moving your own mouse does
  *not* interrupt it — the agent and you share one pointer, so use the Stop button rather
  than trying to wrestle it.
- **Risky clicks ask where C5 can tell.** Actions that look like sending, deleting,
  publishing, or paying stop for your approval first. C5 is reading the screen, so it
  cannot recognize all of them.

> **Danger**
> Never let an agent type a password, a card number, or a security code on your behalf.
> If a task needs those, do that part yourself. C5 is built to ask you rather than
> handle them, but the safest habit is to keep credentials out of any automated flow.

## Good habits

- **Try it on something harmless first** so you can see how it behaves.
- **Close what it does not need.** Fewer open windows means fewer mistakes.
- **Be exact.** "Click the blue Export button at the top right" beats "export it."
- **Do not walk away** the first few times you use it.

## What gets recorded

Every action is written down: what was clicked, what was typed, what was on screen. You
can review it afterwards in the task's history.

Screenshots are stored on your computer, in your data folder, along with the rest of your
work. See [Local encryption](/c5/security/encryption) for how that folder is protected —
and what that protection does not cover.

## Where to go next

- [Permissions](/c5/security/permissions) — where the limits are set.
- [What tools do](/c5/tools/what-tools-do) — the safer alternatives to reach for first.
