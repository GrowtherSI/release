---
title: Permissions
description: Decide what your agents may do alone, and what needs your say-so.
order: 2
---

# Permissions

Permissions decide what your agents may do on their own, and what has to stop and ask
you first.

This is the most important setting in C5. It is worth ten minutes.

> **Human teammate access & user permissions (RBAC)**
> Looking to control what human team members can see, edit, or execute in the C5 interface?
> This page covers autonomous **agent** permissions. To configure role-based access control (RBAC), feature locks, and server controls for human teammates, see [Access & user permissions (RBAC)](/c5/configuration/settings#access--user-permissions-rbac) in Settings.

## The ladder

Think of it as a ladder, from safest to most powerful:

| Level          | What it covers                                          | Default   |
| -------------- | ------------------------------------------------------- | --------- |
| **Read**       | Looking at files and pages. Changes nothing.            | Allowed   |
| **Write**      | Creating and editing files.                             | Asks you  |
| **Run**        | Running commands on your computer.                      | Asks you  |
| **Send**       | Sending anything off your machine — email, posts, calls.| Asks you  |
| **Delete**     | Removing files or data permanently.                     | Asks you  |
| **Spend**      | Anything that costs money beyond normal model usage.    | Asks you  |
| **Control**    | Driving your screen, mouse, and keyboard.               | Off       |

Reading is safe: worst case, an agent wastes time. Deleting and sending are not: worst
case, something is gone or something private went somewhere public.

> **Note**
> Writing asks you by default, wherever the file is. The one way a write happens without
> asking is if you have listed the folder yourself under **Settings → Extensions**, in the
> write-allowed paths — that list is empty until you add to it. An orchestrated run you
> have given filesystem autonomy can also write inside its own task workspace without
> asking, and only there.
>
> **Settings → Locations** is a different setting and does not grant anything. See the
> warning further down this page.

## When an agent asks

You get a clear message saying exactly what it wants to do — which file, which address,
which command. Then you choose:

- **Allow once** — just this time.
- **Allow always** — do not ask again for this kind of action.
- **Deny** — no, and the agent finds another way or stops.

> **Tip**
> Be slow with "allow always". It is the setting people regret. "Allow once" costs you
> two seconds and keeps you in the loop.

## Setting the level

1. Go to **Settings**.
2. Open **Autonomy**.
3. Choose how much freedom your agents have.
4. Save.

Each kind of action has its own setting, so you can be strict about the things that
worry you and relaxed about the rest.

Separately, **Settings → Extensions** gives every tool one of three master positions:

| Position   | What it means                                  |
| ---------- | ---------------------------------------------- |
| **On**     | Agents may use this tool without asking.       |
| **Prompt** | Agents must ask you each time.                 |
| **Off**    | Agents cannot use this tool at all.            |

Between the two, you decide exactly how much rope your agents get.

## Hard limits

**Settings → Guardrails** holds the checks that run no matter what any other setting
says. They cover things like blocking private information from being sent out, refusing
work when the safety checks themselves cannot be reached, and requiring an approved
budget before an agent spends anything.

Guardrails beat permissions. If the two disagree, the guardrail wins.

> **Warning**
> Guardrails and the permission ladder are your real controls. **Settings → Locations**
> is not one of them — it tells C5 which folders to bring documents in from and put
> results into. It is a convenience setting, not a fence: do not rely on it to keep an
> agent away from the rest of your disk.
>
> If you need a genuine boundary, run C5 under a user account that only has access to
> what you are willing to expose.

## Never hand over credentials

C5's guardrails watch for private information leaving your machine, but **do not rely on
software to notice a password**. There is no check that recognizes a card number or a
security code and stops on your behalf.

So make it a habit:

- Never put a password, card number, or one-time code into a chat message or a task
  description.
- Never ask an agent to sign in or pay as you. If a job needs that step, do that step
  yourself and let the agent carry on afterwards.
- Keep keys in **Settings**, which stores them encrypted and sends them only to the
  service they belong to — not in your instructions, where they become part of the
  conversation.

## Reviewing what happened

The **Audit** view in [Ops](/c5/using-c5/ops) lists every permission decision — what was
asked, what you chose, and when. Worth a look after your first busy week to see whether
your settings match how you actually work.

## A good starting point

1. For your first week, leave anything that deletes, sends, spends, or controls your
   screen set to ask you.
2. Notice which prompts you approve every single time.
3. Loosen just those — set those specific tools to **On** in
   **Settings → Extensions**.
4. Leave the rest asking.

You will end up with settings that fit your work instead of someone else's guess.
