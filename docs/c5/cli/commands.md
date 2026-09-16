---
title: The growther command
description: Every C5 command, what it does, and when to use it.
order: 1
---

# The growther command

C5 installs one command: `growther`. This page lists everything it can do.

To see this list in your terminal at any time:

```bash
growther help
```

## Start C5

Run the command with nothing after it:

```bash
growther
```

This starts the C5 server and prints the address it is running on — open that address in
your browser to use the app. The first time you run it, C5 sets itself up and asks you to
activate.

You can also run:

```bash
growther start
```

If C5 is already running, `growther start` focuses the open app in your browser and exits cleanly. If C5 is registered as a background service, it starts that service.

You can also start C5 directly from links or desktop shortcuts using the `growther://start` address.

### Interactive log filtering

When started interactively, C5 displays a startup banner and an interactive log filter. All
category logs are off by default to keep output quiet. You can press single hotkey letters
(like `v` for voice or `a` for agents) to toggle logs on and off in real time. Your choices
are saved automatically to `~/.growther/config/cli.yaml`.

See [Log filtering](/c5/cli/log-filtering) for the full list of hotkeys and configuration options.

## All commands

| Command             | What it does                                                   |
| ------------------- | -------------------------------------------------------------- |
| `growther`          | Start C5. First run sets itself up.                             |
| `growther start`    | Start C5 (or focus your browser if already running).            |
| `growther stop`     | Stop C5 gently, letting it finish what it is doing.             |
| `growther status`   | Say whether C5 is running, and how it is set to start.          |
| `growther service`  | Manage starting C5 automatically. See below.                    |
| `growther activate` | Pair this computer with your license.                           |
| `growther rekey`    | Give this computer a new key, keeping the same license.         |
| `growther update`   | Get the newest version.                                         |
| `growther rollback` | Go back to the version you had before.                          |
| `growther doctor`   | Check your setup and report anything wrong.                     |
| `growther home`     | Show, check or move where C5 keeps its files. See below.       |
| `growther lock`     | Show or clear the single-instance lock. See below.             |
| `growther policy`   | Managed configuration for IT: validate, sign, pin. See below.  |
| `growther user`     | Create the first administrator on a managed install.           |
| `growther webauthn` | Change the host name passkeys are bound to. See below.         |
| `growther qmd-run`  | Run the memory-search engine directly. See below.               |
| `growther verify`  | Prove a file really came from us. Works offline.                 |
| `growther uninstall`| Remove C5 from your computer.                                   |
| `growther version`  | Print which version you have.                                   |
| `growther login`    | Sign in from the command line, for a machine with no browser.   |
| `growther secrets`  | Move API keys into a keystore, and check what is stored where.  |
| `growther key`      | Escrow, reseal or disable the device key. See below.            |
| `growther restore`  | Restore from an encrypted backup.                               |
| `growther evidence` | Export audit evidence for an auditor or a legal hold.           |
| `growther cache`    | Show the caches, or move them to another disk. See below.       |
| `growther reset-auth` | Clear a user's sign-in credentials so they can enrol again.   |
| `growther voice`    | Manage the offline speech model.                                |
| `growther qmd-mcp`  | Run the memory-search engine as an MCP server.                  |
| `growther help`     | Show the list of commands.                                      |

## Commands in detail

### `growther start`

Starts C5, or opens the app in your browser if it is already running.

```bash
growther start
```

If C5 is already running, `growther start` opens or focuses your browser tab at `http://localhost:4299` and exits without creating a second instance. If you have registered C5 as a background service with `growther service install`, `growther start` starts that service. Otherwise, it boots C5 directly.

You can also trigger this command from web links and browser buttons using the `growther://start` protocol link.

### `growther status`

Tells you whether C5 is running right now, and whether it is set to start on its own
when your computer boots.

```bash
growther status
```

### `growther service`

Controls whether C5 starts by itself and stays running.

```bash
growther service install     # start C5 automatically from now on
growther service status      # check whether that is set up
growther service uninstall   # stop starting automatically
```

Use `install` if you want C5 always ready. Use `uninstall` to go back to starting it
by hand.

### `growther activate`

Pairs your computer with your license. C5 shows you a short code and opens a page
where you confirm it. You only do this once per computer.

```bash
growther activate
```

### `growther rekey`

Gives this computer a **new key** while keeping the **same** license and the same
history. Your data, settings and anything you have shared stay exactly where they
are — only the key changes.

C5 does this on its own every few months, so most people never type it. Reach for
it when C5 says the key it has is not the one your license expects:

```bash
growther rekey
```

If the key on this computer is gone or is no longer the right one — after
restoring from a backup, say, or moving to a new disk — add `--recover`:

```bash
growther rekey --recover
```

Recovery asks you to confirm in your browser, and it asks you to have signed in
**within the last 15 minutes**. If you get "step-up re-authentication is
required", sign out of the license portal, sign back in, and run the command
again straight away.

