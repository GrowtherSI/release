---
title: Workspaces
description: Keep separate streams of work apart, and sign finished work.
order: 4
---

# Workspaces

A **workspace** keeps one stream of work separate from another. Think of it as a
different desk for a different job.

## When you need one

You probably do not, at first. One workspace is fine for most people.

Consider adding one when:

- You work for **more than one client** and their work must not mix
- You want **personal and work** things kept apart
- Different jobs need to stay **separately identified**, each with its own signing identity
- You need to **hand over proof** that a finished piece came from you

## What each workspace has

Each one keeps its own:

- Projects, files, and history
- Assigned agents
- Visibility — who in your organisation can see it
- An owner

Budgets, model choices and folder access are **not** per-workspace: they are set once for
your whole install under **Settings**, and apply to every workspace.

Work in one workspace does not show up in another — the same tools, a different set of
papers. Each person belongs to one workspace and sees only its work: tasks, chats,
schedules, the Library, tags and notifications. Agents can be assigned to more than one.

## Creating one

1. Go to **Workspaces**.
2. Click **Add Workspace**.
3. Give it a **Name** that will still make sense in six months, and a **Description** if
   you like.
4. Click **Create Workspace**.

## Who is in which workspace

An administrator decides. Select **Edit** on a workspace's card, then choose its people
under **Human Assignment** and its agents under **Agent Routing (Fleet)**, and click **Save
Workspace**. Or set
**Workspace Assignment** in a person's profile. A person
already in another workspace shows as _Assigned elsewhere_. Nobody can move themselves into
another workspace.

Administrators, too, see their own workspace's work. On **Ops**, **Labs** and **Analytics**,
an administrator can switch the **All workspaces** button in the page header on to see every
workspace together. The choice is remembered for that administrator in that browser.

## Signing your work

A workspace can sign finished work. A signature is proof of two things:

- **It came from you**, from this workspace.
- **It has not been changed** since you signed it.

A signed deliverable carries proof of where it came from. If it is altered afterwards,
that proof no longer checks out, and the person you sent it to can tell.

This matters when you deliver work to a client who needs to trust where it came from.

## How signing works

You do not sign anything by hand. A deliverable is signed **when it is produced**, and the
workspace it came from is recorded inside the signature, so everything your agents finish
carries its provenance already. The signing secret is one per install, not one per
workspace — the workspace is named in the token, it does not hold a key of its own.

What the Library gives you is the other half — **Validate**, which checks a file against its
signature and tells you whether it is intact and where it came from. Use it on something you
have received, or to re-confirm your own work before you send it.

Verification is done by this C5 — yours, or one you have given someone access to. There is
no public key to hand out yet, so a third party cannot verify a deliverable independently.

## Keeping workspaces tidy

- **Name them clearly.** "Acme Corp" beats "Work 2".
- **Budgets and folder access are install-wide**, not per workspace — set them
  once under **Settings › Budget** and **Settings › Locations**.
- **Think before deleting one.** Deleting a workspace is permanent, and unassigns its
  people and agents.

## Where to go next

- [Settings](/c5/configuration/settings) — the install-wide settings every workspace
  shares.
- [Library](/c5/using-c5/library) — where signed deliverables live.
