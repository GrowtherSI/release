---
title: Network and egress
description: The offline switch, corporate proxy, bypass list, private CA bundle and certificate pin; every host C5 contacts and why, including the model downloads; how to make C5 reachable from another machine.
order: 9
---

# Network and egress

C5 runs entirely on your computer, but it does reach out for a few things: your
licence, updates, the small models some features run on your machine, and — if
you use Remote Control with a tunnel — the tunnel program. This page is the
complete account of what it contacts, when, how to route that through your
proxy, and how to turn all of it off.

You can see these settings under **Settings › Enterprise › Network**. An
administrator can switch C5 offline there. The proxy settings are delivered by
policy or by environment variables, and the card only shows them. Every key can
be locked by an organisation policy so nobody on the device can change it.

*The platform*, on this page, is Growther.si's own service, shown as
**Mothership** in the console — see
[Connecting to the platform](../mothership/connecting.md).

## Turn off every outbound connection

One switch stops the connections C5 starts on its own to Growther.si, Hugging Face and the
other services listed below. It has more than one name, depending on where you meet it:

- **Egress posture** in **Settings › Enterprise › Network**;
- **Network posture**, key `networkPosture`, values `online` or `offline`, in the
  policy templates and **Settings › Enterprise › Policy**;
- "network posture" in some messages.

They are all the same switch, called *the offline posture* on the rest of this
page. To set it:

1. Open **Settings › Enterprise › Network** (administrators only).
2. Under **Egress posture**, select **Offline**.

Only an administrator at the machine itself can change this switch: not another
user, whatever their permissions, and not from a device paired through Remote
Control.

To lock it for a fleet, set it in your policy — see
[Managed configuration](enterprise-policy.md):

```yaml
keys:
  networkPosture: { value: offline, locked: true }
```