Do not run `growther activate` to fix a key problem. Activate creates a *new*
deployment; rekey keeps the one you already have.

### `growther update`

Gets the newest version. See [Updating C5](/c5/getting-started/updating) for the
full story.

```bash
growther update            # update now
growther update --check    # only check, do not install
```

C5 restarts itself after an update by default. To stop it doing so — an operator who
manages the restart themselves, or a maintenance window — set `GROWTHER_UPDATE_RESTART=0`
in the environment C5 runs under. There is no `--restart` flag.

### `growther rollback`

Puts back the version you had before an update.

```bash
growther rollback
```

If you have moved your API keys and licence into the system keystore (see
[Secrets and keys](/c5/security/secrets-and-keys)), C5 checks before it swaps. An older
version cannot read a keystore reference: it would read the reference itself as your
licence and refuse to start, and every provider key would fail. C5 refuses the roll back
and tells you to run `growther secrets revert` first. `--force` proceeds anyway.

### `growther doctor`

Checks your whole setup and tells you what is wrong in plain words. This is the first
thing to run when something is not working.

```bash
growther doctor
```

See [Running doctor](/c5/cli/doctor) for what it checks.

`growther doctor --json` prints one machine-readable report and writes
`doctor-status.json` into the C5 folder for device-management tools; `--strict` also fails
on warnings. The report includes where the home was resolved from, the filesystem class
of the data folder, which machine holds the lock, and whether this is a managed install.

### `growther home`

C5 keeps configuration, databases, keys and caches under one folder. `home` lets you
see that layout, check a folder before using it, and move to another local disk.

```bash
growther home show
growther home probe /Volumes/Work/growther
growther home migrate --to /Volumes/Work/growther
growther home rollback
growther home cancel
growther home prune-retired /Users/you/.growther/data.retired-2026-09-06T10-00-00 --yes
```

`migrate` validates the target (a local disk with room to spare), shows what will move,
asks for confirmation, and then stops C5 so the next start performs the move with every
database checked against your key before anything is switched. The old folder is kept
as a retired copy until you prune it. Databases are never placed on a network folder
or a synced folder; see [Where your data lives](/c5/configuration/data-location).

A move or a roll back that is interrupted resumes at the next start. `cancel` abandons
one instead, so a job you no longer want never has to be cleared by hand.

### `growther lock`

Only one C5 may use a data folder at a time, and the lock records which machine holds
it. If a machine was rebuilt and a stale lock remains:

```bash
growther lock status
growther lock break --confirm
```

`break` refuses while the holder is alive on this machine.

### `growther policy`

For IT administrators pushing configuration. See
[Managed configuration](/c5/configuration/enterprise-policy).

```bash
growther policy show                                  # what is applied, from where
growther policy validate policy.yaml                  # one row per key; non-zero if anything is rejected
growther policy keygen --out ./policy-keys            # an Ed25519 signing pair
growther policy sign policy.yaml --key ./policy-keys/policy-signing.key
sudo growther policy pin ./policy-keys/policy-signing.pub
growther policy expect                                # mark this install as managed
growther policy reload                                # re-read the policy now
growther policy templates --out ./c5-mdm               # the ADMX, profile, schema and samples
```

### `growther user`

On a managed install the anonymous first-user setup is off. Create the first
administrator from the device instead:

```bash
growther user bootstrap-admin --name "IT Admin"
```

### `growther webauthn`

For reaching a shared C5 by a corporate host name. A passkey is bound to the name it was
created under, so changing that name is an authentication change, not a settings change. See
[Reaching C5 by a corporate name](/c5/security/corporate-name).

```bash
growther webauthn status                                    # what is enrolled, and under which name
growther webauthn migrate-rpid --to c5.contoso.com          # bind new passkeys to the new name
growther webauthn migrate-rpid --to contoso.com \
  --origins https://c5.contoso.com,https://c5-eu.contoso.com
growther webauthn finish                                    # close the enrolment window
```

`migrate-rpid` opens a dual-name enrolment window: passkeys already enrolled keep working on
the old address while people re-enrol on the new one, at their own pace. `finish` closes it,
and passkeys still on the old name stop working from that point — run it once
`growther webauthn status` shows nothing left there.

It refuses while the only administrator credential is a passkey, because changing the name
would then leave nobody able to sign in; enrol a second administrator with a password or PIN,
or set up single sign-on first. It also refuses a name that is not a registrable suffix of the
sign-in origins, since the browser would reject every sign-in afterwards. There is no `--force`.

Both changing commands ask for confirmation; `--yes` skips it and `--json` prints a machine
report. Run them on the machine that hosts C5, as the account that runs C5. The change takes
effect without a restart.

### `growther qmd-run`

Runs the engine behind memory search directly, for the two things you might want to do
by hand.

```bash
growther qmd-run pull     # fetch the language models it needs (about 2 GB)
growther qmd-run doctor   # report on those models and the search index
```

