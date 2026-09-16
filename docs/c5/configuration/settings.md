---
title: Settings
description: A map of every settings area and what it controls.
order: 1
---

# Settings

Settings is where you tell C5 how to behave. This page is a map, so you know which area
you want.

You do not need to change most of these. C5 works sensibly out of the box.

## The areas

| Area              | What it controls                                             |
| ----------------- | ------------------------------------------------------------- |
| **General**       | Basic behavior and appearance.                                |
| **Integrations**  | Model providers, third-party services and their keys.         |
| **Autonomy**      | How much your agents may do without asking you.               |
| **Guardrails**    | Hard limits agents cannot cross.                              |
| **Budget**        | Spending caps and warnings.                                   |
| **Tools**         | Which tools exist and how each one is allowed to be used.     |
| **Extensions**    | Optional capabilities and MCP servers, each on, prompt, or off. |
| **Access**        | Who can use this C5, UI feature & page locks (RBAC), and gateway restrictions. |
| **Alerts**        | When and how C5 tells you something happened.                 |
| **Communications**| How C5 reaches you — email and other channels.                |
| **Learning**      | How much C5 adapts from your usage.                           |
| **Locations**     | Folders C5 brings documents in from and writes results into.  |
| **Storage**       | Your data, its encryption, and export.                        |
| **System**        | Ports, paths, and how C5 runs on this machine.                |
| **Enterprise**    | Managed policy, directory sign-in, secrets custody, audit shipping, storage. |

## The ones worth setting early

### Integrations

You have to set this up before anything works. Add at least one model and its key. See
[Model providers](/c5/configuration/model-providers).

### Budget

Set a spending limit on your first day. It is the cheapest mistake-insurance available.
The Budget tab is also where you track progress toward self-improvement milestones like
the Retrospective Loop (50 tasks) and Reward Model Promotion (100 tasks).
See [Budgets & costs](/c5/using-c5/ops).

### Autonomy

Decide how much your agents may do on their own. Start cautious. As you learn what C5
does well, loosen it.

See [Permissions](/c5/security/permissions).

### Guardrails

Set boundaries on what your agents may do, where they can connect on the web, and what data gets redacted before leaving your computer.
See [Guardrails](/c5/security/guardrails).

### Locations

Tell C5 which folders to bring documents in from, and where to put finished work. Point
it at the folders you actually work in, so imports and deliverables land somewhere you
expect.

> **Warning**
> This is a convenience setting, not a security boundary. It does not stop an agent from
> reaching other parts of your disk. Use
> [Permissions](/c5/security/permissions) and [Guardrails](/c5/security/guardrails) for that.

## How long C5 keeps things

**Storage** is where you decide how much history to hold. Two of the sliders there are worth
understanding, because they control records you may need after the fact.

| Slider                      | Range       | Default |
| --------------------------- | ----------- | ------- |
| **Audit Trail Retention**   | 1–365 days  | 90 days |
| **System Events Retention** | 31–365 days | 90 days |

**Audit Trail Retention** covers the security record of who did what: sign-ins and account
changes, admin actions, attempts C5 blocked, and changes to encryption. C5 removes it a whole
day at a time, and only once the last entry from that day has aged out, so nothing inside your
window is ever cut short. See [Audit trail](/c5/security/audit-trail).

This slider also covers the **tool decisions** in the same view — each time an agent was allowed
or refused a tool. Those are tidied on the same nightly pass, but with one difference worth
knowing:

> **Note**
> **Tool decisions are never removed sooner than 90 days**, whatever this slider says. They are
> also what the Analytics tool charts count, and those charts can look back up to 90 days — so if
> a shorter setting were applied to them, a chart would quietly show less activity than really
> happened and give you an all-clear nobody measured. Setting this above 90 days keeps them for
> longer, in step with everything else; setting it below only shortens how long the audit records
> themselves are kept.

