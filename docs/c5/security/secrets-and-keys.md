---
title: Secrets and keys
description: Move API keys out of the config file into your keystore or vault, and escrow the device key so a rebuilt machine can be recovered.
order: 9
---

# Secrets and keys

C5 holds two kinds of secret. Understanding the difference is most of what you need.

**Your API keys and tokens** let C5 talk to model providers, GitHub, Slack and the rest.
By default they sit in `config/c5.yaml`, readable by anyone who can read your files.

**The device key** is different. It is 32 random bytes that encrypt your four databases,
sign your session tokens, and back the break-glass recovery path. Lose it and the
databases are unreadable, even by you. Nothing can rebuild it.

## Move your API keys into a keystore

C5 can keep each key in your operating system's own keystore, or in your organisation's
vault, and leave only a reference behind in the config file.

Open **Settings › Enterprise › Secrets custody**, or run:

```bash
growther secrets status
growther secrets migrate --to keychain     # macOS
growther secrets migrate --to dpapi        # Windows
growther secrets migrate --to secret-service   # Linux
```

Vault backends work the same way:

```bash
growther secrets migrate --to keyvault     # Azure Key Vault
growther secrets migrate --to aws-sm       # AWS Secrets Manager
growther secrets migrate --to vault        # HashiCorp Vault
```

Afterwards `c5.yaml` holds a reference rather than a value:

```yaml
OPENAI_API_KEY: "ref:keychain:c5/OPENAI_API_KEY"
```

Each key is written to the keystore, read back, and only then replaced in the file. If the
read-back does not return exactly what was written, nothing is changed. `growther secrets
revert` brings the plaintext values back.

**The SCIM token moves too.** When you generate a SCIM token on a machine with no keystore,
C5 keeps it in `c5.yaml` in plain text (the **Provisioning** panel says where it went).
`growther secrets migrate` moves it into the keystore like any other secret, and `revert`
brings it back. Sign-in *settings* are not secrets, so they stay in the file: name one with
`--keys` (an issuer, an administrator role) and it is skipped with *an identity setting, not
a secret: an administrator sets it in Settings › Enterprise › Identity*.

On a locked-down Windows fleet there is a second route to the keystore. See below.

## Locked-down Windows fleets

Many managed Windows images run PowerShell in **Constrained Language Mode**, a lockdown that
AppLocker or WDAC switches on to stop scripts reaching most of the .NET framework. It restricts
the scripting engine, not the machine.

It matters here because C5's first route to the Windows keystore goes through PowerShell. Under
Constrained Language Mode that route is closed: the encryption class is unreachable, `Add-Type`
is unavailable, and running PowerShell with a different execution policy does not lift it. The
fleets that most want their keys in a keystore were therefore exactly the ones that had to
leave them in a file.

C5 has a second route: a small signed helper program that sits beside the C5 program and calls
the Windows encryption interface directly. A signed program is not a script, so the lockdown
does not touch it. The secret is handed to it on standard input, never on a command line, for
the same reason as everywhere else in C5 — Windows process auditing records command lines and
sends them to your SIEM.

There is nothing to choose and nothing to configure. C5 tries PowerShell first, because it is
on every Windows machine and needs nothing shipped alongside. If that route is blocked, C5 uses
the helper, and proves it works with a real encrypt-and-decrypt round trip before trusting it
with anything. The helper ships inside the Windows download and the MSI, beside the C5 program,
so there is nothing to install separately.

**Items stored either way are interchangeable.** Both routes write the same protected file, in
the same place, with the same scope. A key stored before your fleet was locked down is readable
afterwards, and a key stored through the helper is readable if the lockdown is later lifted.
Nothing needs migrating in either direction.

**Check rather than assume.** Open **Settings › Enterprise › Secrets custody**, or run
`growther secrets status`. It names which route is doing the work and why the other one is not.
If it says nothing on this machine can reach the keystore, your keys are still in the
configuration file — set up escrow (below), and `growther doctor` will keep reminding you.

## Escrow the device key

Escrow wraps the device key set, sealed to a public key **you** hold, into a file that is
safe to keep with your backups. Growther never has your private half and never sees the
key.

```bash
growther key escrow keygen --out ./c5-escrow      # once, on an admin workstation
growther key escrow enable ./c5-escrow/escrow-kek.pub
growther key status
```

