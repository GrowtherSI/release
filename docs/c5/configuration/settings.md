---
title: Settings
description: A map of every settings area and what it controls, including the Learning tab and its local classifier.
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
| **Voice**         | Speech-to-text and text-to-speech providers, including the built-in ones. |
| **Learning**      | How much C5 adapts from your usage, and the local classifier (on by default). |
| **Locations**     | Folders C5 brings documents in from and writes results into.  |
| **Storage**       | Your data, its encryption, and export.                        |
| **System**        | Ports, paths, and how C5 runs on this machine.                |
| **Remote Control**| Reaching this C5 from a phone or another computer, and the paired devices. |
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

## Learning

**Settings › Learning** (headed **Learning Pipeline**) is where you tune how C5 improves
itself from your work. It has six sections:

| Section | What it controls |
| --- | --- |
| **Cognitive Flywheel Settings** | The human revision distance threshold, and the cost weights for simple and complex tasks |
| **Factorial Experiments** | The shadow run sampling rate for C5's experiments on its own settings |
| **Prompt Self-Improvement** | Prompt telemetry, and whether better prompt variants are promoted automatically |
| **Quality vs Efficiency Balance** | How much C5 weighs answer quality against cost |
| **Reward Pipeline Automation** | Which roles use the learned reward model, and the retrospective loop's frequency and token limits |
| **Local Classifier** | The small model C5 runs on this machine (below) |

The first five save together with the tab's **Save** button. **Local Classifier** is
different: each change there saves the moment you make it, and never needs **Save**.

### The local classifier

The local classifier is a small model, about 812 MB, that runs on this machine in its
own process. It answers some of the routine questions C5 asks itself while it works —
starting with which categories a new task belongs to — beside the model that answers
them today. It needs no provider and no account, and nothing it sees leaves the machine.

**It is on by default.** The first time a version of C5 with the classifier starts — a
new install, or an update — it turns the switch on wherever nobody has set it, downloads
the model once from Hugging Face where this machine can run it and is allowed to
download, and sends administrators one notification, *The local
classifier is on*, saying what this machine will do. A switch someone already turned off
stays off. A machine that cannot run it gets no notification and downloads nothing.

**What it does while on.** At first it only **records** its answers beside the usual
ones, for every kind of decision: each one starts in **Shadow**. C5 measures those answers,
on your own install, against the answers people gave and the outcomes that followed. It
**acts** on a kind of decision only after that measurement has passed, and only where its
mode allows it (below). Turning it on or off never changes what C5 does for a kind of
decision in **Shadow**.

**How much it records.** On a machine where it runs on the CPU, or answers slowly, the three
kinds asked most often — Step quality, Tool-call safety and Skill routing — record only one
question in four, always the same ones, so the classifier does not compete with your agents
for the processor. The card says so under each of them: _Sampling 1 in 4 on this machine: …_
See [On a machine where it runs on the CPU](../tools/local-classifier.md#on-a-machine-where-it-runs-on-the-cpu).

**What off means.** Off, it stops learning and C5 answers those questions exactly as it
did before; nothing else changes. Off is also silent: the classifier's process is not
started, nothing is downloaded, and it prints nothing to the log.

#### The card

The card's header has a **Terms** button, a short status badge and the switch. Under
them:

| Line | What it tells you |
| --- | --- |
| **This Mac** (or **This Mac Studio**, **This machine**, …) | The machine as your operating system describes it — model, processor, physical cores and installed memory, for example *Apple M4 Max, 16 cores (12 performance and 4 efficiency), 64 GB memory — supported.* — then where the classifier runs and why: *Runs on the GPU (Metal).* or *Runs on the CPU (8 threads), because LM Studio is configured and the classifier leaves the GPU to your local model.* If the machine cannot run it, the reason |
| **Model** | Whether the model is here and checked, partly downloaded (*300 of 812 MB*), downloading, or not downloaded and why. It also says when the file at the model's path is not the model, or when the path is a link whose file cannot be reached |
| **Notice** | The model's notice: who made it, its licence, and the note about its research-use training data, word for word as C5 shows it everywhere. Shown only while the classifier is on or the model is on disk |
| **Runtime** | What its process is doing: running on the Metal GPU or the CPU, memory used, load time, or why it is not running |
| **Health** | Questions answered, typical and slow response times, time-outs and failures. *Paused after repeated failures* means the usual answers stand alone until it recovers |

Below that is one row per kind of decision, with its mode, a note on what its modes mean
(*Shadow by default: recorded beside … never used.*), its promotion gate (the measurement),
its calibration, and the last seven days' counts.

#### Which machines can run it

| Requirement | |
| --- | --- |
| Platform | macOS (Apple silicon or Intel), Linux x64, Windows x64 or ARM64. Not Linux on ARM |
| Memory | At least 8 GB of the memory your operating system can **use**, rounded to the nearest whole gigabyte, so 7.5 GB or more passes. Most machines sold with 8 GB report 7.6 to 7.9 GB usable and qualify; one that keeps more for its built-in graphics (7.4 GB usable) does not, and the card then shows the usable figure |
| macOS | The version its runtime needs, which can be newer than C5's own minimum (macOS 14 against C5's 13.5 today) |
| Linux | A glibc and a `libstdc++` new enough for its runtime |
| Windows | The Microsoft Visual C++ 2015–2022 Redistributable. If it is missing, the first status line gives the address of the installer for your machine; install it, then restart C5 |