One thing in the Audit view is still not covered: the **system notifications** merged into the
same list have no retention setting, and nothing ages them out. The **Source** column is what tells
the three kinds of row apart.

**System Events Retention** covers C5's own operational record: coordinator failovers, gateway
timeouts, shutdowns, steps that had to be abandoned and requeued, and the adjustments C5 makes
to its own thresholds and prompts as it learns. This is what the Monitor screens read when they
tell you how the platform itself has been behaving.

> **Warning**
> System Events cannot be set below **31 days**. The Monitor failover card counts events over
> a fixed 30-day window, so a shorter retention would delete events that card is still trying
> to count — and it would report fewer problems than actually happened. An all-clear nobody
> measured is worse than no number at all, so the floor is enforced.

Both are cleared out once a day, late in the evening, a few minutes ahead of the nightly
database backup — so your backups hold the tidied-up version rather than a copy of what you
asked to delete. They tidy differently: the audit records go a whole day at a time, for the
reason described on the [Audit trail](/c5/security/audit-trail) page, while tool decisions and
system events are removed one at a time as each passes its cutoff.

If C5 is asleep or switched off at that moment, nothing is lost. The next night removes
everything that was due tonight as well.

If you need records for longer than you want to store them, export them instead of raising the
slider — see [Audit trail](/c5/security/audit-trail).

## Alerts

Alerts tell you when something needs you. Worth turning on:

- A task is blocked and waiting for your answer
- A schedule failed
- You are close to a spending limit
- Something was blocked for security reasons

Without alerts you will find out when you next open C5, which might be tomorrow.

## Access & user permissions (RBAC)

**Settings → Access** (labeled **Security & Access Configuration**) is where administrators configure what standard (non-administrator) teammates are permitted to see and do throughout C5.

Administrator accounts always retain full view, edit, and execution privileges across all pages, features, and system controls. For standard teammates, administrators can fine-tune access using two levels of control on every feature:

- **User View**: Controls whether standard users can see a feature, page, or action button. When turned off, the navigation tab, sidebar link, or button is hidden from their interface.
- **User Edit**: Controls whether standard users can modify records, trigger active pipelines, or perform actions. When edit is turned off, the interface switches to read-only (disabling save buttons, edit forms, creation modals, and action menus).

At the top of the page, a global **Killswitch** banner allows an administrator to immediately halt all autonomous agent execution across the entire platform. When active, background processes pause and the controls dim.

### The RBAC grid

The permissions grid organizes controls into three columns:

#### 1. Feature locks (left column)

Granular controls over specific high-impact capabilities:

| Feature | User View | User Edit | Description |
| --- | :---: | :---: | --- |
| **Chat Pipeline Runner** | Toggle | Toggle | Authorize starting/stopping unprompted, looped orchestration pipelines on the Chat page. |
| **Kanban Deleted Column** | Toggle | Toggle | View reveals the trash icon to see deleted tasks; Edit unlocks the *Undelete → Todo* action. |
| **Orchestration Master Pause** | — | Toggle | Access to the master pause button on Chat. |
| **Sidebar: HITL Button & Modal** | Toggle | Toggle | View controls the Human-In-The-Loop icon; Edit allows reviewing and approving blocked tasks (read-only when off). |
| **Sidebar: Notifications** | Toggle | Toggle | View shows notifications; Edit permits acknowledging or deleting individual notifications. |
| **Sidebar: Restart, Quit, Start C5** | Toggle | Disabled | Controls whether standard users can see and trigger server lifecycle controls in the sidebar `⋯` menu, offline recovery screen, and connection error boundary. Defaults to **Off**. |
| **System Killswitch Execution** | Toggle | Toggle | Grants access to the global Killswitch banner on Settings and Dashboard. |
| **Teammate Profiles & Roles** | Toggle | Toggle | Permits editing team member permissions and autonomy bounds via Profile modal. |
| **Tool Activity Button & List** | Toggle | Toggle | View shows tool activity list; Edit allows approving/denying pending tool authorizations. |

