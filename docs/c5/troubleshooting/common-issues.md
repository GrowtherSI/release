---
title: Common issues
description: Problems people actually hit, and how to fix them.
order: 2
---

# Common issues

Start here when something is wrong. If your problem is not listed, run the checkup:

```bash
growther doctor
```

It checks your whole setup and usually names the cause. See
[Running doctor](/c5/cli/doctor).

## Installing and starting

### "growther: command not found"

Your terminal cannot find C5 yet.

Close the terminal window and open a new one, then try again. Shells only pick up PATH
changes in new sessions.

If that does not work, reinstall — see
[Installation](/c5/getting-started/installation).

### C5 will not start

Check whether it is already running:

```bash
growther status
```

If it says running but you cannot reach it, stop and start it:

```bash
growther stop
growther
```

### "BOOT ABORTED: CRITICAL LICENSE FAILURE"

C5 stops rather than run unlicensed, so it exits instead of staying up in a
half-working state. Read the line under the heading — it says which case you are
in.

**"bound to a different deployment key"** — your licence is fine; the key on this
computer is not the one it expects. This happens after restoring from a backup,
cloning a machine, or moving to a new disk. Give this computer a new key, keeping
the same licence:

```bash
growther rekey
```

If that reports the key is gone or is not the bound one, use recovery, which
confirms in your browser:

```bash
growther rekey --recover
```

**"GROWTHER_C5_LICENSE_SEED is missing"** — no licence file. If this computer was
never paired, run `growther activate`. If it *was* paired and the file has gone,
`growther rekey --recover` restores it without creating a second deployment.

Do not run `growther activate` to fix a key problem on a computer that is already
paired. Activate creates a **new** deployment and leaves the old one stranded;
rekey keeps the one you have, along with its history.

Not sure which you are looking at? `growther doctor` reports the licence and key
state in plain terms.

### "Port already in use"

Something else on your computer is using port 4299. Use a different one:

```bash
PORT=5000 growther
```

### The page will not load in my browser

Confirm C5 is running with `growther status`, then go to `http://localhost:4299`
directly. If you changed the port, use that number instead.

If `growther status` says C5 is running but the browser still cannot reach it,
try `http://127.0.0.1:4299` and `http://[::1]:4299`. `localhost` is two
addresses, and C5 listens on both — but if one of them was unavailable when C5
started, the boot log says so:

```text
[bootstrap] no ::1 listener (EAFNOSUPPORT) — C5 is reachable on 127.0.0.1 only.
```

Use the address that line names. See
[Why C5 listens on two addresses](../configuration/network.md).

### Restart is greyed out or C5 is offline

When C5 is not running, **Restart** is disabled because there is no running server to reboot.

To start C5 again:
- Click the green **Start C5** button in the sidebar menu, on the **Settings → System** page, or on the offline recovery screen.
- Double-click the **Growther.ai C5** shortcut on your desktop or Applications folder.
- Run `growther start` (or `growther`) in your terminal.

Once C5 starts, your browser tab reconnects on its own within a few seconds and the controls become active again.

## Models

### "No model configured"

You have not connected a provider yet. Go to **Settings → Integrations** and add one. See
[Model providers](/c5/configuration/model-providers).

### "Invalid API key"

Nearly always a copy-paste problem. Copy the key again, watching for a trailing space.
If it still fails, make a new key with the provider.

### "Rate limit reached"

You are asking your provider for more than your plan allows. C5 slows down and retries by
itself, so this usually resolves.

If it keeps happening, raise your limit with the provider or route some work to a
different model.

### Results got worse

Check what changed. [Analytics](/c5/using-c5/analytics) shows quality over time — find
the day it dropped and think about what you changed then. A model switch is the most
common cause.

## Tasks

### A task is stuck as "Blocked"

Open it. Blocked almost always means it is waiting for you to approve something, or it
hit a limit.

### A task keeps failing

Open it and read the error. The usual causes:

- A file it needed moved or was renamed
- An expired key
- A budget limit reached
- A website or service it needed is down

Fix the cause, then click **Retry**.

### Everything is queued and nothing starts

Open [Monitor](/c5/using-c5/monitor) → **Queueing**.

If nothing is moving, check that you have a working model provider, that you have not hit
a budget limit, and that no task is waiting on your approval.

### A schedule did not run

Schedules need C5 running. If your computer was asleep or off, the run was missed — C5
catches up when it wakes.

If C5 was running and it still did not fire, open the schedule's history for the error.

## Performance

### Everything is slow

Check [Monitor](/c5/using-c5/monitor) → **Health**. If your fleet is large, your computer
may be overloaded — try running fewer agents. See [Your agent fleet](/c5/agents/fleet).

### Running out of disk space

**Open Monitor → Database only if you suspect the databases.** They are usually not what
filled the disk. The bulk is almost always downloaded models and caches, which live outside
the databases entirely and are safe to delete — C5 downloads them again if it needs them:

| Folder | Typically |
| --- | --- |
| `qmd/` | The memory-search runtime plus its model weights — often 2 GB or more |
| `speech/` | The offline speech model, about 60 MB |
| `cache/` | Working files |
| `lib/` | Unpacked runtime libraries |

`growther cache show` reports what each is using, and `growther cache relocate --to <path>`
moves them all to another disk without touching your work. If the databases really are the
problem, shortening how long history is kept is the biggest lever — see
[Backups and recovery](/c5/security/backups).

## Costs

### I spent more than expected

Open [Ops](/c5/using-c5/ops) and look at spending by task and by model.

The usual culprits are a frequent schedule, a large fleet, or an expensive model doing
simple work. Set a budget so it cannot happen again.

## Serious problems

### "Integrity check failed"

> **Danger**
> The program on disk is not the one Growther.ai signed. Stop using it, reinstall from
> the official installer, and if it fails again ask for help before running it. See
> [Verifying releases](/c5/security/verifying-releases).

### An update broke something

Go back to the previous version:

```bash
growther rollback
```

Then tell us what happened — see [Getting help](/c5/troubleshooting/getting-help).

### I think I lost data

Do not keep working in that install — that can overwrite what is recoverable.

C5 keeps automatic backups. See [Backups and recovery](/c5/security/backups) for how to
restore, and test the restore into a separate folder first.
