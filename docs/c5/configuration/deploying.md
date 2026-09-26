---
title: Deploying across an organisation
description: Push C5 to Windows with an MSI or to macOS with a PKG, set the enterprise install options, and avoid the one mistake that silently configures nobody.
order: 8
---

# Deploying across an organisation

C5 ships two packages for fleet deployment: a Windows Installer package (`.msi`) and a macOS
installer package (`.pkg`). Both wrap the same signed program the ordinary download gives you.

This page is for IT administrators. If you are installing C5 on your own computer, use
[Installation](/c5/getting-started/installation) instead.

## What the packages do, and do not do

| They do                                                            | They do not                                          |
| ------------------------------------------------------------------ | ---------------------------------------------------- |
| Put the signed C5 program in a machine-wide folder                 | Download or rebuild anything                         |
| Put that folder on everyone's `PATH`                               | Touch anyone's shell profile or rc file              |
| Run the ordinary C5 install script to apply the options you chose  | Decide anything the install script does not decide   |
| Ship the install script alongside the program                      | Include a runtime, a service host or an add-on       |

That third row is the design. Every package option is one option of the install script, and
nothing else. There is one description of what a managed install means, not three, and a check
in our build fails if an option ever exists on one side and not the other.

## Before you start

You need the `.msi` or the `.pkg` for the version you are deploying. Both are built and signed
by the same release that produces the ordinary downloads. If they are not listed with the
downloads for your version, ask us for them.

**Check the machine shape first.** C5 **refuses to start on a multi-session host** — RDS,
Citrix, Azure Virtual Desktop, or any shared multi-user box where several people are signed in
at once. It exits with code **4** before it takes the instance lock and before it opens any
database. The reason is the loopback trust boundary: on a shared session host, "a request from
localhost" no longer means "a request from this user", so every local trust decision C5 makes
would be wrong for everybody but the first person to sign in.

There is no way to make this safe by configuration, so the acknowledgement is deliberately
awkward: set the `GROWTHER_MULTI_SESSION_HOST` policy key to `acknowledged`, and only with a
compensating control that separates users some other way. Deploying to a session-host pool
without reading this produces a fleet where every install exits 4 at first launch.

Decide two things first:

1. **Do you push a policy?** Settings your organisation locks — the folder locations, the
   network posture, the identity provider, the model allow-list — do not come from the
   installer. They come from Intune, Group Policy, Jamf or a signed policy file. See
   [Managed configuration](/c5/configuration/enterprise-policy). The installer's job is to say
   *that* a policy is expected, not what it says.
2. **Does C5 update itself, or do you?** Both packages default to **not** updating themselves,
   because the package manager owns the file on disk and a self-update would put its repair,
   upgrade and uninstall out of step with what is actually there. `growther update` becomes
   check-only and says who manages the machine. Set `MANAGEDINSTALL` to `0` to hand updates
   back to C5.

## Windows: the MSI

```text
msiexec /i growther-c5-win-x64-node24-v2026.9.7-v42.msi /qn MANAGEDINSTALL=1 POLICYEXPECTED=1
```

The program lands in `C:\Program Files\Growther\C5`, which goes on the machine `PATH`. There is
one Windows package and it is for x64; there is no package for Windows on Arm, so deploy that
with the install script instead.

| Property         | Default              | What it does                                                                               |
| ---------------- | -------------------- | ------------------------------------------------------------------------------------------ |
| `MANAGEDINSTALL` | `1`                  | Marks the install as managed: no self-install, and `growther update` only checks           |
| `MANAGEDBY`      | `Growther.ai C5 MSI` | The name `growther update` gives when it declines to update                                |
| `POLICYEXPECTED` | `0`                  | Treats a missing policy as a fault, and turns off the anonymous first-user setup           |
| `NOACTIVATE`     | `0`                  | First run opens no browser                                                                 |
| `INSTALLSERVICE` | `0`                  | Starts C5 automatically at sign-in (Windows Startup registration)                          |
| `GROWTHERHOME`   | unset                | Records where C5 keeps its files                                                           |
| `DATADIR`        | unset                | Records where the databases go                                                             |

There is no property for a policy file, a signing key or an expected policy fingerprint. Those
are Group Policy or Intune values, delivered with `Growther-C5.admx` — the installer would be a
second place to set the same thing.

`msiexec /x` removes the program, the `PATH` entry and the managed marker. It does not remove
anyone's data, settings or auto-start registration. `growther uninstall`, run by each user, does that.

## macOS: the PKG

There is a package for Apple silicon and, while the Intel build lasts, one for Intel. They are
separate on purpose: each contains a program that is already signed and notarized, and merging
the two would break both signatures.

The package asks the person installing it nothing. Everything comes from a property list your
management tool drops **before** the install:

```text
/Library/Preferences/ai.growther.c5.install.plist
```

