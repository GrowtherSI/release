---
title: Local encryption
description: How your data is protected on your own computer.
order: 1
---

# Local encryption

C5 encrypts the databases it stores your work in. This page explains what that protects
you from — and, just as importantly, what it does not.

## What encrypted means here

Your data lives in a folder on your computer — by default `~/.growther`. The files there
are scrambled. Opening one without the key shows nothing useful.

This covers:

- Chats and their whole history
- Tasks, plans, and results
- Files your agents made
- API keys and integration settings
- Your context and settings

## Where the key lives

This is the most important thing on the page, so it comes first.

Your key is a file on your computer:

```text
~/.growther/config/device-master-key
```

It sits **inside the same folder as your data**. Only your user account can read it, but
it is not locked in a keychain and it is not protected by a password you type.

That one fact decides everything below. **Whoever has the folder has the key.**

## What it protects against

- **Another account on the same computer.** Other users cannot read the key file, so they
  cannot open your data.
- **Moving the databases somewhere else.** The data files on their own are unreadable.
  Copying just the database out of your folder gets an attacker nothing.
- **Deleting your data for good.** Destroy the key and the data is gone, even if a copy
  of the database survives somewhere.

## What it does not protect against

Be clear about the limits. These are the ones people get wrong:

- **A lost or stolen laptop.** The key is on the same drive as the data. Someone with
  the drive has both. If you want protection here, turn on full-disk encryption —
  FileVault on macOS, BitLocker on Windows, LUKS on Linux. That is the tool for this job,
  and C5's own encryption is not a substitute for it.
- **A copy of your data folder.** A backup that includes `config/` includes the key.
  Treat any such copy as if it were unencrypted.
- **Anything running as you.** Any program logged in as your user can read the key file,
  the same as it could read your documents.
- **Data you send out.** Anything an agent sends to a model provider or an integration
  goes to that service under their terms, not yours.

Encryption here protects data sitting still, from other accounts and other machines. It
is not a safe you can lock and walk away from.

> **Danger**
> Do not put a copy of `~/.growther` in cloud storage or on a shared drive and assume it
> is protected because C5 encrypts its databases. The key is in that copy. Either keep
> the backup somewhere you would be willing to keep unencrypted files, or store
> `config/device-master-key` separately from the rest.

> **Warning**
> Lose the key and your data cannot be recovered. Not by you, not by Growther.ai. There
> is no master key and no back door. See
> [Backups and recovery](/c5/security/backups).

## Getting your data out

Encryption is not a lock-in. You can decrypt and export your data whenever you want,
from Settings.

Exported data is plain and readable, so put it somewhere sensible. An unencrypted export
in your Downloads folder undoes the protection.

## Where your data lives

By default `~/.growther`. You can move it with the `GROWTHER_HOME` setting — see
[Environment variables](/c5/cli/environment).

Whatever folder you use, that one folder is your entire C5. Back it up and you have
backed up everything.

## Where to go next

- [Backups and recovery](/c5/security/backups) — do not skip this one.
- [Privacy](/c5/mothership/privacy) — what leaves your machine, if anything.
- [Remote Control](/c5/remote-control/overview) — reaching C5 from a phone, and who can see what on each path.
