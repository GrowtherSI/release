---
title: Guardrails
description: Protect your network, redact sensitive data, and set rules agents cannot cross.
order: 3
---

# Guardrails

Guardrails are safety boundaries that keep agents on track. They stop private data from
leaking, restrict which websites agents can reach, and enforce limits on automated actions.

You can configure guardrails in **Settings › Guardrails**, or by editing the configuration
file directly at:

```text
~/.growther/config/guardrails.yaml
```

Like other C5 config files, this file is stored with owner-only (`0600`) permissions so other
accounts on your machine cannot view or change your security rules.

## 1. Application policy (Galileo)

Application policies inspect what an agent is thinking and doing to prevent common safety
mistakes before they happen.

| Setting | What it does | Default |
| --- | --- | --- |
| **Block PII Exfiltration** | Scans tool arguments for emails, card numbers, IBANs, SSNs, and phone numbers, and redacts them. | On |
| **Prevent Prompt Injection** | Catches adversarial instructions hidden inside documents or websites. | On *(requires policy engine)* |
| **Halt on Hallucinations** | Stops execution if the agent's confidence or factuality check drops too low. | Off |
| **Semantic Topic Boundaries** | Plain English instructions describing topics or actions the agent must avoid. | Empty |

### Enforcement badges

In **Settings › Guardrails**, you will see status badges next to each control:

- **Enforcing (Green)** — The rule is turned on and actively protecting your system.
- **Not enforcing (Amber)** — The toggle is on, but it needs an external policy engine (like Galileo Agent Control) to evaluate checks. When using Native mode, C5 lets you know so you never assume protection that is not active.

## 2. Network containment (ASC)

Network containment lets you control where C5's built-in web tools (`read_url`, `web_search`)
are allowed to connect.

| Setting | What it does | Default |
| --- | --- | --- |
| **Zero-Trust Default** | Blocks all outbound web tool requests unless the domain is explicitly allowed. | Off |
| **Allowed Domains** | A list of approved web domains. Supports wildcards like `*.github.com`. | `*.github.com`, `api.stripe.com` |
| **Allowed Protocols** | Which ports and schemes are permitted (e.g. `HTTPS (443)` and `HTTP (80)`). | Both |

> **Warning: What network containment covers**  
> The allowlist is enforced inside C5's own web tools (`read_url`, `web_search`). It is not a system-level firewall: raw shell commands (`run_command`), MCP servers, and traffic to your configured model providers do not pass through this filter.

## 3. System Control guardrails

When agents use System Control to drive your screen, keyboard, or mouse, extra safeguards apply:

- **Require a budgeted grant** — Unattended runs must have a time limit or step limit before driving the system. This prevents forgotten background tasks from clicking around unattended.
- **Screenshot preview** — Attaches a live screenshot to interactive approval prompts so you see exactly what the agent is looking at before you approve an action.
- **Fail closed on engine timeout** — If an external policy engine is configured but unreachable, C5 blocks the action rather than silently allowing it through.

## 4. The hard-deny list

Some commands are refused outright, whatever else is configured. Examples include
deleting your home folder or the whole disk (`rm -rf ~`, `rm -rf "$HOME"`, `rm -rf /`),
and reading private keys such as `~/.ssh/id_rsa`.

- It is aimed at the truly catastrophic, so ordinary work is not caught: deleting a
  build folder or a path under `/tmp` is fine, and so are value-free templates such as
  `.env.example`. A delete is refused if **any** of its targets is the root or your home
  folder (`rm -rf build /` included).
- The list is checked **first**, for **every** agent, before any other review.
- It stays on even when Guardian is switched off. Switching Guardian off turns off the AI
  review of tool calls, not this list.
- Guardian's own agent gets no exemption: its tool calls are checked like everyone
  else's.
- The same list protects both C5 itself and the Guardian hook installed into your agent
  gateways, so the two can never disagree.
- If C5 cannot write the audit record for a refusal, the command is still refused.

## 5. How changes are saved

When you save changes in **Settings › Guardrails**:

- C5 sends only the specific settings you changed, ensuring settings configured in other tabs (like Tools or Extensions) are never accidentally overwritten.
- Files are saved safely using atomic replacement so a sudden power loss or restart never leaves a half-written configuration file.
- If you edit `guardrails.yaml` by hand, your custom rules take effect immediately.

## Where to go next

- [Permissions](/c5/security/permissions) — decide what your agents may do alone.
- [Data protection](/c5/security/data-protection) — how C5 detects and masks secrets.
- [Local encryption](/c5/security/encryption) — how your databases and keys are secured.
