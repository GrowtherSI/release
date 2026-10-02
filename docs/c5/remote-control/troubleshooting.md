---
title: Troubleshooting Remote Control
description: The address is not reachable, the tunnel program will not download, certificate warnings, two copies of an install fighting over one address, DNS rebinding, replies arriving late through the tunnel, rate limits, refused sign-ins, what to do when a lease expires, and what the no-longer-paired screen means.
order: 5
---

# Troubleshooting Remote Control

Most answers are on the tab itself, under **Settings › Remote Control** on the machine.
Start with the line under **Reach this machine from anywhere** — it says what the tunnel is
doing right now — and with **Paired devices**, which says what the machine last heard from
each phone.

## The address is not reachable

Read the status line under **Reach this machine from anywhere**:

| It says                                                         | What it means                                                                                                                                                             |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| _Connected. This machine is online and reachable at …_          | The tunnel is up. If the phone still cannot connect, the problem is on the phone's side: check it has a connection at all, and that it is opening the exact address shown |
| _Connecting…_                                                   | Wait a moment. The address is not live until this changes                                                                                                                 |
| _The connection stopped. It will be retried._                   | The machine lost its outbound connection. It reconnects on its own; check the machine's own internet access                                                               |
| _Not connected. Only addresses on your own network work today._ | No tunnel is running. Remote Control was just turned on, or the request for an address was refused. Save the tab to ask again immediately                                 |
| _Automatic setup is not available from your licence service._   | Your licensing service does not issue addresses. Run your own tunnel under Advanced                                                                                       |
| _Could not download the tunnel program. Check this machine's internet access._ | C5 could not fetch Cloudflare's connector, `cloudflared`, which every tunnel needs. It retries on its own. See [The tunnel program will not download](#the-tunnel-program-will-not-download) |
| _The tunnel program downloaded with the wrong contents, so it was not run — a proxy or security product on this network may be altering it. Once that is fixed, save Remote Control's settings to try again._ | The download arrived, but was not the exact file C5 pins. C5 does not run it, and does not retry on its own. See [The download did not match](#the-download-did-not-match) |
| _The tunnel program would not start on this machine._ | The connector was downloaded but would not run. C5 retries; if it keeps failing, check that security software is not blocking `~/.growther/config/rc-tunnel/cloudflared` |
| _Tunnels are not available on …_ | Cloudflare publishes no connector for this platform. Use your own network, `growther connect`, or your own address |

Two things outside the tab:

- **The machine has to be awake.** A laptop lid closed, or a desktop asleep, is not
  reachable by any path. Adjust the machine's sleep settings if it needs to be reachable
  while unattended.
- **The portal says _No address reported_.** The install has not told your account where it
  is. Open C5 on that computer and check Remote Control is on and saved; the address
  reaches the portal on the next licence check-in.

If nothing helps, `growther doctor` on the machine and `growther remote status` say what the
install believes its state to be.

## The tunnel program will not download

Every tunnel — the issued address or your own — runs Cloudflare's connector, `cloudflared`,
which C5 downloads the first time a tunnel starts. It fetches one pinned version from
Cloudflare's releases on GitHub and checks its size and sha256 before running it. When that
fails, the status line reads _Could not download the tunnel program. Check this machine's
internet access._ The usual causes:

- **The egress posture is Offline** (**Settings › Enterprise › Network**). C5 downloads
  nothing while offline, so no tunnel can start. Your own network addresses and
  `growther connect` still work.
- **A proxy or firewall blocks GitHub.** The download goes through the proxy and certificate
  authorities set under **Settings › Enterprise › Network**, to `github.com`, which
  redirects to GitHub's file-download host, `release-assets.githubusercontent.com`
  (GitHub has also used `objects.githubusercontent.com` for this). Ask for `github.com`
  and that host to be allowed; both are on the list **Test connectivity** checks under
  **Settings › Enterprise › Network**. If your proxy inspects TLS, C5 needs its root
  certificate — see [Network and egress](/c5/configuration/network).

C5 records the reason in its error log, with a line ending `the tunnel program did not
download — retrying in …s`, and tries again on its own — soon at first, then once a minute.
Once the cause is fixed, the tunnel comes up without anything further from you.

### The download did not match

When the download arrives but is not the exact file C5 pins — its fingerprint differs, the
server sent more than the published size, the archive does not hold the program, or the
program fails C5's own check — C5 throws it away and never runs it. That nearly always means
something on the network altered it: a proxy, or a security product that inspects downloads.

Retrying would fetch the same wrong file again, so C5 does not: the tunnel stays off, and
the status line reads _The tunnel program downloaded with the wrong contents, so it was not
run — a proxy or security product on this network may be altering it. Once that is fixed,
save Remote Control's settings to try again._ The error log has a line reading
`not retrying the cloudflared download automatically: …`, followed by the exact reason.

Ask your network team to let the download from `github.com` and
`release-assets.githubusercontent.com` through unaltered, then press **Save** on the Remote
Control tab (or turn Remote Control off and on) to try again.

## The phone warns that the certificate is not trusted

On your own network, this is expected. The machine issued that certificate itself, and
nothing outside it vouches for it, so your phone is right to say so. Accept it once per
device — and only on a network you trust. On a network you do not trust, a warning like this
is exactly the one you should not click through.

To be rid of the warning: pair against the issued address instead, which carries a
certificate your phone already trusts, or supply your own certificate under **Advanced**.
See [Setup](/c5/remote-control/setup).

## Two machines keep taking the address from each other

The symptom: the line under **Reach this machine from anywhere** says _Connected_ for a
while, then drops to _The connection stopped. It will be retried._ and stays there — and on
another machine the same address has just come up.

The address Growther.si issues is derived from your install's identity, and a copy of an
install shares that identity: a second copy restored from a backup, a cloned virtual
machine, or the old machine still running after you moved to a new one. When a copy asks for
its address, Growther.si treats it as the same install asking again: the tunnel the other copy
was using is deleted, a fresh one is created under the same name, and the address now points
at the copy that asked last. The other copy loses it — its connector keeps retrying a tunnel
that no longer exists — and takes it back the next time Remote Control is turned off and on
there.

Two copies cannot share one address, and `growther activate` does not separate them: on a
machine that already has an identity, it resumes as that same install, with the same
address. To settle it:

1. Stop C5 on the copy you are retiring (`growther stop`), and do not start it again. If it
   starts on its own, also run `growther service uninstall` there.
2. On the machine you keep, turn Remote Control off and on to take the address back.
   Turning it off unpairs every device, so pair your devices again afterwards.

Do not turn Remote Control off on the copy you are retiring while the other one is in use,
and do not run `growther uninstall` there, which turns it off too. The two share one
identity, so that would release the address the other machine is using.
If both machines must stay in use, contact support; see
[Getting help](/c5/troubleshooting/getting-help).

Occasionally the request for the address is refused with _public name already in use_. The
Save itself succeeds: the address is asked for in the background afterwards. The tab stays at
_Not connected…_, and the error log (`logs/errors.log` in your C5 folder) has a line such as
`could not get an address (HTTP 409): public name already in use. This will be retried in 60s.`
Most of the time it is this install racing itself — two asks for the address in flight at
once, such as a Save landing while the tunnel was still coming up — and it clears on its
own: C5 asks again twice, a minute apart, and saving the Remote Control tab asks again at
once. Only a refusal that persists across saves means the name derived for this install is
held by a different install on Growther.si's side — a coincidence, not a copy — and that
needs support to resolve. See
[Getting help](/c5/troubleshooting/getting-help).

## The name works on mobile data but not on home Wi-Fi

If you gave the machine a name of your own that points at a private address (one starting
`192.168.`, `10.`, or `172.16.` to `172.31.`), many home routers refuse to resolve it. The
feature is called DNS rebinding protection, and it is doing its job: a public name resolving
to a private address is also what an attacker would set up.

Your options:

- add the name to your router's rebinding allow-list, if it has one;
- pair against the network address chip instead of the name while at home;
- use the issued address, which does not resolve to a private address at all.

C5 does not fall back to plain `http://` on a network address: pairing needs a secure
(https) address.

## Chat replies arrive late, or in larger pieces, through the tunnel

Through the issued address, replies can arrive later or in larger pieces than at the
machine, because the path is longer and is not under Growther.si's control. The reply itself is
the same. On your own network, or over `growther connect`, it streams as it does at the
machine.

Nothing on the machine changes this. If it matters, use a direct path.

## "Too many attempts" while pairing through the tunnel

Through the tunnel, every caller reaches the machine from the same address, so the machine
cannot tell one stranger's connection attempts from yours until a device is paired. Paired
devices each get their own allowance; **unpaired** attempts — a pairing that has not
finished, a refused sign-in — share one. If the address is being probed, you can hit that
limit while pairing.

Wait a few minutes, or pair against a network address chip while you are on the same
Wi-Fi. Once paired, the device is no longer affected.

## The lease expired

When a device's sign-in lease runs out, the phone is signed out and lands on a screen saying
that the lease for this device has ended, and that someone at the machine can extend it — or
the phone can be paired again. It does not get back in on its own: leases are extended only
from the machine, so a phone whose lease has run out stays out until someone at the machine
lets it back in.

At the machine, under **Paired devices**, the device shows **Expired**, and the pencil next
to it offers to **Extend** the lease. Extending starts a fresh window from now, and the phone
gets back in with the key it already holds — open C5 on it again; there is no code to scan
and nothing to type. Use the same pencil to set a different length at the same time.

If extending is not offered, or the phone still cannot get in, one of these is true:

- the device was **revoked** at the machine. Pair it again;
- Remote Control was **turned off** at the machine, which revokes every device. Turn it on
  and pair again;
- the phone's stored key is gone — a cleared browser, a reinstalled app. Pair again.

## The phone says _Device No Longer Paired_

Someone at the machine revoked this device, turned Remote Control off, or pressed
**Disconnect everything**. It happens the moment they do it, not the next time the phone
asks: the phone's live connection is closed, and the app is replaced by this screen even if
it was in use — nothing it had on screen stays usable. A phone that was offline at the time
sees the same screen the next time it reaches the machine.

There is nothing to retry from the phone, and refreshing the page will not reconnect it. If
it should still have access, pair it again from **Settings › Remote Control** in C5 on the
machine, as the screen says; the key it held before is not reused. A lease that has run out
shows a different screen, _This Device's Lease Has Ended_ — see
[The lease expired](#the-lease-expired); there, extending the lease at the machine is enough.

If the phone shows _Server disconnected — retrying…_ instead, that is a different thing: the
machine is unreachable, not the pairing gone. See
[The address is not reachable](#the-address-is-not-reachable).

## Sign-in at a remote-facing name is refused

While Remote Control is on, every name that faces the outside accepts only a paired device:
the issued address, a **Public address** you configured under Advanced, and the names on a
certificate you supplied. A password, a PIN, a passkey, or a directory sign-in typed at one
of those names is refused with a message saying to use a device you have paired, or to pair
this one from C5 on the machine. This is deliberate: a shared secret that can be typed
anywhere is exactly the kind of credential a public name should not take.

The same sign-in works as it always has at the machine itself and at its plain network
addresses (`https://192.168…`, for example).

## Where to go next

- [Managing devices](/c5/remote-control/managing-devices) — revoke, leases, Disconnect
  everything.
- [Common issues](/c5/troubleshooting/common-issues) — for problems with C5 itself.
- [Getting help](/c5/troubleshooting/getting-help)
