---
title: Audit shipping and evidence
description: Send the audit trail to Sentinel, Splunk, OpenTelemetry or syslog; hold records for legal hold; export a signed evidence bundle.
order: 10
---

# Audit shipping and evidence

C5 already keeps a tamper-evident [audit trail](/c5/security/audit-trail) on the machine.
This page is about getting a copy into the system your security team already watches, and
producing evidence when somebody asks for it. It is for administrators: only an
administrator can set up, test or backfill a destination.

Set it up under **Settings › Enterprise › Audit shipping**.

## Where it can go

| Destination | What to provide |
| --- | --- |
| OpenTelemetry (OTLP over HTTP) | The collector endpoint |
| Microsoft Sentinel / Azure Monitor | The ingestion endpoint, the rule id and the stream name |
| Splunk | The HTTP Event Collector URL, plus the index and sourcetype you want |
| Syslog | A `tls://host:port` collector. Plain `tcp://` is accepted only to a loopback forwarder on this machine, where the cleartext hop never reaches a wire. Records are written in CEF |

The token or key is a keystore reference, never a value typed into a settings field.

To set up a destination:

1. Put the token or key in a keystore and copy its reference, a value beginning `ref:`. One
   way: add it to `config/c5.yaml` under a name ending in `_TOKEN`, then move it into the
   keystore under **Settings › Enterprise › Secrets custody**. C5 leaves the reference in the
   file in its place, for example `ref:keychain:c5/SPLUNK_TOKEN`. See
   [Secrets and keys](/c5/security/secrets-and-keys).
2. In **Audit shipping**, choose the destination under **Ship to** and fill in its fields,
   with the reference in **Credential reference**.
3. Press **Test**. It sends one synthetic record so you can confirm it arrives.
4. Press **Save**.

## What happens when the destination is down

Nothing is lost and nothing is delayed. Records are written to the local chain first, then
queued on disk. The queue position only advances when your system has actually accepted a
batch, so an outage produces a growing backlog and a red status line rather than a gap you
discover months later.

The queue is capped at 256 MB. If a destination stays down long enough to fill it, C5 drops
the oldest records and writes a marker in their place, so the gap is visible in your own
system with a count and a time span, rather than being silent.

The status row shows the queue depth, the last successful delivery and the last error.

## Backfilling

Choose a date under **Backfill since** and press **Backfill**. C5 walks the existing chain
from that date and ships it in order. It resumes if it is interrupted. Use it after first setting a destination up, or after a
long outage that overflowed the queue.

## Retention and legal hold

Two retention settings decide how long records stay on the machine: the audit trail and the
operational event log. Your organisation can lock both through policy.

**Legal hold** suspends every purge, including backup rotation, until you turn it off.
While it is on, nothing is deleted by age. Turn it on the moment you are told to preserve,
not after.

## Evidence bundles

When someone asks you to produce the record:

```bash
growther evidence export --from 2026-01-01 --to 2026-06-30 --out ./evidence.tar.gz
```

The bundle contains the audit files for that range, a verification result for each day's
hash chain, the diagnostic report, and a manifest with a SHA-256 for every file. Add
`--sign-key` to sign the manifest so a recipient can prove it has not been altered since
you produced it.

A day whose chain does not verify is still included, and the verification result says so.
That is deliberate: an evidence bundle that quietly omitted a bad day would be worse than
useless.

Settings has no button for this: use the command above. (A script can also ask a running C5
for a bundle through its API; that one is written under `logs/audit/evidence` in your C5
folder.)

## What is in a record

Who did what, to which resource, when, whether it succeeded, and a severity, plus a few
details that depend on the action. A model call, for example, names the model and the agent
it was for. The list of actions is in
[What it records](/c5/security/audit-trail#what-it-records).

C5 does not put document contents, conversation text or credentials in the audit trail, so a
copy sent to your security system carries the fact of an action, never its payload.