> **User self-help: Missing Restart, Quit, or Start buttons**
> If you are a standard user and do not see the **Restart C5**, **Quit C5**, or **Start C5** buttons in your sidebar menu (`⋯`), or the **Start C5** button on connection error screens, your administrator has kept **Sidebar: Restart, Quit, Start C5** in its default **Off** position.
>
> When an administrator enables this toggle, the permission automatically synchronizes to your browser (`localStorage`) the next time you sign in, unlocking the server lifecycle controls.

#### 2. Page locks (middle column)

Visibility and edit capabilities for primary application sections:

| Section | User View | User Edit | Behavior when Edit is Off |
| --- | :---: | :---: | --- |
| **Overview** | Toggle | Disabled | View-only dashboard. |
| **Productivity** | Toggle | Toggle | Kanban is read-only; hides *New Task* button and task edit menus. |
| **Schedules** | Toggle | Toggle | Hides *New Schedule* button and disables schedule modifications. |
| **Chat** | Toggle | Toggle | Disables agent orchestration and task-creation slash commands. |
| **Library Page Master** | Toggle | Toggle | Master switch. Toggling off automatically cascades to all nested child tabs. |
| ↳ *Projects* | Toggle | Toggle | Read-only; disables locking, archiving, deleting, and regeneration. |
| ↳ *Deliverables* | Toggle | Toggle | Read-only deliverables view. |
| ↳ *Documents* | Toggle | Toggle | Read-only documents view. |
| ↳ *Notes* | Toggle | Toggle | Read-only notes view. |
| ↳ *Attachments* | Toggle | Toggle | Disables file uploading, editing fields, and deletion. |
| ↳ *Output* | Toggle | Disabled | Generated outputs view. |
| **Ops Page Master** | Toggle | Toggle | Master switch. Cascades to all operational tabs. |
| ↳ *Memory* | Toggle | Toggle | Read-only memory; disables *New Entry*. |
| ↳ *Goals* | Toggle | Toggle | Read-only goals; disables *New Goal*. |
| ↳ *CRM Tracker* | Toggle | Toggle | Read-only CRM; disables *New Contact*. |

#### 3. Page locks & hierarchy (right column)

Advanced workspaces, agent fleets, and system configuration:

| Section | User View | User Edit | Notes |
| --- | :---: | :---: | --- |
| **Labs Page Master** | Toggle | Toggle | Master switch over Variants, Skills, and Recipes. |
| ↳ *Variants* | Toggle | Toggle | Edit off disables agent variant evolution. |
| ↳ *Skills* | Toggle | Toggle | Edit off hides *Add Skill*, *Save*, and skill management menus. |
| ↳ *Recipes* | Toggle | Disabled | Curated workflows and recipes. |
| **Analytics** | Toggle | Disabled | Internal grading loops, quality scores, and reward metrics. |
| **Security** | Toggle | Toggle | View security posture; Edit controls security toggles. |
| **Monitor** | Toggle | Toggle | System health, database, security, and queue telemetry. |
| **Tags** | Toggle | Toggle | Create, edit, archive, and delete system-wide tags. |
| **Fleet: Agent Configurations** | Toggle | Disabled | Agent fleet definitions are strictly administrator-managed. |
| **Fleet: Autonomy Policies** | Toggle | Toggle | Edit off prevents modifying autonomy thresholds and escalation alerts. |
| **Context** | Toggle | Disabled | Context memory routing is administrator-managed. |
| **Workspaces** | Toggle | Disabled | Workspace paths and boundaries are administrator-managed. |
| **Settings** | Disabled | Disabled | Full application settings are strictly administrator-managed. |

### Hierarchical cascading

The master locks for **Library**, **Ops**, and **Labs** simplify management:
- Turning a master **View** toggle off immediately hides all nested sub-tabs for standard users.
- Turning a master **Edit** toggle off locks all nested sub-tabs into read-only mode.
- You can still selectively enable or disable individual child tabs while keeping the parent active.

