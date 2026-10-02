---
title: Verifying releases
description: How C5 proves the version you are running is genuine.
order: 5
---

# Verifying releases

Every copy of C5 is checked before it runs. This page explains how, and what to do if a
check ever fails.

## The problem this solves

Software gets downloaded over networks you do not control. Somewhere between the
publisher and your computer, a file could be swapped or altered.

You want to know that the program you are about to run is exactly the one Growther.si
built — not a modified copy.

## Two checks

### A fingerprint

Every release is published with a **SHA-256** — a short string calculated from the file's
contents. Change even one byte and the string changes completely.

When you install or update, C5 calculates the fingerprint of what it just downloaded and
compares it to the published one. If they differ, the install stops and nothing is
written.

### A signature

Every release also ships with a **signed build manifest** — a small record of how the
build was made, stamped in a way only Growther.si can produce. Growther.si holds a
private key; the stamp can be checked by anyone but created by no one else. So a valid
stamp proves the build came from Growther.si and has not been altered since.

## Where the checking happens

| When                | What is checked                                              |
| ------------------- | ------------------------------------------------------------ |
| **Installing**      | The SHA-256 of the download. A mismatch stops the install.    |
| **Updating**        | The signature and the file's hash, before anything replaces your copy. |
| **Rolling back**    | The kept older program against the SHA-256 recorded when it was kept, and that it starts. Its signed build manifest goes back with it. |
| **On demand**       | `growther doctor` checks the signature and the program file.  |

The first three happen on their own — you do not have to do anything. Together they mean a
tampered file cannot get onto your machine through the installer or the updater.

C5 also never makes a checksum vouch for bytes it cannot vouch for. When `growther update`
finds the program already current, it rewrites a `<program>.sha256` beside it only if the
signed build manifest on this machine names that program's fingerprint; otherwise it leaves
the file as it is and tells you to run `growther verify`.

> **Tip**
> To confirm at any point that the copy on disk is still the one that was installed, run
> `growther doctor`. Its integrity check is exactly for this, and it is worth running
> after anything unusual — a crash during an update, a restore from backup, or a machine
> someone else has had access to.

## Checking for yourself

To check one specific file — the copy you are running, or something you just
downloaded — use:

```bash
growther verify            # the copy of C5 you are running
growther verify ./growther # a file you downloaded
```

This works **offline**. Nothing is sent anywhere and there is nothing to download
first: the key used to check the signature is built into C5 itself. See
[Commands](/c5/cli/commands) for what each answer means.

A **?** answer is not a pass — it means the check could not be completed. Treat it
as "unknown", not "fine".

For a broader checkup of your whole setup, including the same integrity check
alongside licensing and storage:

```bash
growther doctor
```

See [Running doctor](/c5/cli/doctor).

## If a check fails

> **Danger**
> A failed integrity check means the program on disk is not the one Growther.si signed.
> Do not ignore it and do not work around it.

What to do:

1. **Stop using that copy.**
2. **Reinstall from the official installer** — see
   [Installation](/c5/getting-started/installation).
3. **If it fails again, ask for help** before running it. See
   [Getting help](/c5/troubleshooting/getting-help).

Most real-world causes are dull — a download that got truncated, a disk error, an
antivirus tool that modified the file. But the check cannot tell dull from serious, so it
treats every failure the same way. That is the correct behavior.

## Where releases come from

Published releases and their fingerprints live in the public
[release repository](https://github.com/GrowtherSI/release). Every version is listed with
its digest, so you can check any file by hand if you want to.

## What C5 downloads later, and the notices

The checks above cover the program. C5 also downloads a few things after you install it, and
checks each of them in the same spirit. They are covered in more detail on
[Open-source licences and downloaded models](/c5/security/open-source-and-models).

- **The models**, for memory search, voice and the local classifier. Each is pinned to one exact
  version, and C5 compares its size and SHA-256 with values built into C5 before it uses the
  file. A model that does not match is never loaded. That is not a reason to reinstall C5: C5
  sets the file aside or downloads it again. See
  [What C5 checks, and what it sends](/c5/security/open-source-and-models#what-c5-checks-and-what-it-sends).
- **The cloudflared connector**, which C5 downloads only when
  [Remote Control](/c5/remote-control/overview) starts a Cloudflare tunnel — the issued
  address or a tunnel of your own. It is pinned to one release and held to
  that release's exact size and SHA-256 before it runs.
- **`THIRD-PARTY-NOTICES.txt`** lists the open-source software and models C5 uses, with their
  licences. The release archives, the website zip, the MSI and the PKG installed by MDM carry a
  copy beside the program. The copy of C5 in `~/.local/bin` (Windows:
  `%LOCALAPPDATA%\Growther\bin`), where the install commands and the program's first run put
  it, has the notices inside the program only. On every install you can read them under
  **About › Copyright & Legal** or print them with `growther licenses`.
