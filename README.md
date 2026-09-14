# Growther.ai C5

**A self‑hosted, single‑binary AI agent platform.** Autonomous multi‑agent
orchestration, harness driven, safe tool use, and a self‑improving workflow — running entirely on
your machine, with encrypted local storage and zero required external dependencies.
Optionally supercharged by **Mothership**, the Growther.ai cloud.

---

<!-- RELEASE-STATUS:START -->

### 📦 Latest stable :: [`v2026.9.14-v290`](dist/c5/v2026.9.14-v290/)

![build](https://img.shields.io/badge/build-passing-brightgreen?style=plastic)
![tests](https://img.shields.io/badge/tests-passing-brightgreen?style=plastic)
&nbsp;**client** <code>6889</code> · **server** <code>20323</code> tests passing

<sub>↻ Written automatically by the C5 Release pipeline on every build.</sub>

<!-- RELEASE-STATUS:END -->

<br>

**Growther.ai Comprehensive Platform Suite**&nbsp; [![Full Platform Tests](https://img.shields.io/badge/31%2C084%20passed-success?style=plastic&logo=vitest&logoColor=white&color=FFD700)](#)

[![API & Server Tests](https://img.shields.io/badge/All%20APIs%20%2B%20Servers%20%2B%20Cloud-21%2C418%20passed-green?style=plastic&logo=node.js)](#) &nbsp;&nbsp; [![App Tests](https://img.shields.io/badge/All%20Apps-9%2C666%20passed-blue?style=plastic&logo=react)](#)

<br>

**Official Software Signing Certifications**

[![Certified macOS Developer](https://img.shields.io/badge/Certified%20macOS%20Developer-%23000000.svg?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/developer-id/) <!--[![MS Azure Trusted Artifact](https://img.shields.io/badge/MS%20Azure%20Trusted%20Artifact-%230078D4.svg?logo=data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgdmlld0JveD0iMCAwIDI1IDI1IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGl0ZW1wcm9wPSJsb2dvIiBpdGVtc2NvcGU9Iml0ZW1zY29wZSI+PHBhdGggZD0iTTExLjUyMTYgMC41SDBWMTEuOTA2N0gxMS41MjE2VjAuNVoiIGZpbGw9IiNmMjUwMjIiPjwvcGF0aD48cGF0aCBkPSJNMjQuMjQxOCAwLjVIMTIuNzIwMlYxMS45MDY3SDI0LjI0MThWMC41WiIgZmlsbD0iIzdmYmEwMCI+PC9wYXRoPjxwYXRoIGQ9Ik0xMS41MjE2IDEzLjA5MzNIMFYyNC41SDExLjUyMTZWMTMuMDkzM1oiIGZpbGw9IiMwMGE0ZWYiPjwvcGF0aD48cGF0aCBkPSJNMjQuMjQxOCAxMy4wOTMzSDEyLjcyMDJWMjQuNUgyNC4yNDE4VjEzLjA5MzNaIiBmaWxsPSIjZmZiOTAwIj48L3BhdGg+PC9zdmc+&style=for-the-badge&logoColor=white)](https://azure.microsoft.com/en-us/products/artifact-signing)-->

<br>

## What is Growther.ai C5?

Growther.ai C5 is a complete AI‑agent runtime that ships as **one self‑contained
executable** — no Node, no Docker, no dependency chase. Drop the binary on macOS,
Windows, or Linux and you have:

- **Multi‑agent orchestration** — a planner plus specialized coordinators and
  workers that decompose and execute real tasks, with per‑coordinator model routing.
- **Tool use, safely** — native tools, computer use & system control, and MCP
  integrations with industry-standard guardrails behind a human‑in‑the‑loop
  permission ladder, per‑tool circuit breakers, and egress DLP.
- **Chat, scheduling, and workspaces** — streaming chat that understands your
  imports, scheduled/recurring requests, and a kanban + library UI for attachments
  and deliverables.
- **Private by default** — everything lives in `~/.growther`, encrypted at rest
  with SQLCipher. Your prompts, data, and keys never leave the machine.
  Or decrypt your data at the touch of a button; you always own your data.
- **Self‑improving** — a built‑in flywheel that learns from your usage and gets
  better over time. Sparring loops automatically evaluate and improve the system
  doing your work.
- **Self-healing** - Don't worry if your browser, server, or LLM go down, or even if
  the power goes out. C5 keeps track of its work and will resume where it left off.
- **Peace of mind** - Rest easy: C5's databases auto-heal, auto-backup, and auto-recover.
  Configurable enterprise grade backup strategies for your data and configurations.
- **Total visibility** - See what C5 is doing, why it's doing it, and how it's doing it.
  Charts, graphs, and visualizations of budgets, data, productivity, and more.

The CLI is `growther`. One binary, batteries included.

<br>

## Install

**macOS / Linux**

```bash
curl -fsSL https://growther.ai/install.sh | bash
```

**Windows** (PowerShell)

```powershell
irm https://growther.ai/install.ps1 | iex
```

**Homebrew** (macOS / Linux)

```bash
brew install growther/tap/growther-c5
```

The installer detects your OS/arch, downloads the matching binary, **verifies its
SHA‑256**, puts `growther` on your PATH, and seeds `~/.growther` with the signed
build manifest (which the app verifies at runtime). Then:

```bash
growther --help
growther activate        # first‑run license / device activation
```

<br>

## Updating

```bash
growther update          # self‑update to the latest signed release (verifies the hash)
growther update --check  # just check whether a newer version exists
```

Or update the way you installed:

- **Homebrew** — `brew upgrade growther-c5` (the formula auto‑bumps the moment a
  release lands, so `brew` always has the newest version).
- **Install script** — re‑run the `curl … | bash` / `irm … | iex` one‑liner above.

<br>

## Growther.ai C5 alone vs. C5 + Mothership

C5 is fully functional on its own — a private, powerful agent platform you own end
to end. **Mothership** is the Growther cloud that turns a collection of private
installs into a compounding, self‑improving network.

| | **C5 standalone** | **C5 + Mothership** |
| --- | --- | --- |
| Agents · Harnesses · Orchestration · Recipes · Skills · Tool use · And more | ✅ Full | ✅ Full |
| Fault tolerant requests & storage | ✅ | ✅ |
| Kill‑switch | ✅ | ✅ |
| Local encrypted storage | ✅ | ✅ |
| Managed updates | ✅ | ✅ |
| Works fully offline | ✅ | ✅ _Purely additive_ |
| Accelerate quality & throughput | _Local only_ | ✅ **Dual**-flyweel effect |
| Analytics + performance insight | _Local only_ | ✅ Aggregate dashboards |
| Shared instructions / skills / rules / defect-detection | _Local only_ | ✅ **The flywheel** — patterns proven across the network propagate to you |
| Self-learning | _Local only_ | ✅ Exponential gains |
| Community bolstered self-improvement | — | ✅ Force-multiplied; privacy assured |

**The case for Mothership — network effects.** A single C5 gets better from _your_
usage. A fleet on Mothership gets better from _everyone's_: the flywheel measures
which prompts, skills, and rules actually win (Wilson‑dominance adoption) and
propagates them, so each install rides the collective's learning curve — not just
its own. Layer on managed operations — fleet control, signed updates,
telemetry‑driven fixes, billing — and Mothership is the difference between _running
an agent_ and _operating an ever‑improving agent platform at scale_.

Start standalone today; connect to Mothership with `growther activate` whenever you
want the network.

<br>

## Verify what you run

Every binary is published with a `.sha256` and a signed `build_manifest.json`. The
installer checks the SHA‑256 before installing, and C5 verifies the manifest's
Ed25519 signature at runtime (SOC 2 change management). Nothing runs that wasn't
built and signed by the release pipeline.

<br>

## Links

- 🌐 [Growther.ai](https://Growther.ai) — home
- 🌐 [docs.Growther.ai](https://docs.Growther.ai) — docs & resources
- 📦 [Release archive](dist/c5/) — every published version, with digests
- 🧾 [`releases.json`](dist/c5/releases.json) — versions catalog the
  installer and the in‑app auto‑updater read

<br>

---

The **Growther.ai** platform is built around best-practices in software
  architecture and development with enterprise-grade security and
  reliability standards, and automated deployment & quality control.
  The status block at the top is written automatically by the **C5** Release
  pipeline; everything else here is hand‑maintained.

<br>

<sub>**Shift-Left Quality Assurance:** Static analysis catches syntax, type, and security flaws before execution, unit tests verify isolated logic correctness, and integration tests guarantee components work together seamlessly—ensuring end-to-end platform reliability and rapid, confident releases.</sub>

---

<br>

### Patent Notice

Growther.ai C5 and Mothership mechanisms are covered by U.S. Patent Application No. 64/130,388.
