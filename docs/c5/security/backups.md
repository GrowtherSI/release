---
title: Backups & recovery
description: Keep a copy of your work, and get it back when you need it.
order: 4
---

# Backups & recovery

C5 backs itself up. You should still keep your own copy.

## What C5 does on its own

C5 looks after its own storage:

- **Automatic backups** on a schedule you can change
- **Self-repair** for many kinds of storage damage
- **Self-recovery** after most crashes and power cuts

If your computer loses power mid-task, C5 comes back knowing what it was doing and picks
up from there. You do not lose your place.

## Why you still need your own copy

C5's backups live in the same folder as your data. That protects you from software
problems. It does **not** protect you from:

- A failed hard drive
- A lost or stolen laptop
- Deleting the folder by accident

For those, you need a copy somewhere else.

## Backing up

On macOS and Linux everything is in one folder — by default `~/.growther`. Copy that folder
and you have copied your entire C5.

**On Windows it is two folders.** Every install created since C5 2026.9 keeps your settings
under `%USERPROFILE%\.growther` but puts the databases and the keys under
`%LOCALAPPDATA%\Growther\C5`, deliberately: `%LOCALAPPDATA%` never travels with a roaming
profile, so signing in on another machine cannot carry an encrypted database away from the key
that opens it. Copying only `.growther` would back up your settings and none of your work —
and none of the key needed to read it.

Run `growther home show` and back up **every path it prints**. That is the reliable answer on
any platform, because it reports where your install actually keeps things rather than where
the default would be.

The simplest approach is to include it in whatever backup you already run. Time Machine,
a cloud backup service, or a copy to an external drive all work.

> **Danger**
> A copy of `~/.growther` contains your encryption key, at
> `config/device-master-key`. That means a backup of the folder is **not** protected
> by C5's encryption — anyone who gets the copy can open it.
>
> Either put the backup somewhere you would be willing to keep unencrypted files, or
> encrypt the backup itself. See [Local encryption](/c5/security/encryption).

Best practice is to back up while C5 is stopped, so nothing is mid-write:

```bash
growther stop
# run your backup
growther
```

A backup taken while C5 is running is usually fine, but stopping first removes all doubt.

## Backing up to GitHub

The **GitHub** card in **Settings › Integrations** can also push your C5 folder to a GitHub
repository on a schedule, in its **C5 Data** panel.

**Secret files stay out by default.** The folder holds your device master key, every
provider's API key and the licence signing key, so C5 refuses to push those files, copies
still in the commit history included. **Back up secret files**, in the same panel, lets
them through:

- It can be turned on only for a repository GitHub confirms is private. Otherwise the
  switch is greyed out: _This repo is public. Secrets can only be backed up to a repo GitHub
  confirms is private._, or _C5 cannot verify this repo is private, so secrets stay
  excluded._ C5 checks again on every push, and stops including them the moment the
  repository is no longer private.
- Turning it on asks first: **Push secrets to GitHub?**, saying that anyone who can read the
  repository, now or later, can read those keys. **Include them** turns it on; **Cancel**
  leaves it off.
- **Only an administrator at the machine** can turn it on or off. Anyone else, and any
  device paired through Remote Control, is refused, and the card says _Failed to update
  secret handling_. Each change is recorded in the audit log.

Treat a repository that holds them like the folder itself: see the warning above.

## Backup settings

Inside the app you can change:

- **How often** automatic backups run
- **How many** old ones are kept
- **How long** history is kept before old records are trimmed

If disk space is tight, shortening history retention is the biggest lever.

## Restoring

To restore onto the same computer:

1. Stop C5: `growther stop`
2. **Move your current data folder aside — do not delete it:**

   ```bash
   mv ~/.growther ~/.growther.before-restore
   ```

3. Copy your backup into place as `~/.growther`.
4. Start C5: `growther` — and check that your work is actually there.
5. Only once you are satisfied, delete `~/.growther.before-restore`.

> **Danger**
> Do not overwrite your live data folder with a backup you have not opened yet. If the
> backup turns out to be incomplete or corrupted, moving the old folder aside is the
> only thing standing between you and losing both copies.

To move to a new computer:

1. Install C5 — see [Installation](/c5/getting-started/installation).
2. Stop it: `growther stop`
3. Copy your backup into place as the data folder.
4. Start it: `growther`
5. Activate: `growther activate`

Your projects, files, history, and settings come with you.

## Checking your backup works

An untested backup is a guess. Test it by restoring the copy into a spare folder and
starting C5 there:

```bash
mkdir -m 700 -p ~/c5-restore-test
cp -R /path/to/your/backup/. ~/c5-restore-test/
GROWTHER_HOME=~/c5-restore-test growther
```

`GROWTHER_HOME` tells C5 to use that folder instead of your real one, so this cannot
disturb your working setup. Open the app and look for your projects and chats. If they
are there, your backup is good.

Delete the test folder afterwards:

```bash
rm -rf ~/c5-restore-test
```

> **Warning**
> Restore into a folder only you can read — that is what `mkdir -m 700` above is for —
> and put it in your home folder, not in `/tmp`. A restored copy contains your key, and
> `/tmp` is shared with every other user and program on the machine.

> **Note**
> Pointing `GROWTHER_HOME` at an empty folder does not test anything. C5 will simply set
> up a brand-new, empty install there. You have to copy the backup in first.

## If something is badly wrong

Run the checkup first:

```bash
growther doctor
```

It will tell you whether the problem is your install, your license, or your data. See
[Running doctor](/c5/cli/doctor) and
[Common issues](/c5/troubleshooting/common-issues).