Offline stops everything in the table below: the connections C5 makes on its own to
Growther.si, Hugging Face, GitHub (for the `cloudflared` download) or your directory's cloud
service, and the connection tests in Settings. There is no second setting to remember for
these. Destinations an administrator configured, such as audit shipping and off-site
backups, are not stopped; see [What offline does not cover](#what-offline-does-not-cover).

| What | What stops |
| --- | --- |
| Licence refresh | No refresh, no key rotation. Your licence runs on its offline grace period |
| Platform check-in | No check-in |
| Flywheel sync (the shared catalogue of improvements) | Nothing is fetched from the catalogue and nothing is uploaded to it |
| Background update check | Stopped |
| Memory-search models | No embedding, reranking or query-expansion model is downloaded — not at start, and not by `growther qmd-run pull` |
| Offline speech model | Not downloaded — not at start, and not by `growther voice pull` |
| Local classifier model | Not downloaded — not at start, not when someone turns the classifier on, and not by `growther classifier pull` |
| Remote Control tunnel program | `cloudflared` is not downloaded. A tunnel that still needs it cannot start; a tunnel whose program is already on the machine still runs (see below) |
| Hugging Face as a model provider (Inferencer) | No background health check (normally at start and once a minute), no model list for the model pickers, and no latency test in Settings, to any Hugging Face host — `huggingface.co`, `hf.co`, `huggingface.cloud` or any name under them, such as `router.huggingface.co` or a dedicated Inference Endpoint. The provider shows as unhealthy, with no models and no latency figure. An Inferencer endpoint on any other host — your own server — is still checked |
| Directory group sync | Skipped |
| Sign-in provider test | Refused with *This deployment's network posture is offline; no outbound probe was made.* |
| **Test connectivity** | Refused with *The egress posture is offline, so C5 makes no outbound contact.* |
| `growther doctor` proxy check | Skipped, and the report says so |

There is no error-report row: this version of C5 sends no error reports at all,
whatever the **Report errors anonymously** setting says.

Offline is a posture, not a firewall rule: C5 refuses to start the connection
itself, so it holds even where the network would have allowed it. Each
background job it stops writes one line an hour at most, so you can see the
offline posture being honoured without the log filling with it:

```text
[posture] offline — local classifier model download skipped; this deployment makes no outbound contact
```

The name in the middle says which job it was: `licence refresh`,
`Mothership check-in`, `flywheel sync`, `update check`, `QMD model download`,
`offline speech model download`, `local classifier model download`,
`cloudflared download`, `identity graph sync` or `identity oidc probe`. The Hugging Face
provider's skipped checks write nothing at all: a skipped check every minute is not news.

### What offline does to the model downloads

A model download refused by the offline posture is not an error, and nothing is left
half done. C5 still checks any model file already on disk, so a model you place
by hand is used. Each command tells you what to do instead of downloading:

- `growther classifier pull` prints the address to fetch the model from on a
  connected machine, the exact path to put it at, and its sha256.
- `growther voice pull` prints the same three things for the speech model. It
  first prints *Downloading the offline speech model (~60 MB, pinned and
  sha256-checked)…*; the refusal follows straight away, and nothing is
  downloaded.
- `growther qmd-run pull` points you at `qmd/README.md` in the cache folder,
  which lists each memory-search model's address, size and sha256.

All three exit with code 1. **Settings › Learning** says the same for the local
classifier: *Not downloaded: This deployment's network posture is offline, so
the classifier model is not downloaded.*, followed by the placement step.

When you switch back to **Online**, the automatic downloads happen at the next
start of C5. You can also run the `pull` command for the one you want, or — for
the local classifier — turn it off and on again in **Settings › Learning**.

### What offline does not cover

Offline governs what C5 does on its own initiative. It does not stop traffic
*you* have configured: a cloud model provider still answers an agent's request,
and a web-search tool still reaches its endpoint, because those happen because
someone asked for them. Restrict those separately with the provider allow-list
and the guardrail domain allow-list. (C5's own background checks of the Hugging Face
provider are stopped, as in the table above; a request an agent sends to a provider is
not.)

These connections are not stopped by the offline posture either:

- **A Remote Control tunnel whose program is already on the machine.** Offline
  stops C5 downloading `cloudflared`, but if the program is already there, the
  tunnel still starts and connects to Cloudflare's network. Turn Remote Control
  off to stop it — see [Privacy and Cloudflare](../remote-control/privacy-and-cloudflare.md).
- **LDAP sign-in.** C5 still contacts your directory server to sign people in,
  and **Test connection** beside the LDAP fields still reaches it. A directory server
  is normally on your own network, and air-gapped sites are the ones that rely
  on it.
- **Destinations an administrator configured.** Audit shipping to Splunk, Microsoft
  Sentinel / Azure Monitor, OpenTelemetry or syslog; backups copied to a network folder, an
  Azure Blob container or an S3 bucket under **Settings › Enterprise › Enterprise storage**;
  and scheduled backups to GitHub all keep running while offline. Turn those off where you
  configured them if the machine must make no outbound contact.

`growther update` run by hand still contacts the platform. The three model
`pull` commands do not: the offline posture refuses them too. To get a model
onto an offline machine, place it by hand — see
[Place a model by hand](data-location.md#place-a-model-by-hand).

### Details worth knowing

- If C5 has not loaded its settings yet when a download is about to start, it
  uses your policy's value, never "online". A machine set offline by policy
  makes no connection at all, even while it is starting up.
- A command you type checks the switch before it downloads anything, but the
  commands do not all read it the same way:
  - `growther classifier pull` loads your organisation's whole policy first:
    the device's own policy (Group Policy, macOS managed preferences or
    `/etc/growther`) and a signed policy document, if you use one. Loading the
    document can mean one request to its web address, or reading the copy C5
    keeps of it. A lock set either way wins over the value in Settings.
  - `growther voice pull`, `growther qmd-run pull` and `growther doctor` read
    the device's own policy (Group Policy, macOS managed preferences or
    `/etc/growther`) and the value saved in Settings. A posture the device
    policy **locks** wins over whatever Settings says, so a machine locked
    offline stays offline for these commands even if someone once saved
    **Online** there. Otherwise the value saved in Settings decides; with nothing
    saved there, they treat the posture as online. An unlocked (*Recommended*)
    policy value is not read by these commands, so lock the posture if they must
    honour it.
  - Those three commands do not read a signed policy document at all. A lock
    delivered only in a signed document reaches the running C5, and
    `growther classifier pull`, but not them. To cover every command, lock the
    posture through device policy too.
- On a machine where C5 has never run, these commands use the device policy
  alone and do not create a database.
- If C5 cannot read the setting, it keeps the last value it knew. Not being able
  to read the setting never counts as permission to connect.
