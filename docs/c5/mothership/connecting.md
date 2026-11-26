---
title: Connecting
description: Link your C5 to Mothership, check the link, and disconnect if you want to.
order: 2
---

# Connecting

Connecting to Mothership takes one command.

```bash
growther activate
```

## What happens

1. C5 shows you a short code.
2. It opens a page in your browser.
3. You confirm the code there.
4. The two are linked.

The code proves the request came from your machine. Nobody can connect your install
without you approving it in a browser you control.

## Checking it worked

```bash
growther doctor
```

The output includes your license and Mothership state. You can also see it inside the
app, in Settings.

### The Mothership status in the sidebar

The Mothership icon in the sidebar shows the link at a glance. Hover over it for the detail:

| It says | What it means |
| --- | --- |
| **Mothership interconnection**, _Cloud API securely bridged_ | Connected. The rows below give the latency and when the last and next check-ins are |
| **Mothership interconnection**, _Cloud API synchronizing..._ | Connected, and sending or receiving right now |
| **Mothership unreachable**, _Connection problem_ | The last check-in failed. The **Error** row says why (see below) |
| **Mothership nonintegrated**, _Cloud flywheel disconnected_ | Your licence does not include Mothership. An administrator sees a **License** button |

The icon is not shown at all when Mothership is switched off.

The **Error** row names the cause in words, with the system's own code beside it:

| The Error row says | What to check |
| --- | --- |
| _Address lookup failed (ENOTFOUND)_ | The machine cannot look up the Mothership's name: DNS, or no network |
| _Connection refused_, _Connection dropped_, _No network_ | The network, or a firewall between you and the Mothership |
| _Timed out_ | A slow or blocking network or proxy |
| _Certificate expired_, _Certificate not trusted_ | A proxy that inspects HTTPS may be re-signing the connection. See [Network and egress](/c5/configuration/network#behind-a-tls-inspecting-proxy) |
| _Certificate pin mismatch_ | The certificate presented was not the one C5 expects. See [Network and egress](/c5/configuration/network#the-certificate-pin-and-your-proxy) |
| _Mothership returned an error_ | The Mothership answered, but not with success. Try again later |

Right after you set C5 up, the status can read _Couldn't read C5's status (sign in, or reload
the page) — the Mothership was not reached_. That is C5 asking itself before you have
signed in. It clears on its own within half a minute of signing in.

## Connecting more machines

Run `growther activate` on each one. Every machine gets its own code and its own
approval step.

Once several machines are connected, you can see them together in your Mothership
dashboards.

## If activation fails

**"Cannot reach the activation service"**
A network or firewall problem. Activation goes to `license.growther.si`, which is a
different host from the platform's `api.growther.si` — allow both. C5 keeps working
offline; you just cannot activate until it can connect. See
[Network and egress](/c5/configuration/network) for the full host list.

**"Code expired"**
Codes are short-lived on purpose. Run `growther activate` again for a fresh one.

**"Already activated"**
This machine is connected. Nothing to do.

**"License limit reached"**
Your plan covers a certain number of machines. Disconnect one you no longer use, or
change plan.

## Working offline after connecting

Connected does not mean dependent. If your internet drops, C5 keeps running: your agents
work, your tasks run, your files save. It syncs up again when the connection returns.

## Disconnecting

You can disconnect from Settings at any time.

When you do:

- Everything on your computer stays exactly where it is
- Your projects, files, and history are untouched
- C5 keeps working as a standalone install
- Combined dashboards and shared improvements stop

There is no penalty and no lock-in. You can reconnect later with `growther activate`.

## Where to go next

- [Privacy](/c5/mothership/privacy) — what is shared while connected.
- [What Mothership is](/c5/mothership/overview) — what you get from it.
