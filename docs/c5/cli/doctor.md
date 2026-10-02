---
title: Running doctor
description: Have C5 check its own setup and tell you what is wrong.
order: 3
---

# Running doctor

`growther doctor` checks your setup and reports anything wrong, in plain words. It is
the first thing to try when something is not working.

```bash
growther doctor
```

You can run it whether C5 is running or not. It does not start C5.

## What doctor changes

Doctor is a check, not a repair. It never downloads a model, and it never moves or
deletes your files. On a computer where C5 has never run it says so and creates no
databases.

It does write a few things:

- **Its report**, as `doctor-status.json` in your C5 folder, every time it runs. On a
  computer where C5 has never run, doctor creates the C5 folder to hold it. Where it has
  permission it also writes a copy for device-management tools to
  `%ProgramData%\Growther\C5\status.json` (Windows),
  `/Library/Application Support/Growther/status.json` (macOS) or
  `/var/lib/growther/status.json` (Linux).
- **A check result beside a model file.** If the offline speech model has never been
  checked, doctor checks it and records the result in a small `.verified.json` file next
  to it, so the check is not repeated.
- **On Linux, a library C5 ships.** Like every start of C5, doctor first makes sure the
  OpenSSL 1.1 library the encrypted databases need is available, and may unpack the copy
  C5 ships into the `lib/` folder under the cache root.