### OpenClaw gateway restrictions

Below the RBAC grid, the Access tab provides direct configuration for the OpenClaw gateway security boundary:

- **Agent Capabilities**: Enable or disable agent-to-agent delegation, shell execution, browser automation, sub-agent spawning, and MCP tool access.
- **Filesystem Boundaries**: Confine agent read/write operations strictly to designated workspace paths.
- **Network Allowlist**: Enforce explicit host allowlists for outbound network traffic.

### Saving and synchronization

When an administrator clicks **Save** on the Access tab:
1. Permissions update immediately in the central configuration database.
2. Active user sessions update in real time.
3. For offline-capable controls (like the **Sidebar: Restart, Quit, Start C5** toggle), the client browser automatically synchronizes the permission into local browser storage (`localStorage`) upon sign-in. This ensures offline fallback screens know whether to present server restart buttons even when the backend is unreachable.

## Starting, restarting and quitting C5

**Settings → System** carries the controls that act on the server,
and the same options sit at the bottom of the sidebar **Options** menu (the `⋯`
button) so you can reach them without leaving what you are doing. Both Restart
and Quit ask you to confirm first — they act on the server everyone on this
machine is using.

> **Note on permissions**
> For standard (non-admin) team members, the visibility of Restart, Quit, and Start buttons is controlled by the **Sidebar: Restart, Quit, Start C5** toggle under [Settings → Access](#access--user-permissions-rbac). By default, this is turned off to prevent accidental server shutdowns.

| Control | What happens |
| --- | --- |
| **Restart C5** | C5 finishes its writes, closes its databases and starts fresh. Your browser tab reconnects on its own; you do not need to reload it. |
| **Quit C5** | C5 shuts down cleanly and stays down. |
| **Start C5** | When C5 is offline, launches C5 on your computer and reconnects this tab. |

Two settings sit beside them and are often confused:

- **Start when I sign in** registers C5 with your operating system, so it is
  already running the next time you log in.
- **Restart automatically if it stops unexpectedly** covers crashes only. An
  intentional quit — this button, `Ctrl+C`, or `growther stop` — is respected
  and stays stopped. If it resurrected an explicit quit, you could never stop
  C5 at all.

### When C5 is not running

When the server is stopped or offline, the interface adjusts automatically:

- In **Settings → System**, **Restart** is disabled, and the Quit panel transforms into a green **Start C5** panel.
- In the sidebar **Options** menu (`⋯`), **Restart** and **Quit** are replaced by a centered green **Start C5** button.
- On the offline fallback page and connection error modal, an emerald **Start C5** button appears below the details view.

Clicking **Start C5** invokes your computer's built-in `growther://start` protocol link to launch C5 (or wake its background service). While it starts, the button shows a spinning indicator with **Starting…**. Once C5 is running, your tab reconnects on its own within a few seconds and the online controls return.

You can also start C5 at any time from the "Growther.ai C5" desktop shortcut, or by running `growther start` in a terminal.

## Saving changes

Changes save when you click **Save** and apply to new work right away. Work already
running finishes under the settings it started with, so nothing shifts mid-task.

## If you break something

Settings are just values you can change back. Note what you changed, set it to what it
was, and save.

If you are not sure what you changed, the **Audit** view in [Ops](/c5/using-c5/ops) covers
some of it: changes to what tools an agent may use, and to search providers and integrations,
are recorded there with a timestamp. An ordinary **Save** on the other settings areas is not
recorded there — so when a setting matters, note what it was before you change it.

If C5 will not start at all after a change, see
[Common issues](/c5/troubleshooting/common-issues).

## Where to go next

- [Config files](/c5/configuration/config-files) — how C5 manages `c5.yaml` on disk.
- [Model providers](/c5/configuration/model-providers) — connect cloud and local models.
- [Guardrails](/c5/security/guardrails) — safety limits and network allowlists.

