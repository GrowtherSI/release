---
title: Permissions
description: Decide what your agents may do alone, and what needs your say-so.
order: 2
---

# Permissions

Permissions decide what your agents may do on their own, and what has to stop and ask
you first.

This is the most important setting in C5. It is worth ten minutes.

> **Human teammate access & user permissions (RBAC)**
> Looking to control what human team members can see, edit, or execute in the C5 interface?
> This page covers autonomous **agent** permissions. To configure role-based access control (RBAC), feature locks, and server controls for human teammates, see [Access & user permissions (RBAC)](/c5/configuration/settings#access-user-permissions-rbac) in Settings.

## The ladder

Think of it as a ladder, from safest to most powerful:

| Level          | What it covers                                          | Default   |
| -------------- | ------------------------------------------------------- | --------- |
| **Read**       | Looking at files and pages. Changes nothing.            | Allowed   |
| **Write**      | Creating and editing files.                             | Asks you  |
| **Run**        | Running commands on your computer.                      | Asks you  |
| **Send**       | Sending anything off your machine — email, posts, calls.| Asks you  |
| **Delete**     | Removing files or data permanently.                     | Asks you  |
| **Spend**      | Anything that costs money beyond normal model usage.    | Asks you  |
| **Control**    | Driving your screen, mouse, and keyboard.               | Off       |

Reading is safe: worst case, an agent wastes time. Deleting and sending are not: worst
case, something is gone or something private went somewhere public.

> **Note**
> Writing asks you by default, wherever the file is. A write goes ahead without asking only
> where you have said so: a folder you listed under the write-allowed paths in
> **Settings → Extensions** (empty until you add to it), an **Always Allow** you gave that
> agent for that tool, or the tool set to **On** in **Settings → Extensions**. An
> orchestrated run you have given filesystem autonomy can also write inside its own task
> workspace without asking, and only there.
>
> **Settings → Locations** is a different setting and does not grant anything. See the
> warning further down this page.

## When an agent asks

You get a clear message saying exactly what it wants to do — which file, which address,
which command. Then you choose:

- **Approve Once** — just this time.
- **Deny** — not this time; the agent finds another way or stops.
- **Always Allow** — do not ask again for this agent and this tool. It covers only the agent
  that asked: every other agent is still asked, and an **Always Deny** you gave another agent
  stands. Where the prompt offers it, you can limit this to the one file or address it asked
  about. Under **"Always" lasts** you pick how long it holds: **Forever**, **1 hour** or
  **10 uses**.
- **Always Deny** — refuse this agent and this tool from now on, without asking (or only that
  file or address, if you chose that).

**An "Always" is about this agent.** It never sets the tool's switch under **Master Tool
Authorizations** (below) to **On**, which would let every agent use the tool without asking.
The one move it can make is the other way: an **Always Deny** for the whole tool turns a
switch that is **On** to **Off**, because while it is On every agent runs the tool, this one
included, whatever its own rule says. A switch at **Prompt** or **Off** is left as it is, and
an "Always" for one file or address moves no switch.

**Under Prompt, C5 still asks.** A tool at **Prompt** asks before every call, whatever an
agent's own rule says, so your answer tells you so: _read_file is set to Prompt in Master
Tool Authorizations, which asks before every call to it, so C5 will still ask. Your “Always
Allow” for researcher is saved and applies if that switch is set to Off in Settings ›
Extensions._

If C5 could not save part of your choice, a message says which part, for example _“Always
Allow” for read_file was not saved (HTTP 403), so C5 will ask again next time._ or, for an
Always Deny that had to turn the switch off, _The Master Tool Authorizations switch for
read_file was not changed (…); it is still On, so every agent still runs read_file without
asking. Set it to Off in Settings › Extensions._ When C5 cannot read the switches, it changes
none of them and says so, so the other tools' switches are never reset. Your answer to the
call itself goes through either way.

**Only an administrator at the machine can answer.** Anyone else sees the request, with
_Only an administrator can answer tool requests._ in place of the buttons (on a paired
device, _You can answer tool requests only on the machine running C5._), and a **Close**
button, which Escape presses too. Close only takes the prompt off that screen: nothing is
sent, and the request waits for an administrator until it times out. In the notification
list's **Tool Activity**, a call waiting for an answer shows its **Approve** and **Deny**
buttons to an administrator only; a teammate who may act on that list reads _Only an
administrator can approve or deny tool requests._ instead.

> **Tip**
> Be slow with **Always Allow**. It is the choice people regret. **Approve Once** costs you
> two seconds and keeps you in the loop.

### When an agent lacks a tool

An agent sometimes needs something C5 has not been set up with — a local tool, or a way to
make video or audio. With **Tool & Web Escalation** on, it can ask for one. The checkbox is
in **Settings › Tools**, in the **Tool Use** panel; it is off by default, takes effect when
you press **Save**, and only an administrator at the machine can change it.

The request comes as a **Tool Authorization Required** dialog, marked **Tool Capability
Escalation**, **Free Web Resource Escalation** or **System Control & Web Escalation**, and
saying why: _Agent … is requesting tool escalation because a local capability is
unconfigured._ It shows the **Missing Capability**, the **Free Web Resource** where there is
one, and the **Escalation Target**. You answer it like any other request. What an approval
grants is fixed:

- **A local tool** (`request_tool_escalation`): that tool, for that agent, for up to 10 uses
  within 30 minutes.
- **A public web resource** (`request_web_resource_escalation`): reading that address, and —
  unless the agent asked without it — **System Control** for that agent: C5's tools that
  drive the screen, mouse and keyboard, each for up to 25 uses within 30 minutes. Approve
  this only if you would let the agent drive your screen.

An approval never overrides a rule you set:

- **An Always Deny stays.** A tool that agent was told **Always Deny** — for the whole tool,
  or for the address or command it asked about — is left denied; the agent is told so, and
  not to ask again. A web escalation still grants the System Control tools that are not
  denied.
- **An approval of nothing but denied tools grants nothing.** When `read_url` and every
  System Control tool it would grant are at **Always Deny** for that agent, the agent is told
  the approval granted nothing, and System Control stays off for its task. When only the
  System Control tools are denied, it gets `read_url` and is told that System Control was
  not granted.
- **An Always Allow you gave stays as you gave it**, with no budget put on it.
- **A request about one address or command** grants only that, where the tool works on one;
  otherwise the whole tool.
- **Asking again does not top it up.** While a grant from an earlier approval still has uses
  and time left, a new approval keeps it as it is; a new budget starts only once it is spent
  or expired.

When its uses or its time run out, the tool asks again. Spent and expired grants are
cleared away every night.

With the checkbox off, an agent's request for escalation is answered that escalation is off,
and you are not asked — unless the request tool is set to **On** or **Prompt** under
**Master Tool Authorizations** (below), or you gave that agent an **Always** for it.

## Setting the level

Which tools ask you first is set per tool, in **Settings → Extensions**, and by your answers
to the approval prompt above. **Settings → Extensions** gives every tool one of three master
positions:

| Position   | What it means                                  |
| ---------- | ---------------------------------------------- |
| **On**     | Every agent may use this tool without asking.  |
| **Prompt** | Agents must ask you each time, even an agent you gave **Always Allow** for the whole tool. An **Always** answer for one file or address still applies to that file or address. In a task run nobody may be there to answer: once the **Authorize-Use Timeout** in **Settings › Tools** passes, the step is suspended, not refused, and resumes when you approve it. A chat nobody answers is denied at the timeout. |
| **Off**    | No override: the tool's own per-agent rules decide, and anything you have not answered with an **Always** still asks you. It is not a block. To stop a tool, choose **Always Deny** when it asks. A tool nobody has set is at **Off**, and the panel shows it so. |

**Master Tool Authorizations**, in **Settings → Extensions**, is where those positions are
set, one switch per tool, listed by the tool's own name. Besides the tools agents already
have, it lists:

| Tool | Group | What it does |
| --- | --- | --- |
| `render_video` | Media — generate | Makes a video with captions from slides, on this machine |
| `fetch_web_image` | Media — generate | Downloads one image from the web into the task |
| `create_file` | Files — write | Another name for `write_file`, with its rules |
| `request_tool_escalation` | Tool & Web Escalation | Lets an agent ask for a local tool it lacks |
| `request_web_resource_escalation` | Tool & Web Escalation | Lets an agent ask for a public web resource, and System Control with it |

**On** for `request_web_resource_escalation` approves every such request without asking,
System Control included. Only an administrator at the machine can change a switch (see
[Settings only an administrator can change](#settings-only-an-administrator-can-change)).

**Settings → Autonomy** (headed **Autonomy Policies**) sets how far agents may go without
you for each type of work: under **Work Type Thresholds**, the minimum autonomy level that
work needs, from **Level 1 (Tools)** to **Level 5 (Deploy)**, and what happens when an agent's
level is too low (**Downgrade** or **Block Task**). **Agent Overrides** forces that choice for
one agent and type of work, and **Escalation Notifications** lists the tasks that were
blocked or downgraded this way.

Between the two, you decide exactly how much rope your agents get.

## Settings only an administrator can change

Some settings each take a prompt away from every agent, or let C5 do more with nobody asked.
Only an administrator can change them, and only at the machine running C5: a phone or
tablet paired through [Remote Control](/c5/remote-control/overview) is refused, even when it
is signed in as an administrator. Anyone else sees them as they are, held back, with the
reason beside them (below).

| Setting | Where it is |
| --- | --- |
| **Tool & Web Escalation** | **Settings › Tools**, in the **Tool Use** panel |
| **System Control** (computer use) | **Settings › Tools** |
| **Egress Data-Loss Prevention**: its mode (**Off**, **Warn**, **Redact**, **Block**) and **Scan PII** | **Settings › Tools** |
| **Strict Path Boundary** and **Enable Root Level Terminal** | **Settings › Tools** |
| **FFmpeg location** | **Settings › Tools** (see [Pictures and video](/c5/tools/what-tools-do#pictures-and-video)) |
| **Master Tool Authorizations** | **Settings › Extensions**, on the **Saved Tool Authorizations** card |
| **Permitted Directory Paths**, read and write | **Settings › Extensions**, on the **Saved Tool Authorizations** card |
| **State Machine HITL Decay Threshold**: how many approvals of a recipe step skip its sign-off from then on | **Settings › Autonomy**, under **Global Rules** |
| **Guardian Vetting**: the guardian's check of agents' tool calls | **Settings › Budget**, under **System-Level Prompting** |
| **Back up secret files** | **Settings › Integrations**, on the **GitHub** card, under **C5 Data** (see [Backing up to GitHub](/c5/security/backups#backing-up-to-github)) |

C5 also strips credentials from the environment of every command an agent runs. That has
no switch in Settings, and only an administrator could turn it off.

**Guardian Vetting is off only while it is saved off.** If C5 cannot read the setting, the
guardian goes on vetting.

**What a teammate sees.** For anyone but an administrator at the machine, these controls are
greyed out, with the reason beside them:

| Where | What it says |
| --- | --- |
| **Settings › Tools** | Every panel is greyed out and **Save** is held back, with _Only an administrator can change tool settings._ under the heading. The list of rate-limited agents at the foot of the tab, which only reads, is not |
| **Settings › Extensions** | The **Saved Tool Authorizations** card is read-only, with no **Save** for it and _Only an administrator can change tool authorizations._ under its heading |
| **Settings › Autonomy** | The decay slider, with _Only an administrator can change the HITL decay threshold._ |
| **Settings › Budget** | The **Guardian Vetting** switch, with _Only an administrator can change Guardian vetting._ |
| **Settings › Integrations** | The **Back up secret files** switch, with _Only an administrator can change whether secret files are backed up._ |

On a paired device each reads _You can … only on the machine running C5._ instead, for
example _You can change tool settings only on the machine running C5._ On **Settings ›
Budget** and **Settings › Autonomy** only what you changed is sent, so these settings never
block a teammate's other changes there.

**What is recorded.** Every change an administrator makes to one of them is recorded in the
audit log, with who made it, and so is every attempt from a paired device. A save that
changes nothing — the same value, or the same list in another order — is not recorded as a
change. See [Audit trail](/c5/security/audit-trail).

**Two settings work one way round.** A teammate can tighten **Remote Control**'s
restrictions but not loosen them (see
[Who can change these switches](/c5/remote-control/setup#who-can-change-these-switches)),
and can turn **Voice on remote devices** off but not on (see
[Voice from a paired phone](/c5/using-c5/voice#voice-from-a-paired-phone)). Once the
setting is saved the restrictive way, its switch is greyed out for them.

### When a change is refused

A teammate should rarely see a refusal, since Settings holds these controls back. One comes
from a page opened before an update, say, or from a script. Nothing in that save is stored,
and the message names each setting as Settings does:

| The message | What it means |
| --- | --- |
| _Forbidden: Guardian Vetting is admin-only._ | A setting in the table above; ask an administrator at the machine to change it |
| _Forbidden: only an administrator can lift these Remote Control restrictions: Read-only for all remote devices. Turning one on is allowed._ | Loosening a Remote Control restriction; see [Who can change these switches](/c5/remote-control/setup#who-can-change-these-switches) |
| _Forbidden: only an administrator can turn on Voice on remote devices. Turning it off is allowed._ | See [Voice from a paired phone](/c5/using-c5/voice#voice-from-a-paired-phone) |
| _Forbidden: Retrospective Loop needs the HITL edit permission (Settings › Access)._ | The Retrospective Loop's switch, schedule and token cap need **Edit** on **Sidebar: HITL Button & Modal** |
| _Forbidden: … is managed by your organisation's policy._ | A setting your organisation's policy locks; see [How a policy is applied](/c5/configuration/enterprise-policy#how-a-policy-is-applied) |
| _These settings cannot be changed from a remote device. Change them in C5 on the machine itself: Guardian Vetting._ | Saved from a paired phone or tablet: change it on the machine itself |
| _Strict Path Boundary needs a value: an empty one would turn it off. Nothing was saved._ | An empty value (below) |

Sending the value already stored is not a change, and goes through.

**A blank never turns a guard off.** An empty value for **Strict Path Boundary**, the
**Egress Data-Loss Prevention** mode or the filesystem autonomy level is refused from
everyone, an administrator included; an administrator turns one off by choosing off. A
setting nobody has saved yet counts as what C5 uses while it is unset, and one C5 cannot
read at that moment counts as a change, so neither lets a teammate's value through as a
repeat.

## Hard limits

**Settings → Guardrails** holds the checks that run no matter what any other setting
says. They cover things like blocking private information from being sent out, refusing
work when the safety checks themselves cannot be reached, and requiring an approved
budget before an agent spends anything.

Guardrails beat permissions. If the two disagree, the guardrail wins.

> **Warning**
> Guardrails and the permission ladder are your real controls. **Settings → Locations**
> is not one of them — it tells C5 which folders to bring documents in from and put
> results into. It is a convenience setting, not a fence: do not rely on it to keep an
> agent away from the rest of your disk.
>
> If you need a genuine boundary, run C5 under a user account that only has access to
> what you are willing to expose.

## Never hand over credentials

C5's guardrails watch for private information leaving your machine, but **do not rely on
software to notice a password**. There is no check that recognizes a card number or a
security code and stops on your behalf.

So make it a habit:

- Never put a password, card number, or one-time code into a chat message or a task
  description.
- Never ask an agent to sign in or pay as you. If a job needs that step, do that step
  yourself and let the agent carry on afterwards.
- Keep keys in **Settings**, which stores them encrypted and sends them only to the
  service they belong to — not in your instructions, where they become part of the
  conversation.

## Reviewing what happened

The **Audit** view in [Ops](/c5/using-c5/ops) lists every permission decision — what was
asked, what you chose, and when. Worth a look after your first busy week to see whether
your settings match how you actually work.

## A good starting point

1. For your first week, leave anything that deletes, sends, spends, or controls your
   screen set to ask you.
2. Notice which prompts you approve every single time.
3. Loosen just those — set those specific tools to **On** in
   **Settings → Extensions**.
4. Leave the rest asking.

You will end up with settings that fit your work instead of someone else's guess.
