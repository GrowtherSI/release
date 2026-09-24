---
title: Managing devices
description: The paired-devices list, revoking, changing a lease, what an administrator at the machine can see, Disconnect everything, and what turning off does.
order: 3
---

# Managing devices

Every control on this page lives in C5 on the machine, under **Settings › Remote Control**.
A paired device can see the list but cannot change it — not even when it is signed in as an
administrator. The one thing a paired device may do for itself is sign out.

## The paired-devices list

**Paired devices** shows every device that has been paired to this install and not yet
revoked. For each one:

- its name, as given when it was paired;
- **Lease** — how long each sign-in from it lasts, and how much of the current one is left.
  _(default)_ means it follows the **Default sign-in lease** on the tab;
- **Last seen** — when it last reached the machine, accurate to a few minutes;
- a pencil to change the lease, and **Revoke**.

An administrator at the machine sees **every** user's devices, each marked with its owner.
Everyone else sees their own.

## Revoke

Press **Revoke** next to a device and it is cut off. Revocation takes effect on the device's
next request, and any live feed it holds ends within about a minute. It does not wait for the
lease to run out.

A revoked device cannot get back in with the key it holds. To use it again, pair it again
from the machine.

Revoke a device the moment it is lost, stolen, or no longer yours to trust. A paired phone
holds its own key, and also whatever drafts and unsent messages were on screen.

If the tab shows a notice that a revoked device could not be recorded yet, leave C5 running
until it clears.

## Change or extend a lease

A **lease** is how long one sign-in from a paired device lasts — between one hour and seven
days. The pairing itself does not expire; only the sign-in does.

- The **Default sign-in lease** on the tab applies to devices that have not been given their
  own. Twenty-four hours unless you change it.
- The pencil next to a device sets a lease for that device alone. Shortening takes effect on
  the current sign-in immediately; you cannot shorten it below the time already used.
- When a device's sign-in has run out, the list says **Expired** and the pencil offers to
  **Extend** it, which starts a fresh lease window from now.

Leases are changed only from the machine. What the phone sees when its lease runs out is
covered in [Troubleshooting](/c5/remote-control/troubleshooting).

## Disconnect everything

**Disconnect everything**, in the paired-devices area, is the one button that does it all.
It asks you to confirm:

> Signs out every paired device, deletes this machine's address and tunnel, ends
> rc.growther.ai sign-ins for your account, and turns Remote Control off.

Press **Disconnect** and, in this order, C5 turns the switch off, stops serving the secure
address, revokes every pairing, releases the tunnel and the issued address on Growther.ai's
side, removes the tunnel connector's credential files from this machine, withdraws your
addresses and machine name from your account, and then asks the licensing service to end
your portal sign-ins. The tab then shows the switch off and an empty device list.

Ending the portal sign-ins needs the licensing service. If it cannot be reached at that
moment, everything on this machine is still torn down and the tab says the portal sign-ins
could not be confirmed; use **Sign out everywhere** on the portal to end them.

Use it when you are not sure which device to distrust, when a machine changes hands, or
when you simply want a clean slate. It is not offered on a paired device.

## What turning off does

Before saving, C5 asks you to confirm:

> Turning Remote Control off signs out every paired device, gives back any address Growther.ai
> issued and deletes its tunnel, removes your addresses and machine name from your account,
> and deletes the connector's credential files here. A tunnel token you pasted yourself is
> kept, and your tunnel runs again when you turn back on. Devices must be paired again if
> you turn it back on; you are normally issued the same address again.

**Cancel** keeps it on; **Turn off** proceeds. In this order, C5 then turns the switch off,
stops serving the secure address, revokes every pairing, releases the issued address and its
tunnel on Growther.ai's side (when you had one), removes the tunnel connector's credential files
from this machine, and withdraws your addresses and machine name from your account.

A tunnel token you pasted under Advanced is **not** cleared. The connector stops and its
credential files go, but the token stays saved for the next time, and Growther.ai — which holds
nothing for your tunnel — is not asked to release anything. Only an address Growther.ai issued is
given back.

The one thing the switch does not do on its own is end your sign-in at
[rc.growther.ai](https://rc.growther.ai). That portal sign-in lasts seven days regardless of
the switch; **Disconnect everything** ends it, and so does **Sign out everywhere** on the
portal.

The switch flips even if one of the cleanup steps cannot complete at that moment — if the
licensing service cannot be reached, for example, the tunnel is still stopped and its
credential removed here, and the address is removed on Growther.ai's side by its own
housekeeping. The addresses are withdrawn from your account immediately rather than at the
next scheduled check-in.

The same teardown happens on its own when:

- your licence is revoked, cancelled, paused, or shut off for non-payment after the grace
  period;
- the deployment record is deleted from your account;
- you run `growther uninstall`;
- the install has not checked in with the licensing service for thirty days.

## Turning it back on, and re-pairing

Turn the switch on again and press **Save**. The acceptance dialog is not shown again unless
the terms have changed since you accepted them; if it is, agreeing turns Remote Control on
without a Save. Growther.ai normally issues the same address as before, with a fresh tunnel
behind it. If you were running your own tunnel, the token you pasted is still saved: C5 runs
your tunnel again and asks Growther.ai for nothing. Your tunnel answers for the host of your
**Public address**, or for the hostname you gave it in your own dashboard when none is set.

Every device has to be paired again, because turning off revoked every pairing. There is no
way to keep pairings across an off-and-on, by design: "off" has to mean off.

## From the command line

On a machine with no browser, two read-only commands answer the usual questions:

```bash
growther remote status
growther remote devices
```

The first says whether Remote Control is on, the name this machine publishes, and how many
devices are paired. The second lists the devices with when each was added and last seen.
Neither can turn Remote Control on or off or revoke a device — those need the running
server to take effect immediately, which is why they are only in **Settings › Remote
Control**.

## What a paired device can never do

Whatever account it is signed in as, a paired device cannot:

- pair another device;
- revoke a device other than itself;
- change any lease;
- change any Remote Control, voice, or security setting;
- change how an account signs in, or administer accounts;
- release the address or the tunnel.

These are refused by the install, not merely hidden in its screens.

## Where to go next

- [Troubleshooting](/c5/remote-control/troubleshooting) — expired leases, unreachable
  addresses, certificate warnings.
- [Access & user permissions](/c5/configuration/settings#access--user-permissions-rbac) —
  who may change settings at all.
