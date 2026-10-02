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

A word C5 does not recognise never starts the server. If you mistype a command (for
example `growther updfate` instead of `growther update`), C5 prints "Unknown command",
shows the list of commands, and exits with code `1`.

### Interactive log filtering

When started interactively, C5 displays a startup banner and an interactive log filter. All
category logs are off by default to keep output quiet. You can press single hotkey letters
(like `v` for voice or `a` for agents) to toggle logs on and off in real time. Your choices
are saved automatically to `~/.growther/config/cli.yaml`.

See [Log filtering](/c5/cli/log-filtering) for the full list of hotkeys and configuration options.

## All commands

| Command               | What it does                                                          |
| --------------------- | --------------------------------------------------------------------- |
| `growther`            | Start C5. First run sets itself up.                                   |
| `growther start`      | Start C5 (or focus your browser if already running).                  |
| `growther stop`       | Stop C5 gently, letting it finish what it is doing.                   |
| `growther status`     | Say whether C5 is running, and how it is set to start.                |
| `growther service`    | Manage starting C5 automatically. See below.                          |
| `growther activate`   | Pair this computer with your licence.                                 |
| `growther rekey`      | Give this computer a new key, keeping the same licence.               |
| `growther update`     | Get the newest version.                                               |
| `growther rollback`   | Go back to the version you had before.                                |
| `growther doctor`     | Check your setup and report anything wrong.                           |
| `growther home`       | Show, check or move where C5 keeps its files. See below.              |
| `growther lock`       | Show or clear the single-instance lock. See below.                    |
| `growther policy`     | Managed configuration for IT: validate, sign, pin. See below.         |
| `growther user`       | Create the first administrator on a managed install.                  |
| `growther webauthn`   | Change the host name passkeys are bound to. See below.                |
| `growther qmd-run`    | Fetch or check the memory-search models. See below.                   |
| `growther voice`      | Check or fetch the offline speech model. See below.                   |
| `growther classifier` | Check or fetch the local classifier's model. See below.               |
| `growther licenses`   | Print the open-source notices for everything C5 ships or downloads.   |
| `growther verify`     | Prove a file really came from us. Works offline.                      |
| `growther uninstall`  | Remove C5 from your computer.                                         |
| `growther version`    | Print which version you have.                                         |
| `growther login`      | Sign in from the command line, for a machine with no browser.         |
| `growther connect`    | Reach a C5 on another machine over your own SSH connection.           |
| `growther remote`     | Say whether Remote Control is on, and list the paired devices.        |
| `growther secrets`    | Move API keys into a keystore, and check what is stored where.        |
| `growther key`        | Escrow, reseal or disable the device key. See below.                  |
| `growther restore`    | Restore from an encrypted backup.                                     |
| `growther evidence`   | Export audit evidence for an auditor or a legal hold.                 |
| `growther cache`      | Show the downloaded models and caches, or move them. See below.       |
| `growther reset-auth` | Clear a user's sign-in credentials so they can enrol again.           |
| `growther qmd-mcp`    | Used by C5 itself to run memory search for agents. See below.         |
| `growther help`       | Show the list of commands.                                            |

`growther licences` (British spelling) is the same command as `growther licenses`.

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

### `growther stop`

Stops a C5 that is running on this machine.

```bash
growther stop
```

"Gently" means C5 is asked to shut down rather than being killed: it finishes writing
its databases and releases its lock before it exits. The command prints
`Stopping C5 (pid …)…`, waits up to 10 seconds, and then prints `C5 stopped.`. If C5 is
not running it says `C5 is not running.` Both exit with code `0`.

If C5 has not exited after 10 seconds, the command says so and exits with code `1`. C5
may still be shutting down: run `growther status` a moment later to check.

A background service registered with `growther service install` does not start C5 again
after a clean stop. It starts it again the next time you sign in. To stop it starting
at all, run `growther service uninstall`.

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

Pairs your computer with your licence. C5 shows you a short code and opens a page
where you confirm it. You only do this once per computer.

```bash
growther activate
```

### `growther rekey`

Gives this computer a **new key** while keeping the **same** licence and the same
history. Your data, settings and anything you have shared stay exactly where they
are — only the key changes.

C5 does this on its own every few months, so most people never type it. Reach for
it when C5 says the key it has is not the one your licence expects:

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
required", sign out of the licence portal, sign back in, and run the command
again straight away.

Do not run `growther activate` to fix a key problem. Activate creates a _new_
deployment; rekey keeps the one you already have.

### `growther update`

Gets the newest version. See [Updating C5](/c5/getting-started/updating) for the
full story.

```bash
growther update            # update now
growther update --check    # only check, do not install
```

