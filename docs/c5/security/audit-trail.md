---
title: Audit trail
description: The record of what happened, why you can trust it, and how to keep a copy.
order: 8
---

# Audit trail

C5 keeps a running record of what it did. This page explains what is in it, why it can be
trusted, how long it is kept, and how to take a copy away with you.

You will find it in **Ops › Audit**.

## What it records

- **Sign-ins and account changes** — passkey enrolments, logins, users created and updated.
- **Administrative access** — every attempt at an admin action, whether it was allowed or
  refused.
- **Security events** — rate limits hit, blocked attempts to reach outside a permitted folder,
  requests refused because the caller did not own the thing they asked for.
- **Storage changes** — turning database encryption on or off.
- **Tool and extension permissions** — changes to what an agent is allowed to use, and to
  search providers and integrations.

Two further records are shown in the same list, so one timeline covers everything:

- **Tool decisions** — every time an agent was allowed or refused a tool, and which one.
- **System notifications** — the things C5 told you about.

Each entry has a time, an actor, what was touched, whether it succeeded, and how serious it
was. The **Source** column says which of the three records a row came from — the audit trail
itself, a tool decision, or a notification. That distinction matters more than it looks: only
the audit rows are fingerprinted, and the three are not all kept for the same length of time.
See [How long it is kept](#how-long-it-is-kept).

Ordinary settings changes are **not** here. Saving a change in most Settings areas does not
write an audit entry. The exceptions are the security settings: a change to one of the
[settings only an administrator can change](/c5/security/permissions#settings-only-an-administrator-can-change)
is recorded with who made it, and so is a paired device's refused attempt.

## Why you can trust it

This section is about the audit entries — the first group in the list above. Tool decisions
and notifications are ordinary records: useful, but not fingerprinted and not chained.

The audit trail is **tamper-evident**. Every entry carries a fingerprint of the entry before
it, so the day's entries form one continuous chain.

Change a word in an old entry, or take an entry out, and every fingerprint after it stops
matching. There is no way to quietly edit history: the break shows up immediately, and it
shows up at the exact entry that was touched.

Tamper-evident is not the same as tamper-proof. Someone with access to your computer can
still delete the whole file. What they cannot do is alter it and have it still look right.

Every audit entry is also written twice — once where you can search and filter it, and once as
a dated file in your C5 folder. The two are kept in step with each other, so they cannot end up
telling different stories.

## How long it is kept

**Settings › Storage › Audit Trail Retention** sets how many days to keep. Anything from 1 to
365 days; the default is 90.

C5 removes records **a whole day at a time**, and only once the last thing that happened that
day has aged out of the window.

> **Note**
> A worked example. You set retention to 30 days.
>
> An activity that ran late on your 31st-oldest day and carried on into the 30th sits right on
> the edge. That whole day is kept, in one piece, until every last entry from it is older than
> 30 days. Nothing is snipped out of the middle.
>
> The result: you may hold slightly more than 30 days of history. You will never hold less.

Whole days, rather than individual entries, is what protects the chain described above. If C5
removed only the entries older than the cutoff, it would break the fingerprints of the entries
it kept — and a trail that looks tampered with every time it is tidied up is worth nothing.

So the rule you can rely on is: **a broken chain always means someone changed the record. It
never means C5 cleaned up.**

Old records are removed once a day, late in the evening, a few minutes before the nightly
database backup — so your backups hold the tidied-up version rather than a copy of what you
asked to delete.

### The other two kinds of row

**Tool decisions** are covered by the same setting, and removed on the same nightly pass — but one
at a time as each passes the cutoff, rather than a whole day at once. They are not chained, so
there are no fingerprints to protect and nothing is gained by keeping a day together.

> **Note**
> **Tool decisions are never removed sooner than 90 days**, whatever the slider says. They are
> also what the Analytics tool charts count, and those charts can look back up to 90 days. If a
> shorter setting were applied to them, a chart would quietly show less tool activity than really
> happened — an all-clear nobody measured — so a floor of 90 days is enforced for this kind of row.
> Setting the slider above 90 days keeps them longer, in step with everything else.

**System notifications** are not covered. They have no retention setting of their own and nothing
ages them out, so a notification from two years ago will still be there, looking as current as
everything around it.

> **Warning**
> So "the last 90 days" is true of the audit rows, not of the whole view. If you are answering a
> question about what the record covers, answer it per source — the **Source** column is how you
> tell which is which.

There is a second, separate setting for C5's own operational events. See
[Settings](/c5/configuration/settings).

## Exporting a copy

**Ops › Audit › Export CSV** downloads the trail as a spreadsheet file.

Four things worth knowing:

- **You get everything that matches, not the page on screen.** The file is built on the server
  from the whole record — all three kinds of entry, audit rows, tool decisions and
  notifications alike — rather than from the fifty rows in front of you.
- **It usually holds more than the count says.** The list on screen loads only the most recent
  activity — several hundred rows at most — while the export has no limit at all. So the
  number above the table is a floor, not a total: on an install with any history behind it,
  expect the file to be longer — sometimes far longer. What it will never be is shorter than
  what you can see.
- **Your filters come with it.** Filter by action, severity or actor first, and the export
  matches what you are looking at. The filename says whether the export was filtered, so a
  file that leaves your machine cannot be mistaken for the complete trail.
- **The fingerprints are included** — on the audit rows. The chain columns are in the CSV, so
  whoever receives it can check those records end to end with their own tools, without taking
  C5's word for it and without having C5 installed. Tool decisions and notifications are not
  fingerprinted, so those columns are empty on those rows; the Source column is what makes an
  empty fingerprint read as "this kind of record was never chained" rather than as a broken
  one.

A large export can take a few seconds. The button says so while it works, and tells you if it
fails rather than quietly doing nothing.

> **Note**
> Export is how you keep a copy of records longer than your retention setting. Once a day has
> aged out it is gone from both copies, and every backup taken from that night onwards was
> made after the tidy-up — so restoring one does not bring it back.

**Under a preservation obligation, use legal hold instead of exporting.** An administrator can
turn on **Legal hold**, which suspends audit pruning entirely: nothing ages out for as long as
it is on, so the record stays complete and in place rather than depending on somebody having
remembered to export the right days. It is a lockable policy key, so your organisation can set
it centrally and stop it being turned off on the device. `growther doctor` reports whether a
hold is active, and `growther evidence` exports the held record for an auditor.

## What this is not

- **It is not a backup.** It records what C5 did, not the contents of your work. See
  [Backups & recovery](/c5/security/backups).
- **It is not a permission control.** It records decisions; it does not make them. See
  [Permissions](/c5/security/permissions).
- **It does not leave your machine unless you send it.** Nothing is shipped by default.
  An administrator can configure a destination — OpenTelemetry, Microsoft Sentinel, Splunk
  HEC or syslog — under **Settings › Enterprise › Audit**, and from then on every sealed
  entry is spooled and delivered there. A remote syslog collector must be `tls://`; plain
  `tcp://` is accepted only to a loopback forwarder on this machine. See
  [Shipping audit events](/c5/security/audit-shipping).

## Where to go next

- [Settings](/c5/configuration/settings) — where the retention sliders live.
- [Permissions](/c5/security/permissions) — what your agents may do in the first place.
- [Backups & recovery](/c5/security/backups) — keeping your own copy of everything.
