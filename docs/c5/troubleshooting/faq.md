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

Only for a few things: installing, updating, activating, and using AI models hosted by
other companies.

If you run models on your own computer, C5 works with no internet at all.

### Does my data go to the cloud?

No. Your prompts, files, and results stay on your computer, encrypted. See
[Privacy](/c5/mothership/privacy).

### What does it cost to run?

C5 itself is licensed software. On top of that you pay whichever AI provider you use,
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
2. **From your desktop:** Double-click the **Growther.ai C5** icon in your Applications folder or Start menu.
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

## Data and safety

### What if I lose my computer?

Getting your work back depends on whether you kept a backup — see
[Backups and recovery](/c5/security/backups).

Keeping it *private* is a separate question, and the honest answer is that C5's own
encryption does not cover this case: your key file sits on the same drive as your data,
so someone with the drive has both. Turn on full-disk encryption — FileVault on macOS,
BitLocker on Windows, LUKS on Linux. That is the tool that protects a lost laptop. See
[Local encryption](/c5/security/encryption).

### Can Growther.ai see my work?

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

Get one from [growther.ai](https://growther.ai). Then run `growther activate` on each
computer to pair it — see [Connecting](/c5/mothership/connecting).

### I have a referral link or discount code — how do I use it?

Open the link and sign in when asked, or — if you only have the code — sign in to
[license.growther.ai](https://license.growther.ai) and enter it under *Have a
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
