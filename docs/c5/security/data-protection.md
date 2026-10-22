---
title: Data protection
description: What C5 checks for before anything leaves your machine.
order: 6
---

# Data protection

C5 agents use tools — searching the web, calling an API, posting to a service.
Every one of those is a moment where something could leave your machine that you
did not mean to send.

Before any tool runs, C5 reads what it is about to send and looks for things that
should not be going anywhere.

## What it looks for

**Credentials.** API keys and tokens for the services people actually use —
OpenAI, Anthropic, AWS, GitHub, Stripe, Slack, Google, and others — plus private
keys, JWTs and `Authorization: Bearer` headers. It also catches the common shape
of a secret written into a config line, like `api_key = "..."`.

**Personal information.** Email addresses, payment card numbers, IBANs, US Social
Security numbers and internationally formatted phone numbers.

Card numbers, SSNs and IBANs are **checked, not guessed at**. C5 runs the real
validation rules — the checksum on a card, the mod-97 check on an IBAN, the
number ranges the SSA has never issued — so an order number or a record ID does
not get flagged as a credit card just because it is the right length.

## What happens when it finds something

An administrator chooses, in **Settings › Tools**, under *Egress Data-Loss Prevention*, at
the machine running C5 (see
[Settings only an administrator can change](/c5/security/permissions#settings-only-an-administrator-can-change)):

| Setting    | What C5 does                                                             |
| ---------- | ------------------------------------------------------------------------ |
| **Redact** | Masks the value, then lets the tool run. This is the default.            |
| **Warn**   | Records what it found and lets the call through unchanged.               |
| **Block**  | Stops the call. The tool never runs.                                     |
| **Off**    | No checking at all.                                                      |

With redaction, the agent's request still goes out and still works — the
sensitive value is replaced with a marker like `«REDACTED:credit_card»` before it
leaves.

## Turning it on

It is already on. **Block PII Exfiltration** in **Settings › Guardrails** ships
enabled, and enabling it is all that is needed — C5 redacts by default. Use
**Egress Data-Loss Prevention** in **Settings › Tools** only if you want warn or block
instead.

## What this does not cover

Worth being straight about:

- It checks what agents **send to tools**. It does not scan what tools send back,
  or the agent's own written replies.
- It looks for recognisable formats. A secret with no distinctive shape — a
  password in a sentence, say — will not be spotted.
- **Logs are plain text.** Before v327, C5 wrote the start of a task's goal to
  `logs/categorization-debug.log` whenever a categorisation failed. It no longer does, but
  an existing file is kept; see
  [Where your data lives](/c5/configuration/data-location#the-four-kinds-of-files) for what to
  do with it.
- **Prevent Prompt Injection** and **Halt on Hallucinations** in Settings ›
  Guardrails need an external policy engine. With the policy engine set to
  Native they do nothing, and the Guardrails screen marks them **Not enforcing**
  so you can see that at a glance rather than assuming a switch in the on
  position means you are covered.

Nothing here contacts the internet. All checking happens on your machine, which
means it works the same in an air-gapped install as anywhere else.

## Where to go next

- [Permissions](/c5/security/permissions) — decide what agents may do at all.
- [Encryption](/c5/security/encryption) — how your data is stored at rest.
