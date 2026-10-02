---
title: FAQ
description: Short answers to the questions people ask most.
order: 1
---

# FAQ

## About C5

### Do I need to be a programmer?

No. You ask for things in plain words. Being comfortable with a terminal helps for
install and updates, but the app itself is a normal website in your browser.

### Do I need internet?

Only for a few things: installing, updating, activating, and using SI models hosted by
other companies.

C5 also downloads a few models once, from Hugging Face, for features that run on your own
computer:

| Feature | Download |
| --- | --- |
| [Memory search](/c5/tools/memory-search) (semantic search) | about 2.26 GB |
| [Offline voice](/c5/using-c5/voice) | about 60 MB |
| [The local classifier](/c5/tools/local-classifier) | about 812 MB |

Without them C5 still works; those features wait for their model, and each model can be
placed on the machine by hand instead.

If you run your AI models on your own computer and place the downloads above by hand, C5
needs the internet only for an occasional licence renewal — or not at all with an
air-gapped licence (see
[C5 needs internet just to stay licensed?](#c5-needs-internet-just-to-stay-licensed)).

### Does my data go to the cloud?

No. Your prompts, files, and results stay on your computer, encrypted. See
[Privacy](/c5/mothership/privacy).

### What does it cost to run?

C5 itself is licensed software. On top of that you pay whichever SI provider you use,
based on how much you use it. Running models locally costs nothing per use.

Set a budget on day one — see [Budgets](/c5/using-c5/ops).

### Can I use it on more than one computer?

Yes. Install it on each and run `growther activate` on each. Your plan sets how many
machines you can have active.

## Using it

### How do I get better results?

Say what "done" looks like, attach the files, and say what to avoid. See
[Chat](/c5/using-c5/chat) for the habits that help most.

### Why is it asking me before doing things?

That is the permission system protecting you. You control how much it asks — see
[Permissions](/c5/security/permissions).

### Can I stop it mid-task?

Yes. Click Stop and it stops right away. Stop is a brake, not an undo — anything already
done stays done: a file that was written is still written, an email that was sent is
still sent. See [Chat](/c5/using-c5/chat).

### Where do my finished files go?

The [Library](/c5/using-c5/library). Everything has a Download button.

### Why is a task taking so long?

Usually it split into many smaller pieces, or it is waiting on you. Open
[Productivity](/c5/using-c5/productivity) and click the task to see exactly where it is.

### How do I start C5 if it is stopped?

You have three easy ways:
1. **From your browser:** Click the green **Start C5** button in the sidebar menu or in **Settings → System**.
2. **From your desktop:** Double-click the **Growther.si C5** icon in your Applications folder or Start menu.
3. **From your terminal:** Run `growther start` (or `growther`).

## Models and money

### Which model should I use?

Start with the defaults. When you want to tune it, see
[Choosing models](/c5/agents/model-routing).

### Can I run models on my own machine?

Yes. It costs nothing per use and nothing leaves your computer. See
[Model providers](/c5/configuration/model-providers).

### How do I keep costs down?

Set a budget, use smaller models for simple work, be specific in your requests, and check
your schedules — a frequent schedule is usually the biggest line on the bill.

## The local classifier

### What is the local classifier?

A small model, decider-0.8b, that C5 runs on your own computer to answer some of the
routine questions it asks itself while it works — for example, which categories a new task
belongs to. Without it, C5 sends each of those questions to the AI provider you
configured. It lives in **Settings › Learning**, on the **Local Classifier** card — see
[Settings › Learning](/c5/configuration/settings#learning). The full guide is
[Local classifier](/c5/tools/local-classifier).

### Does it change what C5 does?

Not at first. When it is first on, it only **records** its answers beside the usual ones:
every kind of decision it can answer starts in **Shadow**. C5 lets it decide something only
after it has been measured, on your own install, against the answers people gave or the
outcomes that followed — and only for the kinds of decision allowed under **Settings ›
Learning**. Until then, everything is decided the way it was before. See
[When it starts to act](/c5/tools/local-classifier#when-it-starts-to-act).

### Will it slow my computer down?

It is built not to. On an Apple-silicon Mac it uses the GPU and answers in a fraction of a
second. Where it runs on the CPU — every other machine, and a Mac whose GPU is left to a
local model such as LM Studio — the three kinds of decision it is asked most often (step
quality, tool-call safety and skill routing) record only one question in four, always the
same ones, so for those it uses about a quarter of the processor time it otherwise would. The card in
**Settings › Learning** says _Sampling 1 in 4 on this machine_ where this applies. It never
waits in front of your work while it only records, and it leaves two of your processor's
cores alone. See
[On a machine where it runs on the CPU](/c5/tools/local-classifier#on-a-machine-where-it-runs-on-the-cpu).

### Is anything sent to Growther.si?

No. The classifier runs on your machine, in its own process. Its answers, what it learns
and how often it is used stay there. The one network request it involves is the model's
one-time download (about 812 MB), which goes from your machine to Hugging Face, through
your proxy settings if you have them. Nothing about the model, or your use of it, goes to
Growther.si. See [Privacy](/c5/tools/local-classifier#privacy) on the classifier's page.

### Why is it on by default?

Because it uses no provider and no account of yours, costs nothing per use, and learns
only from what it records while it is on. When it comes on, administrators get one
notification saying so, and what will happen on this machine — whether the model will be
downloaded, is already there, or cannot be downloaded here and why. A machine that cannot
run it is told nothing, and nothing is downloaded there.

The model's publisher says its training mixture includes datasets released for research
use. C5 shows that notice beside the model in **Settings › Learning**. If it does not fit
your use, turn the classifier off. See
[Why it is on by default](/c5/tools/local-classifier#why-it-is-on-by-default).

### How do I turn it off?

In **Settings › Learning**, switch off **Local classifier**. C5 asks first. **Turn off**
leaves the model on disk, so turning it back on costs no download. **Turn off and delete
the model** also frees the space; it is offered only to an administrator signed in at the
machine itself (not from a paired phone). Anyone with permission to change settings can
turn the classifier off. With it off, an administrator at the machine can still press
**Delete the model (… MB)** on the card later. Step by step:
[Turn the classifier off](/c5/tools/local-classifier#turn-the-classifier-off) and
[Delete the model](/c5/tools/local-classifier#delete-the-model).

Off means off: C5 then loads nothing for it, downloads nothing for it, and prints nothing
about it. Everything else in C5 carries on as before.

To keep it off before it ever downloads — on a new install, or across a fleet — have your
organisation set the managed-policy key `classifier_enabled` to `false`. A policy can lock
it on or off; the switch then shows the lock and cannot be changed in C5, and a change to
the policy takes effect without a restart. See
[Keep the local classifier on or off](/c5/configuration/enterprise-policy#keep-the-local-classifier-on-or-off).

### It says "Unsupported". Is something wrong?

No. The classifier needs a supported platform, at least 8 GB of memory that the system can use, rounded to the nearest gigabyte (most 8 GB
machines qualify; one that keeps more than about half a gigabyte for built-in graphics may
not, and the card then shows the usable figure), and a recent enough operating system and system libraries. Where those are missing, C5 downloads
nothing and works as it did before. The card gives the exact reason; see
[Machines it cannot run on](/c5/tools/local-classifier#machines-it-cannot-run-on) and
[Common issues](/c5/troubleshooting/common-issues#the-local-classifier-says-this-machine-cannot-run-it).

### Can I use it on a machine with no internet?

Yes. Download the model on a machine that can reach Hugging Face, copy it to the
classifier's `models` folder, and run `growther classifier status` to check it. The exact
address, size, sha256 and folder for each platform are in
[Offline and air-gapped installs](/c5/tools/local-classifier#offline-and-air-gapped-installs).

You do not need to restart C5: open **Settings › Learning**, and C5 checks the new file
and starts the classifier. (C5 looks for a new model file whenever that page asks for the
classifier's status.) Otherwise it picks the file up at its next start.

The terminal commands are `growther classifier status` (can this machine run it, and is
the model there and checked) and `growther classifier pull` (download it now, even if
automatic downloads are switched off with `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1`). The
pull is refused while the egress posture is **Offline**, or when your organisation's policy
keeps the classifier off.

## Data and safety

### What if I lose my computer?

Getting your work back depends on whether you kept a backup — see
[Backups and recovery](/c5/security/backups).

Keeping it *private* is a separate question, and the honest answer is that C5's own
encryption does not cover this case: your key file sits on the same drive as your data,
so someone with the drive has both. Turn on full-disk encryption — FileVault on macOS,
BitLocker on Windows, LUKS on Linux. That is the tool that protects a lost laptop. See
[Local encryption](/c5/security/encryption).

### Can Growther.si see my work?

No — your prompts, files, and results never leave your computer. If you connect to
Mothership, what is shared is limited to measurements — the full list is at
[Privacy](/c5/mothership/privacy).
Never connect, and nothing leaves at all.

### Can I get my data out?

Yes, at any time, from Settings. It is yours.

### What happens if I stop paying?

Your data stays on your computer and you can still export it. You own it — that does not
change.

C5 itself is licensed software, so an inactive license means the app stops running. Your
work is not held hostage: export what you need from the Library, or from Settings, at any
time.

### How do I get a license?

Get one from [growther.si](https://growther.si). Then run `growther activate` on each
computer to pair it — see [Connecting](/c5/mothership/connecting).

### I have a referral link or discount code — how do I use it?

Open the link and sign in when asked, or — if you only have the code — sign in to
[license.growther.si](https://license.growther.si) and enter it under *Have a
referral code?* in the cart on the Plans page. The cart shows what comes off before
you pay. Everything else — time limits, who gets what, and how to become a
referrer yourself — is on the
[Referrals and discount codes](/c5/getting-started/referrals) page.

### Why does C5 check in with the license service?

C5 holds a short-lived licence file and renews it quietly in the background, well
before it runs out. It is a routine check-in, not a re-purchase, and you do not
have to do anything.

Renewing is also how a change reaches you: buy more seats, add a feature, or
extend your term, and it appears without reinstalling anything.

### C5 needs internet just to stay licensed?

Only briefly, and only now and then. The licence file lasts long enough to cover
ordinary time offline — travel, a flaky connection, a laptop shut for a week.
Nothing stops the moment you disconnect.

If a machine will be offline for a long stretch, or permanently, ask us about an
air-gapped licence instead.

### Does my license expire soon? It shows a date only a couple of weeks away

It should not, and if you see one, tell us.

There are two different dates involved, and only one of them concerns you: **when
your access ends**, which is the date the app and the admin console show. The
other is an internal renewal deadline for the licence file itself, a couple of
weeks out and refreshed continuously. You should never be shown that one.

## Still stuck?

Try [Common issues](/c5/troubleshooting/common-issues), or
[Getting help](/c5/troubleshooting/getting-help).
