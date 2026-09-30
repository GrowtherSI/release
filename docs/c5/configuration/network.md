---
title: Network and egress
description: The offline switch, corporate proxy, bypass list, private CA bundle and certificate pin; every host C5 contacts and why; how to make C5 reachable from another machine.
order: 9
---

# Network and egress

C5 runs entirely on your computer, but it does reach out for a few things: your
licence, updates, and — if you use them — downloaded models. This page is the
complete account of what it contacts, how to route that through your proxy, and
how to turn all of it off.

Everything here is set under **Settings › Enterprise › Network**, and every key
can be locked by an organisation policy so nobody on the device can change it.

## Turn off every outbound connection

**Egress posture** is the one switch. Set it to **Offline** and C5 stops making
outbound connections entirely — there is no second setting to remember and no
loop that keeps its own exception:

| Loop | What stops |
| --- | --- |
| Licence refresh | No refresh, no key rotation. Your licence runs on its offline grace period |
| Platform check-in | No check-in |
| Flywheel sync | No catalogue pull, no artefact upload |
| Background update check | Stopped. `growther update` run by hand still contacts the platform — the posture does not gate a command you typed |
| QMD model pull | No embedding, reranker or query-expansion downloads |
| Speech model pull | No offline speech model download |
| Error reports | Nothing is sent |

Offline is a posture, not a firewall rule: C5 refuses to start the connection
itself, so it holds even where the network would have allowed it. A loop that
skips writes one line an hour at most, so you can see the posture being honoured
without the log filling with it.

**What it does not cover.** Offline governs the loops C5 runs on its own
schedule — the table above. It does not stop traffic *you* have configured: a
cloud model provider still answers an agent's request, and a web-search tool
still reaches its endpoint, because those happen because someone asked for them.
Restrict those separately with the provider allow-list and the guardrail domain
allow-list.

Two details worth knowing:

- The posture is read **synchronously and from policy first**. Some downloads
  decide before they open a socket, so a cold cache falls back to the policy
  value rather than to "online" — an air-gapped install never makes the call
  once per boot on the way to finding out it shouldn't.
- A read that **fails** keeps the last known posture. "I could not read the
  posture" is not treated as permission to start talking.

When an administrator locks this key, the console shows a padlock and the
control is frozen.

## Corporate proxy

| Setting | Key | What it does |
| --- | --- | --- |
| Outbound proxy | `proxyUrl` | An HTTP(S) proxy URL used for every outbound connection |
| Proxy bypass list | `proxyNoProxy` | Hosts, domain suffixes and IPv4 CIDRs that go direct |
| CA bundle | `caBundlePath` | A PEM file of extra certificate authorities, for a TLS-inspecting proxy |
| Certificate pinning | `mothershipTlsPin` | Whether the platform connection pins its certificate. `on` by default |

Loopback always bypasses the proxy, whether or not you list it.

**These four are delivered, not typed.** In a shipped build the Network card is
read-only: set them through Group Policy, macOS managed preferences or
`/etc/growther`, or through the launcher environment / `c5.yaml` as
`GROWTHER_PROXY_URL`, `GROWTHER_NO_PROXY`, `GROWTHER_CA_BUNDLE` and
`GROWTHER_MOTHERSHIP_TLS_PIN`. The card is where you confirm what arrived.

A change to any of the four is picked up by a running C5 **within about 30
seconds**: the outbound stack is rebuilt in place, with no restart. Connections
already open finish on the settings they started with.

(The key registry marks these `applies: restart`, which is why you may see a
restart hint in the console. The runtime re-reads them; the metadata is
conservative.)

These four are **L1-only keys**: they can be set by Group Policy, macOS managed
preferences or `/etc/growther`, but never by a signed policy document from a
file or an https source. A document that could redirect your proxy or add a
certificate authority would be able to intercept the connection that fetches
the next document.

### Behind a TLS-inspecting proxy

If your proxy re-signs TLS, C5 will not trust it until you give it the
authority. Deliver both values the same way you deliver the rest of your policy:

1. Export your proxy's root CA as PEM and put it somewhere every device can read.
2. Set `caBundlePath` to that path.
3. Set `mothershipTlsPin` to `off` — the pin exists to detect exactly what your
   proxy is doing, so switching it off must be a deliberate, recorded decision
   rather than a silent failure.
4. Wait about 30 seconds, or restart C5 if you would rather not wait.

Turning pinning off is the one step here that removes a protection. Leave it
`on` unless you are actually behind an inspecting proxy.

## What C5 contacts, and why

This is the list for a firewall ticket. **Test connectivity** on the same
screen probes each of these through your real proxy settings and reports which
answered.

| Host | Why |
| --- | --- |
| `api.growther.si` | The signed version manifest and update catalog, the licence check-in clock, the flywheel catalogue and artefact downloads, and anonymous error reports |
| `license.growther.si` | Device-code activation, licence refresh and key rotation. Verification is Ed25519 against a pinned key — the host is only the transport |
| `raw.githubusercontent.com` | The release mirror: installer scripts and self-update binary assets. Every asset is SHA-256 checked against the signed manifest |
| `huggingface.co` | Model pulls: the QMD embedding, reranker and query-expansion models, and the offline speech model |
| `api-inference.huggingface.co` | The default Hugging Face inference endpoint — only when you have configured that provider |
| `growther.si` | The canonical installer scripts, and product documentation linked from the console |
| `docs.growther.si` | Documentation, reached only when someone clicks a link |

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
[bootstrap] C5 API running on http://localhost:4299
[bootstrap] C5 API also on http://[::1]:4299
```

This changes nothing about who can reach C5. Both addresses are loopback, so
the server is still reachable only from the computer it runs on, and the host
check, the browser-origin allowlist and the passkey origin rules all behave
exactly as they did.

If IPv6 is switched off on your machine — some hardened Linux builds and some
Windows configurations do this — the second listener cannot start. That is not
a failure and C5 does not stop for it; you get a line naming the reason and the
address that does work:

```text
[bootstrap] no ::1 listener (EAFNOSUPPORT) — C5 is reachable on 127.0.0.1 only.
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

- [Enterprise policy](enterprise-policy.md) — locking any of these keys fleet-wide
- [Deploying C5](deploying.md) — what to prepare before a rollout
- [Connecting to the platform](../mothership/connecting.md) — activation and check-in
