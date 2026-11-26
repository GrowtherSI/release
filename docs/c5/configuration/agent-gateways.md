---
title: OpenClaw and Hermes
description: How C5 works with agent gateways, the suggestions on their Config tabs, restarts, and what C5 does when a gateway goes down.
order: 11
---

# OpenClaw and Hermes

OpenClaw and Hermes Agent are **gateways**: separate programs that run agents with their own
tools, and that C5 hands work to. You turn each one on in **Settings › Integrations**, where
its card shows whether it is connected and has a **Restart** button. Each gateway you turn on
also adds a **Config** tab with its icon (hover it to read _OpenClaw Config_ or _Hermes
Config_) for its own settings file; how its optimizers work is in
[Config tabs and optimizers](/c5/configuration/model-providers#config-tabs-and-optimizers).

## Your agents' own tools come first

A gateway gives its agents tools of their own, such as web search. C5 can add its tools on
top: **Settings › Tools › Supplement Gateway with C5 Tools** (on by default; only an
administrator can change it). See also
[Tools for gateway agents](/c5/tools/what-tools-do#tools-for-gateway-agents).

C5 now asks the gateway what each agent already has, and adds only what is missing. So an
agent with its own web search no longer sees two web searches, and its prompts carry fewer
tool descriptions. Two rules hold:

- **Web search and reading a web page** are left to the agent's own tools only while your
  egress controls are off. While **Block PII Exfiltration** or **Zero-Trust Default** is
  on (**Settings › Guardrails**, see [Guardrails](/c5/security/guardrails)), C5's
  own versions are used, because only they are checked by those controls.
- **Files, commands, and pictures or video** always use C5's tools. They work inside your
  task's working folder, and they go through C5's approvals, safety checks and audit trail,
  which the gateway's own tools do not.

If C5 cannot ask the gateway (it is restarting, say), it adds all of its tools, as before.

## Suggestions on the OpenClaw Config tab

Besides tuning the gateway itself, the OpenClaw **Config** tab's optimizers now suggest
these, about how it works with C5:

| Suggestion | Group | What it does |
| --- | --- | --- |
| **Add C5's Lean Health-Ping Agent** | Reliability | Adds a small agent named `c5-ping`, with no tools, no skills and no workspace files, on your agents' default model. C5 uses it to check that the gateway is alive. Without it, C5 checks by sending a message to your `main` agent, whose large prompt can overflow a local model, so a healthy gateway can look dead and be restarted for nothing. |
| **Deny All Tools on C5's Health-Ping Agent** | Reliability | Shown when `c5-ping` exists but still has tools. C5 uses the agent only once all its tools are turned off. |
| **Trim Native Tools for "…"** | Performance | For an agent with OpenClaw's full tool set: switches it to a small set (files, shell, web, memory, sub-agents, skills). The full set puts about 37,000 tokens of tool descriptions into every prompt, most of a local model's budget. Add back anything the agent needs. |
| **Stop Inheriting Global Native Tools** | Harden | When a global tool list gives many agents OpenClaw's own file and shell tools: clears it, so those agents use C5's instead. Agents with their own list (such as `main`) are not affected. |
| **Native Network Tools Bypass C5 Egress Controls** | Harden | Advice only, nothing to apply. Names the agents that can reach the internet with OpenClaw's own tools, which C5's egress controls do not see. See [Native network tools](#native-network-tools). |

`c5-ping` is C5's own agent. It does not appear in your agent lists or in chat.

**Suggestions that were removed.** Several older suggestions wrote settings that newer
versions of OpenClaw no longer accept, and OpenClaw refuses a settings file with even one
unknown setting in it. They are gone, and every remaining suggestion is checked against
OpenClaw's own list of accepted settings. **Enable Loop Detection**, **Enable Auto-Update**
and **Enable Channel Bot-Loop Protection** now change only the one setting OpenClaw still
accepts. If OpenClaw stopped loading its settings after you applied a suggestion in an
earlier version, see
[OpenClaw ignores its settings file](/c5/troubleshooting/common-issues#openclaw-ignores-its-settings-file).

## When a gateway stops answering

C5 checks each gateway regularly. When OpenClaw stops answering and work is failing, C5
restarts it for you:

1. It first asks OpenClaw to restart itself.
2. If that does not work, it runs `openclaw gateway restart`.
3. Before either, it checks that OpenClaw's settings file is valid. If it is not, C5 does
   not restart onto it (OpenClaw would not come back); the alert lists the settings that are
   wrong.

C5 waits for a gateway that is still starting instead of treating it as down. It does not
restart more than once every ten minutes, waits longer after repeated restarts, and after five
restarts in three hours it stops and alerts the administrators instead, because restarting is
clearly not fixing the problem. A slowdown caused by C5 giving the model to more urgent work
never triggers a restart.

**If you stopped OpenClaw yourself** with `openclaw gateway stop`, C5 leaves it stopped and
files a notice, _Gateway Stopped by an Operator_. Start it again with `openclaw gateway start`
or the **Restart** button; once C5 sees it running again, the notice closes.

### The Restart button

**Settings › Integrations**, on the OpenClaw card: **Restart** (administrators only) uses the
same steps as the automatic restart, including the settings check. Active chats and tasks on
that gateway are interrupted while it starts again, which takes about a minute or two. If a
restart is already running, the button says so instead of starting a second one.

On the Hermes card, **Restart** asks the Hermes dashboard to restart the gateway, and C5
confirms when Hermes is back. If the Hermes dashboard is not running, or requires its own
sign-in, the message says so.

## When Hermes is down

If Hermes Agent is turned on as a coordinator and has not answered for **10 minutes**, C5
sends the administrators a notification, _Hermes has not answered for 10 minutes_. It closes
on its own when Hermes answers again.

The most common cause is a crash loop at startup caused by cached media files from earlier
conversations. When C5 sees that pattern, it clears those files for you, at most once every
six hours, after copying them into the `backups` folder in the Hermes home folder
(`~/.hermes/backups/`). You do not need to restart anything: Hermes's own supervisor is
already restarting it. Both the clean-up and the recovery are recorded in the
[audit trail](/c5/security/audit-trail).

You can run the same clean-up yourself: Hermes **Config** tab › **Performance** › **Archive &
Clean Native-Inputs Media Cache**.

## Native network tools

A gateway's own tools, such as its web search, browser or command line, run inside the
gateway, so C5's checks on its own tools do not see them. There are two ways to bring them
under your network rules, both for administrators:

- **Route the gateways through the egress gateway** (off by default). Their tools keep
  working, and their connections are checked against your rules and recorded. This is the
  recommended way; see [Egress gateway](/c5/security/egress-gateway), including what it
  cannot cover.
- **Turn the gateways' network tools off** while an egress rule is on (also off by default).
  C5 then turns off OpenClaw's network tools for every agent, checks that OpenClaw accepts
  the change and records it; it will not send work to an agent that still has one; and cloud
  providers' own web search is not used. Agents still search and read the web through C5's
  own tools. This removes capability C5 does not fully replace (browsing, speech, GitHub,
  background commands, MCP servers configured in OpenClaw), and turning it off again restores
  exactly what C5 changed. See the settings table in
  [Egress gateway](/c5/security/egress-gateway#the-settings).

## Where to go next

- [LM Studio](/c5/configuration/lm-studio) — keep a local model loaded between turns.
- [Egress gateway](/c5/security/egress-gateway)
- [What tools do](/c5/tools/what-tools-do)
- [Guardrails](/c5/security/guardrails)
- [Common issues](/c5/troubleshooting/common-issues#gateways-and-local-models)