- **Network requests.** The **Mothership** check asks the platform for the latest
  version. When a proxy is configured, doctor also asks a few hosts through it (see
  [Proxy reachability](#proxy-reachability)). When C5 is set to **Offline** (the
  *egress posture*, see
  [Network and egress](/c5/configuration/network#turn-off-every-outbound-connection)),
  the Mothership check still runs, because you ran doctor yourself, and the proxy check
  is skipped. See
  [What Offline stops](/c5/cli/commands#what-offline-stops) for the same rule across
  every command.

## What it checks

Doctor runs about forty checks, grouped below. Which ones appear depends on your install:
some appear only when there is something to say.

**Where your files are**

| Check | Looking for |
| --- | --- |
| **Data home** | Your data folder exists |
| **Home source** | How the location was decided: default, pointer, environment or policy |
| **Home resolution** | Anything odd about how the location was worked out (shown only then) |
| **Data dir filesystem** | The databases are on a local disk, not a share or a synced folder |
| **Secrets location** | Where the key set lives, and whether it is split from the home |
| **Config (c5.yaml)** | The config file is present. Missing, it warns: the licence seed lives there |
| **Databases** | How many of the four data files are present. "none yet" on a fresh install |
| **Backup target** | Where finished backups are copied, and when the last copy landed |
| **Lock host** | Who holds the single-instance lock, and whether it is this machine |

**This copy of C5**

| Check | Looking for |
| --- | --- |
| **Install** | The program is where it should be |
| **`growther` on PATH** | You can run `growther` from any shell, and it is this copy |
| **Build manifest** | The record of how this build was made is present |
| **Manifest signature** | That record really was signed by Growther.si |
| **Binary integrity** | The program file matches what was built |
| **OpenSSL 1.1 (SQLCipher)** | Linux: the library the encrypted databases need is available |
| **SOC2 change-mgmt** | Internal build and release change-control checks |

**Licence**

| Check | Looking for |
| --- | --- |
| **License** | This computer is activated, and how many days are left |
| **Seed validity** | The licence seed is authentic and unexpired |
| **Seed ↔ key binding** | The seed belongs to this machine's key |
| **Identity key** | The deployment identity key is present and readable |
| **Confirmed identity** | The machine identity matches what the lock and licence expect |
| **Last key mint** | When a key was last issued |
| **Retired key on disk** | A superseded key that should have been shredded |

**Network**

| Check | Looking for |
| --- | --- |
| **Mothership** | C5 can reach the platform and read the latest version |
| **Platform URL** | Which platform address this install is pointed at |
| **Control-plane hosts** | The list of hosts C5 contacts on its own — the list for a firewall ticket |
| **Egress posture** | Online or offline, and whether a policy locked it. A posture locked by the device's own policy (Group Policy, macOS managed preferences or `/etc/growther`) wins over the value saved in Settings; doctor does not read a signed policy document — see [Details worth knowing](/c5/configuration/network#details-worth-knowing) |
| **Proxy reachability** | When a proxy is configured: whether it carries C5's traffic, host by host |
| **Served origin** | The address your browser opens C5 at is one where sign-in can work |
| **Network posture** | A risky way of exposing C5 to other machines (shown only then) |
| **Session host** | Whether this is a shared multi-session host, which C5 refuses to run on |

**Keys, accounts and records**

| Check | Looking for |
| --- | --- |
| **Managed install** | Whether this install expects a policy, and how many administrators it has |
| **Key custody** | Where the device key is kept: keystore, wrapped, or a file |
| **Escrow** | Whether the key set has been escrowed, so it can be recovered |
| **Plaintext secrets** | API keys still stored in the clear rather than in a keystore |
| **Credential-less** | Accounts that sign in with no password, passkey or PIN at all |
| **Audit sink** | The audit shipping destination, and whether events are piling up |
| **Legal hold** | Whether a legal hold is suspending audit pruning |

**Optional features**

| Check | Looking for |
| --- | --- |
| **Offline speech** | The offline speech model, and whether the engine can load it |
| **Local classifier** | Whether this machine can run the local classifier, and its model |
| **QMD semantic search** | Windows only: whether the Visual C++ runtime that memory search's semantic search needs is installed |
| **libvips** | Which image library C5 uses, when you have pointed it at your own |

> **Note**
> Doctor does **not** test your model providers or your integrations. Those are checked
> when you save them in Settings, which is also where a bad key is reported. See
> [Model providers](/c5/configuration/model-providers).

## Reading the output

Each check gets one line: a mark, the check's name, and what it found.

```text
  ✓ Local classifier     model verified — /Users/you/.growther/classifier/models/decider-0.8b.Q8_0.gguf
  ! Proxy reachability   proxy=http://proxy.example:8080 … — license.growther.si: no answer within 5000 ms. …
  ✗ Served origin        http://192.168.1.20:4299 is NOT a secure context — …
```

- **✓ OK** — nothing to do.
- **! Warning** — works, but something is not ideal.
- **✗ Failed** — this is broken, and doctor tells you how to fix it.

The last line sums up: `✓ healthy`, or `✗ 2 problem(s)`, followed by how many warnings
there were.

Work top to bottom. An early failure often causes the ones below it, so fixing the first
problem sometimes clears several at once.

### Exit codes

| Code | Meaning |
| --- | --- |
| `0` | No check failed. Warnings are allowed |
| `1` | At least one check failed — or, with `--strict`, at least one warned |

## For scripts and device management

```bash
growther doctor --json            # one JSON document on standard output
growther doctor --json --strict   # the same, and warnings count as failures
```

With `--json`, standard output carries the JSON document and nothing else, so you can
pipe it straight into `jq` or a detection script. Anything else C5 prints while doctor
runs — database messages, the `[sharp] using libvips …` line — goes to standard error.

The document has `schemaVersion` (currently `1`), `healthy` (`true` when the exit code
is `0`), the `failed` and `warned` counts, `strict`, `managedInstall`, `home`, `version`,
`platform`, the time it ran (`at`), every check as
`{ "label", "state", "detail" }` with `state` one of `ok`, `warn` or `fail`, and
`statusFiles`: the status files it managed to write.

## The model and library checks

These four report optional features. A feature you do not use, or a model that has not
arrived yet, never turns the report red.

Doctor does not check the memory-search models (about 2.3 GB). For those, run
`growther qmd-run doctor` to see their state, or `growther qmd-run pull` to check them and
fetch any that are missing. See [The models C5 downloads](/c5/cli/commands#the-models-c5-downloads).
On Windows, doctor does check the runtime those models need (see
[QMD semantic search](#qmd-semantic-search)).

### Local classifier

The local classifier is on by default and downloads its model (about 812 MB) once. Doctor
looks at the file and the record of its last check — it does not read all 812 MB itself.

| You see | What it means | What to do |
| --- | --- | --- |
| ✓ `not available here (optional): <reason>` | This machine cannot run the classifier, and C5 will not download its model. The reason says why: too little memory (it needs 8 GB), a platform it does not ship for, an operating system or system library too old for its runtime, or, on Windows, the Microsoft Visual C++ 2015-2022 Redistributable (x64, or arm64 on Windows on Arm) missing | Nothing, unless you want the classifier. For the Visual C++ runtime the line gives Microsoft's download link; install it and restart C5 |
| ✓ `model not downloaded yet — it is fetched while the classifier is on (Settings › Learning), or by growther classifier pull` | Normal on a new install, or while the download runs | Nothing. Run `growther classifier pull` if you want it now |
| ✓ `model not downloaded — this install's network posture is offline, so C5 never downloads it. Fetch … and place it at … (sha256 …)` | C5 is set to Offline | Place the file by hand, as the line says |
| ✓ `model not downloaded — GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1, so C5 does not fetch it on its own …` | Automatic download is turned off | Run `growther classifier pull`, or place the file by hand |
| ✓ `model verified — <path>` | Ready | Nothing |
| ✓ `model present, not yet verified — <path>` | The file is the right size but has not been checked yet | Nothing; C5 checks it before use. `growther classifier status` checks it now |
| ! `<path> is N bytes, not the pinned model's 811844032; it will not load` | A file that is not the model is at its path | `growther classifier pull` replaces it (on an Offline install, replace it by hand). If the path is a symbolic link, pull refuses: point the link at the model, or remove it |
| ! `could not be checked: …` | Doctor could not look | Run `growther classifier status` for more detail |

If the model's path is a symbolic link whose file cannot be reached (a share that is not
mounted, say), doctor reports it as not downloaded. Run `growther classifier status`, which
says so: C5 never downloads over a link, and uses the model once the file can be reached.

To turn the classifier off or delete its model, use **Settings › Learning** (see
[Local classifier](/c5/tools/local-classifier#turn-the-classifier-off)). Doctor reports
the model file whether the classifier is on or off.

### Offline speech

The offline speech model (about 60 MB) is only needed if you use the built-in voice engine.

| You see | What it means | What to do |
| --- | --- | --- |
| ✓ `not installed (optional) — growther voice pull fetches it, or place <address> (59,721,011 bytes, sha256 …) at <path>` | No model. Normal if you do not use offline voice | Nothing, or run `growther voice pull` |
| ✓ `ready — <path>` | The model file is in place and the engine loads | Nothing |
| ! `<path> is not the pinned model (<why>) — set aside or replace it …; it is never loaded` | A file that is not the model is at its path | Move it away, then run `growther voice pull` or place the right file |
| ! `<path> could not be read to check it against the pinned model, so it is not used` | The file exists but could not be read | Check its permissions |
| ✗ `the model is downloaded but the engine will not load on <platform>: …` | The model is fine but this copy of C5 cannot run the engine here | Update C5; if it persists, see [Getting help](/c5/troubleshooting/getting-help) |
| ! `could not be checked: …` | Doctor could not look | Run `growther voice status` for more detail |

If you keep the speech model on another disk and link to it from the model's path, run
`growther voice status` as well. It tells you when the link's target cannot be reached
(for example, a share that is not mounted), and doctor does not check for that.

Doctor looks for both models under the cache root, which is where C5 reads them — so a
cache you moved with `growther cache relocate` or `GROWTHER_CACHE_DIR` is checked where
it really is.

### QMD semantic search

Windows only. Memory search's semantic search (vector search, reranking and query expansion)
runs on llama.cpp, which needs the Microsoft Visual C++ 2015-2022 Redistributable. On macOS
and Linux this line does not appear.

| You see | What it means | What to do |
| --- | --- | --- |
| ✓ `the Visual C++ runtime its llama.cpp binding imports is present` | Semantic search can run | Nothing |
| ! `semantic search (vector search, reranking and query expansion: llama.cpp, …) needs the Microsoft Visual C++ 2015-2022 Redistributable (x64), which is not installed on this machine (… not found); keyword search and the document tools work without it. Install it from https://aka.ms/vs/17/release/vc_redist.x64.exe, then restart C5` | The runtime is missing. Memory search still works, but only by keyword | Install the redistributable from the link in the line (it names the x64 or arm64 one for your machine), then restart C5 |
| ! `could not be checked: …` | Doctor could not look | Run `growther doctor` again; if it persists, see [Getting help](/c5/troubleshooting/getting-help) |

### libvips

C5 uses libvips for image features. When you run `growther doctor`, you only see this
line when you have set `GROWTHER_LIBVIPS_DIR` to run C5 on your own copy (see
[Environment variables](/c5/cli/environment#run-c5-on-your-own-libvips)).

| You see | What it means |
| --- | --- |
| ✓ `your copy from GROWTHER_LIBVIPS_DIR=<dir>: binding <file>, library <file>` | Your copy loaded. The two paths are the files the system actually loaded. On a platform that does not report the library, the second path reads `(not reported by this platform)` |
| ! `override refused — <reason>` | Your copy could not be used, and why. While the variable is set, C5 does not fall back to its own copy: image features stay off until you fix it or unset the variable |
| ! `could not be checked: …` | Doctor could not run the check |
| ✓ `the copy bundled with C5` | Only in the doctor report inside an evidence export (`growther evidence export`) taken from a running C5 that uses its own libvips. A plain `growther doctor` never shows it |

Doctor checks the variable **as your terminal has it**, and the line ends with "(checked
in this shell's environment; C5 started at sign-in reads the variable from its service
definition)". If C5 starts on its own at sign-in, put the variable in its service
definition too, or the running C5 will not use your copy.

## The network checks

### Proxy reachability

When no proxy is configured, this line just describes the network settings and ends
"nothing to probe" — doctor does not open connections to prove a direct line works.
When C5 is set to Offline it reads `skipped, the egress posture is offline — …`.

When the proxy setting holds something C5 cannot use as a proxy — not a URL, or a
scheme other than `http://` or `https://`, such as `socks5://` — the line **fails** (✗),
without asking any host. It starts `proxy=INVALID <the setting> (<why>; proxied
connections are refused)` and says the setting must be an `http://` or `https://` URL.
This is a failure, not a warning, because it is an outage: C5 does not go round such a
proxy, and until you fix or remove the value it makes no outbound connection except to
the machine itself. See [Corporate proxy](/c5/configuration/network#corporate-proxy).

When a proxy **is** configured, doctor asks four hosts through it, with five seconds
each: the platform, `license.growther.si`, the release mirror (`raw.githubusercontent.com`)
and `github.com` (where the Remote Control tunnel program comes from). The licence host
matters most: a proxy that lets the platform through but not the licence service looks
healthy until your licence expires.

| You see | What to do |
| --- | --- |
| ✓ `… — 4 control-plane host(s) reachable` | Nothing |
| ! `<host>: no answer within 5000 ms` | Allow that host on the proxy |
| ! `<host>: 407 from the proxy (basic auth only)` | The proxy wants credentials. Put them in the proxy URL; C5 speaks Basic proxy authentication only |
| ! `<host>: <certificate error>` | Add your proxy's root certificate to the CA bundle |

A host the proxy does not carry is always a warning, never a failure: an install that is
cut off by a firewall on purpose is a choice, not a fault. Use `--strict` if you want it
to fail a script.

The line starts with the settings in force, for example
`proxy=http://proxy.example:8080 no_proxy=.corp.example ca=/etc/ssl/corp.pem (2 certs, additive) mothership-pin=off`.
Any password in the proxy URL is left out.

### Control-plane hosts

The hosts C5 contacts on its own initiative, by name, as one line that starts with how
many there are:

```text
14 control-plane host(s): api.growther.si, license.growther.si, raw.githubusercontent.com, github.com, release-assets.githubusercontent.com, huggingface.co, …
```

They are the platform, the licence service, the release mirror, `github.com` and GitHub's
file-download host (where the Remote Control tunnel program comes from), Hugging Face and
its download servers for models, Hugging Face's inference endpoint (contacted only if you
use Hugging Face as a model provider), and the documentation sites. If you set a relay
with **Platform address**, it is listed first. See
[Network and egress](/c5/configuration/network#what-c5-contacts-and-why) for why each host
is contacted, and for the full list to give a firewall team.

### Network posture and Served origin

**Served origin** fails when the address your browser opens C5 at is not one where the
browser allows the cryptography sign-in needs — typically a plain `http://` address on
another machine's IP. Use `http://localhost:4299` on this machine, or forward the port
over SSH with `growther connect`.

**Network posture** appears only when there is a problem with how C5 is exposed:

- ✗ when `GROWTHER_ALLOW_REMOTE_NONE_LOGIN=1` is set while C5 listens on a non-local
  address (`GROWTHER_BIND_HOST`), which would let anyone on the network sign in without
  a credential — unset one of them;
- ! when C5 listens on a non-local address (`GROWTHER_BIND_HOST`) without
  `GROWTHER_ALLOWED_HOSTS`, which turns off a protection against DNS rebinding.

## Common findings

**Install** warns or fails
C5 is not where it expects to be. Reinstall — see
[Installation](/c5/getting-started/installation). If your terminal simply cannot find the
`growther` command, close the terminal window and open a new one first; shells only pick
up PATH changes in new sessions.

**License** fails
Run `growther activate` to pair this computer with your license. It warns when fewer
than 14 days are left.

**Databases** says "none yet"
Normal before C5's first start. If C5 has run before, your data folder may have moved;
run `growther home show`. If the databases are there but cannot be opened, see
[Backups and recovery](/c5/security/backups).

**Mothership** says "unreachable"
Usually a network, proxy or firewall issue — the message in brackets says which. C5 keeps
working; you just will not get updates until it can connect. Check
**Proxy reachability** next.

**Credential-less** warns
Some accounts sign in with no credential at all. That is safe while C5 is reachable only
from this machine, and a risk on anything other machines can reach. Ask those users to
set a password, passkey or PIN.

**Binary integrity** fails
The program file does not match what was published.

> **Danger**
> Do not ignore an integrity failure. It means the program on disk is not the one
> Growther.si signed. Reinstall from the official installer, and see
> [Verifying releases](/c5/security/verifying-releases).

## When you ask for help

Run doctor first and include its output. It answers most of the questions a support
person would otherwise have to ask you.

See [Getting help](/c5/troubleshooting/getting-help).