On a machine that falls short, the badge reads **Unsupported**, the first status line says
exactly what is missing, the switch cannot be turned on, and the model is never
downloaded.

On Apple silicon it uses the Metal GPU — unless a local model server (LM Studio,
llama.cpp, Ollama or Inferencer) is configured, in which case it uses the CPU so it does
not compete with the model you chose. Everywhere else it uses up to eight CPU threads. A
machine where it answers slowly (every Windows machine starts that way until a test
answer comes back within two seconds) uses it only for decisions that do not wait on it.
On the CPU, or on a slow machine, the most frequent kinds record one question in four
(above).

#### Read the Terms that cover it

Select **Terms** on the card. The dialog shows Section 14 of the Terms of Service,
*Models C5 downloads and runs on your machine*, word for word; this install's model with
its size, licence (Apache-2.0) and what is on this machine (for example *present and
verified*, *a link to the model, verified*, or *a file that is not the model (wrong size), so
it is not used*); and the model's notice. While the model is not here,
on a machine that will not download it, a line under the notice says so and why. From there you can
open the **Full Terms of Service** (<https://growther.si/t=models>) and the
**Third-party notices** for everything C5 is built from — the same notices as
**About › Copyright & Legal** in the sidebar's **Options** menu (`⋯`). If you may change
settings and the classifier is on, it also offers **Turn off the local classifier…**.
Nothing in the dialog asks you to accept anything.

#### Turn the classifier off

1. Turn the switch off, or select **Turn off the local classifier…** in the Terms dialog.
2. C5 asks first, because nobody chose to turn it on. The question says what off means
   and what is on the disk.
3. Choose **Turn off**. The model stays on the machine, so turning it back on costs no
   download.

Anyone with permission to edit settings can do this. If an organisation's policy keeps
the classifier on or off, the switch is disabled and the card says so — see
[Managed configuration](enterprise-policy.md#keep-the-local-classifier-on-or-off).

Turning it off also stops a download in progress. The part already downloaded is kept,
and turning it back on resumes from there.

#### Delete the model

An administrator can delete the model to free its 812 MB:

- While it is on, choose **Turn off and delete the model** in the turn-off question
  (**Turn off and remove the link** when the model is a link). C5 turns it off first,
  stops it, and then deletes. The question offers this only when there is something of
  the model on this machine to delete (the model or a partial download).
- While it is off, choose **Delete the model (812 MB)** under **Model** on the card, or
  **Delete the partly downloaded model** if only part of it is there.
- If the file at the model's path is not the model (a copy that failed, or the wrong file),
  the **Model** line says so — *The file at the model's path is not the model (…), so C5 does
  not use it.* — and the buttons read **Delete the file (N MB)** and **Turn off and delete the
  file**. C5 never loads such a file; while the classifier is on and this machine downloads,
  the next verified download replaces it.

Deleting needs an administrator with a second factor (a passkey, or a multi-factor
sign-in through your identity provider); on an install set up without any sign-in, no
second factor is needed. It is not offered on a device paired through Remote Control.
C5 removes the model, any partial download and its check
record, and says how much space was freed. If the model was placed by hand as a link to a
file elsewhere, the button reads **Remove the link to the model**: only the link goes, and
no space is freed.

The classifier stays off afterwards. Turning it back on downloads the model again only
on a machine that downloads models on its own; on an offline, opted-out or CI machine you
put it back yourself; on one short of disk, free some space, then restart C5 or turn the
classifier off and on, and C5 downloads it again (see **Turn it back on**, below).

If another C5 process is downloading the model at that moment (for example
`growther classifier pull` in a terminal), the model is not deleted, and the message
says so. (If you chose **Turn off and delete the model**, the classifier is still turned
off.) Wait for that download to finish, or stop it, and delete again.

#### Turn it back on

Turn the switch on. If the model is not here, C5 asks first and shows the model, its size,
its licence and its notice; only **Download and turn on** starts the download. Where this
machine will not download it — the offline posture is on,
`GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` is set, it is a CI runner, there is not
enough free disk, or the model's path is a symbolic link (C5 never downloads over a link) —
the question says so, the button reads **Turn on**, and the card tells you how to get the
model instead: `growther classifier pull`, freeing space, placing the file by hand
([Where your data lives](data-location.md#downloaded-models)), or, for a link, making the
file it points to reachable, pointing it at the model, or removing it.

A model placed by hand while the classifier is on is picked up the next time
**Settings › Learning** is opened, or at the next start. No restart is needed.

#### Modes: what each kind of decision is allowed to do

| Kind of decision | Default | Modes offered here |
| --- | --- | --- |
| **Task categories** — which categories a new task belongs to | Shadow | Off, Shadow, Assisted, Authoritative |
| **Skill routing** — which skill domain a specialist's step draws on | Shadow | Off, Shadow |
| **Step quality** — how good a step's output is, on five levels | Shadow | Off, Shadow |
| **Tool-call safety** — whether a tool call is unsafe, beside the guardian's check | Shadow | Off, Shadow |
| **Alert triage** — whether a repeating error is noise to suppress. Muting or unmuting an alert in the Auto-Suppression Ledger counts as your answer, and your latest one stands | Shadow | Off, Shadow |

The defaults apply to a kind nobody has set. A mode someone chose — **Off** included — is
kept. An install updated from an earlier version may have saved kinds nobody chose at the
old defaults (Task categories in Shadow, the rest Off); C5 resets those once, at its first
start, when its audit log shows nobody chose them. See
[What it does at first](../tools/local-classifier.md#what-it-does-at-first).

| Mode | What it means |
| --- | --- |
| **Off** | Never asked |
| **Shadow** | Asked after the fact; its answer is recorded and measured, never used |
| **Assisted** | The usual model answers as before; where it could not answer, the classifier's confident answer is used |
| **Authoritative** | Asked first; a confident answer is used and the usual model is not asked. Anything less confident goes to the usual model |

**Assisted** and **Authoritative** need the kind's promotion gate to pass first — the
measurement against your own labels — and a fitted calibration. Until then they are
shown but cannot be chosen (except by an administrator, below), with the reason beside
them. Calibration is fitted every night once there are enough labels, or at once by an
administrator's **Fit calibration now**. An acting mode uses only answers calibrated the
way its gate measured them. If the nightly check finds the evidence no longer holds,
C5 moves the kind back to **Shadow**. A kind an administrator raised anyway is not
moved back just because its gate still has not passed; it is moved back only if the
model or its calibration changes, or its calibration error doubles.

An administrator can raise a kind on a gate that has not passed, after a warning
(**Raise anyway**). The kind then reads *Unvalidated: an administrator raised it on a
gate that had not passed*. This is not offered from a device paired through Remote
Control, and never without a fitted calibration. Lowering a mode never needs a gate.

The full guide — what it records, when it starts to act, offline installs, log lines and
troubleshooting — is [Local classifier](../tools/local-classifier.md). For the files on
disk and the network side, see
[Where your data lives](data-location.md#downloaded-models) and
[Network and egress](network.md#the-models-and-programs-c5-downloads).

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
| **Orchestration Master Pause Button** | — | Toggle | Access to the master pause button on Chat. |
| **Sidebar: HITL Button & Modal** | Toggle | Toggle | View controls the Human-In-The-Loop icon; Edit allows reviewing and approving blocked tasks (read-only when off). |
| **Sidebar: Notifications Button & List** | Toggle | Toggle | View shows notifications; Edit permits acknowledging or deleting individual notifications. |
| **Sidebar: Remote Control Button** | Toggle | Disabled | Shows the **Remote Control** button in the sidebar `⋯` menu to standard users. Kept in step with **Enable Remote Control for non-admin accounts** in **Settings → Remote Control**. Administrators always see it. |
| **Sidebar: Restart, Quit, Start C5** | Toggle | Disabled | Controls whether standard users can see and trigger server lifecycle controls in the sidebar `⋯` menu, offline recovery screen, and connection error boundary. Defaults to **Off**. |
| ↳ *Remote Control: Restart, Quit* | Toggle | Disabled | Whether Restart and Quit, and the Remote Control launcher, are offered over Remote Control. A standard user needs this row and the row above it. Administrators always have it. |
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
> For standard (non-admin) team members, the visibility of Restart, Quit, and Start buttons is controlled by the **Sidebar: Restart, Quit, Start C5** toggle under [Settings → Access](#access-user-permissions-rbac). By default, this is turned off to prevent accidental server shutdowns.

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

You can also start C5 at any time from the "Growther.si C5" desktop shortcut, or by running `growther start` in a terminal.

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

