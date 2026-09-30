---
title: Getting help
description: Where to ask, and what to include so you get a fast answer.
order: 3
---

# Getting help

## Before you ask

Two things solve most problems and save you a wait:

1. **Run the checkup.** `growther doctor` names the cause more often than not.
2. **Check [Common issues](/c5/troubleshooting/common-issues).** Most first-week problems
   are there.

## Where to ask

| Where | Best for |
| --- | --- |
| [Help & Feedback](https://growther.si/#modal=help) | Questions, problems, and feature ideas. |
| [GitHub](https://github.com/GrowtherSI) | Release notes and public discussion. |

## What to include

A good report gets a good answer. Include:

**Your version**

```bash
growther version
```

**Your checkup output**

```bash
growther doctor
```

**Your system** — macOS, Windows, or Linux, and which version.

**What you expected to happen**, in one sentence.

**What actually happened**, in one sentence.

**How to make it happen again**, if you can. This is the single most useful thing you can
provide.

**The exact error message**, copied and pasted rather than described.

> **Warning**
> Before you paste anything, take out API keys, passwords, and anything private. Error
> messages sometimes include file paths or snippets of your content.

## A good example

> **Version:** 2026.1.0 on macOS 15.2
>
> **Expected:** My Monday schedule should produce a weekly summary.
>
> **Happened:** It failed with "provider unavailable" three Mondays in a row. Running the
> same request by hand in Chat works fine.
>
> **To reproduce:** Make a schedule with any request, set it weekly, and wait.
>
> **doctor says:** All checks OK.

That gives someone everything they need to start looking, with no back and forth.

## What is unlikely to help

- "It doesn't work." — Which part, and what did you see?
- A screenshot of a wall of text. — Paste the text instead, so it can be searched.
- A description of the error from memory. — Copy the real one.

## Feature ideas

Send them to [Help & Feedback](https://growther.si/#modal=help). Say what you are trying
to achieve, not only what feature you want — often there is already a way, and if there
is not, knowing the goal makes for a better feature.

## Something security-related

If you think you have found a security problem, please report it privately through
[Help & Feedback](https://growther.si/#modal=help) rather than posting it publicly, so it
can be fixed before it is widely known.