C5 fetches the models by itself the first time it starts, so most people never need
`pull`. Reach for it when you want them on your own schedule — before taking a laptop
somewhere without signal, for instance.

`growther qmd-run doctor` is not the same as `growther doctor`. The first reports on
memory search; the second checks C5 as a whole.

See [Memory search](/c5/tools/memory-search) for what these models do and how to install
them on a machine with no internet.

### `growther verify`

Checks that a file really is the one we built, and that nobody has changed it since.
Useful if you downloaded C5 somewhere other than our site, or if you simply want to
confirm the copy you are running is untouched.

```bash
growther verify            # check the copy of C5 you are running
growther verify ./growther # check a specific file you downloaded
```

It works **offline**. Nothing is sent anywhere and nothing needs downloading: the key
used to check the signature is built into C5 itself.

What the answers mean:

| You see                         | What it means                                          |
| ------------------------------- | ------------------------------------------------------ |
| ✓ signature is valid            | The record of how this was built really came from us.  |
| ✓ contents match                | The file has not been changed since we built it.       |
| ✗ has been altered              | Do not run it. Download it again from growther.ai.     |
| ✗ signature is INVALID          | Do not run it. Download it again from growther.ai.     |
| ? unsigned / no key / no record | Cannot tell either way — see below.                    |
| ? this is a release archive     | Extract it, then verify the program inside.            |

A **?** is not a pass. It means the check could not be completed — usually because you
are running a development build, because the file has no build record next to it, or
because you pointed it at a downloaded `.tar.gz`/`.zip` rather than the program itself.
Treat it as "unknown", not "fine".

Checking a downloaded archive tells you its build record is genuine but says nothing
about the bytes inside it, so extract it first and verify the program:

```bash
tar -xzf growther-c5-macos-arm64.tar.gz
growther verify ./growther-c5-macos-arm64
```

If you are writing a script, the exit codes are `0` verified, `1` failed or altered, and
`2` could not be checked.

See [Verifying releases](/c5/security/verifying-releases) for the whole trust story.

### `growther key`

The device key that encrypts your databases: where it is kept, and how to make it
recoverable. See [Secrets and keys](/c5/security/secrets-and-keys).

```bash
growther key status                          # custody mode, fingerprint, escrow state
growther key escrow keygen --out ./kek       # run this OFF the C5 machine
growther key escrow enable ./kek/kek.pub     # seal the key set, then verify it
growther key escrow rotate ./next-kek.pub    # roll to a new key without a flag day
growther key escrow reseal                   # after a device-key change
growther key wrap                            # move the key into the OS keystore
growther key unwrap                          # move it back to a file
growther key recover --escrow key-escrow.blob --private-key ./kek/kek.pem
```

`wrap` needs a verified escrow and will refuse without one — wrapping makes the OS
keystore a boot dependency, and escrow is the only way back from a destroyed keystore
entry.

### `growther cache`

The downloaded models and caches, which are usually what filled your disk. Deleting them
is safe; C5 fetches them again if it needs them.

```bash
growther cache show                              # where qmd/, speech/, cache/ and lib/ live, and their size
growther cache relocate --to /Volumes/Big/c5     # move all four to another local disk
```

C5 must be stopped to relocate, and the new location is recorded so it survives restarts.

### `growther secrets` and `growther restore`

```bash
growther secrets status                # what is stored where, and what is still in the clear
growther secrets migrate               # move API keys out of the config file into a keystore
growther restore --from <backup>       # restore from an encrypted backup
```

### `growther evidence`

Export the audit record for an auditor or a legal hold. See
[Audit trail](/c5/security/audit-trail).

### `growther login` and `growther reset-auth`

```bash
growther login                 # sign in from the command line, for a host with no browser
growther reset-auth <user>     # clear a user's credentials so they can enrol again
```

`reset-auth` is the way back in when somebody has lost the device holding their passkey.

### `growther uninstall`

Removes the C5 program, takes it off your PATH, and turns off automatic starting.

```bash
growther uninstall
```

**Your data is kept.** Everything in your data folder stays where it is, so you can
reinstall later and pick up where you left off.

> **Danger**
> To delete your data too, add `--purge-data`. This erases everything C5 has stored —
> your chats, tasks, files, and settings. It cannot be undone.

```bash
growther uninstall --purge-data
```

`--purge-data` removes every folder C5 owns, not only the main one: a data or key folder
you moved to another disk, and the small pointer file that records where the folder is.
It lists each one before removing it. Leaving the pointer behind used to stop the next
fresh install from starting, so a purge is now genuinely complete.

## Getting the version

```bash
growther version
```

Useful when reporting a problem — see [Getting help](/c5/troubleshooting/getting-help).

## Next steps

- [Environment variables](/c5/cli/environment) — change ports, folders, and channels.
- [Running doctor](/c5/cli/doctor) — check your setup.
