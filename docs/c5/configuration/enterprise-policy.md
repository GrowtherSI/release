---
title: Managed configuration
description: Push C5 settings from Intune, Jamf, Group Policy or a signed policy file; what users see when a setting is locked; keeping the local classifier on or off; the growther policy commands.
order: 7
---

# Managed configuration

C5 can take its settings from your organisation instead of from each user. Push a
policy from the tools you already run, and every setting it locks shows *Managed by
your organization* on the user's screen.

This page is for IT administrators. Users need to do nothing.

## What you can manage

Every key an organisation may set is listed in the generated templates (below) and
under **Settings › Enterprise › Policy** on any C5. In short:

- **Where things live**: the configuration, data, secrets and cache folders (device
  policy only).
- **Network**: port, bind address, allowed hosts, whether credential-less sign-in is
  allowed from the network, the proxy and the certificate authority. The proxy and
  certificate keys come from device policy only, never from a signed document, and
  only when the policy **locks** them — see
  [How a policy sets the proxy](#how-a-policy-sets-the-proxy) below.
- **Offline mode**: `networkPosture` (`online` or `offline`), the one switch that
  stops the outbound connections C5 starts on its own (not the audit shipping or off-site
  backups you configure), for air-gapped fleets — see
  [Turn off every outbound connection](network.md#turn-off-every-outbound-connection).
  Lock it through device policy: a device-policy lock is honoured by every `growther`
  command, even on a machine whose Settings once said **Online**, while a lock that
  arrives only in a signed document is not read by `growther voice pull`,
  `growther qmd-run pull` or `growther doctor` (see
  [Details worth knowing](network.md#details-worth-knowing)).
- **What leaves the machine**: sharing improvements with the Mothership, anonymous
  error reports (the key exists, but this version sends no error reports — see
  [Network and egress](network.md)), GitHub backups, automatic updates and the
  release channel.
- **Models**: which providers and models agents may use, and whether C5 runs its
  local classifier (`classifier_enabled`, below).
- **Security**: elevated exec, workspace-only edits, autonomy ceilings, the global cost
  cap, allowed domains.
- **Retention and audit**: audit and event retention, legal hold, the audit shipping
  endpoint.
- **Identity**: the sign-in provider, admin role, whether single sign-on is required.

Secrets are never part of a policy. API keys and tokens live in the keystore; a policy
refers to them, it never carries them.

## Four ways to deliver a policy

### First: get the templates

C5 writes them itself. Every install puts the current set in `<home>/enterprise` at
startup — `%USERPROFILE%\.growther\enterprise` on Windows, `~/.growther/enterprise`
elsewhere — and you can write them anywhere on demand:

```bash
growther policy templates --out ./c5-mdm
```

| File | For |
| --- | --- |
| `Growther-C5.admx` + `en-US/Growther-C5.adml` | Group Policy and Intune |
| `ai.growther.c5.mobileconfig` | Jamf, Intune and any macOS MDM |
| `samples/policy.d/10-baseline.yaml` | Linux drop-in, ready to edit |
| `samples/policy.example.yaml` | A signed policy document to start from |
| `growther-c5-policy.schema.json` | Validate a document in your editor or CI |
| `README.md` | Every key, its type and what it locks |

**Use the templates from the version you are deploying.** They are generated from that
build's own key list, so they can never offer a key the server does not understand — which
is the failure they exist to prevent: a policy an administrator sets and the server silently
ignores. C5 refreshes them on every start, and leaves any file you have edited alone.
Templates written by a build from before the local classifier do not carry
`classifier_enabled` ([below](#keep-the-local-classifier-on-or-off)); write them again
from the version you deploy.

### Windows: Intune or Group Policy

Import `Growther-C5.admx` and `en-US/Growther-C5.adml` into the Intune Settings Catalog
(imported ADMX) or your central store. Policies under **Computer Configuration › Growther C5** are locked;
**Recommended** values are defaults the user may change. The values land in
`HKLM\SOFTWARE\Policies\Growther\C5`.

### macOS: Jamf or Intune

Deploy a configuration profile for the preference domain `ai.growther.c5`. Top-level
keys are locked; keys inside a `Recommended` dictionary are defaults. Use the
`ai.growther.c5.mobileconfig` written above as your starting point.

### Linux

Drop one or more YAML files in `/etc/growther/policy.d/`. They are merged in name order
and use the same document shape as a signed policy file. Start from
`samples/policy.d/10-baseline.yaml`.

That directory is **root-owned on purpose**, and so is the signing keyring
(`/etc/growther/policy-keys` on Linux, `%ProgramData%\Growther\C5\policy-keys` on Windows,
`/Library/Application Support/Growther/policy-keys` on macOS). C5 never reads policy from the
user's home folder: if it did, the person the policy governs could write one. The templates
in `<home>/enterprise` are copies to export — nothing there influences what C5 believes.

### A signed policy file (any platform)

Publish a policy document on a share or at an https address and point devices at it
through the platform policy (`PolicySource`), or through `/etc/growther/policy-source.yaml`
on Linux. File and https sources must be signed with a key you pin on each device:

```bash
growther policy keygen --out ./policy-keys          # once, on an admin workstation
growther policy sign policy.yaml --key ./policy-keys/policy-signing.key --out policy.signed.yaml
sudo growther policy pin ./policy-keys/policy-signing.pub   # on each device, or through your MDM
```

A policy document looks like this:

```yaml
schemaVersion: 1
policyId: contoso-c5-baseline
version: 12
managed: true
maxOfflineHours: 336
keys:
  shareImprovements: { value: false, locked: true }
  allowedProviders: { value: ["anthropic", "azure-openai"], locked: true }
  auditRetentionDays: { value: 730 }
```

Azure App Configuration and AWS AppConfig are also accepted as sources; their identity
stands in for the signature, and a signature is verified when present.

## How a policy is applied

1. C5 reads the device policy, then the signed document, at start and every fifteen
   minutes (or on demand).
2. The signature is checked against the pinned key, and the version must be higher
   than the last one applied. An older document is refused as a replay.
3. Every key is checked on its own. An unknown key, a secret, or a value of the wrong
   type is reported and skipped. A locked key with a bad value falls to its safest
   default and raises a critical audit event. One typo never unlocks a fleet.
4. Locked keys shadow whatever the user had set. Lifting the policy restores the
   user's value.
5. If the source becomes unreachable, the last verified policy holds for the grace
   window (default fourteen days). After that, locked keys fall to their safest
   defaults and C5 says so. It never quietly runs unmanaged.
6. To stop managing on purpose, publish a signed document with `managed: false`.

### How a policy sets the proxy

`proxyUrl` behaves differently from most keys, because a proxy decides where every
connection C5 makes is sent:

| What the device policy says | What C5 does |
| --- | --- |
| Locked to a usable `http://` or `https://` URL | Uses that proxy |
| Locked to an empty value (`proxyUrl: { value: "", locked: true }` in `policy.d`, an empty `<string>` in the profile, an empty registry value) | No proxy: connects directly, and nobody on the device can set one |
| Locked to a value C5 cannot use (`socks5://…`, a malformed URL, a list of several blank entries) | Refuses every connection the proxy would carry, and never connects directly instead. The **Network** card reads **Proxy unusable — connections refused** |
| **Recommended** (not locked), well-formed or not | Not applied. The proxy in C5's environment or `c5.yaml` decides. A malformed recommended value is only listed among the rejected keys, so a typo in it cannot take a machine offline |

C5 reads the same answer when it starts, before your whole policy has loaded, as it
does afterwards. See [Corporate proxy](network.md#corporate-proxy).

## What users see

A locked control is disabled, shows the value your policy set, and carries a small lock
that names the source when hovered. Administrators who save a page that includes a
locked setting see which settings were set aside; nothing else on the page is lost.

**Settings › Enterprise › Policy** shows the source, the policy id and version, the
signature state, when it was fetched and applied, the locked settings, the defaults it
applied, and any keys it rejected with the reason.

## Keep the local classifier on or off

C5's local classifier is a small model (about 812 MB, downloaded once from Hugging
Face) that answers some of C5's routine questions on the machine itself. It is **on by
default**: the first time a version of C5 with the classifier starts, it turns the
switch on wherever nothing has set it, and then downloads the model. While it is on,
every kind of decision starts in Shadow, where it only records its answers. Passing its
measurement changes nothing by itself: only Task categories can be raised to act, and only
when someone with permission to change settings chooses to. No policy key does it. On a
machine where it runs on the CPU, the most frequent kinds record one question in four.
What it does, and what users see, is described in [Local classifier](../tools/local-classifier.md) and
under [Settings › Learning](settings.md#learning). One policy key decides it for a
fleet:

| | |
| --- | --- |
| Key | `classifier_enabled` |
| Type | Boolean: `true` keeps it on, `false` keeps it off |
| Lockable | Yes |
| Delivered by | Group Policy or Intune, macOS managed preferences, `/etc/growther/policy.d`, or a signed policy document. Not by the Mothership |
| Applies | Live, with no restart |
| If a locked value is malformed, or the policy expires | Off |

In the generated templates it is the **Local classifier** policy in
`Growther-C5.admx` (enabled is `1`, disabled is `0`, under the registry value
`classifier_enabled`), and a commented-out `classifier_enabled` line in
`ai.growther.c5.mobileconfig` and in the YAML samples — uncomment it and set the value.
To keep it off everywhere:

```yaml
keys:
  classifier_enabled: { value: false, locked: true }
```

### Set it before the first start if you never want the download

A policy value counts as an answer. If `classifier_enabled` arrives before the first
start of a C5 version with the classifier, C5 never turns the switch on itself, so a fleet that sets `false` never downloads
the model at all. The notice C5 normally gives administrators — *The local classifier
is on* — is not sent either.

A **Recommended** (unlocked) value is only a default. It decides machines where nobody
has set the switch yet; on a machine that has already started such a version, C5 has
already set it on, and that setting outranks a recommended `false`. To turn it off on machines that
are already running, **lock** it.

### What a lock does

A change takes effect at the next policy reload — at most fifteen minutes,
`growther policy reload`, or **Reload policy** in **Settings › Enterprise › Policy** — with no
restart:

**Locked off.** A running classifier is stopped, and a download in progress is stopped
too (the part already downloaded stays, so it can resume if the policy changes). Nothing
is downloaded afterwards: not at start, not from Settings, and not by
`growther classifier pull`, which answers *Your organisation's policy keeps the local
classifier off, so its model is not downloaded.* and exits with code 1. A model already
on the machine stays there until an administrator deletes it; the **Delete the model**
button in **Settings › Learning** still works while the classifier is off.

**Locked on.** Nobody on the device can turn it off or delete its model, because C5
would only download it again. A request to turn it off is refused with *Locked by your
organisation's policy: classifier_enabled.*, and a delete with *Your organisation's
policy keeps the local classifier on, so its model was not deleted: C5 would download it
again.* The offline posture and the `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD` variable
still stop the download itself — see [Network and egress](network.md). If the file at
the model's path is not the model, the card says so and that *Your organisation's policy
keeps the classifier on, so the file cannot be deleted here.* An administrator at the
machine can put the model in its place by hand.

**In Settings › Learning**, either way, the switch is shown disabled with the managed
badge, and the card says why in words a phone user can read without hovering: *Your
organisation's policy keeps the local classifier off, so it cannot be turned on here.
The policy is set by* … followed by where the policy came from. The Terms dialog does
not offer **Turn off the local classifier…**, and under a lock that keeps it on, no
delete button is shown.

Lifting the lock gives the switch back to the device: it returns to whatever was set
there, and the classifier starts or stops to match. On a machine where nothing was ever
set (the policy arrived before the first start), it stays off until C5 next starts, and
C5 then turns it on as it would on a new install.

## Validate before you ship

```bash
growther policy validate policy.signed.yaml
growther policy show
growther policy reload
```

`validate` prints one row per key and exits non-zero if anything would be rejected.

## Unattended installs

To push C5 itself, use the Windows or macOS installer package — see
[Deploying across an organisation](/c5/configuration/deploying).

Add `--policy-expected` to the install script, or run `growther policy expect` after
installing. C5 then treats the absence of a policy as a fault rather than a choice, and
disables the anonymous first-user setup so nobody can claim the administrator seat before
your policy arrives. Create the first administrator from the device:

```bash
growther user bootstrap-admin --name "IT Admin"
```

or let the first sign-in through your identity provider create it.

`growther doctor --json` reports *Managed install* with the marker and the admin count,
which is what an Intune detection script or a Jamf extension attribute should read.
