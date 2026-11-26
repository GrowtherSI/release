---
title: Getting help
description: Where to ask, and what to include so you get a fast answer.
order: 3
---

# Getting help

## Before you ask

A few things solve most problems and save you a wait:

1. **Run the checkup.** It names the cause more often than not:

   ```bash
   growther doctor
   ```

   See [Running doctor](/c5/cli/doctor) for how to read it.
2. **Check [Common issues](/c5/troubleshooting/common-issues)** and the
   [FAQ](/c5/troubleshooting/faq). Most first-week problems are there.
3. **Watch a tutorial.** Open the **Options** menu (`⋮`) at the bottom of the sidebar and
   choose **Tutorials** for short videos on each part of the app. **Docs** in the same menu
   links to these pages.

## Where to ask

### From inside C5

The quickest way to reach us is the **Feedback** form in the app:

1. Open the **Options** menu (`⋮`) at the bottom of the sidebar.
2. Choose **Feedback**.
3. Pick a **Category**: **Bug**, **Idea**, **Question** or **Other**.
4. Describe the problem in the box (up to 4,000 characters), using the checklist under
   [What to include](#what-to-include).
5. Select **Send**.

Your message goes to the Growther.si team with the version of C5 you run, so you do not need
to add it. If they reply, the answer arrives in your notifications in C5. The form needs C5
to be activated, and an internet connection to send.

### Everywhere else

| Where | Best for |
| --- | --- |
| [Help & Feedback](https://growther.si/#modal=help) | Questions, problems, and feature ideas — also when C5 will not start, so the form inside it cannot be reached. |
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

If a feature that reads attachments, images or speech behaves oddly, also include the report
of the built-in component check:

```bash
growther packaged-selftest
```

See [Checking the built-in components](/c5/cli/doctor#checking-the-built-in-components).

**Your system** — macOS, Windows, or Linux, and which version.

**What you expected to happen**, in one sentence.

**What actually happened**, in one sentence.

**How to make it happen again**, if you can. This is the single most useful thing you can
provide.

**The exact error message**, copied and pasted rather than described. C5 also keeps its
errors in `logs/errors.log` in your C5 folder (`~/.growther` unless you moved it); the lines
from around the time it went wrong are worth including. A line that starts
`[Aggregated 12x]` counts repeats of the same error. The first one was written on its own
line, with its details; the summary gives the count (`includesFirst: true` means the count
includes that first line) and, in `firstSeen` and `lastSeen`, when they happened. Its own time
is when it was written, which can be a few minutes later. C5 keeps up to two weeks of this log,
within about 40 MB.

> **Warning**
> Before you paste anything, take out API keys, passwords, and anything private. Error
> messages sometimes include file paths or snippets of your content.

## A good example

> **Version:** 2026.11.25-v358 on macOS 15.2
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

Send them with **Feedback** in the app, choosing **Idea**, or through
[Help & Feedback](https://growther.si/#modal=help). Say what you are trying
to achieve, not only what feature you want — often there is already a way, and if there
is not, knowing the goal makes for a better feature.

## Something security-related

If you think you have found a security problem, please report it privately through
[Help & Feedback](https://growther.si/#modal=help) rather than posting it publicly, so it
can be fixed before it is widely known.
