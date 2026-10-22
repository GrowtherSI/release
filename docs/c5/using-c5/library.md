---
title: Library
description: Where your finished work, files, notes, and projects live.
order: 5
---

# Library

The Library is where your work ends up. Anything your agents make is saved here so you
can find it later.

## What is inside

The Library is split into tabs:

| Tab              | What it holds                                                |
| ---------------- | ------------------------------------------------------------ |
| **Projects**     | Groups of related work, kept together.                        |
| **Deliverables** | Finished pieces of work meant to be handed to someone.        |
| **Documents**    | Longer written pieces your agents wrote or edited.            |
| **Notes**        | Short bits of writing — ideas, reminders, findings.           |
| **Attachments**  | Files you gave C5, and files it made along the way.           |
| **Output**       | Raw results from tasks, before anyone cleaned them up.        |

## Finding things

There is a search box at the top of every tab. It looks inside your files, not just at
their names, so you can search for a phrase you remember — except on **Attachments**, which
searches names, descriptions and C5's analysis of each file (see below).

You can also:

- **Filter by date** to see only recent work
- **Filter by tag** to pull up everything about one topic
- **Sort** by newest, oldest, or name

## Projects

A project is a folder for related work. If you are working on one big thing over several
weeks, make it a project. Then every task, file, and note about it stays together.

To start one, click **New project** and give it a name. After that you can point new
work at it, and C5 files the results in the right place.

## Deliverables

A deliverable is a finished piece of work. It is separate from your everyday files
because it is the thing you actually hand to someone.

Deliverables can be signed, which is a way of proving a file came from you and has not
been changed since. This matters when you send work to a client. See
[Workspaces](/c5/configuration/workspaces).

### Images in a deliverable

When a deliverable's PDF carries images an agent fetched from the web:

- **Each image appears once**, even if it was attached twice, or attached again under the
  same headline.
- **It sits with the item it belongs to**, after that item's headline, summary and link,
  under a readable file name instead of a string of letters and digits.
- **Its caption says where it came from**, ending _| Source: domain (address)_.
- **Lines that only name an image file**, such as `**Image:** headline1.jpg`, are left out
  of the text, because the image itself is shown.

An image that belongs to no item goes into a **Task Attachments** section at the end, and
the images the task started with into **Task Inputs**.

## Attachments

**Attachments** holds every file attached to your tasks and chats: the ones you gave C5 and
the ones its agents made. Its header counts them, **Attachments (N)**.

- **Search.** **Search attachments...** looks through every attachment, not only the ones
  on screen, by name, description and C5's analysis of the file; it does not read inside the
  files. Clear it to get back the list you had, scrolled where it was (when the type filter
  is **All**).
- **Filter by type.** **All**, a group — **Documents**, **Images**, **Text & Code**,
  **Audio**, **Video**, **Archives**, **Other** — or one type within it, such as **PDF** or
  **PNG**. Only the types you have are offered.
- **Previews.** A text file's card shows its first lines. A PDF's card shows its first page
  where Poppler's `pdftoppm` is installed on this machine, and a plain PDF card otherwise.
- **Open one** to see it full size: an image or a PDF in place, and text, Markdown, JSON,
  CSV or code in a viewer with **Copy** (and **Preview** or **Source** for Markdown). Other
  files, such as a video or a ZIP, are not previewed properly: download them to open them.
  **Download** there saves the file.
- **Download several.** Tick them and press **Download Selected (N)**: C5 saves them one
  after another, each under its own name. Your ticks stay while you search, so you can
  gather files from several searches. Ticking needs **Edit** on Attachments. In the table
  view, the header's tick selects the rows shown and replaces what you had ticked.

## Getting files out

Everything can be downloaded — an attachment from its preview, or several at once from the
Attachments tab. There is nothing locking your work inside C5 — files are files, and you
can take them whenever you like.

You can also download a whole project at once as a zip.

## Cleaning up

Over time the Library fills up. To keep it useful:

- **Archive** finished projects. They leave your main view but stay searchable.
- **Delete** things you truly do not need. This cannot be undone.
- **Tag** as you go, so search stays quick. See [Tags](/c5/configuration/tags).

## Where your files really are

Everything in the Library is stored on your own computer, inside your data folder,
encrypted. Nothing is sitting on someone else's server.

If you want to see where, look at `GROWTHER_HOME` in
[Environment variables](/c5/cli/environment).