The wrapped file lands at `config/key-escrow.blob`. It is not a secret: without your
private key it is meaningless, so it belongs in your normal backup rotation.

Keep the private key where your organisation keeps root secrets. It is the only way back
in after a machine is wiped.

Three things to know for the life of that key:

```bash
growther key escrow rotate <next-kek.pub>   # re-seal under a new key; the old one still
                                            # opens the blob for one window, so a fleet can
                                            # roll over without a flag day
growther key escrow reseal                  # re-seal under the pinned key — do this after a
                                            # device-key change, and to close a rotation window
growther key escrow disable                 # remove the blob entirely
```

`escrow disable` is **refused while the device key is in a keystore**, because that
combination is the one with no way back: the blob is the only copy that survives a destroyed
keystore entry.

## Pointing at a secret you already manage

If your organisation already delivers secrets to the machine — a Kubernetes projected volume,
a systemd credential, a CI runner's environment — you do not have to copy them into C5. Write
a reference instead of a value, anywhere a key is accepted:

| Form | Reads from | Use it when |
| --- | --- | --- |
| `ref:env:NAME` | The launcher environment | A supervisor or container runtime injects the value |
| `ref:file:/absolute/path` | A file, read at use time | A headless host with secrets mounted on disk |

The file must be **owner-only** on macOS and Linux — mode `0600` or narrower, or C5 refuses
to read it. On Kubernetes set `defaultMode: 0400` on the projected volume, which a default
mount does not do. Windows uses the ACL and is not mode-checked.

Both are read when the secret is needed, not cached at boot, so rotating the underlying value
takes effect without restarting C5. `ref:env:` reads the environment C5 was **launched** with
— not `c5.yaml` — so a value in the config file cannot impersonate one your supervisor set.

## Then, if you want, wrap the device key itself

With escrow verified, C5 can move the device key out of its file and into the keystore:

```bash
growther key wrap
```

The key is written to the keystore, read back, and only then is the plaintext file
overwritten and deleted. `growther key unwrap` reverses it.

C5 refuses to wrap the key while escrow is missing or out of date. That refusal is
deliberate. On Entra-joined Windows machines the keystore blob is tied to the user's
password key: a forced password reset, an Intune "remove user", or a rebuilt profile
destroys it. Escrow is what makes that recoverable rather than fatal.

**Wrapping makes the OS keystore a boot dependency.** Once the device key lives in the
keystore, C5 cannot open its databases without it — so if the keystore is unavailable or the
entry is gone, C5 refuses to start rather than starting into an unreadable state. It exits
with its own code and says which of the two it is. Recover with:

```bash
growther key recover --escrow key-escrow.blob --private-key <kek.pem>
```

That is what the escrow is for, and why C5 will not let you wrap without one.

## Recover a rebuilt machine

On the new machine, after installing C5, and with C5 stopped:

```bash
growther key recover --escrow ./key-escrow.blob --private-key ./c5-escrow/escrow-kek.key
growther restore --from /backups/growther/2026-09-06T02-00-00 \
                 --escrow ./key-escrow.blob --private-key ./c5-escrow/escrow-kek.key
```

Generate the pair off the C5 machine: the private key must never sit beside the blob it
opens. `key recover` puts the key set back in the right order. `restore` verifies every backup
file against its recorded hash, snapshots whatever is already there, restores the
databases, checks each one opens and passes an integrity check with the recovered key, and
reports whether the licence still recognises this deployment.

## What `growther doctor` tells you

```bash
growther doctor
```

- **Key custody**: file, keystore, or keystore with escrow.
- **Escrow**: disabled, enabled with its key id, or **stale** when the blob no longer
  matches the current device key. Stale escrow under keystore custody is a failure, not a
  warning: fix it before the machine is rebuilt.
- **Plaintext secrets**: how many API keys are still values rather than references.

## What never happens

- A secret is never passed on a command line. Command lines are recorded by Windows
  process auditing and macOS logging; C5 passes every secret on standard input instead.
- A secret never travels in a policy. Your organisation's policy can say *which* keystore
  to use; it can never carry a key.
- The device key is never written to a network folder, a roaming profile, or a synced
  folder, and never leaves the machine except inside an escrow blob sealed to your key.
