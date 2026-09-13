# Growther.ai Documentation

This folder holds the source for [docs.growther.ai](https://docs.growther.ai).

Every page is a Markdown file. The docs website reads this folder at build time and
turns it into a searchable site. You can read the docs right here on GitHub, or read
them on the website with search, navigation, and a table of contents.

## How this folder is organized

```
docs/
└── c5/                     one folder per product
    ├── getting-started/    install C5 and run your first task
    ├── using-c5/           a page for each area of the app
    ├── cli/                the growther command
    ├── configuration/      settings, providers, integrations
    ├── mothership/         the optional Growther.ai cloud
    ├── security/           encryption, permissions, backups
    └── troubleshooting/    fixes, FAQ, and how to get help
```

## How pages work

Each folder has a `_meta.json` file that gives the section a title and a sort order:

```json
{ "title": "Getting Started", "order": 1 }
```

Each Markdown file starts with front matter that gives the page a title, a short
description, and a sort order:

```markdown
---
title: Installation
description: Install C5 on macOS, Windows, or Linux.
order: 2
---
```

The website uses `title` for navigation, `description` for search results and search
engines, and `order` to sort pages inside a section.

## Generated blocks

Put `<!-- RELEASES -->` on a line by itself and the website replaces it with a
per-platform download table built from `dist/c5/releases.json` — versions, file
sizes, and checksums, kept in step with the release pipeline automatically. It is
used on `c5/getting-started/downloads.md`. Before the first release is published
it renders an explanatory placeholder, so the page is never broken.

Put `<!-- CHANGELOG -->` on a line by itself and the website replaces it with the
release ledger — one block per version, its changes grouped into what is new, what
is fixed, and what is faster, built from `dist/c5/changelog.json`. It is used on
`c5/changelog/overview.md`. Each line is written once, read by a person before it
reaches this repository, and then frozen: a rebuild never rewords a version that
has already been published. The generated block carries no links of its own, so
anything the page needs to link to belongs in the prose above the marker.

## Writing style

- Write so a fifth grader can follow along. Short sentences. Common words.
- Say "you" and tell the reader what to do.
- Show the command, then say what happens after you run it.
- Explain what a feature does for the reader, not how it is built inside.

## What not to write

This content is public. It must not describe how C5 works internally — its
architecture, how it decides or scores anything, its data model, or any technique
specific enough for someone else to rebuild. Describe **what a feature does for
the reader**, never **how the system does it**.

The [public README](../README.md) is the ceiling: anything at or below its level
of detail is safe, and anything beyond it needs a second look.

Accuracy matters as much as discretion. Every command, flag, default, and file
path in these pages should be checked against the real product before it ships —
a confident wrong statement on a security page can cause real harm.

## Editing

Edit any file here and open a pull request. When it merges to `main`, the website
rebuilds and the change goes live. There is no separate copy of this content — the
website has no pages of its own.