| Key              | Default              | What it does                                                                     |
| ---------------- | -------------------- | -------------------------------------------------------------------------------- |
| `MANAGEDINSTALL` | `1`                  | Marks the install as managed: no self-install, and `growther update` only checks |
| `MANAGEDBY`      | `Growther.ai C5 PKG` | The name `growther update` gives when it declines to update                      |
| `POLICYEXPECTED` | `0`                  | Treats a missing policy as a fault, and turns off the anonymous first-user setup |
| `NOACTIVATE`     | `0`                  | First run opens no browser                                                       |
| `INSTALLSERVICE` | `0`                  | Starts C5 automatically at sign-in (a launchd user agent)                        |
| `GROWTHERHOME`   | unset                | Records where C5 keeps its files                                                 |
| `DATADIR`        | unset                | Records where the databases go                                                   |

`1`, `true` and `yes` in any case mean on; anything else means off. No property list at all
gives you a plain managed install: the program, the `PATH` entry and the marker.

```sh
sudo defaults write /Library/Preferences/ai.growther.c5.install.plist \
  MANAGEDINSTALL -string 1 \
  POLICYEXPECTED -string 1 \
  MANAGEDBY -string "Contoso IT"
sudo installer -pkg growther-c5-macos-arm64-node24-v2026.9.7-v42.pkg -target /
```

The program lands at `/opt/growther/bin/growther`, and `/etc/paths.d/growther` puts it on
everyone's `PATH`. No shell rc file is touched.

There is no uninstaller package. `growther uninstall` removes each person's own data; the
program itself goes with `sudo rm -rf /opt/growther /etc/paths.d/growther` and
`sudo pkgutil --forget ai.growther.c5`.

As with the MSI, there is no key for a policy file or a signing key. Those belong in a
configuration profile.

## The one thing that will bite you

**Most of these settings are per-user, and an installer running as the system account cannot
write them anywhere useful.**

The managed marker sits beside the program and is machine-wide. But the policy fingerprint, the
record of where C5 keeps its files, the configuration file and the automatic-start task all
live under a **user profile**. There is nowhere else for them to go.

So if you set `POLICYEXPECTED`, `NOACTIVATE`, `INSTALLSERVICE`, `GROWTHERHOME` or `DATADIR`:

- **On Windows**, deploy in **user context** (in Intune, a Win32 app with _Install behavior:
  User_). Deployed as SYSTEM with any of those set, the install **fails and says why**, rather
  than writing them into `C:\Windows\system32\config\systemprofile` where no real account will
  ever read them.
- **On macOS**, they are applied to the person currently logged in. If nobody is logged in — an
  imaging-time install, for instance — the install **fails and says why**, rather than writing
  them into the root account's home.

Both refusals are deliberate, and both exit non-zero so your deployment tool reports a failure.
A machine that believes it is managed but carries no marker looks fine from every angle and is
not, which is the one state worth failing loudly to avoid.

A system-context deployment that sets only `MANAGEDINSTALL` and `MANAGEDBY` is fine, because
those are machine-wide.

## Check a property list before it reaches a fleet

This prints the account it would use and the exact options it would apply, and changes nothing:

```sh
sudo GROWTHER_PKG_PRINT_ONLY=1 \
     GROWTHER_PKG_SETTINGS=/Library/Preferences/ai.growther.c5.install.plist \
     /path/to/postinstall '' '' /
```

## Check the result

On a deployed machine:

```bash
growther doctor --json
```

The report's *Managed install* section carries three things: whether a policy is **expected**,
the **path** of the marker that says so, and how many administrators exist. It does not record
who set the marker, and it is not where you find out whether a policy actually arrived — for
that, read the *Egress posture*, *Network posture* and *Served origin* checks, or run
`growther policy show`, which reports the source, signature and every locked key.

`growther doctor --json` also writes `doctor-status.json` into the C5 folder, which is what an
Intune detection script or a Jamf extension attribute should read.

On a managed install the anonymous first-user setup is off, so create the first administrator
from the device or let the first sign-in through your identity provider create one:

```bash
growther user bootstrap-admin --name "IT Admin"
```

## What the packages are signed with

The Windows package carries an Authenticode signature from the same certificate that signs the
C5 program itself. The macOS packages are signed with a Developer ID Installer certificate,
notarized by Apple and stapled, so they install on a machine with no network connection.

If a package is named `…-unsigned.msi` or `…-unsigned.pkg`, it was built without a certificate.
SmartScreen and Gatekeeper will treat it accordingly. Do not deploy one to a fleet.

## Next steps

- [Managed configuration](/c5/configuration/enterprise-policy) — pushing the settings themselves.
- [Where your data lives](/c5/configuration/data-location) — what `GROWTHERHOME` and `DATADIR`
  actually move, and what C5 refuses to put on a network folder.
- [Sign in with your organisation](/c5/security/identity) — so people do not need a local
  account.
- [Secrets and keys](/c5/security/secrets-and-keys) — keystore custody and escrow, which you
  want in place before a machine is ever rebuilt.
