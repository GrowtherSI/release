---
title: Turning it on and pairing a phone
description: Turn Remote Control on, accept the terms, pair a phone by QR code, set leases, and the Advanced options for your own address, certificate, or tunnel.
order: 2
---

# Turning it on and pairing a phone

Everything on this page happens in C5 on the machine, under **Settings › Remote Control**.
A device that is itself paired remotely can look at this tab but cannot change it.

You need permission to change settings. An administrator has it; other accounts have it only
if an administrator granted it under
[Access & user permissions](/c5/configuration/settings#access--user-permissions-rbac).

## Step 1 — Turn Remote Control on

Flip the switch labelled **Publish this machine's address**.

The first time, the switch does not move: the acceptance dialog opens instead, and Remote
Control turns on only once you have agreed. **Agree** turns it on and saves it in the same
step — there is no Save to press. **Cancel** leaves it off.

You press **Save** only when you change the other fields on the tab, or when you turn
Remote Control on again later, after the terms have already been accepted.

### The acceptance dialog

The dialog shows the Terms version and its effective date, and the full text of Section 14,
Remote Control, of the [Growther Terms of Service](https://growther.ai/t=remote-control). It
also links to [Cloudflare's terms](https://www.cloudflare.com/terms/) and
[Cloudflare's privacy policy](https://www.cloudflare.com/privacypolicy/), because the address
Growther issues is carried by Cloudflare under Cloudflare's own agreements.

To accept:

1. Scroll to the end of the text. The checkbox stays disabled until you have.
2. Tick **I have read Section 14 and I accept it, including that Cloudflare carries sessions
   through the address Growther issues**.
3. Press **Agree**.

**Cancel** leaves the switch off. Once accepted, the dialog is not shown again unless the
Terms change; the tab shows a line like _Terms v1.5 accepted by Ana Ruiz on Sep 24, 2026_ — the name of
whoever accepted, your own included — with a **View** link that reopens the text. Only when
that account no longer exists on the install — deleted since — does the line fall back to
the account id.

If you want Remote Control without the issued address — on your own network only, or with a
tunnel or certificate you supply — you still accept the same Section, because it is the one
that describes all three ways in.

### If Remote Control was already on before this version

An install that upgrades with Remote Control already on keeps working: nothing is torn down,
no device is signed out, and the address stays up. What changes is that this version records
who accepted the Terms, and an upgraded install has no such record yet. The next time you
press **Save** on this tab — whichever field you changed — or turn Remote Control off and on,
the acceptance dialog opens, and the save goes through only once you have agreed. Until
then the tab shows no _accepted_ line; **Cancel** leaves the install as it was.

### What happens next

C5 confirms with a brief message — _Remote Control on. This machine will publish its
address shortly._ Behind that:

- the machine starts serving a secure (https) address on your own network;
- unless you supplied your own tunnel under Advanced, C5 asks Growther for an address and
  Growther creates a Cloudflare Tunnel for this install. **Reach this machine from anywhere**
  shows _Connected_ and the address, of the form `https://<label>.rc.growther.ai`, once the
  tunnel is up;
- the machine reports its name and addresses to your account, so
  [rc.growther.ai](https://rc.growther.ai) can list it.

Nothing needs configuring on your router.

### The other switches

| Switch                                           | What it does                                                                              |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------- |
| **Enable Remote Control for non-admin accounts** | Lets accounts that are not administrators pair devices. Off means only administrators can |
| **Read-only for remote devices**                 | Every remote device, administrators included, can look but not change anything            |
| **Read-only restriction for non-admin accounts** | Only non-administrator remote devices are read-only                                       |

Read-only is a preference for how you want to use your install from a phone, not a security
boundary. The things a paired device can never do are listed in
[Managing devices](/c5/remote-control/managing-devices) and are refused whatever these
switches say.

## Step 2 — Pair your phone

Pairing needs Remote Control on and saved; the tab says so if it is not.

1. Set the **Default sign-in lease** — how long a newly paired device stays signed in each
   time, from one hour to seven days. Twenty-four hours unless you change it. You can change
   it per device afterwards.
2. Press **Show pairing code**. C5 shows a QR code and, under it, one chip per address it can
   be paired against — your network addresses and, when the tunnel is up, the issued one.
   Press a chip to point the code at that address; pressing it also copies the link, for a
   device that cannot scan.
3. Open the camera on your phone or tablet and scan the code. It offers to open the link.
4. Follow the pairing screen on the phone.

The code **expires in three minutes and works once**. If it lapses, press
**Generate new code**.

Each device creates its own key during pairing. The key never leaves the device; the machine
stores only the matching public half. Treat the code like a key while it is on screen: anyone
who scans it first is the device that gets paired.

> **Note**
> If you pair against a network address rather than the issued one, your phone will warn
> that the certificate is not trusted. That is expected — this machine signed it itself.
> Accept it once per device, and only on a network you trust. Pairing against the issued
> address, or supplying your own certificate, removes the warning.

## Finding the machine later

Once paired, the phone connects straight to the machine at the address it was paired
against. If that address changes — a different Wi-Fi network, a restart — sign in at
[rc.growther.ai](https://rc.growther.ai) with your licence email. It lists your installs and
their current addresses and hands you off to the right one with a link. **Open the portal**
on the tab takes you there.

A portal sign-in lasts seven days. **Sign out everywhere** on the portal ends portal
sign-ins only; it does not touch paired devices.

## Advanced — your own address, certificate, or tunnel

Fold open **Advanced — your own address, your own certificate** when the turnkey path does
not suit you. Each option is independent.

> **Note**
> While Remote Control is on, a Public address you set here, and the names on a certificate
> you supply, accept paired devices only — exactly like the issued address. A password, PIN,
> passkey, or directory sign-in typed at one of those names is refused. Sign in that way at
> the machine itself, or at its plain network address.

**Public address (optional).** An address of your own, origin only — `https://box.example.com`,
no path. C5 offers it first, ahead of the addresses it detected on the machine. Use it when
you already have a tunnel or a name that reaches this machine.

**Run your own tunnel instead.** Create a tunnel in Cloudflare Zero Trust on your own
account and, in the same dashboard, give it a public hostname in a zone you own — that
record is what makes the name reach the tunnel, and only you can create it. Copy the tunnel's
token, paste it here, enter that hostname as the **Public address** above, and Save. C5 runs
the connector and sends the tunnel's traffic to this machine. While a token you pasted is
saved, Growther issues nothing for this install and holds no credential for your tunnel. The
token is stored on this machine and never shown again; leave the field blank later to keep
the one already saved. Your tunnel provider is in the path in the same way Cloudflare is for
an issued address, under your agreement with them rather than Growther's.

Turning Remote Control off **keeps** the pasted token. Everything else is torn down as usual —
the connector stops and its credential files are removed, every device is signed out, and your
addresses are withdrawn (see
[What turning off does](/c5/remote-control/managing-devices#what-turning-off-does)) — but the
token stays saved on this machine, and Growther is not asked to release anything, because it
holds nothing for your tunnel. Only an address Growther issued is given back when you turn off.
When you turn it back on, C5 runs your tunnel again from the saved token, with no request to
Growther; there is nothing to paste again.

Your tunnel answers for the host of the **Public address** you set above. If you set none, it
answers for the hostname you gave the tunnel in your Cloudflare dashboard, which is then the
only place that knows the name. It never answers for a `<label>.rc.growther.ai` address — that
name points at a tunnel on Growther's account, not yours.

**Your own certificate (optional).** Give the paths to a certificate chain and its private
key — `/etc/letsencrypt/live/box.example.com/fullchain.pem` and
`/etc/letsencrypt/live/box.example.com/privkey.pem`, for example — and the machine serves
them itself: a trusted address with no certificate warning and no reverse proxy. C5 reads the
files rather than a pasted copy, so your renewal tool can rewrite them on its own schedule. A
pair that does not match, or is past its validity date, is refused and the self-signed
certificate is used instead. The tab shows the name this machine would use if you want to
get a certificate for that.

A name is not a route. A record pointing at a private address only resolves on your own
network, and one pointing at your home connection still needs the port opened on your router.
If you want it to work while you are out, a tunnel is less work than either.

## Over SSH, with no address at all

If you already reach the machine over SSH, you need none of the above:

```bash
growther connect user@host
```

This forwards a local port over your SSH connection and opens C5 in your browser at
`http://localhost:4399`. Nothing is published, no certificate is involved, and no pairing is
needed — you sign in as you would at the machine, over a channel your SSH already secures.

`growther connect` checks that the two ends are different machines and refuses if they are
not. Use `--local-port N` to pick another local port; `--remote-port N` if the far C5 is not
on 4299.

## Where to go next

- [Managing devices](/c5/remote-control/managing-devices) — revoking, leases, turning off.
- [Privacy and Cloudflare](/c5/remote-control/privacy-and-cloudflare) — what the issued
  address means for your data.
- [Voice from a paired phone](/c5/using-c5/voice#voice-from-a-paired-phone) — off until
  you turn it on at the machine, and where the audio goes when you do.
