---
title: Privacy
description: Exactly what stays on your machine and what does not, when you connect.
order: 3
---

# Privacy

This page is deliberately plain. You should be able to decide about Mothership without
reading between any lines.

## What never leaves your computer

Connected or not, these stay on your machine:

- **Your prompts.** What you ask for.
- **Your files.** Anything you upload or your agents create.
- **Your results.** The work that comes back.
- **Your API keys.** Passwords and keys for other services.
- **Your chats.** Whole conversations and their history.
- **Your context.** The standing instructions you wrote.

These are stored encrypted in your data folder. Growther.si cannot read them, because
Growther.si never receives them.

## What is shared when you connect

Connecting shares a limited set of operational information:

- **Which version you run**, so updates can be managed.
- **Your license state**, so your plan works.
- **Measurements of how well things worked** — how often work succeeded, how long it
  took, how often something failed.
- **Signals about what is working well**, so the network can improve.

The rule of thumb is: **measurements, not your content.** That a task succeeded, how long
it took, and how the system is performing — not what the task was about or what it
produced.

## An example

Say you ask C5 to summarize a confidential contract.

**Stays on your machine:** the contract, your request, the summary, the file name, every
word of the conversation.

**May be shared:** that a summarizing task ran, that it succeeded, that it took 40
seconds, that it used two retries.

Someone reading the shared data learns that summarizing works well. They learn nothing
about your contract.

## Fully offline

If you never connect, nothing at all leaves your machine. C5 is complete this way. Some
people run it with no network access at all, and that is a supported way to use it.

## Your data is yours

Whatever you decide:

- You can **export everything** at any time.
- You can **decrypt your data** yourself.
- You can **delete it**, and it is gone.
- You can **disconnect**, and keep everything.

There is no version of C5 where your work is held somewhere you cannot reach.

## Storage and encryption

Your work is stored in encrypted databases in your data folder. See
[Local encryption](/c5/security/encryption) for how that works and what to back up.

## Questions this page does not answer

For formal terms — the legal agreement, the data processing agreement, and the privacy
policy — see the links in the footer of [growther.si](https://growther.si).

If something here is unclear, ask before you connect. See
[Getting help](/c5/troubleshooting/getting-help).