- `growther doctor` prints `Egress posture: offline (zero egress)` or
  `Egress posture: online`, followed by `— locked by managed policy` when the
  device's own policy locks it. While the posture is offline (locked or not), it also
  skips its proxy check, unless the proxy setting itself cannot be used, which it still
  reports as a failure.

When an administrator locks this key, the console shows a padlock and the
control is frozen.

## The models and programs C5 downloads

Three features run small models on your machine, in their own processes, so
your content does not leave it: memory search, voice (offline speech to text)
and the local classifier. C5 does not ship those models inside its installer.
It downloads each one from Hugging Face the first time the feature needs it,
then keeps it. Remote Control's tunnel works the same way with Cloudflare's
`cloudflared` program.

| What | From | When it is downloaded | Size | Turned off by |
| --- | --- | --- | --- | --- |
| Memory-search models (three files) | `huggingface.co` | At each start of C5, shortly after it is up, for any of the three that has no file yet | about 2.3 GB in total | The offline posture, or `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1` |
| Offline speech model | `huggingface.co` | At each start, while the built-in speech engine is on (it is, unless someone turned it off) and the model is missing | about 60 MB | The offline posture, or `GROWTHER_VOICE_NO_AUTO_DOWNLOAD=1` |
| Local classifier model | `huggingface.co` | At start while the classifier is on and the model is missing, and when someone — or a policy — turns it on | about 812 MB | The offline posture, `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1`, a policy that keeps the classifier off, or turning it off |
| `cloudflared` (Remote Control tunnel) | `github.com` (Cloudflare's releases) | When Remote Control starts a Cloudflare tunnel and the program is missing, or is not the exact file this build pins | about 19–69 MB, by platform | The offline posture |

Each is downloaded once and then reused. A model download that fails is tried
again at the next start, not over and over; for the local classifier, turning it
off and on, or `growther classifier pull`, also tries again. A `cloudflared`
download that fails on the network (a dropped connection, an error answer, a
download cut short) is retried while the tunnel is on, waiting a little longer
each time, up to a minute between tries. One whose **contents** are wrong — the
wrong fingerprint, more than the published size, an archive without the program
in it, or a program that fails C5's check — is not retried on its own: the same
proxy would serve the same wrong bytes every minute. Remote Control then says
*The tunnel program downloaded with the wrong contents, so it was not run — a
proxy or security product on this network may be altering it. Once that is
fixed, save Remote Control's settings to try again.* See
[Troubleshooting Remote Control](../remote-control/troubleshooting.md#the-tunnel-program-will-not-download).

The local classifier's model is never downloaded over a symbolic link placed at
its path: a link is yours, typically to a shared copy (see
[Local classifier](../tools/local-classifier.md#offline-and-air-gapped-installs)).

Some things are true of all of them:

- **Pinned and checked.** Every file is fetched from one fixed version — a fixed
  repository commit on Hugging Face, a fixed release of `cloudflared` — never
  from a moving "latest". C5 checks the exact size and the sha256 recorded in
  the build before it uses the file. A file that does not match is not used.
- **Fetched by C5 itself, through your proxy.** Every one of these downloads,
  whether C5 started it or you typed a `pull` command, goes through the proxy
  and CA bundle configured below. The memory-search engine (QMD) cannot
  download a model itself: C5 blocks it.
- **Nothing sent to Growther.si.** A model download is a request from your
  machine to Hugging Face. Nothing about it is sent to us.

And some are true of the three model downloads:

- **Never on a CI runner.** None of them runs automatically when the `CI`
  environment variable is set.
- **The memory-search download does not wait for memory search to be used.**
  It runs at start whether or not memory search is paused, so if you never want
  those 2.3 GB on a machine, set `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1` or use the
  offline posture.
- **The local classifier checks disk room first.** Its automatic download does
  not start unless the free space covers the bytes still to fetch plus a
  64 MiB margin (about 67 MB). `growther classifier pull` does not make that
  check: it starts the download whatever the free space.

### The opt-out variables

Each one stops only the **automatic** download for its feature. The matching
`pull` command still downloads, because running it is your explicit request.

| Variable | Stops | Still works |
| --- | --- | --- |
| `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1` | The memory-search models at start | `growther qmd-run pull`, or placing the files by hand |
| `GROWTHER_VOICE_NO_AUTO_DOWNLOAD=1` | The speech model at start | `growther voice pull`, or placing the file by hand |
| `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` | The classifier model at start and when it is turned on | `growther classifier pull`, or placing the file by hand |

The value must be exactly `1`. Anything else, `0` and `true` included, leaves
the download on. Set them where C5's environment is set — the launcher, the
service definition, or `c5.yaml` — see
[Environment variables](../cli/environment.md).

For an air-gapped machine the offline posture is the better tool: it stops all
of them, and the `pull` commands, with one switch. Where each file goes, and how
to place one by hand, is in [Where your data lives](data-location.md).

### Hugging Face redirects to a download network

`huggingface.co` does not serve a model file itself. Its download address
answers with a redirect to its download network, and C5 follows it. A proxy or
firewall that admits `huggingface.co` and nothing else therefore fails every
model download at the redirect — which usually looks like a download that hangs,
or one that fails as soon as it starts. Allow these as well:

- `cas-bridge.xethub.hf.co`
- `cdn-lfs.hf.co`
- `cdn-lfs-us-1.hf.co`
- `cdn-lfs-eu-1.hf.co`
- `cdn-lfs.huggingface.co`

C5 reaches them only by following that redirect.

`github.com` does the same for `cloudflared`: it redirects the download to
GitHub's own file-download host, and C5 follows the redirect (never from https
down to plain http). Today that host is `release-assets.githubusercontent.com`;
older GitHub setups used `objects.githubusercontent.com`. The host is GitHub's
choice and can change, and C5 does not fix it. If you use Remote Control with a
tunnel, allow `github.com` **and** that download host: allowing `github.com`
alone fails at the redirect.

### If a model download fails

Nothing breaks while a model is missing: the feature waits for it, and memory
search falls back to keyword search. To find out which model is missing and why:

1. Run `growther doctor`. Its **Local classifier** and **Offline speech** rows
   say whether each model is here and checked, and if not, why. For memory
   search, run `growther qmd-run doctor`.
2. For the local classifier, **Settings › Learning** shows the same under
   **Model**.
3. If the reason is the network, check that `huggingface.co` and the five
   download-network hosts above are allowed, through your proxy if you use one.
4. Run the matching command to try again: `growther classifier pull`,
   `growther voice pull` or `growther qmd-run pull`.

See also [growther doctor](../cli/doctor.md).

## Corporate proxy

| Setting | Policy key | Environment variable | What it does |
| --- | --- | --- | --- |
| Outbound proxy | `proxyUrl` | `GROWTHER_PROXY_URL` | An HTTP(S) proxy URL used for every outbound connection |
| Proxy bypass list | `proxyNoProxy` | `GROWTHER_NO_PROXY` | Hosts, domain suffixes and IPv4 CIDRs that go direct |
| CA bundle | `caBundlePath` | `GROWTHER_CA_BUNDLE` | A PEM file of extra certificate authorities, for a TLS-inspecting proxy |
| Certificate pinning | `mothershipTlsPin` | `GROWTHER_MOTHERSHIP_TLS_PIN` | Whether the platform connection pins its certificate. `on` by default |

Loopback always bypasses the proxy, whether or not you list it.

**What goes through it.** Everything C5 itself sends out: the licence, the
platform check-in and Mothership calls, the update check and the self-update
download, every model download (the three `pull` commands included),
`cloudflared`'s download, cloud model providers, **Test connectivity**, and the
proxy check in `growther doctor`. The CA bundle is added to the public
authorities, never used in place of them, so hosts your proxy does not re-sign
keep working.

**C5 does not read `HTTP_PROXY`, `HTTPS_PROXY` or `NO_PROXY`.** That is
deliberate: a variable in one user's shell must not be able to redirect licence
and provider-key traffic. If you want C5 to use the same proxy, set
`GROWTHER_PROXY_URL` (or the policy key) to the same value.

**Basic authentication only.** C5 can sign in to a proxy with a user name and
password in the URL (`http://user:password@host:port`). NTLM and Kerberos
proxies are not supported: give C5 a listener that takes Basic or no
authentication, or exclude it from interception.

**These four are delivered, not typed.** In a shipped build the Network card
only shows them. Set them by policy, or by the environment variables in the
table (in the launcher environment or `c5.yaml`); the card is where you confirm
what arrived. C5 refuses a change to any of the four from anyone but an
administrator at the machine itself: not from another user, whatever their
permissions, and not from a device paired through Remote Control. Wherever C5
shows the proxy URL, a password in it is hidden.

**An unusable proxy stops traffic; C5 does not go round it.** If the proxy
setting holds something C5 cannot use — not a URL at all, or a scheme other
than `http://` or `https://`, such as `socks5://` — C5 does not quietly connect
directly instead. Every connection that proxy would carry is refused until the
value is fixed or removed; hosts on the bypass list and the machine itself are
still reached directly. `growther doctor` fails its proxy check and says why.
The same goes for a proxy URL that your device policy locks but C5 cannot use.
C5 also writes a warning to its log once for each such value:
`[net] the configured proxy … cannot be used: …`.

The **Network** card shows it plainly, whatever the egress posture (going back
online does not make a broken proxy usable):

- the status pill reads **Proxy unusable — connections refused** instead of
  *Online through a proxy*;
- an alert says **C5 refuses to connect through the configured proxy.**, gives
  the reason (*It cannot be used: …*), and says that every connection it would
  carry is refused, never made directly, until the proxy URL is fixed or
  removed;
- the **Outbound proxy** field shows the value as configured, followed by
  *— cannot be used: \<reason\>*. Any password in it is hidden.

**How a policy sets the proxy.** The proxy is taken from a policy only when the
policy **locks** it:

- **Locked to a proxy URL** — that proxy is used. A locked value C5 cannot use
  (`socks5://`, a malformed URL, a list of several blank entries) is refused:
  every connection the proxy would carry is refused, never made directly.
- **Locked to an empty value** (an empty string in `policy.d`, an empty
  `<string>` in a configuration profile, an empty registry value) — no proxy:
  C5 connects directly, and nobody on the device can set one.
- **Recommended (not locked)** — not applied at all, well-formed or not: the
  value in the environment or `c5.yaml` decides. A malformed recommended value
  does not take the machine offline; it is listed among the rejected keys under
  **Settings › Enterprise › Policy**.

C5 gives the same answer from the moment it starts, before it has loaded your
whole policy, as after.

A change to any of the four is picked up by a running C5 **within about 30
seconds**: the outbound stack is rebuilt in place, with no restart. Connections
already open finish on the settings they started with.

The console may still show a "restart needed" hint for these four. You can
ignore it: C5 picks the change up within about 30 seconds.

These four can come only from device policy (Group Policy, macOS managed
preferences or `/etc/growther`) or from the environment, never from a signed
policy document on a share or web address. Otherwise, a document that changed
your proxy could also intercept the download of the next document.

### The certificate pin and your proxy

With `mothershipTlsPin` **on**, platform calls still go through your proxy. The
proxy opens a tunnel, and the pin is checked on the encrypted connection inside
it — so a proxy that only passes traffic through works with the pin on. Only a
proxy that decrypts and re-signs traffic needs the pin off, as below.

### Behind a TLS-inspecting proxy

If your proxy re-signs TLS, C5 will not trust it until you give it the
authority. Deliver both values the same way you deliver the rest of your policy:

1. Export your proxy's root CA as PEM and put it somewhere every device can read.
2. Set `caBundlePath` to that path.
3. Set `mothershipTlsPin` to `off` — the pin exists to detect exactly what your
   proxy is doing, so switching it off must be a deliberate, recorded decision
   rather than a silent failure.
4. Wait about 30 seconds, or restart C5 if you would rather not wait.
5. Check it: select **Test connectivity** on the same screen, or run
   `growther doctor` and look at the **Proxy reachability** row. Every host
   should answer.

Turning pinning off is the one step here that removes a protection. Leave it
`on` unless you are actually behind an inspecting proxy.

### When the proxy says no

A failed update check, a failed `growther update`, or a failed model download
(the local classifier's, the offline speech model's or memory search's, whether
C5 started it or you ran a `pull` command) names the cause rather than only
saying "fetch failed": the certificate pin, an untrusted certificate, or the
proxy that refused. The local classifier's message gives the cause straight
after *Could not download the classifier model:*; the memory-search and speech
downloads give it after *fetch failed:*. A proxy refusal reads like this:

```text
the proxy http://proxy.corp.example:3128 refused to open a tunnel to api.growther.si:443: it answered CONNECT with 407 Proxy Authentication Required; it wants credentials — put them in the proxy URL (http://user:password@host:port), C5 speaks Basic proxy authentication only
```

Credentials in your proxy URL are never printed. The end of the line tells you
what to do:

| What the message says | What it means, and what to do |
| --- | --- |
| The proxy answered CONNECT with `407` | The proxy wants credentials. Put them in the proxy URL (Basic authentication only) |
| The proxy answered CONNECT with `403` | Its policy does not allow this host. Ask for the host to be allowed |
| The proxy answered CONNECT with `502`, `503` or `504` | The proxy could not reach the host itself |
| *Mothership TLS public-key pin mismatch* | Your proxy is decrypting and re-signing the platform connection. Follow [Behind a TLS-inspecting proxy](#behind-a-tls-inspecting-proxy) above |
| A certificate C5 does not trust, in the system's own words — for example *self-signed certificate in certificate chain* or *unable to get local issuer certificate* | Your proxy re-signs traffic with its own authority. Add its root CA with `caBundlePath` |
| *C5 refused to connect to … the configured proxy … cannot be used* | The proxy setting is not something C5 can use (see [An unusable proxy stops traffic](#corporate-proxy) above). Fix or remove it |

`growther doctor` checks the proxy from the command line. With a proxy
configured, its **Proxy reachability** row asks the proxy for four hosts: the
platform, the licence service, the release mirror and `github.com`. It asks no
more than four, so if the proxy is down, doctor waits for one round of
time-outs, not many. It warns with every host
that failed: *Allow these hosts on the proxy, or add its CA to the CA bundle.*
If the proxy setting is one C5 cannot use, the row fails without asking any
host, and says the setting must be an `http://` or `https://` address.

## What C5 contacts, and why

This is the list for a firewall ticket. **Test connectivity** on the same
screen (administrators only) asks each host on it through your real proxy
settings and reports which answered. `growther doctor` prints the same list on
its **Control-plane hosts** row.

| Host | Why |
| --- | --- |
| `api.growther.si` | The signed version manifest and update catalogue, the licence check-in clock, and the shared catalogue of improvements (flywheel sync) |
| `license.growther.si` | Device-code activation, licence refresh and key rotation. C5 checks the licence's signature itself, so this host only carries it |
| `raw.githubusercontent.com` | The release mirror: installer scripts and self-update binary assets. Every asset is SHA-256 checked against the signed manifest |
| `github.com` | Remote Control: C5 downloads Cloudflare's `cloudflared` from its releases there, only when a Cloudflare tunnel starts and the program is not already on the machine. Its size and SHA-256 are checked before it runs |
| `release-assets.githubusercontent.com` | Where `github.com` redirects that download today. Reached only by following that redirect. The host is GitHub's choice and can change ([above](#hugging-face-redirects-to-a-download-network)) |
| `huggingface.co` | Model downloads: the three memory-search models, the offline speech model, and the local classifier's model (only while the classifier is on, or when someone runs `growther classifier pull`). Stopped by the offline posture; each automatic download also by its `GROWTHER_*_NO_AUTO_DOWNLOAD` variable |
| `cas-bridge.xethub.hf.co` | Hugging Face's download network. Reached only by following a redirect from `huggingface.co` |
| `cdn-lfs.hf.co` | Hugging Face's download network, as above |
| `cdn-lfs-us-1.hf.co` | Hugging Face's download network (US), as above |
| `cdn-lfs-eu-1.hf.co` | Hugging Face's download network (EU), as above |
| `cdn-lfs.huggingface.co` | Hugging Face's older download-network name, as above |
| `api-inference.huggingface.co` | The default Hugging Face inference endpoint (the Inferencer provider) — only when you have configured that provider with an API token and no address of your own. An `HF_TOKEN` or `INFERENCER_API_KEY` in C5's environment counts as one. An install that has not configured this provider sends it nothing, and while the posture is offline C5 makes no background check of it |
| `growther.si` | The canonical installer scripts, and product documentation linked from the console |
| `docs.growther.si` | Documentation, reached only when someone clicks a link |

That is fourteen hosts by default; `growther doctor` prints the same count. The two
GitHub hosts matter only if you use Remote Control with a Cloudflare tunnel, but allow
both if you do: allowing `github.com` alone fails at the redirect. Once the tunnel runs,
it connects to Cloudflare's network — see
[Privacy and Cloudflare](../remote-control/privacy-and-cloudflare.md).

If you point C5 at a relay or mirror with **Platform address**
(`GROWTHER_PLATFORM_BASE_URL`), that host is listed first and the default is
still listed — a binary that has not yet read your policy, such as the
installer, will use the default.

Nothing on this list carries your work. The databases, your notes and your
deliverables never leave the machine.

## Why C5 listens on two addresses

`localhost` is not one address. It is two — `127.0.0.1` on IPv4 and `::1` on
IPv6 — and which one a program gets depends on how its resolver is configured.
C5 serves its own address bar name, and passkeys are bound to it, so it listens
on **both** by default.

You will see both in the boot log:

```text
[bootstrap] C5 API running on http://127.0.0.1:4299
[bootstrap] C5 API also on http://[::1]:4299
```

Open C5 at `http://localhost:4299` all the same; that is the address C5 opens in your
browser. Passkeys are tied to the name `localhost`, not to either number.

This changes nothing about who can reach C5. Both addresses are loopback, so
the server is still reachable only from the computer it runs on, and the host
check, the browser-origin allowlist and the passkey origin rules all behave
exactly as they did.

If IPv6 is switched off on your machine — some hardened Linux builds and some
Windows configurations do this — the second listener cannot start. That is not
a failure and C5 does not stop for it; you get a line naming the reason and the
address that does work:

```text
[bootstrap] no ::1 listener (EAFNOSUPPORT) — C5 is reachable on 127.0.0.1 only. If a browser resolves localhost to ::1 it will need http://127.0.0.1:4299 instead.
```

Setting `GROWTHER_BIND_HOST` to a real interface or to `0.0.0.0` is a
deliberate choice to widen exposure, and C5 does **not** pair those with a
second address: you asked for one family, and pairing would quietly add the
other.

## Making C5 reachable from another machine

By default C5 binds to loopback only: the server is reachable from the computer
it runs on and from nowhere else. To serve it to other machines you must say so
explicitly, and say which names you will serve.

| Variable | Default | What it does |
| --- | --- | --- |
| `GROWTHER_BIND_HOST` | `127.0.0.1` | The interface to bind. Set `0.0.0.0` for a deliberate self-host deployment |
| `GROWTHER_ALLOWED_HOSTS` | loopback names | Comma-separated host names C5 will answer to |
| `GROWTHER_ALLOWED_ORIGINS` | the C5 origin | Comma-separated browser origins allowed to call the API. Never a wildcard |
| `GROWTHER_WEBAUTHN_ORIGINS` | the C5 origin | Origins a passkey may be registered and used on |
| `PORT` | `4299` | The port C5 serves on, in every environment |

Three things to get right together, or sign-in breaks in a way that is hard to
read:

- **Binding to a real interface turns the host check off unless you turn it back
  on.** Bound to loopback, only loopback host names are accepted. Bound to
  `0.0.0.0`, setting `GROWTHER_ALLOWED_HOSTS` enables the check for exactly the
  names you list — and leaving it unset is an explicit opt-in to answering any
  `Host` header at all. Set it.
- **WebAuthn origin checking is exact.** A passkey collected on
  `https://c5.corp.example` is refused at `https://c5.corp.example:8443`. If
  you serve C5 under a real name, set `GROWTHER_WEBAUTHN_ORIGINS` to match
  exactly what the browser will show — including the scheme and any port.
- **`PORT` moves everything.** The allowed origins and the WebAuthn defaults
  are derived from it, so changing the port does not strand them — but a
  hard-coded origin in your own reverse-proxy configuration will.

Serving C5 beyond loopback also means the loopback trust boundary no longer
does the work it used to. Put it behind a reverse proxy that terminates TLS,
and read [Reaching C5 by a corporate name](../security/corporate-name.md),
which covers moving passkeys to that name without invalidating the ones people
already hold.

## Related

- [Managed configuration](enterprise-policy.md) — locking any of these keys fleet-wide, the local classifier included
- [Where your data lives](data-location.md) — where each downloaded model is kept, and placing one by hand
- [Open-source licences and downloaded models](../security/open-source-and-models.md) — who publishes each model, and its licence
- [Local classifier](../tools/local-classifier.md) — the classifier's model, and what it does
- [Memory search](../tools/memory-search.md) — the three memory-search models
- [Voice](../using-c5/voice.md) — the offline speech model
- [Deploying C5](deploying.md) — what to prepare before a rollout
- [Connecting to the platform](../mothership/connecting.md) — activation and check-in
