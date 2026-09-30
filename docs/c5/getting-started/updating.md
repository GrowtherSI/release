---
title: Updating C5
description: Keep C5 current, check for new versions, and roll back if you need to.
order: 4
---

# Updating C5

C5 can update itself. One command gets you the newest version.

## Update now

```bash
growther update
```

This downloads the latest release, checks that it is genuine, and installs it.

## Just check, do not install

Want to see if there is something new without changing anything?

```bash
growther update --check
```

It tells you your version, the latest version, and whether you should update.

## Update and restart

If you run C5 as a background service, this updates it and restarts it in one step:

```bash
growther update --restart
```

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

Your data is not touched. Only the program file changes.

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