What it does, in order:

1. Asks the platform for the newest version on your release channel.
2. Stops there if this machine cannot run that version (its operating system is too
   old), or if C5 was installed by a package manager that owns the program. It tells
   you which, and where to update instead.
3. Downloads the new version and checks its SHA-256 against the signed release record.
4. Checks that the new program actually starts on this machine, before touching the
   one you have.
5. Swaps the program, keeping the old one so `growther rollback` can put it back.
6. Refreshes the `THIRD-PARTY-NOTICES.txt` file beside the program, if there is one
   there, so it describes the version you now run. If that cannot be done you see a
   line starting `! THIRD-PARTY-NOTICES.txt beside the binary still describes the
   previous release`. The update itself has still worked, and `growther licenses`
   always prints the current notices.

**If an update is interrupted** (a closed terminal, a crash, a full disk), run
`growther update` again. It does not wait for the interrupted run, and it tidies up
what that run left beside the program. If the program was already swapped, it answers
`✓ Already up to date.` and, where needed, puts the files beside the program back in step:

- **The notices** (`THIRD-PARTY-NOTICES.txt`) are written again from the program you run.
- **The checksum file** (`<program>.sha256`) is rewritten only when the signed build record
  on this machine (`~/.growther/build_manifest.json`) names the running program's SHA-256.
  A checksum that does not match is also what a damaged or altered program looks like, so
  without that record the file is left as it is and the run warns:

  ```text
    ! <program>.sha256 does not match the running binary, and no signed build manifest on this machine names the binary's hash, so it was left as it is. Run `growther verify`: the binary may have been altered on disk.
  ```

  Run [`growther verify`](#growther-verify) to find out.

It then prints `✓ the files beside the binary (notices, checksum) now describe this
release`. If it left the checksum file as it was, you see the warning above instead,
followed, when the notices were rewritten, by
`✓ the notices beside the binary now describe this release`. This repair is skipped on
`--check`, and on a copy a package manager installed.

When the swap is done it prints `✓ Updated <old> → <new>. Restart C5 to apply.` The
new version runs from the next start. What happens next depends on how C5 runs:

- **C5 runs as a background service** (you ran `growther service install`) on macOS or
  Linux, and that service runs this same copy of the program: C5 restarts the service
  for you and prints `↻ requested managed-service restart (update)`.
- **The service runs a different copy**: it is left alone. You see
  `(the C5 service runs <program>, not this copy; it is left running)`, followed by the
  "restart C5 manually" line below.
- **No service**: you see `(no managed service detected — restart C5 manually)`. Stop
  C5 with `growther stop` and start it again.
- **Windows**: the update is staged and applies when C5 restarts. You see
  `(restart C5 to apply the staged update)`.

To stop C5 restarting the service by itself, for example during a maintenance window,
set `GROWTHER_UPDATE_RESTART=0` (exactly `0`) in the environment you run
`growther update` from. There is no `--restart` flag.

Updating from the app instead restarts C5 for you, on every platform, unless
`GROWTHER_UPDATE_RESTART=0` is set in the environment C5 itself runs in.

**Behind a corporate proxy.** The check and the download both go through the proxy and
certificate authority bundle configured for C5 — the same ones C5 itself uses, set by
policy, by `GROWTHER_PROXY_URL` and `GROWTHER_CA_BUNDLE`, or in `c5.yaml`. C5 does not
read `HTTPS_PROXY` or `HTTP_PROXY`. See [Network and egress](/c5/configuration/network).

If the check or the download fails, the message says why rather than only "fetch
failed":

| The message says | What to do |
| --- | --- |
| `the proxy … refused to open a tunnel to <host>:443: it answered CONNECT with 407 …` | The proxy wants credentials. Put them in the proxy URL (`http://user:password@host:port`). C5 speaks Basic proxy authentication only. |
| `… answered CONNECT with 403 …` | The proxy's policy does not allow that host. Ask for it to be allowed. |
| `… answered CONNECT with 502` (or `503`, `504`) | The proxy could not reach the host itself. |
| `Mothership TLS public-key pin mismatch …` | Something between you and the platform re-signs TLS. If that is your inspecting proxy, follow [Behind a TLS-inspecting proxy](/c5/configuration/network#behind-a-tls-inspecting-proxy). |
| A certificate error | Add your proxy's root certificate to the CA bundle. |

`growther update` still runs when C5 is set to **Offline**; only the background update
check stops. See [What Offline stops](#what-offline-stops) below.

### `growther rollback`

Puts back the version you had before an update.

```bash
growther rollback
```

It prints `✓ Rolled back from <version> to <older version>. Restart C5 to apply.`
and then restarts C5 the same way `growther update` does (see above).

Rollback also puts back the `THIRD-PARTY-NOTICES.txt` beside the program that matches
the version it restores, where there is one.

Before it swaps anything, rollback checks the kept older program twice: that it is
still exactly the file the update kept (C5 records its SHA-256 beside it, as
`<program>.prev.sha256`, with a `# version <version>` line naming the version kept), and
that it runs and reports its version. If either check fails — for example because the copy
was damaged after it was kept — rollback stops, says so
(`… nothing was replaced; C5 stays on v<version>`, naming the record file when the
checksum is the problem), and replaces nothing.

Two cases are told apart by that version line:

- **The record is out of date.** An older version of C5 may have updated again and replaced
  the kept copy without touching the record. If the copy reports a different version from the
  one recorded, rollback accepts it on the start check alone, and says so:

  ```text
    The checksum recorded beside <program>.prev describes v<recorded>, not the v<kept> an older update kept there since; it was checked by starting it instead.
  ```

- **The copy is damaged.** If it reports the recorded version but does not match, rollback
  refuses.

A record with no version line (written by an older version of C5) keeps the strict rule:
any mismatch is refused. A copy kept by an older version of C5 with no record at all is
checked by starting it.

Rollback also puts back the signed build record (`build_manifest.json`) that matches the
version it restores. If the install had none before the update, it leaves none, so
`growther verify` does not judge the older program against the newer release's record.

If you have moved secrets out of `c5.yaml` into the system keystore with
`growther secrets migrate` (see [Secrets and keys](/c5/security/secrets-and-keys)), C5
checks them before it swaps, because an older version may not be able to read the
keystore:

- **Only API keys are in the keystore.** Rollback goes ahead, with a `⚠` warning that
  the providers using those keys will fail to authenticate on the older version.
- **Your licence is in the keystore.** An older version would not start at all, so C5
  refuses to roll back and tells you to run `growther secrets revert` first.
  `growther rollback --force` (or `GROWTHER_ROLLBACK_FORCE=1`) rolls back anyway; use
  it only if you know the version you are going back to can read the keystore.

If there is no earlier version kept, it says "no previous version to roll back to" and
exits with code `1`.

### `growther doctor`

Checks your whole setup and tells you what is wrong in plain words. This is the first
thing to run when something is not working.

```bash
growther doctor
```

See [Running doctor](/c5/cli/doctor) for what it checks.

`growther doctor --json` prints one machine-readable report and nothing else on standard
output, so `growther doctor --json | jq .` always works; any other line goes to standard
error. It also writes `doctor-status.json` into the C5 folder for device-management tools.
`--strict` also fails on warnings. See
[Running doctor](/c5/cli/doctor#for-scripts-and-device-management) for what the report
contains.

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

`break` refuses while a C5 on this machine is still running and holding the lock: stop
it first with `growther stop`.

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

The name a passkey is tied to is called its RP ID, which is where `migrate-rpid` gets
its name. `migrate-rpid` opens a dual-name enrolment window: passkeys already enrolled keep working on
the old address while people re-enrol on the new one, at their own pace. `finish` closes it,
and passkeys still on the old name stop working from that point — run it once
`growther webauthn status` shows nothing left there.

It refuses while the only administrator credential is a passkey, because changing the name
would then leave nobody able to sign in; enrol a second administrator with a password or PIN,
or set up single sign-on first. It also refuses a name the browser would not accept for your sign-in addresses: the new
name must be the address itself or a parent domain of it, such as `contoso.com` for
`c5.contoso.com`, and it cannot be a suffix anyone can register under, such as `co.uk`.
Otherwise the browser would reject every sign-in afterwards. There is no `--force`.

Both changing commands ask for confirmation; `--yes` skips it and `--json` prints a machine
report. Run them on the machine that hosts C5, as the account that runs C5. The change takes
effect without a restart.

## The models C5 downloads

Three features use models that run on your own machine. C5 downloads each one once, from
Hugging Face, and checks its exact size and SHA-256 before using it. Each model is
*pinned*: C5 accepts only one exact published version of it, identified by that size and
SHA-256, so a model changed at the source is refused rather than used. Three commands let you do the same from a terminal — useful on a server nobody
opens a browser on, before you take a laptop somewhere without signal, or when the
automatic download has been turned off.

| Command | Model | Size | Used by |
| --- | --- | --- | --- |
| `growther qmd-run pull` | Three memory-search models: embedding, reranking and query expansion | about 2.3 GB in all | [Memory search](/c5/tools/memory-search) |
| `growther voice pull` | Whisper `base.en`, English | about 60 MB | [Voice](/c5/using-c5/voice) |
| `growther classifier pull` | `decider-0.8b`, the local classifier | about 812 MB | [Local classifier](/c5/tools/local-classifier) |

What the three pull commands have in common:

- **They go through your proxy.** Each one uses the proxy and certificate authority bundle
  configured for C5, exactly as the running server does.
- **They are refused when C5 is set to Offline** (see
  [What Offline stops](#what-offline-stops)). Each one then tells you how to place the
  file by hand instead. `classifier pull` and `voice pull` print the address to fetch it
  from on a connected machine, where to put it, and the SHA-256 to check. `qmd-run pull`
  names the missing files and points you to `<cache root>/qmd/README.md`, which lists
  each file's address, size and SHA-256. You may also see the line
  `[posture] offline — … skipped; this deployment makes no outbound contact`.
- **They ignore the automatic-download switches** `GROWTHER_QMD_NO_AUTO_DOWNLOAD`,
  `GROWTHER_VOICE_NO_AUTO_DOWNLOAD` and `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD`. Those
  switches turn off only the downloads C5 starts on its own. Running `pull` is how you
  ask for the model when the switch is set. See [Environment variables](/c5/cli/environment).
- **The large ones resume.** An interrupted memory-search or classifier download leaves a
  `.partial` file beside the model, and the next attempt continues from it. The 60 MB
  speech model starts again from the beginning.
- **Only one download of a model runs at a time.** If a running C5 (or another terminal)
  is already downloading the same model, the command says so and stops; the model is
  used once that download finishes. If an earlier download was cut off by a crash or a
  restart, it does not block the next one.
- **They never load an unchecked file.** A model is used only after it passes the size
  and SHA-256 check. What happens to a wrong file at the model's name differs:
  - **Memory search and offline speech** rename it to `<file>.rejected` and keep it, and
    never download over it.
  - **The local classifier** never loads it, and the next verified download **replaces**
    it. If you want to keep that file, move it away before you run
    `growther classifier pull`. A symbolic link at the model's path is never downloaded
    over: `classifier pull` refuses instead, and says what to do.

All three models live under the cache root — your C5 folder unless you moved it. See
[`growther cache`](#growther-cache) below.

### What Offline stops

C5's **Offline** network setting (the *egress posture*, see
[Network and egress](/c5/configuration/network#turn-off-every-outbound-connection)) stops
everything C5 contacts on its own. For the commands on this page the rule is:

| Still contacts the internet when Offline | Refused when Offline |
| --- | --- |
| `growther update` and `growther update --check` | `growther qmd-run pull` |
| The **Mothership** check in `growther doctor` | `growther voice pull` |
| | `growther classifier pull` |
| | The **Proxy reachability** check in `growther doctor` (skipped) |

The left column is about C5 itself: checking for a new version and installing it. It
runs because you typed it. The model downloads in the right column are refused even when
you type them, because Offline promises that this install fetches no models; each one
tells you how to place the file by hand instead.

### `growther qmd-run`

The engine behind memory search. Two things you might want to do by hand:

```bash
growther qmd-run pull     # fetch any missing model (about 2.3 GB for all three)
growther qmd-run doctor   # report on those models and the search index
```

C5 fetches the models by itself the first time it starts, so most people never need
`pull`.

`pull` checks every model file already on disk, then downloads only the ones that are
missing. For each it prints a line naming the model, its size and the published version
it is pinned to, then its progress in 10% steps from where it starts (`0%` for a new
download, further on for one it resumes):

```text
Downloading the embedding model (~334 MB, pinned at 0f741b5a, sha256-checked) to <path>…
  0%
  10%
  20%
  …
✓ embedding downloaded and checked — <path>
```

A model that is already there and correct is reported as `✓ <role> present and checked`.

A file at a model's name that is **not** the model this C5 version expects is renamed
beside itself to `<file>.rejected`, never deleted, and the correct file is fetched in
its place. If that file changed within the last minute (a copy may still be arriving),
it is left where it is and `pull` refuses with "C5 never fetches over a file; move it
away and run this again".

When all three are in place it ends with "QMD uses them the next time it loads a model;
restart C5 if a query still reports one missing."

`pull` takes no options. It exits with `0` when all three models are present and
checked afterwards, and `1` otherwise. When something is still missing it says which,
and that running it again resumes the download. `<cache root>/qmd/README.md` lists each
file's address, size and SHA-256 if you would rather place them by hand.

`growther qmd-run doctor` is not the same as `growther doctor`. The first reports on
memory search; the second checks C5 as a whole. A `qmd-run` command that loads a model
checks the file first, and does not start the engine on one that fails the check.

See [Memory search](/c5/tools/memory-search) for what these models do and how to install
them on a machine with no internet.

### `growther voice`

The offline speech engine.

```bash
growther voice status    # is the engine usable here, and is the model downloaded?
growther voice pull      # fetch the model (about 60 MB, English)
```

`status` (also what `growther voice` does on its own) gives two answers, because they
have different fixes:

- `✓ speech engine loadable on this platform`, or `✗ speech engine unavailable — …`.
  The engine is part of the C5 program, so this one is fixed by an update, not a
  download.
- `✓ offline speech model present and checked — <path>`, or
  `✗ offline speech model not downloaded (run growther voice pull)`.

If the file at the model's path is not the model, `status` sets it aside as
`ggml-base.en-q5_1.bin.rejected` (nothing is deleted) and reports the model as not
downloaded. `status` exits with `1` unless both answers are yes.

`pull` prints `Downloading the offline speech model (~60 MB, pinned and sha256-checked)…`,
progress in 5% steps starting at `0%`, then `✓ downloaded and checked — <path>`. It exits with `1` on any
failure. A wrong file at the model's path is set aside first, as `status` does. If it
cannot be set aside — or it changed within the last minute, so a copy may still be
arriving — `pull` refuses rather than download over it: move that file away and run it
again.

You do not need to switch the built-in voice engine on in Settings to run `pull`. See
[Voice](/c5/using-c5/voice).

### `growther classifier`

The local classifier is on by default. These two commands only check and fetch its
model. To turn the classifier off or delete its model, go to **Settings › Learning**
(see [Local classifier](/c5/tools/local-classifier#turn-the-classifier-off)).

```bash
growther classifier status   # can this machine run it, and is the model verified?
growther classifier pull     # fetch the model now (about 812 MB)
```

**`status`** answers two questions and then names the model:

```text
✓ supported on Mac Studio (darwin-arm64): Apple M4 Max, 16 cores (12 performance and 4 efficiency), 64 GB memory
  GPU: Metal, unless a local model (LM Studio, llama.cpp, Ollama, Inferencer) is configured — then CPU
✓ model present and verified — /Users/you/.growther/classifier/models/decider-0.8b.Q8_0.gguf
  decider-0.8b-q8_0, 812 MB, context 4096
  sha256 2665d08c1052b4e01dabcb08771d25579f6776f7066355e4a0ccc5f74e32d4a2
```

The first line says whether this machine can run the classifier, and describes it as your
operating system does: the machine's name where it gives one, the platform, the processor,
the physical cores (by kind, where the processor has more than one kind) and the memory.
Each part the system does not give is left out. More examples:

```text
✓ supported on Dell XPS 15 9520 (win32-x64): 12th Gen Intel Core i9-12900HK, 14 cores, 64 GB memory
✓ supported on linux-x64: AMD Ryzen 9 7950X, 16 cores, 31.1 GB usable memory
✓ supported on Lenovo ThinkPad T14s Gen 4 (win32-x64): AMD Ryzen 7 7840U w/ Radeon 780M Graphics, 8 cores, 32 GB memory (29.8 GB usable)
```

Memory is given in the gigabytes your operating system shows (binary gigabytes), so a 64 GB
Mac shows 64. On Linux, where installed memory needs the administrator account to read, the
line gives what the system can use and says _usable_. Where the system can use at least half
a gigabyte less than is installed, both are given. The 8 GB floor is checked against the
memory the system can **use**, rounded to the nearest whole gigabyte, so 7.5 GB or more
passes. Most machines sold with 8 GB report 7.6 to 7.9 GB usable and qualify; one that keeps
more for its built-in graphics (7.4 GB usable) does not. Reading the machine's details can take
a few seconds the first time on Windows.

The second line says where the classifier runs. On Apple silicon it reads as above: if you
also run a local model server such as LM Studio or Ollama, the classifier uses the CPU so the
two do not compete for the GPU. (This command cannot see which model servers are configured,
so it says both; **Settings › Learning** says which applies.) Elsewhere it gives the reason and
the thread count, for example
`CPU: GPU acceleration is only used on Apple silicon (this is linux-x64). It uses 8 CPU threads.`
You do not need to do anything.

When the machine cannot run the classifier, the first line starts `✗ not available:` and
says why, for example:

| Reason | What it means |
| --- | --- |
| `This machine has 5.8 GB of memory; the classifier needs at least 8 GB.` | Not enough memory. |
| `No local classifier build ships for <platform>.` | Supported: macOS (Apple silicon and Intel), Linux x64, Windows x64 and Arm64. |
| `C5's release for linux-arm64 is experimental, so the classifier is not offered there.` | Linux on Arm. |
| `… needs macOS <version> or later; this machine has macOS <version> …` | The classifier's runtime needs a newer macOS than C5 itself does. |
| `… needs glibc <version> or later …` or `… needs a libstdc++ with GLIBCXX_<version> or later …` | The Linux system libraries are too old for the classifier's runtime. |
| `… needs the Microsoft Visual C++ 2015-2022 Redistributable (x64) …` (or `(arm64)` on Windows on Arm) | Windows is missing that runtime. The line names the missing files and the Microsoft download link for your processor; install it and restart C5. |

The model line says one of:

- `✓ model present and verified` — ready.
- `✗ model not downloaded` — run `growther classifier pull`, or place the file at the
  path shown.
- `✗ <path> is not the pinned model (wrong size)` (or `sha256 mismatch`, or
  `unreadable`) — this file is never loaded. The line ends
  `` `growther classifier pull` replaces it ``, which is true of a file but not of a symbolic
  link: for a link, pull refuses, so point the link at the model or remove it.
- `✗ <path> is a link whose file cannot be reached (a share that is not mounted?); it is
  used once it can be, and never downloaded over` — the model's path is a symbolic link and
  the file it points to is not there right now. Mount the share, or remove the link to have
  C5 fetch the model.

Checking the SHA-256 reads all 812 MB the first time, so it can take a moment. The result
is remembered in `decider-0.8b.Q8_0.gguf.verified.json` beside the model, so later checks
are instant until the file changes. `status` exits with `0` only when the machine is
supported **and** the model is verified, otherwise `1`.

**`pull`** first prints the model's licence notice, then downloads:

```text
decider-0.8b by Mapika (Apache-2.0), fine-tuned from Qwen3.5-0.8B-Base (Apache-2.0) …
Downloading decider-0.8b-q8_0 (~812 MB) to <path>…
  0%
  5%
  10%
  …
✓ downloaded and verified — <path>
While the classifier is on, a running C5 starts using the model when Settings › Learning is next opened, or when C5 next starts. …
```

The `Downloading …` line appears only once the first bytes arrive. A pull that is refused
(Offline, a policy, another download, a link) or finds the model already in place prints the
notice and then its result, with no `Downloading` line before it. Progress is printed
in 5% steps from where the download starts; a resumed download starts at its own percentage.

You do not need to restart C5 afterwards. While the classifier is on, a running C5 picks
up the new model the next time **Settings › Learning** is opened, or at its next start.

It works whether the classifier is switched on or off, and it does not check whether
this machine can run the model — run `status` first. It refuses, and exits with `1`,
when:

- C5 is set to **Offline** (it prints how to place the model by hand instead);
- your organisation's policy locks the classifier off, whether that policy comes from
  the operating system's policy store or from a signed policy document
  ("Your organisation's policy keeps the local classifier off, so its model is not
  downloaded.");
- another C5 process is already downloading it;
- the model's path is a symbolic link whose file cannot be reached, or a link to a file
  that is not the model — C5 never downloads over a link (the message says to make the file
  reachable, point the link at the model, or remove it);
- the download fails, or the disk fills up — the message says which, and how to place
  the file by hand. A network failure gives its cause directly:
  `✗ Could not download the classifier model: <the cause>. Fetch … and place it at … (sha256 …).`
  The cause is the proxy's answer, a certificate C5 does not trust, a refused connection,
  or a proxy setting C5 cannot use (see
  [When the proxy says no](/c5/configuration/network#when-the-proxy-says-no)).

A file of the wrong size or content already at the model's path is replaced by the
verified download. Move it away first if you want to keep it.

See [Local classifier](/c5/tools/local-classifier) for what the classifier does, how to
turn it off and how to delete its model. See
[Network and egress](/c5/configuration/network) for the hosts the downloads reach, and
[Managed configuration](/c5/configuration/enterprise-policy) for the `classifier_enabled`
policy key.

### `growther licenses`

C5 includes open-source software, fonts and native libraries, and downloads the models
above. Their licences ask that their notices go with every copy. This prints them all:
every package, component and model, each with its licence text.

```bash
growther licenses                 # the whole file (about 1.5 MB of text)
growther licenses --summary       # the counts, and where the file is
growther licenses | less          # read it page by page
growther licenses > THIRD-PARTY-NOTICES.txt
```

The output is a byte-for-byte copy of the notices built into the program, so it is safe
to pipe or redirect. `--summary` prints one line of counts — npm packages (and how many
of those belong to memory search), native and runtime components, and downloaded models
— followed by where to find the file. In a release build the file is built into the
program; `--summary` says so and names the copy installed beside the program, if there
is one.

On **Windows PowerShell** (version 5.1, the one built into Windows), `>` saves the file as
UTF-16 rather than as the UTF-8 the notices are written in. Save it from Command Prompt
instead, or run `cmd /c "growther licenses > THIRD-PARTY-NOTICES.txt"`. The MSI
installer already puts a UTF-8 copy beside `growther.exe`.

The same notices are in the app under **About › Copyright & Legal**, and every download
carries `THIRD-PARTY-NOTICES.txt` beside the program. See
[Open-source licences and downloaded models](/c5/security/open-source-and-models) for
what the notices list and whose terms govern each model.

It exits with `1`, and says so, if the program carries no notices (only possible in a
build made from source without generating them) or if you pass an option other than
`--summary`.

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

| You see                         | What it means                                         |
| ------------------------------- | ----------------------------------------------------- |
| ✓ signature is valid            | The record of how this was built really came from us. |
| ✓ contents match                | The file has not been changed since we built it.      |
| ✗ has been altered              | Do not run it. Download it again from growther.si.    |
| ✗ signature is INVALID          | Do not run it. Download it again from growther.si.    |
| ? unsigned / no key / no record | Cannot tell either way — see below.                   |
| ? this is a release archive     | Extract it, then verify the program inside.           |

A **?** is not a pass. It means the check could not be completed — usually because you
are running a development build, because the file has no build record next to it, or
because you pointed it at a downloaded `.tar.gz`/`.zip` rather than the program itself.
Treat it as "unknown", not "fine".

Checking a downloaded archive tells you its build record is genuine but says nothing
about the bytes inside it, so extract it first and verify the program:

```bash
tar -xzf growther-c5-macos-arm64-node24.tar.gz
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

The downloaded models and caches, which are usually what filled your disk. None of it is
your data, and none of it is backed up.

```bash
growther cache show                              # where the five folders live, and their size
growther cache relocate --to /Volumes/Big/c5     # move all five to another local disk
growther cache relocate --to /Volumes/Big/c5 --dry-run   # show what would move, move nothing
```

The five folders, all under the cache root:

| Folder | What is in it |
| --- | --- |
| `qmd/` | The memory-search engine and its three models (about 2.3 GB) |
| `speech/` | The offline speech model (about 60 MB) |
| `classifier/` | The local classifier's model (about 812 MB) |
| `cache/` | Other regenerable caches |
| `lib/` | Native libraries C5 unpacks for itself, such as OpenSSL 1.1 on Linux |

`show` prints the cache root, what decided it (`GROWTHER_CACHE_DIR`, or how the home was
resolved), the pointer file that records a move, and each folder's size. The size of `qmd/`
leaves out `qmd/model-view/`, which can hold C5's own checked copies of the memory-search
models (up to about 2.3 GB) on a disk that cannot clone files.

`relocate` copies all five folders (not memory search's `qmd/model-view/`, which C5
rebuilds at its next start — its `checked/` copies of the memory-search models included, see
[Memory search](/c5/tools/memory-search#where-they-go)), checks that each copied folder holds the same number
of files and the same number of bytes as the original, records the new location in the
home pointer, and only then deletes the originals. It asks first; on a terminal that
cannot answer (a script, a pipe) you must add `--yes`. Then start C5 again to use the new
location. `growther cache relocate /Volumes/Big/c5` (without `--to`) works too.

It refuses, and changes nothing, when:

- C5 is running — run `growther stop` first, because a running C5 keeps using the old
  location whatever the pointer says;
- `GROWTHER_CACHE_DIR` is set, because that variable outranks the pointer, so the move
  would be ignored — change the variable instead;
- the target is not a local or removable disk: a network folder, a synced folder, a
  roaming profile, or a disk C5 cannot recognise. The cache holds programs C5 loads and
  models it reads directly, so it must be on a local disk;
- the target is the current cache root, is inside it, or contains it;
- the target cannot be written to;
- one of the five folders at the target already holds files — move or remove them
  first, because C5 will not merge into a folder it cannot vouch for;
- a classifier, memory-search or offline speech model download is in progress — let
  `growther classifier pull`, `growther qmd-run pull` or `growther voice pull` (or the
  running C5) finish first.

If your organisation's policy sets the cache location, do not use `relocate`: the policy
location wins at the next start, so C5 would ignore the move and download the models
again where the policy says. Ask whoever manages the policy to change it instead.

**Can I just delete these folders?** Yes, with C5 stopped. C5 downloads a model again the
next time it needs it, unless the automatic download is turned off or C5 is set to
Offline. For the classifier's model there is a better way: an administrator at the
machine can delete it in **Settings › Learning**, which also works while the classifier
is off.

`show` exits with `0`. `relocate` exits with `0` once the move is done, and `1` when it
refuses, fails or you cancel. `growther cache` exits with `2` when `relocate` is given no
target, or the subcommand is not `show` or `relocate`.

### `growther secrets` and `growther restore`

```bash
growther secrets status                # what is stored where, and what is still in the clear
growther secrets migrate               # move API keys out of the config file into a keystore
growther secrets revert                # move them back into the config file
growther restore --from <backup>       # restore from an encrypted backup
```

`revert` copies the secrets back into `c5.yaml` in plain text and removes them from the
keystore. You need it before rolling back to a version older than the keystore support
(see [`growther rollback`](#growther-rollback)). `migrate` and `revert` both ask before
they change anything; `--yes` skips the question. See
[Secrets and keys](/c5/security/secrets-and-keys).

### `growther evidence`

Export the audit record for an auditor or a legal hold. See
[Audit trail](/c5/security/audit-trail).

```bash
growther evidence export --from 2026-07-01 --to 2026-07-31
growther evidence export --from 2026-07-01 --to 2026-07-31 --out /mnt/evidence/july.tar.gz
```

It exits with `0` when the bundle is written and every day's audit chain checks out, `1`
when the bundle is written but a chain is broken or a part is missing, and `2` when the
request is refused (for example, a missing `--from` or `--to`).

### `growther qmd-mcp`

C5 runs this itself, to give agents memory search as an MCP tool. You do not need to run
it by hand, and it prints nothing useful in a terminal: it waits for MCP messages on its
input.

### `growther login` and `growther reset-auth`

```bash
growther login                 # sign in from the command line, for a host with no browser
growther reset-auth <user>     # clear a user's credentials so they can enrol again
```

`reset-auth` is the way back in when somebody has lost the device holding their passkey.

### `growther connect`

Reaches a C5 running on another machine over an SSH connection you already have. It forwards
a local port over SSH and opens C5 in your browser at `http://localhost:4399`. Nothing is
published, no certificate is involved, and no pairing is needed: you sign in as you would at
that machine, over a channel your SSH already secures.

```bash
growther connect user@host
```

Leave it running; press Ctrl+C to close the forward.

- `--local-port N` picks another local port. `4399` is the default on purpose: it is not the
  port a C5 on _this_ machine serves on, so the forward cannot land on the wrong C5.
- `--remote-port N` if the far C5 is not on `4299`.

`growther connect` checks that the two ends really are different machines and refuses if the
forward has looped back to the C5 you started from.

### `growther remote`

Two read-only commands for a machine with no browser:

```bash
growther remote status     # whether Remote Control is on, the name it publishes, how many devices are paired
growther remote devices    # each paired device: its label, when it was added, when it was last seen
```

Neither can turn Remote Control on or off or revoke a device. Those need the running server
to take effect immediately, so they live only in **Settings › Remote Control** on the machine
— see [Managing devices](/c5/remote-control/managing-devices).

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

## Exit codes for scripts

Every command exits with `0` when it did what you asked. For the commands you are most
likely to script:

| Command | `0` | `1` | `2` |
| --- | --- | --- | --- |
| `growther doctor` | Healthy | A check failed (or, with `--strict`, warned) | — |
| `growther verify` | Verified | Failed or altered | Could not be checked |
| `growther classifier status` | Supported and model verified | Either is not so | — |
| `growther classifier pull` | Model present and verified | Refused or failed | — |
| `growther voice status` | Engine loadable and model checked | Either is not so | — |
| `growther voice pull` | Model present and checked | Refused or failed | — |
| `growther qmd-run pull` | All three models present and checked | Anything still missing, or refused | — |
| `growther licenses` | Printed | No notices in this build, or an unknown option | — |
| `growther cache relocate` | Moved (or `--dry-run` done) | Refused, cancelled or failed | Target missing, or unknown subcommand |
| `growther evidence export` | Written, every chain verified | Written, but a chain is broken or a part missing | Refused |
| `growther stop` | Stopped, or was not running | Still shutting down after 10 seconds | — |
| An unknown command | — | Always | — |

## Next steps

- [Environment variables](/c5/cli/environment) — change ports, folders, channels and
  downloads.
- [Running doctor](/c5/cli/doctor) — check your setup.
- [Local classifier](/c5/tools/local-classifier) — what it does, how to turn it off, and
  how to delete its model.
- [Open-source licences and downloaded models](/c5/security/open-source-and-models) — the
  notices `growther licenses` prints, and the terms of each model.
