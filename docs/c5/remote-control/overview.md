---
title: What Remote Control is
description: Reach your own C5 from a phone, tablet, or another computer. The three ways in, and who can see what on each.
order: 1
---

# What Remote Control is

Remote Control lets you use your own C5 from a phone, a tablet, or another computer. It is
**off until you turn it on**, and it is turned on, changed, and turned off only in C5 on the
machine itself — never from a device that reaches it remotely.

This page says what it is and what each party in the path can see. The other pages in this
section cover [turning it on and pairing a phone](/c5/remote-control/setup),
[managing paired devices](/c5/remote-control/managing-devices),
[privacy and Cloudflare's role](/c5/remote-control/privacy-and-cloudflare), and
[troubleshooting](/c5/remote-control/troubleshooting).

## Three ways to reach your install

| Way in                                                           | How your device gets there                                            | Who is in the path             |
| ---------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------ |
| **Your own network**, or a name and certificate you supply       | Straight to the machine                                               | Nobody but you and the machine |
| **Your own SSH connection**, with `growther connect`             | Through a channel your SSH already secures                            | Nobody but you and the machine |
| **An address Growther.ai issues**, like `<label>.rc.growther.ai` | Through a Cloudflare Tunnel that Growther.ai creates for your install | Cloudflare                     |

The first two need nothing from Growther.ai and keep working without it. The third is the one
that works from anywhere without touching your router, and it is the one with a real
disclosure attached: Cloudflare carries the session and can read it in transit. That is
explained plainly in [Privacy and Cloudflare](/c5/remote-control/privacy-and-cloudflare),
and you accept it in C5 before the address is issued.

## Who can see what

| Path                                               | Who can read your session         | Who can change it without you noticing                        |
| -------------------------------------------------- | --------------------------------- | ------------------------------------------------------------- |
| On the machine itself                              | Nobody                            | Nobody                                                        |
| Your own network, or your own name and certificate | Nobody                            | Nobody                                                        |
| Your own SSH connection                            | Nobody                            | Nobody                                                        |
| The address Growther.ai issues                     | **Cloudflare**                    | Nobody, for ordinary requests. Streamed content is not signed |
| Signing in at `rc.growther.ai`                     | Growther.ai sees the sign-in only | Nobody                                                        |

"Streamed content" means chat replies as they arrive, file downloads, audit exports, and live
event feeds. C5 signs ordinary requests and responses so that a change made in transit is
detected; it does not sign streams, and it does not encrypt any of it end to end. Nothing
here changes what your AI providers see: they receive whatever you send them, on your own
account, with or without Remote Control.

## What Growther.ai receives

Your session content never passes through Growther.ai's servers. While Remote Control is on,
your install sends the licensing service — signed with the install's own key — your
machine's name and up to four addresses it can be reached at. They are shown only to
someone signed in to your account at `rc.growther.ai`, and they are deleted when you turn
Remote Control off. When it is off, your install sends nothing about your network.

## The portal, in one paragraph

`rc.growther.ai` signs you in with the same email link as your licence account, lists the
installs on your account with the addresses each one published, and hands you off to your
own machine with a link. After that hand-off the portal is out of the path. It is a
directory, not a relay.

## What it does not do

- It does not make your install public. While Remote Control is on, every name that faces
  the outside — the issued address, a **Public address** you configured, and the names on a
  certificate you supplied — accepts only a device you have paired; passwords, PINs,
  passkeys, and directory sign-ins are refused there. They still work at the machine itself
  and at its plain network addresses.
- It is not a proxy or a VPN. An issued address may be used only to reach your own C5
  install. Relaying other traffic through it, or giving other people access to your install
  as a service, is not permitted.
- It does not survive being turned off. Turning Remote Control off signs out every paired
  device and deletes the issued address; devices must be paired again if you turn it back
  on. A tunnel of your own is the one thing kept: its token stays saved, and it runs again
  when you turn back on.

## Where to go next

- [Turning it on and pairing a phone](/c5/remote-control/setup)
- [Privacy and Cloudflare](/c5/remote-control/privacy-and-cloudflare) — read this before
  you use an issued address for anything sensitive.
- The Terms section you accept: [Section 14, Remote Control](https://growther.ai/t=remote-control)
