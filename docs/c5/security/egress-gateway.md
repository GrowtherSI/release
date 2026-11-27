---
title: Egress gateway
description: For administrators. How C5 applies your network rules to agent gateways and to the commands agents run, what that guarantees, and what to do when confinement blocks something.
order: 4
---

# Egress gateway

C5's network rules — the [data-loss checks](/c5/security/data-protection), the
[Network Containment allowlist](/c5/security/guardrails), the
[offline setting](/c5/configuration/network) and the audit trail — have always applied to
C5's own tools. The **egress gateway** extends them to two things that used to go around
them:

- **The commands agents run** (`run_command`). These are now **confined by default**.
- **The agent gateways' own tools** — OpenClaw, Hermes Agent and PicoClaw — and the MCP
  servers C5 starts, while they are routed through it. By default (**Auto**) that is
  whenever an egress rule is on.

It is a small proxy that C5 runs on this machine only (`127.0.0.1`, port `4302`). Nothing
outside the machine can connect to it, and every program that uses it has its own
credential, so each connection in the audit trail says which program and which agent made
it.

This page is for administrators. Every setting on it can be changed only by an
administrator, using C5 on the machine itself.

## What it guarantees

For every connection that goes through it, C5:

- **checks the destination** against your rules before anything is sent: offline refuses
  everything, Network Containment allows only the domains and ports on its list, and private
  addresses on your network are refused unless you allow them;
- **checks the address the name really points to**, so a public name that resolves to a
  private address is refused;
- **records it** in the audit trail: which program, which agent, which host and port, whether
  it was allowed, how much data went each way. Never the page, the query or the content;
- **applies the data-loss checks to what is sent**, where it can see it (below).

| Kind of traffic | Destination checked | Content checked by the data-loss rules |
| --- | --- | --- |
| Plain HTTP | Yes | Yes |
| HTTPS from a program that trusts C5's inspection certificate | Yes | Yes |
| HTTPS from any other program | Yes | **No** — only the host name is visible |
| WebSocket | Yes, and the address | Not the messages |
| Your SI model providers | Recorded | Never inspected |

**Your SI model providers are always reachable.** Requests to the providers you configured
are allowed even under Network Containment and offline, because C5 itself needs them to
work; each one is still recorded. An administrator can hold them to Network Containment like
everything else, but then providers missing from the allowlist stop working.

## `run_command` is confined by default

When an agent runs a command, C5 runs it in an operating-system sandbox (macOS and Linux)
that only lets it reach the network through the egress gateway.

**What still works:**

- Web requests over HTTP and HTTPS through the gateway: `git clone https://…`, `npm install`,
  `pip install`, `curl https://…`, subject to your rules.
- While **Network Containment** and **offline** are both off: services on this machine's own
  `localhost` (a test server, a local database such as Postgres or Redis) and local sockets
  (ssh-agent, Docker, gpg-agent). On Linux, only services the command starts itself are
  reachable on `localhost`; services already running on the machine are not.

**What is blocked:**

- `ssh`, `scp` and `git` remotes of the form `git@host:…` to other machines, and any other
  direct connection that is not HTTP or HTTPS.
- Everything external while the gateway is not running.
- Reading the files that hold the gateways' and the egress gateway's own keys and
  credentials.

When a command fails because of confinement, the result tells the agent so and names the
setting. Usually the fix is in the command: use an `https://` remote instead of
`git@host:`, for example.

**Windows** has no such sandbox: commands get the proxy settings only, so programs that
honour them go through the gateway and others do not. The result says so.

### Turning confinement off

**Settings › Tools › Command network confinement** (shown to administrators only). It is
**on** by default. Turning it off asks you to confirm, because then every command an agent
runs can reach any host on any port directly, unaudited, outside your allowlist, the offline
setting and the data-loss checks. Only the command text itself is still checked.

Turn it off only if your agents need direct connections (ssh to a server, say) and you
accept that.

## Routing the agent gateways

**Route agent gateways through C5** (Settings › Tools › Egress gateway) has three choices:

- **Auto** (the default): routes OpenClaw, Hermes Agent and PicoClaw through the egress
  gateway whenever an egress rule is on (data-loss checks, Network Containment or the
  offline posture), and leaves them direct when none is. The card says what Auto is doing
  right now and why.
- **On**: always route them.
- **Off**: never route them. Their own network tools then bypass your egress rules.

When routing starts, C5 configures each gateway to use the egress gateway for its outgoing
connections and records exactly what it changed, so when routing stops each gateway is
restored as it was. C5 asks before any change that would start or stop routing.

- **OpenClaw** is restarted to pick up the change.
- **Hermes Agent**: C5 changes the Hermes settings file and notifies you to restart the
  Hermes gateway (`hermes gateway restart`); profile gateways that C5 starts pick it up on
  their next start.
- If the egress gateway stops or stops answering while gateways are routed through it, C5
  **switches them back to direct** so your agents keep working, alerts the administrators,
  and routes them again once it is back.

