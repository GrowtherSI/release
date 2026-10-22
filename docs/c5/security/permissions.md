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
- **Always Allow** — do not ask again for this agent and this tool. Where the prompt offers
  it, you can limit this to the one file or address it asked about. Under **"Always" lasts**
  you pick how long it holds: **Forever**, **1 hour** or **10 uses**.
- **Always Deny** — refuse this agent and this tool from now on, without asking (or only that
  file or address, if you chose that).

**An "Always" for the whole tool also moves its switch** under **Master Tool
Authorizations** (below): **Always Allow** sets it to **On**, which lets every agent use the
tool without asking, not only this one, and **Always Deny** sets it to **Off**, so the
agent's own rule decides. An "Always" for one file or address moves no switch. If C5 could
not save part of your choice, a message says which part, for example _“Always Allow” for
read_file was not saved (HTTP 403), so C5 will ask again next time._ or _The Master Tool
Authorizations switch for read_file was not changed (…); it is still Off. Set it in Settings
› Extensions._ When C5 cannot read the current switches, it changes none of them, so the
other tools' switches are never reset. Your answer to the call itself goes through either
way.

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
is signed in as an administrator. A teammate who may change other settings sees them, but a
change to one is refused, and nothing else in that save is stored either.

| Setting | Where it is |
| --- | --- |
| **Tool & Web Escalation** | **Settings › Tools**, in the **Tool Use** panel |
| **System Control** (computer use) | **Settings › Tools** |
| **Egress Data-Loss Prevention**: its mode (**Off**, **Warn**, **Redact**, **Block**) and **Scan PII** | **Settings › Tools** |
| **Strict Path Boundary** and **Enable Root Level Terminal** | **Settings › Tools** |
| **FFmpeg location** | **Settings › Tools** (see [Pictures and video](/c5/tools/what-tools-do#pictures-and-video)) |
| **Master Tool Authorizations** | **Settings › Extensions** |
| **Permitted Directory Paths**, read and write | **Settings › Extensions** |
| **State Machine HITL Decay Threshold**: how many approvals of a recipe step skip its sign-off from then on | **Settings › Autonomy**, under **Global Rules** |
| **Guardian Vetting**: the guardian's check of agents' tool calls | **Settings › Budget**, under **System-Level Prompting** |
| **Back up secret files** | **Settings › Integrations**, on the **GitHub** card, under **C5 Data** (see [Backing up to GitHub](/c5/security/backups#backing-up-to-github)) |

C5 also strips credentials from the environment of every command an agent runs. That has
no switch in Settings, and only an administrator could turn it off.

**What a teammate sees.** The save is refused with a message that names the setting by its
internal name, for example _Failed to save budget settings: Forbidden: these
security-critical settings are admin-only (rejected: guardian_enabled)_. From a paired
device the message reads _These settings cannot be changed from a remote device. Change
them in C5 on the machine itself (…)._ On **Settings › Budget** and **Settings ›
Autonomy** only what you changed is sent, so these settings never block a teammate's other
changes there. **Settings › Tools**, **Settings › Extensions** and the GitHub card's switch
save only for an administrator.

**What is recorded.** Every change an administrator makes to one of them is recorded in the
audit log, with who made it, and so is every attempt from a paired device. See
[Audit trail](/c5/security/audit-trail).

**Remote Control's own restrictions** work one way round: a teammate can tighten them but
not loosen them. See
[Who can change these switches](/c5/remote-control/setup#who-can-change-these-switches).

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
