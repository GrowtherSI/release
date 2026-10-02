---
title: Updating C5
description: Keep C5 current, check for new versions, roll back if you need to, what the first start after an update does, and updating through a proxy.
order: 4
---

# Updating C5

C5 can update itself. One command gets you the newest version.

## Update now

```bash
growther update
```

This downloads the latest release, checks that it is genuine, and installs it.

If there is a `THIRD-PARTY-NOTICES.txt` file beside the program — as there is in a copy
unpacked from a release archive — the update brings it up to date with the new release
too. C5 does not create one where there was none. See
[After an update or a rollback](/c5/security/open-source-and-models#after-an-update-or-a-rollback).

**If an update was interrupted**, run `growther update` again. If the new program was
already in place, it answers `✓ Already up to date.` and puts the files beside the program
back in step with it. It restores the notices file from the program you run, and rewrites
the program's checksum file (`<program>.sha256`, from a website download) only when the
signed build record on this machine vouches for the program. Otherwise it leaves the
checksum file as it is and warns:

```text
  ! <program>.sha256 does not match the running binary, and no signed build manifest on this machine names the binary's hash, so it was left as it is. Run `growther verify`: the binary may have been altered on disk.
```

A checksum that does not match is also exactly what a damaged or altered program looks like,
so C5 never makes the file vouch for a program it cannot vouch for itself. Run
`growther verify` (see [Verify what you run](/c5/security/verifying-releases)). A copy that a
package manager installed is left to the package manager.

## Just check, do not install

Want to see if there is something new without changing anything?

```bash
growther update --check
```

It tells you your version, the latest version, and whether you should update.

## Update and restart

If you run C5 as a background service on macOS or Linux, plain `growther update` restarts
it for you once the new version is in place. There is no `--restart` flag. To pick the moment
yourself, for example during a maintenance window, set `GROWTHER_UPDATE_RESTART=0`; C5 then
tells you to restart it to finish. On Windows the update is staged and applies the next time
C5 restarts. See [`growther update`](/c5/cli/commands#growther-update) for each case.

## Update the way you installed

If you used Homebrew:

```bash
brew upgrade growther-c5
```

If you used the install script, run the same one-line command from
[Installation](/c5/getting-started/installation) again. It will replace your copy with
the newest one.

## Go back to the older version

If a new version gives you trouble, you can step back to the one you had before:

```bash
growther rollback
```

Your data is not touched. Only the program file changes, along with the
`THIRD-PARTY-NOTICES.txt` beside it, if there is one, which goes back to the one for the
older version. C5 first checks that the older program it kept is still exactly the file
it kept and that it still runs; if either check fails, nothing is replaced, and the
message says so.

**If your secrets are held in a keystore** rather than in `c5.yaml` (see
[Secrets and keys](/c5/security/secrets-and-keys)), an older version may not be able to read
them. When your licence is held there, rollback refuses and says why
(`refusing to roll back: …`): run `growther secrets revert` first, on the version you are
running now, then roll back. When only API keys are held there, rollback goes ahead but
warns that the providers using them will fail to authenticate on the older version; run
`growther secrets revert` to avoid that. Use `growther rollback --force` only if you know the
older version can read the keystore references (`ref:` values) in `c5.yaml`.

The record of the kept program also names its version. So if an older version of C5 later
replaced the kept copy without updating that record, rollback can tell a stale record from a
damaged copy: it starts the copy, and if the copy reports a different version from the one
recorded, it goes ahead and says the record was out of date. A copy that reports the recorded
version but does not match is damaged, and rollback refuses. If the install had no signed
build record before the update, rollback leaves none afterwards, so `growther verify` does
not judge the older program against the newer release's record.

Downloaded models stay where they are. If the older version has no local classifier, its
model simply sits unused in the `classifier` folder; see
[Running out of disk space](/c5/troubleshooting/common-issues#running-out-of-disk-space)
if you want the space back.

## What happens on the first start after an update

Most updates change nothing you need to act on.

### Updating to the release with the local classifier (Terms v1.8)

If you are updating from a version that had no local classifier, the first start does
three things once.

**C5 checks the models already on your disk.** The memory-search and offline-voice models
are now pinned to exact files and checked by size and sha256 fingerprint before C5 uses
them. On the first start, C5 reads each model file you already have, once, and records the
result beside it. On a slow disk this can take a minute or two. Memory search waits for
the check; the rest of C5 starts as normal. A file that turns out not to be the right one
is renamed to `.rejected`, never deleted, and where downloads are allowed C5 fetches the
right one in its place. See
[Memory search](/c5/tools/memory-search) and [Voice](/c5/using-c5/voice).

**The local classifier comes on.** This release adds the
[local classifier](/c5/tools/local-classifier), a model of about 812 MB that answers some
of C5's routine questions on your own machine. It is on by default, so on this first start
C5 switches it on, unless:

- someone on this install had already switched it off — it stays off; or
- your organisation's policy sets `classifier_enabled` — the policy decides.

When C5 switches it on, administrators get **one notification** saying so, and what will
happen on this machine:

| This machine | What happens |
| --- | --- |
| Can run it, and can reach Hugging Face | The notification says C5 downloads the model once (about 812 MB) |
| Already has the checked model | The notification says nothing is downloaded and it is ready to use |
| Has the egress posture set to **Offline** | The notification says nothing is downloaded, and to place the model by hand |
| Runs with `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` | The notification says nothing is downloaded automatically, and to run `growther classifier pull` |
| Has too little free disk space | The notification says how much room it needs and where. Free some space, then restart C5 or turn the classifier off and on |
| Has a symbolic link at the model's path | The notification says C5 never downloads over a link. If the file it points to cannot be reached (a share that is not mounted), C5 uses the model once it can be. If the link points to a file that is not the model, it stays unused until the link points at the model or is removed. A link C5 has not checked yet is checked before it is used |
| Cannot run it (platform, memory, operating system or system libraries) | No notification, and nothing is downloaded |

The download happens in the background after startup and goes through your proxy
settings. At first the classifier only records its answers beside the usual ones, for every
kind of decision it can answer — task categories, skill routing, step quality, tool-call
safety and alert triage each start in **Shadow** — and it decides nothing until it has been
measured on your install. On a machine where it runs on the CPU, step quality, tool-call
safety and skill routing record only one question in four, so it stays out of your agents'
way. To turn it off, or delete its model, go to **Settings › Learning** — see
[Turn the classifier off](/c5/tools/local-classifier#turn-the-classifier-off). The
[FAQ](/c5/troubleshooting/faq#the-local-classifier) answers what it is and what it sends
(nothing to Growther.si).

**The Terms of Service are now version 1.8.** Section 14, Models C5 downloads and runs on
your machine, is new, so Remote Control moves to Section 15. If Remote Control is on, it
keeps running and nobody is signed out. The **Settings › Remote Control** tab says that the
new version has not been accepted on this machine, and the next save on that tab asks you
to accept it. See [Turning it on and pairing a phone](/c5/remote-control/setup).

### Updating from a version that already had the local classifier

In this release every kind of decision the classifier answers starts in **Shadow**: asked in
the background, its answer recorded beside the usual one and never used. Before, only task
categories did, and the other four were **Off**.

A mode someone on this install chose is kept, **Off** included, and nothing is raised into a
mode that acts. Earlier versions saved every kind's mode as soon as anyone changed one, so the
kinds nobody chose could be saved at the old defaults. On the first start, once, C5 looks in
its audit log: a kind still at its old default that nobody chose is reset to today's default.
The reset is recorded in the audit log as a change made by `system`. If the audit log no
longer reaches back far enough to tell (to 27 September 2026), C5 changes nothing, and while
the classifier is on it logs
`[classifier] site modes kept as stored: the audit trail no longer shows which were chosen, so none is taken for a default`.
You can set any kind's mode yourself in **Settings › Learning**. See
[What it does at first](/c5/tools/local-classifier#what-it-does-at-first).

## Updates through a corporate proxy

The update check and the update download both go through the proxy and certificate
authorities your organisation set under **Settings › Enterprise › Network**, like the rest
of C5. If certificate pinning is on, it still applies when the connection goes through the
proxy.

When a check or download fails, `growther update` and C5's own update check say why — a
certificate the pin did not accept, a missing certificate authority, or a proxy that
refused, with the answer it gave:

```text
the proxy http://proxy.example:3128 refused to open a tunnel to raw.githubusercontent.com:443: it answered CONNECT with 407 Proxy Authentication Required; it wants credentials — put them in the proxy URL (http://user:password@host:port), C5 speaks Basic proxy authentication only
```

See [Network and egress](/c5/configuration/network) for the hosts updates use, and
[Common issues](/c5/troubleshooting/common-issues#model-downloads-or-updates-fail-behind-a-corporate-proxy)
for what each proxy answer means.

## Every update is checked

Every release is published with a fingerprint and a signature. Before C5 installs an
update, it checks both. If either one does not match, the update stops and nothing is
installed.

This means you can only ever end up running a version that Growther.si actually built
and signed. See [Verify what you run](/c5/security/verifying-releases).

## Release channels

Most people should stay on the stable channel, which is the default. If you want early
versions, you can switch:

```bash
GROWTHER_CHANNEL=beta growther update
```

| Channel  | Who it is for                                       |
| -------- | --------------------------------------------------- |
| `stable` | Everyone. Tested and ready for daily use.            |
| `beta`   | People who want new features early and can hit bugs. |
| `dev`    | Testing only. Expect rough edges.                    |
