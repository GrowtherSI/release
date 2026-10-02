---
title: Environment variables
description: Change where C5 stores data, which port it uses, which releases it gets, which models it downloads on its own, and which libvips it runs on.
order: 2
---

# Environment variables

Environment variables let you change how C5 behaves without editing any files. You set
them before the command, like this:

```bash
PORT=5000 growther
```

Or you can set them for your whole terminal session:

```bash
export PORT=5000
growther
```

If C5 starts on its own at sign-in, a variable you set in a terminal does not reach it.
See [When C5 starts at sign-in](#when-c5-starts-at-sign-in) below.

## The variables

**Where things live**

| Variable                   | What it does                                    | Default                  |
| -------------------------- | ----------------------------------------------- | ------------------------ |
| `GROWTHER_HOME`            | Where C5 keeps all your data.                   | `~/.growther`            |
| `GROWTHER_DATA_DIR`        | Where the databases live. Must be a local disk. | `<home>/data`            |
| `GROWTHER_SECRETS_DIR`     | Where the device key set lives. Local only.     | `<home>/config`          |
| `GROWTHER_CACHE_DIR`       | Where downloaded models and caches live.        | `<home>`                 |

**Running and updating**

| Variable                   | What it does                                                        | Default  |
| -------------------------- | ------------------------------------------------------------------- | -------- |
| `PORT`                     | Which port the C5 server listens on.                                | `4299`   |
| `GROWTHER_CHANNEL`         | Which releases you get: `stable`, `beta`, or `dev`.                 | `stable` |
| `GROWTHER_NO_SELF_INSTALL` | Set to `1` to run the program where it sits.                        | off      |
| `GROWTHER_NO_MODIFY_PATH`  | Set to `1` so C5 never edits your shell files.                      | off      |
| `GROWTHER_UPDATE_RESTART`  | Set to exactly `0` so C5 does not restart after an update. See [`growther update`](/c5/cli/commands#growther-update). | restarts the service, if one runs this copy |
| `GROWTHER_ROLLBACK_FORCE`  | Set to `1` to roll back past the keystore check, like `--force`.    | off      |

**Model downloads**

| Variable                               | What it does                                                     | Default |
| -------------------------------------- | ---------------------------------------------------------------- | ------- |
| `GROWTHER_QMD_NO_AUTO_DOWNLOAD`        | Set to `1` so C5 never downloads the memory-search models on its own. | off |
| `GROWTHER_VOICE_NO_AUTO_DOWNLOAD`      | Set to `1` so C5 never downloads the offline speech model on its own. | off |
| `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD` | Set to `1` so C5 never downloads the local classifier's model on its own. | off |

**Network**

| Variable                      | What it does                                                    |
| ----------------------------- | --------------------------------------------------------------- |
| `GROWTHER_PROXY_URL`          | The HTTP(S) proxy for every outbound connection.                |
| `GROWTHER_NO_PROXY`           | Hosts, domain suffixes and IPv4 ranges that skip the proxy.     |
| `GROWTHER_CA_BUNDLE`          | A PEM file of extra certificate authorities.                    |
| `GROWTHER_MOTHERSHIP_TLS_PIN` | `on` or `off`: whether the platform connection pins its certificate. |

These four are explained in [Network and egress](/c5/configuration/network). C5 does
**not** read `HTTPS_PROXY`, `HTTP_PROXY` or `NO_PROXY`; set `GROWTHER_PROXY_URL` to the
same value if that is the proxy you want.

**Image library**

| Variable               | What it does                                                         |
| ---------------------- | -------------------------------------------------------------------- |
| `GROWTHER_LIBVIPS_DIR` | Run C5 on your own copy of libvips instead of the one it ships with. |

## Common things people do

### Use a different port

If something else on your computer already uses port 4299:

```bash
PORT=5000 growther
```

### Keep your data somewhere else

Handy if you want your C5 data on an external drive, or you want two separate setups
that do not share anything:

```bash
GROWTHER_HOME=/Volumes/Work/growther growther
```

> **Warning**
> Each data folder is its own separate world. Chats, tasks, and settings in one folder
> are not visible from another.

### Put the downloaded models on another disk

The models C5 downloads take about 3.1 GB in all if you use every feature. They are not
your data and are never backed up, so they can live on a bigger, slower disk:

```bash
GROWTHER_CACHE_DIR=/Volumes/Big/c5-cache growther
```

C5 decides where the cache lives in this order, and the first answer wins:

1. A `cacheDir` set by your organisation's policy.
2. `GROWTHER_CACHE_DIR`.
3. The location recorded by `growther cache relocate`.
4. Your C5 folder.

For a permanent move, `growther cache relocate --to <folder>` is usually better: it moves
what is already downloaded and records the location for you. It refuses while
`GROWTHER_CACHE_DIR` is set, because the variable would win anyway. See
[`growther cache`](/c5/cli/commands#growther-cache).

Point `GROWTHER_CACHE_DIR` at a local disk: the cache holds programs C5 loads and models
it reads directly, and a network share that drops out takes them with it. The variable is
read once, when C5 starts, and only from the environment C5 starts in — never from
`c5.yaml`.

### Stop C5 downloading models on its own

Three features use models that run on your machine, and C5 downloads each one once, the
first time it is needed:

| Feature | Download | When C5 downloads it on its own |
| --- | --- | --- |
| Memory search | about 2.3 GB | At start, for any of the three models that has no file yet |
| Offline speech | about 60 MB | At start, while the built-in voice engine is switched on and the model is missing |
| Local classifier | about 812 MB | At start while the classifier is on, and when someone switches it on in **Settings › Learning** |

To stop the automatic download of one of them, set its variable to `1`:

```bash
GROWTHER_QMD_NO_AUTO_DOWNLOAD=1
GROWTHER_VOICE_NO_AUTO_DOWNLOAD=1
GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1
```

Only the value `1` counts. `0`, `true`, `yes` or an empty value leave the download on.
Spaces around the `1` are ignored.

What each one does and does not do:

- It stops only the download C5 starts **on its own**. The matching command still
  downloads when you run it: `growther qmd-run pull`, `growther voice pull` or
  `growther classifier pull`. That is the point — the variable is how you say "only when
  someone asks".
- It does not switch the feature off. Memory search's semantic queries, offline speech
  and the local classifier simply wait until the model is there. You can also place the
  file by hand; C5 checks it and uses it.
- C5 reads the variable when it would start an automatic download — at start, and for
  the classifier also when someone switches it on. Restart C5 after changing it.

You can set them in the environment C5 starts in, or as a custom key in `c5.yaml` (see
[Config files](/c5/configuration/config-files)).

Two other things stop every automatic download too:

- Setting C5 to **Offline** (the *egress posture*, see
  [Network and egress](/c5/configuration/network#turn-off-every-outbound-connection)).
  It also refuses the three `pull` commands.
- A `CI` variable with any non-empty value, even `false` or `0`. C5 never downloads models on
  its own on a build server.
  The `pull` commands still work there.

To keep the classifier from downloading anything at all across a fleet, **lock** the
managed policy key `classifier_enabled` to `false` instead. A locked `false` switches the
feature off and also refuses `growther classifier pull`. A *Recommended* (unlocked)
`false` is only a default: on a machine that has already run a C5 version with the
classifier, the switch is already on and outranks it, and it never refuses `pull`. See
[Managed configuration](/c5/configuration/enterprise-policy) and
[Local classifier](/c5/tools/local-classifier#for-administrators).

### Try early versions

```bash
GROWTHER_CHANNEL=beta growther update
```

Switch back with `GROWTHER_CHANNEL=stable growther update`.

### Keep C5 out of your shell files

Some people manage their PATH by hand and do not want any program editing their shell
setup:

```bash
GROWTHER_NO_MODIFY_PATH=1 growther
```

You will then need to add C5 to your PATH yourself.

### Run C5 on your own libvips

C5 processes images with sharp, which runs on a library called libvips. libvips and the
libraries built into it are licensed under the LGPL, which gives you the right to run C5
with a modified version of them. `GROWTHER_LIBVIPS_DIR` is how you do that.

**1. Lay out a folder** the way sharp's own `@img` folder is laid out, with your build
under these names:

```text
<folder>/sharp-<platform>/lib/sharp-<platform>-<sharp version>.node     the sharp binding
<folder>/sharp-libvips-<platform>/lib/libvips-cpp.<version>.dylib      macOS
<folder>/sharp-libvips-<platform>/lib/libvips-cpp.so.<version>         Linux
```

`<platform>` is, for example, `darwin-arm64`, `linux-x64` or `win32-x64`. On **Windows**
the libvips DLLs, and any other DLLs your libvips needs, go in the same folder as the
binding: `<folder>\sharp-win32-x64\lib\`.

Instead of that layout, the folder can hold a single `sharp-<platform>-<sharp version>.node`
that you built from sharp's source against your own libvips.

The exact file names for your copy of C5 — the sharp version and the libvips library
names — are in the libvips section of the third-party notices (`growther licenses`).
Your libvips must be at least the version that sharp release needs; C5 says so if it is
not.

**2. On macOS**, sign any library you change (an ad hoc signature is enough) and clear
the quarantine flag a download puts on files, or macOS refuses to load them:

```bash
codesign --force --sign - <folder>/sharp-libvips-darwin-arm64/lib/libvips-cpp.*.dylib
xattr -dr com.apple.quarantine <folder>
```

**3. Start C5 with the variable set:**

```bash
GROWTHER_LIBVIPS_DIR=/path/to/folder growther
```

The first time C5 processes an image it loads your copy and prints a line like this,
naming the files the system actually loaded:

```text
[sharp] using libvips <version> from GROWTHER_LIBVIPS_DIR: binding /path/to/folder/sharp-darwin-arm64/lib/sharp-darwin-arm64-<version>.node, library /path/to/folder/sharp-libvips-darwin-arm64/lib/libvips-cpp.<version>.dylib
```

`growther doctor` shows the same thing on its **libvips** line, when the variable is set
in the terminal you run it from.

**If your copy cannot be loaded**, C5 does not quietly fall back to its own. It logs the
reason once — for example that the folder is not a directory, that no binding for this
platform is in it, that the binding could not be loaded, or that your libvips is older
than sharp needs — and image features stay off. The message starts
`GROWTHER_LIBVIPS_DIR=<folder>:` and ends by saying that unsetting the variable restores
the copy bundled with C5. Fix the folder, or unset the variable, and restart C5.

Things to know:

- C5 decides which libvips to use the first time it needs one, and keeps that choice
  until it restarts. Change the variable, then restart C5.
- The variable is read **only** from the environment C5 is started in. A
  `GROWTHER_LIBVIPS_DIR` line in `c5.yaml` or in Settings is refused, because the
  variable makes C5 load native code.
- If C5 starts on its own at sign-in, set the variable where that start reads it — see
  the next section.

## When C5 starts at sign-in

When you have run `growther service install`, C5 is started by your operating system, not
by your terminal, so it never sees variables you `export` in a shell. C5 rewrites its own
start-up definition each time it starts, so put your variables where it leaves them alone:

**macOS (launchd).** Add the variable to `EnvironmentVariables` in
`~/Library/LaunchAgents/ai.growther.c5.plist`. C5 keeps `GROWTHER_LIBVIPS_DIR` there when
it rewrites that file:

```bash
plutil -replace EnvironmentVariables.GROWTHER_LIBVIPS_DIR -string /path/to/folder \
  ~/Library/LaunchAgents/ai.growther.c5.plist
```

Then sign out and back in, so launchd reads the changed file. Other variables you add
there are not kept when C5 rewrites the file.

**Linux (systemd).** Use a drop-in, which C5 never touches — it only rewrites the main
unit:

```bash
systemctl --user edit growther-c5
```

Add these lines in the editor that opens, save, then restart C5:

```ini
[Service]
Environment=GROWTHER_LIBVIPS_DIR=/path/to/folder
```

```bash
systemctl --user restart growther-c5
```

Without systemd, C5 starts from your desktop's autostart, which uses the environment your
desktop session starts in.

**Windows.** Make it a user environment variable, then sign out and back in:

```powershell
setx GROWTHER_LIBVIPS_DIR C:\path\to\folder
```

Both ways C5 starts at sign-in on Windows inherit user environment variables.

The Linux and Windows places work for the other variables on this page too. On macOS C5
keeps only `GROWTHER_LIBVIPS_DIR` across its rewrite, so for anything else use another
route: the three download switches can go in `c5.yaml` as custom keys, and the models'
location is better moved with `growther cache relocate`, which records it for every
start.

## What is in your data folder

Everything C5 knows lives in `GROWTHER_HOME` (by default `~/.growther`):

- Your chats, tasks, and their whole history
- Files your agents made
- Your settings and API keys — see [Config files](/c5/configuration/config-files)
- Backups

The databases are encrypted, and on macOS and Linux the key file lives in this same folder
— so a copy of the folder is a copy of everything, key included. See
[Local encryption](/c5/security/encryption) before you back it up anywhere shared.

**On Windows it is two folders.** Every install created since C5 2026.9 keeps configuration
under `%USERPROFILE%\.growther` and puts the databases and keys under
`%LOCALAPPDATA%\Growther\C5`, because `%LOCALAPPDATA%` does not travel with a roaming
profile — an encrypted database must never be carried to a machine without its key.

### The downloaded models

The cache root — your C5 folder, unless you moved it — holds what C5 downloads and unpacks.
None of it is your data, none of it is backed up, and all of it can be fetched again:

| Path under the cache root | What it is |
| --- | --- |
| `qmd/cache/qmd/models/` | The three memory-search models, about 2.3 GB |
| `qmd/README.md` | Each memory-search model's address, size and SHA-256, for placing them by hand |
| `speech/ggml-base.en-q5_1.bin` | The offline speech model, about 60 MB |
| `classifier/models/decider-0.8b.Q8_0.gguf` | The local classifier's model, about 812 MB |
| `classifier/runtime.json` | What the classifier process reads to find its model. C5 writes it only for a model that passed the check, and writes it again whenever the classifier starts, so it is safe to delete with C5 stopped |
| `cache/`, `lib/` | Other caches, and native libraries C5 unpacks for itself |

Next to a model you may see:

| File | What it means |
| --- | --- |
| `<model>.partial` | A download in progress or interrupted. For memory search and the classifier, the next attempt resumes it; the speech model starts again from the beginning |
| `<model>.partial.lock` | Marks which C5 process is downloading the model right now |
| `<model>.verified.json` | C5 has checked this file's size and SHA-256, and records the result so it does not read the whole file again |
| `<model>.rejected` (or `.rejected.1`, …) | A file that was at the model's name but is not the model. C5 renamed it so it is never loaded, and deleted nothing. Remove it once you no longer need it. (Memory search and offline speech only — a wrong classifier model is left in place, never loaded, and replaced by the next download) |

Run `growther cache show` to see where these are and how big they are, and
`growther home show` to see every path your install uses. See
[Where your data lives](/c5/configuration/data-location) for the full layout.

## Locations are decided once

`GROWTHER_HOME` and the three folders above are read when C5 starts and never change
while it runs. On a managed device an organisation policy wins over the environment;
otherwise the environment wins over the pointer file C5 writes when you move the home
from Settings. A service unit registered by an older version may still carry an old
`GROWTHER_HOME`; C5 prefers the pointer in that case and rewrites the unit at the next
start.

Databases are refused on a network folder, a mapped drive, a roaming profile or a synced
folder. `GROWTHER_ALLOW_REMOTE_DATA=1` lifts that only in development builds, never in a
released binary.
