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
[bootstrap] no ::1 listener (EAFNOSUPPORT) — C5 is reachable on 127.0.0.1 only. If a browser resolves localhost to ::1 it will need http://127.0.0.1:4299 instead.
```

Use the address that line names. See
[Why C5 listens on two addresses](../configuration/network.md).

### Restart is greyed out or C5 is offline

When C5 is not running, **Restart** is disabled because there is no running server to reboot.

To start C5 again:
- Click the green **Start C5** button in the sidebar menu, on the **Settings → System** page, or on the offline recovery screen.
- Double-click the **Growther.si C5** shortcut on your desktop or Applications folder.
- Run `growther start` (or `growther`) in your terminal.

Once C5 starts, your browser tab reconnects on its own within a few seconds and the controls become active again.

> **Self-help: Missing "Start C5" button on offline screens?**
> The green **Start C5** button on the offline screen and sidebar menu is governed by an administrative RBAC toggle. If your organization has disabled **Sidebar: Restart, Quit, Start C5** in [Settings → Access](/c5/configuration/settings#access-user-permissions-rbac), this button remains hidden for standard users. Ask your administrator to enable the permission for your account.

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

## Downloaded models

C5 downloads up to five models from Hugging Face, each only for the feature that needs
it: three for [memory search](/c5/tools/memory-search) (about 2.26 GB), one for
[offline voice](/c5/using-c5/voice) (about 60 MB), and one for the
[local classifier](/c5/tools/local-classifier) (about 812 MB). Each is pinned to one exact
file and checked against its size and sha256 before C5 uses it. The full list, with each
model's licence, is in
[Open-source licences and downloaded models](/c5/security/open-source-and-models#check-which-models-c5-downloads).

### Memory search says "query limited" or "reduced capability"

A startup line such as
`[mcp] QMD query limited without download requirements — running (bundled runtime), keyword search and document tools work; …`
means C5 is running normally. Keyword search works; semantic search is waiting for one or
more of its models. The rest of the line says which model is missing, still being
checked, or not the right file.

- **Missing**: C5 fetches it in the background after startup. If your network cannot
  reach Hugging Face, place it by hand — see
  [Placing the models by hand](/c5/tools/memory-search#placing-the-models-by-hand).
- **Being checked**: wait. On the first start after an update, C5 reads each model file
  once to check it, which can take a minute or two on a slow disk.
- **Not the right file**: see the next entry.

`growther qmd-run pull` fetches whatever is missing and says exactly what it did.

### A model file was renamed to `.rejected`

C5 found a file at a model's name that is not the model this release records — a
different upload, a cut-off copy, or a page a proxy saved in its place. It renamed the file
to `<file>.rejected` so it is never loaded, and said so in the log. **Nothing was deleted.**

Where downloads are allowed, C5 fetches the right file in its place by itself. If
automatic downloads are switched off with a `GROWTHER_*_NO_AUTO_DOWNLOAD` variable, run
`growther qmd-run pull` (memory search) or `growther voice pull` (voice). If the egress
posture is **Offline**, place the right file by hand — the
[memory search](/c5/tools/memory-search#placing-the-models-by-hand) and
[voice](/c5/using-c5/voice#placing-it-by-hand) pages give each file's address, size and
sha256. Once the feature works, delete the `.rejected` file to get the space back.

If the log says C5 **could not** set a file aside, stop C5, move the file away yourself, and
start C5 again. On Windows this happens when another program has the file open.

The local classifier works differently: a wrong file at its model's name is left where it
is and never loaded, and the next download — automatic, or `growther classifier pull` —
replaces it with the right one. **Settings › Learning** says so: _The file at the model's
path is not the model (…), so C5 does not use it._ On an offline install nothing replaces
it, so delete it (an administrator at the machine can press **Delete the file** on the card
while the classifier is off) and copy the right file in; see
[Offline and air-gapped installs](/c5/tools/local-classifier#offline-and-air-gapped-installs).
A symbolic link at the model's name is never downloaded over: point it at the model, or
remove it.

### The local classifier says this machine cannot run it

The **Local Classifier** card under **Settings › Learning** shows **Unsupported** and a
reason, `growther doctor` shows the same reason in its **Local classifier** row, and C5
downloads nothing. This is not a fault: C5 works exactly as it did before the classifier
existed. The reasons you may see:

| Reason | What to do |
| --- | --- |
| No local classifier build ships for your platform, or C5's release for it is experimental (Linux on ARM) | Nothing; the classifier is not offered there |
| This machine has less than 8 GB of memory (C5 counts the memory the system can use, rounded to a whole gigabyte: 7.5 GB or more passes. Most 8 GB machines qualify; one that keeps more for built-in graphics, such as one showing _8 GB memory (7.4 GB usable)_, does not) | Nothing, unless you can add memory |
| The classifier's runtime needs a newer macOS, or a newer glibc on Linux, than this machine has | Update the operating system, then restart C5 |
| The classifier's runtime needs a libstdc++ with a newer `GLIBCXX_` version (Linux) | Update the system's C++ runtime (usually by updating the distribution), then restart C5 |
| The classifier's runtime needs the Microsoft Visual C++ 2015-2022 Redistributable (Windows) | Install it from the link in the message, then restart C5 |

Run `growther classifier status` to see the same verdict in a terminal. More on each
reason is in
[Machines it cannot run on](/c5/tools/local-classifier#machines-it-cannot-run-on).

### The local classifier is on but has no model

The card shows **No model** or explains why the model is not being downloaded on this
machine. The usual causes:

- **The egress posture is Offline.** Nothing is downloaded. Place the model by hand: the
  card and `growther doctor` give its download address, exact path and sha256, and
  [Offline and air-gapped installs](/c5/tools/local-classifier#offline-and-air-gapped-installs)
  walks through it.
- **C5 runs with `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1`.** Run `growther classifier
  pull`.
- **There is not enough free disk space.** C5 needs room for the remaining download plus
  64 MB to spare. Free some space, then restart C5 or turn the classifier off and on.
- **The model's path is a symbolic link whose file cannot be reached.** The card says
  _The model's path is a link whose file cannot be reached (a share that is not mounted?).
  C5 uses the model once that file can be reached, and never downloads over the link._
  Mount the share or restore the file, or remove the link to have C5 fetch the model.

After `growther classifier pull` or placing the file by hand, you do not need to restart
C5: open **Settings › Learning**, and C5 checks the new file and starts the classifier.
(C5 looks for a new model file whenever that page asks for the classifier's status.)
Otherwise it picks the file up at its next start.

### Model downloads or updates fail behind a corporate proxy

C5 sends update checks, update downloads, Mothership calls, the Remote Control tunnel
program and every model download through the proxy and certificate authorities your
organisation configured under **Settings › Enterprise › Network**.

**Updates.** When `growther update` or C5's own update check fails, the message says why.
A proxy that refuses reads like this:

```text
the proxy http://proxy.example:3128 refused to open a tunnel to api.growther.si:443: it answered CONNECT with 403 Forbidden; its policy does not allow this host — ask for it to be allowed
```

| The proxy answered | What to do |
| --- | --- |
| `407 Proxy Authentication Required` | Put the credentials in the proxy URL (`http://user:password@host:port`). C5 supports Basic proxy authentication only |
| `403 Forbidden` | Ask for the host named in the message to be allowed |
| `502`, `503` or `504` | The proxy could not reach the host itself; try again later or ask your network team |

