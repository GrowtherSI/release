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

It only reads and checks. It does not change anything.

## What it checks

Doctor runs 38 checks, grouped below. Which ones appear depends on your install — the
enterprise checks are silent unless the feature is configured.

**Where your files are**

| Check | Looking for |
| --- | --- |
| **Data home** | Your data folder exists and can be written to |
| **Home source** | How the location was decided: default, pointer, environment or policy |
| **Home resolution** | The pointer file parses and agrees with where C5 is actually running |
| **Data dir filesystem** | The databases are on a local disk, not a share or a synced folder |
| **Secrets location** | Where the key set lives, and whether it is split from the home |
| **Config (c5.yaml)** | The config file parses, and which keys the environment overrides |
| **Databases** | Your data files are present where they should be |
| **Backup target** | The configured backup destination exists and is writable |
| **Lock host** | Who holds the single-instance lock, and whether it is this machine |
| **Session host** | Whether this is a shared multi-session host, which C5 refuses to run on |

**This copy of C5**

| Check | Looking for |
| --- | --- |
| **Install** | The program is where it should be |
| **`growther` on PATH** | You can run `growther` from any shell |
| **Build manifest** | The record of how this build was made is present |
| **Manifest signature** | That record really was signed by Growther.si |
| **Binary integrity** | The program file matches what was installed |
| **OpenSSL 1.1 (SQLCipher)** | The library the encrypted databases need is available |
| **SOC2 change-mgmt** | Internal build and release change-control checks |

**Licence and the platform**

| Check | Looking for |
| --- | --- |
| **License** | This computer is activated |
| **Seed validity** | The licence seed is authentic and unexpired |
| **Seed ↔ key binding** | The seed belongs to this machine's key |
| **Mothership** | C5 can reach the platform, if you use it |
| **Platform URL** | Which platform address this install is pointed at |
| **Control-plane hosts** | Each host C5 contacts answers, through your proxy settings |

**Keys and secrets**

| Check | Looking for |
| --- | --- |
| **Key custody** | Where the device key is kept: keystore, wrapped, or a file |
| **Escrow** | Whether the key set has been escrowed, so it can be recovered |
| **Identity key** | The deployment identity key is present and readable |
| **Last key mint** | When a key was last issued |
| **Retired key on disk** | A superseded key that should have been shredded |
| **Plaintext secrets** | API keys still stored in the clear rather than in a keystore |
| **Credential-less** | Settings that reference a keystore entry that does not exist |
| **Confirmed identity** | The machine identity matches what the lock and licence expect |

**Enterprise**

| Check | Looking for |
| --- | --- |
| **Managed install** | Whether this install expects a policy, and where the marker is |
| **Egress posture** | Online or offline, and whether a policy locked it |
| **Network posture** | The proxy, bypass list and certificate pin in effect |
| **Served origin** | The origin C5 answers on, and whether passkeys match it |
| **Audit sink** | The audit shipping destination, and whether it is reachable |
| **Legal hold** | Whether a legal hold is suspending audit pruning |
| **Offline speech** | The offline speech model's state |

> **Note**
> Doctor does **not** test your model providers or your integrations. Those are checked
> when you save them in Settings, which is also where a bad key is reported. See
> [Model providers](/c5/configuration/model-providers).

## Reading the output

Each check gets a clear result:

- **OK** — nothing to do.
- **Warning** — works, but something is not ideal.
- **Failed** — this is broken, and doctor tells you how to fix it.

Work top to bottom. An early failure often causes the ones below it, so fixing the first
problem sometimes clears several at once.

## Common findings

**"Install" failed**
C5 is not where it expects to be. Reinstall — see
[Installation](/c5/getting-started/installation). If your terminal simply cannot find the
`growther` command, close the terminal window and open a new one first; shells only pick
up PATH changes in new sessions.

**"Not activated"**
Run `growther activate` to pair this computer with your license.

**"Database check failed"**
Your stored data could not be opened. C5 repairs itself where it can — see
[Backups and recovery](/c5/security/backups) if it cannot.

**"Cannot reach the update service"**
Usually a network or firewall issue. C5 keeps working offline; you just will not get
updates until it can connect.

**"Integrity check failed"**
The program file does not match what was published.

> **Danger**
> Do not ignore an integrity failure. It means the program on disk is not the one
> Growther.si signed. Reinstall from the official installer, and see
> [Verifying releases](/c5/security/verifying-releases).

## When you ask for help

Run doctor first and include its output. It answers most of the questions a support
person would otherwise have to ask you.

See [Getting help](/c5/troubleshooting/getting-help).
