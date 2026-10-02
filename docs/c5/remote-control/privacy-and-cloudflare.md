---
title: Privacy and Cloudflare
description: What is encrypted and what is signed, who is in the path on each address, what Growther.si receives and keeps, and what it never does.
order: 4
---

# Privacy and Cloudflare

This page is the trust statement for Remote Control: what is encrypted, what is signed, who
is in the path on each address, and what Growther.si receives, keeps, and never does. It is
exact where exactness matters, so that it is a page you can rely on.

## Who is in the path

**Every hop is encrypted. Through the address Growther.si issues, Cloudflare is in the path.**

That address — `<label>.rc.growther.si` — is served through a Cloudflare Tunnel that
Growther.si creates for your install on Growther.si's Cloudflare account. Your device
connects to Cloudflare over HTTPS, and Cloudflare connects to your machine over an encrypted
tunnel; nothing travels the internet unencrypted. Cloudflare operates the address, and, as
for any site served through Cloudflare, the connection is decrypted within Cloudflare's
network in order to be routed to your machine. So the session is not end-to-end encrypted
between your device and your machine, and Cloudflare is in a position to see it as it passes
through. Growther.si is not.

This is how a tunnel of this kind works, not a C5 setting. Cloudflare's handling of traffic
passing through its network is governed by [Cloudflare's terms](https://www.cloudflare.com/terms/)
and [Cloudflare's privacy policy](https://www.cloudflare.com/privacypolicy/), not by
Growther.si, and you acknowledge that when you accept the terms in C5.

**If you would rather have no third party in the path**, use your own network, your own SSH
connection with `growther connect`, your own name and certificate, or your own tunnel. Each
of those is described in [Setup](/c5/remote-control/setup), and each keeps working without
Growther.si.

## Encrypted in transit, signed against tampering

C5 adds its own protection on top of the encrypted connections, and it is worth being exact
about what it does.

**Ordinary requests and responses are signed.** Every normal request from a paired device,
and every normal response from the machine, carries a signature derived from that device's
pairing. Something in the path — Cloudflare or anything else — cannot fabricate a response,
replay one onto a different request, or change a result without the device refusing it.
Stripping the signature is refused, not ignored.

**Signing is in addition to encryption; it is not end-to-end encryption.** The connections
are encrypted hop by hop; signing proves who said something and that it was not changed on
the way. What it does not do is hide the content from the service that terminates the
connection, which through the issued address is Cloudflare.

**Streamed content travels over the same encrypted connections but is not signed.** Chat
replies as they arrive, file downloads, audit exports, and live event feeds are delivered as
streams, and streams are not signed. A change to a stream in transit would not be detected
the way it is for an ordinary response.

## What Growther.si receives

Your session content does not pass through Growther.si's servers, and Growther.si does not
receive it. This is true on every path, including the issued address: the portal hands you
off to your own machine with a link and is then out of the way.

To make the feature work, and **only while Remote Control is on**, your install sends
Growther.si's licensing service, signed with the install's own key:

- your machine's name, so you can tell your installs apart;
- up to four addresses it can be reached at, which may include addresses on your private
  network and the issued address.

These are shown only to someone signed in to your account at `rc.growther.si`. They are
refreshed on each licence check-in and deleted when you turn Remote Control off. When Remote
Control is off, your install sends nothing about your network.

## What Growther.si keeps

For an issued address, Growther.si keeps the tunnel's identifier and its hostname, so the
tunnel can be deleted later.

**The tunnel's connection secret is generated for your install, delivered to it once, and
not retained.** Growther.si holds no credential that can connect to your tunnel. If the address
has to be issued again — after you turn Remote Control off and on, for example — a fresh
secret is generated and the old tunnel is deleted.

The hostname is kept only while Remote Control is on. Turning it off deletes the tunnel and
the address on Growther.si's side; so does a licence being revoked, cancelled, paused, or shut
off after the grace period, the deployment record being deleted, uninstalling C5, or an
install that has not checked in for thirty days.

## What Growther.si does not do

- It does not route, log, inspect, or store the content of your remote sessions.
- It does not place any service of its own — a proxy, an access gateway, or logging — in
  front of an issued address.
- It does not use the records above for anything other than operating Remote Control for
  you.
- It cannot revoke a paired device for you. Pairings live on your machine, not in your
  account, and only someone at the machine can revoke one.

## What Growther.si learns when you use the portal

Signing in at `rc.growther.si` uses the same email link as your licence account. Growther.si
sees that you signed in and when, and which installs are on your account with the addresses
each one published. It does not see what you do on your install afterwards, because the
hand-off is a link to your own machine and the portal is not in the path after it.

## The connector C5 runs

A tunnel — the address Growther.si issues, or a tunnel of your own on Cloudflare — is
carried by Cloudflare's connector program, `cloudflared`, running on your machine. It is
open-source software from Cloudflare under the Apache License 2.0, used only to carry
traffic to your own install. C5 does not ship it inside its download, and does not use any
copy already installed on your system:

- **It is fetched only when needed.** The first time a tunnel starts, C5 downloads it from
  Cloudflare's releases on GitHub (`github.com/cloudflare/cloudflared`, which redirects to
  GitHub's file-download host, `release-assets.githubusercontent.com`). Turning Remote
  Control on without a tunnel downloads nothing.
- **It is one pinned version, checked before it runs.** Every C5 of this release fetches
  `cloudflared` 2025.8.1, holds the download to its exact published size, and checks its
  sha256 fingerprint against the one recorded in C5 before running it. On macOS the
  archive is checked before it is unpacked, and the program inside is checked again. A
  download that does not match is thrown away and never run.
- **It is checked again at every start.** A copy already on disk that no longer matches —
  replaced by something else, say — is discarded and downloaded afresh.
- **It goes through your network settings.** The download uses the proxy and certificate
  authorities set under **Settings › Enterprise › Network**, like everything else C5
  fetches.
- **Offline means no tunnel.** While the egress posture is **Offline**, C5 does not
  download it, so no tunnel starts. Your own network addresses and `growther connect` keep
  working.
- **It lives with C5's own files**, at `~/.growther/config/rc-tunnel/cloudflared`
  (`cloudflared.exe` on Windows). On Windows on ARM, C5 runs the 64-bit Intel build, which
  Windows runs under emulation, because Cloudflare publishes no ARM build for Windows.

If the download fails, **Reach this machine from anywhere** says _Could not download the
tunnel program. Check this machine's internet access._ and C5 retries on its own. If what
arrived was the wrong file — something on the network altered it — C5 does not run it and
does not keep downloading it every minute; the line says _The tunnel program downloaded with
the wrong contents, so it was not run …_ and C5 tries again when you save Remote Control's
settings. See [Troubleshooting](/c5/remote-control/troubleshooting).

## Your own tunnel, your own provider

If you paste your own tunnel token under Advanced, or supply your own name and certificate,
Growther.si is not in the path and holds no credential for it. Your tunnel provider — Cloudflare
on your own account, Tailscale, ngrok — is in the path instead, under your agreement with
them, and most operate the way Cloudflare does: encrypted to and from them, with the
connection handled within their network. Choose one you are content to have there. Turning
Remote Control off keeps a token you pasted on your machine; Growther.si is not asked to
release anything, because it holds nothing for your tunnel.

## Voice

Voice on a remote device is off until you turn it on, and it can be turned on only in C5 on
the machine, under **Settings › Voice**. Every voice setting is changed at the machine: a
paired device is refused when it tries to change any of them, including which speech provider
the audio goes to. One tap on a phone captures live microphone audio,
sends it to the machine — through the tunnel, if that is the path — and the machine forwards
it to whichever speech provider you configured, or transcribes it on the machine itself if
your chain starts with **Built-in (on-device)**. You are responsible for any consent the
people being recorded are entitled to.

## What an unpaired caller can see

C5's health check, `/health`, answers anyone who can reach the machine, paired or not,
because supervisors and `growther connect` rely on it. To a caller who is neither signed in
nor paired, it says whether C5 is running and whether it is serving, the time, a random
number that changes every time C5 starts (which `growther connect` uses to tell two
machines apart), and how many AI requests C5 is running and how many are waiting, with
the limits it sets on them. It leaves out the details: how often the local classifier is used and
how fast it answers, and which agents those running and waiting requests belong to. Those
go only to a signed-in session that is not a paired device, or to a check made directly on
the machine itself (not through the issued address).

**A paired device gets the short answer too**, wherever it connects from — including a
device whose pairing was just revoked, which everything else on the machine already refuses.
C5 on a phone never needs the details: it uses the health check only to see that the machine
is there and serving.

## Limits, stated plainly

1. Through the issued address, Cloudflare is in the path: encrypted to and from it, not end
   to end. Signed, so a change in transit is detected.
2. Streamed responses are not signed.
3. A self-signed certificate on your own network will warn, and the warning is correct.
   Accept it only on a network you trust.
4. Some routers block a public name resolving to a private address, and pairing needs a
   secure (https) address, so C5 does not fall back to plain http. See
   [Troubleshooting](/c5/remote-control/troubleshooting).
5. Through the tunnel every caller reaches the machine from the same address, so unpaired
   attempts share one rate-limit allowance. Paired devices each get their own.
6. The issued address depends on Cloudflare and on capacity Growther.si does not control. It
   is provided as a convenience, is not guaranteed, and may be withdrawn or replaced if
   Cloudflare limits or suspends the service. Your own network, your own SSH connection, and
   your own tunnel are unaffected.

## The words that bind

This page describes; the Terms bind. Section 15 of the Growther.si Terms of Service, Remote
Control, is the text you accept in C5 (it was Section 14 before Terms version 1.8), and it is
at
[growther.si/t=remote-control](https://growther.si/t=remote-control). Cloudflare's own
[terms](https://www.cloudflare.com/terms/) and
[privacy policy](https://www.cloudflare.com/privacypolicy/) govern Cloudflare's part.