**Model downloads.** A model download that fails on the network says why in the same
way: it names the proxy that refused and what it answered, or the certificate C5 does not
trust. Memory search and voice give it after `fetch failed:`; the local classifier gives
it straight after `Could not download the classifier model:`. For example:

```text
[mcp] QMD model download did not complete (embedding: fetch failed: the proxy http://proxy.example:3128 refused to open a tunnel to huggingface.co:443: it answered CONNECT with 403 Forbidden; …). …
```

```text
The download failed: Could not download the classifier model: the proxy http://proxy.example:3128 refused to open a tunnel to huggingface.co:443: it answered CONNECT with 403 Forbidden; its policy does not allow this host — ask for it to be allowed. Fetch … on a connected machine and place it at … (sha256 …).
```

If the reason says *C5 refused to connect … the configured proxy … cannot be used*, the
proxy setting itself is broken: the **Network** card under **Settings › Enterprise** reads
**Proxy unusable — connections refused**. Fix or remove the proxy URL; see
[Corporate proxy](/c5/configuration/network#corporate-proxy).

Check that the proxy allows `huggingface.co` **and** its download hosts — see
[Hugging Face redirects to a download network](/c5/configuration/network#hugging-face-redirects-to-a-download-network).
An administrator can press **Test connectivity** under **Settings › Enterprise ›
Network** to ask each host C5 contacts, those included, through the proxy and see which
answered.

A certificate error behind a proxy that inspects TLS means C5 has not been given the
proxy's root certificate. See
[Behind a TLS-inspecting proxy](/c5/configuration/network#behind-a-tls-inspecting-proxy).

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
filled the disk. The bulk is almost always downloaded models and caches. They sit in five
folders under your C5 folder (`~/.growther` by default), outside the databases entirely:

| Folder | What it holds | Typically | If you delete it |
| --- | --- | --- | --- |
| `qmd/` | The memory-search engine, its three models (in `qmd/cache/qmd/models/`), its search index of your folders, and C5's own checked copies of the models (in `qmd/model-view/checked/`) | about 2.3 GB, and up to about 2.3 GB more for the checked copies on a disk that cannot clone files. `growther cache show` does not count the copies | To free model space, delete only `qmd/cache/qmd/models/`: C5 downloads the models again at its next start, unless downloads are off. Deleting all of `qmd/` also deletes the search index, and memory search finds nothing in your folders until they are indexed again: an administrator presses **Sync Now** on the **QMD Data Folders** card under **Settings › Locations**. See [What is safe to delete](/c5/configuration/data-location#what-is-safe-to-delete) |
| `classifier/` | The local classifier's model | about 812 MB | Downloaded again while the classifier is on. Delete it from **Settings › Learning** instead — see below |
| `speech/` | The offline speech model | about 60 MB | Downloaded again at the next start while **Built-in (on-device)** voice is on |
| `cache/` | Working files | varies | Recreated as needed |
| `lib/` | Unpacked runtime libraries | varies | Unpacked again at the next start |

Delete these folders only while C5 is stopped. "Unless downloads are off" means the egress
posture is **Offline**, or C5 was started with one of the `GROWTHER_*_NO_AUTO_DOWNLOAD`
switches; on such an install a deleted model stays gone until you place it again.

**To remove the local classifier's model, use Settings › Learning.** An administrator,
signed in at the machine itself (not from a paired phone), can press
**Delete the model (… MB)** on the card while the classifier is off, or
**Turn off and delete the model** in the question that turning it off asks. (For an
unfinished download the button reads **Delete the partly downloaded model**, and for a
model placed as a link to a file elsewhere, **Remove the link to the model**.) Turning it off first is what keeps C5 from downloading it again.
If your organisation's policy keeps the classifier on, the delete is refused, because C5
would only download the model again. See
[Delete the model](/c5/tools/local-classifier#delete-the-model) for who can delete it and
what is removed.

`growther cache show` reports what each folder is using, and
`growther cache relocate --to <path>` moves all five to another disk without touching your
work. If the databases really are the problem, shortening how long history is kept is the
biggest lever — see [Backups and recovery](/c5/security/backups).

## Costs

### I spent more than expected

Open [Ops](/c5/using-c5/ops) and look at spending by task and by model.

The usual culprits are a frequent schedule, a large fleet, or an expensive model doing
simple work. Set a budget so it cannot happen again.

## Serious problems

### "Integrity check failed"

> **Danger**
> The program on disk is not the one Growther.si signed. Stop using it, reinstall from
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