**Keep in mind what routing cannot do.** A program that ignores its proxy settings and makes
its own connections is not stopped: for example the shell commands and browsers that Hermes
Agent and PicoClaw run for their agents, and the Chrome that OpenClaw's browser tool
launches. Only `run_command` is confined by the operating system.

## Checking HTTPS content (TLS inspection)

To apply the data-loss checks to HTTPS content, the gateway has to read it, which only works
for a program that trusts C5's own inspection certificate. C5 creates that certificate on
this machine and gives it **only to the programs it starts or configures**, never to your
system or your browser.

The setting has four values: **off**, **auto** (the default: inspect while the data-loss
checks are on), **on** and **required** (refuse HTTPS that cannot be inspected). Even when
it is on, only programs known to trust the certificate are inspected, so turning it on never
breaks a program that does not. Today that means the Hermes profile gateways C5 starts and
PicoClaw on Linux. OpenClaw is inspected only after a manual step on macOS that installs the
certificate into its service. Commands agents run are inspected only with **on** or
**required**. SI model providers and a few services that refuse inspection are never
inspected.

## C5's tools for Hermes Agent and PicoClaw

Hermes Agent and PicoClaw cannot take C5's tools the way OpenClaw does. C5 can offer them
its tools through a local MCP server instead (off by default). An administrator turns it on
and says, for the main Hermes gateway, each Hermes profile or PicoClaw, **which existing C5 agent it acts as**;
only those are connected, and every tool call runs with that agent's permissions, approvals
and audit, like any other C5 tool call.

## The settings

All are administrator-only. Only **Command network confinement** has a switch in Settings in
this version; the others are stored settings an administrator changes, and C5 refuses the
change from anyone else or from a paired phone.

| Setting | Values | Default | What it does |
| --- | --- | --- | --- |
| **Command network confinement** (`run_command_network_confinement`) | on, off | **on** | Confines commands agents run, as above. |
| **Egress gateway** (`egress_gateway_mode`) | off, auto, on | **auto** | `auto` runs the gateway while any of your egress rules is on (data-loss checks, Network Containment, the computer-use allowlist or offline). |
| **Route agent gateways through C5** (`egress_gateway_routing`) | on, auto, off | **auto** | Routes OpenClaw, Hermes Agent and PicoClaw through it; **auto** routes while an egress rule is on. |
| **Egress TLS inspection** (`egress_tls_inspection`) | off, auto, on, required | **auto** | Whether HTTPS content is inspected, as above. |
| **Egress private allowlist** (`egress_gateway_private_allowlist`) | addresses, address ranges, `host:port`, host names, `*.domain` | empty | Private destinations on your network that are allowed, such as an intranet server. |
| **Egress LLM provider hosts** (`egress_gateway_inference_hosts`) | host names | empty | Extra hosts treated as SI model providers. |
| **LLM hosts follow Network Containment** (`egress_gateway_inference_follows_containment`) | true, false | **false** | Holds model provider hosts to Network Containment and offline too. |
| **Egress no-inspect hosts** (`egress_gateway_no_inspect_hosts`) | host names | empty | Hosts never inspected. |
| **C5 tools over MCP** (`c5_mcp_host`) | off, on | **off** | Offers C5's tools to Hermes Agent and PicoClaw. |
| **C5 MCP agent mapping** (`c5_mcp_host_agent_map`) | `root` (the main Hermes gateway), a Hermes profile name or `picoclaw` → an existing C5 agent | empty | Which C5 agent each one acts as. Nothing is connected without it. |
| **Deny providers' native network tools** (`native_egress_deny_strategy`) | off, deny | **off** | Turns the gateways' own network tools off instead, while an egress rule is on. Removes capability; with the egress gateway it is rarely needed. |

## What it does not cover

- HTTPS content from programs that do not trust the inspection certificate (OpenClaw until
  the manual step, the main Hermes gateway, MCP servers) is checked by destination only.
- Programs that ignore proxy settings, as listed under routing above.
- Your SI model providers are reachable under Network Containment and offline, so a prompt
  can carry data to a provider you configured.
- While routing is switched back after a failure, the gateways' traffic is direct; you are
  alerted.
- With confinement on and Network Containment off, a command can reach any service on this
  machine's `localhost` and any local socket. Docker's socket in particular gives full control
  of the machine.

## If you need to undo routing without C5

If C5 is not running and a gateway is still routed through the stopped egress gateway:

```sh
openclaw config set proxy.enabled false && openclaw gateway restart
```

For Hermes Agent, open `~/.hermes/.env`, delete the block between the two lines that mention
the C5 egress gateway, and run `hermes gateway restart`. `growther uninstall` also restores
both.

## Where to go next

- [Guardrails](/c5/security/guardrails) — Network Containment and the data-loss checks.
- [Network and egress](/c5/configuration/network) — everything C5 itself connects to, and offline.
- [OpenClaw and Hermes](/c5/configuration/agent-gateways)
- [Audit trail](/c5/security/audit-trail)
