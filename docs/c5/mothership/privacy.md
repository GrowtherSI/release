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
- **What the local classifier does.** Its answers, what it learns from them, and how often
  it is used.

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

## Models C5 downloads

[Memory search](/c5/tools/memory-search), [offline voice](/c5/using-c5/voice) and the
[local classifier](/c5/tools/local-classifier) use models that run on your machine. C5
downloads each one once, from Hugging Face, when the feature that needs it is on, and
checks it against a size and fingerprint recorded in C5 before using it. That download is
a request from your machine to Hugging Face. Growther.si is not part of it, and C5 sends
Growther.si nothing about the models — not whether you have them — and nothing the
classifier keeps: the questions it was asked, its answers, or how often it ran. This is
true whether or not you connect to Mothership.

The models, their sizes and their licences are listed in C5 under **About › Copyright &
Legal** and in
[Open-source licences and downloaded models](/c5/security/open-source-and-models#check-which-models-c5-downloads).
The Terms section that covers them is
[Models C5 downloads and runs on your machine](https://growther.si/t=models).

## What C5 shows without signing in

C5's health check, `/health`, answers without asking who you are, because supervisors and
installers use it to see that C5 is running. To a caller that is not signed
in — including someone reaching your machine through Remote Control without a paired
device — it says whether C5 is running and serving, the time, and a random number that
changes every time C5 starts (`growther connect` uses it to tell two machines apart; it
identifies nothing), and how many AI requests C5 is running and how many are waiting, with
the limits it sets on them. How often the local classifier is used, how fast it answers, and which
agents those requests belong to are shown only to a signed-in session that is not a paired
device, or to a check made directly on the machine itself. A phone or tablet paired through
Remote Control gets the same short answer as anyone else.

## Fully offline

If you never connect to Mothership, nothing about your work leaves your machine. C5 is
complete this way. Some people run it with no network access at all, and that is a
supported way to use it: set the egress posture to **Offline** so C5 makes no downloads
or check-ins of its own, and place any models you want by hand. Offline also stops licence
renewals, so your licence runs on its offline grace period; for a machine that will stay
offline for a long time, ask us for an air-gapped licence — see
[C5 needs internet just to stay licensed?](/c5/troubleshooting/faq#c5-needs-internet-just-to-stay-licensed).
See
[Network and egress](/c5/configuration/network) for everything C5 contacts and how to turn
it off.

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
