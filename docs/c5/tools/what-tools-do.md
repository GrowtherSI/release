---
title: What tools do
description: How agents reach outside the chat window to do real work.
order: 1
---

# What tools do

A **tool** is something an agent can use to affect the real world. Without tools, an
agent can only talk. With tools, it can do.

## Examples of tools

- Reading and writing files on your computer
- Searching the web and reading pages
- Running commands
- Talking to other programs you use
- Controlling your screen, keyboard, and mouse

## How an agent uses one

When an agent decides it needs a tool, it says so, uses it, and gets a result back. All
of that shows up in the conversation. You can see:

- Which tool it used
- What it asked for
- What came back

Nothing is hidden. If an agent read a file, you will see which file.

## You decide what is allowed

An agent can only use tools you have allowed. Some are safe and always on. Others ask
you first. Some you may want to switch off entirely.

C5 stops and asks before anything risky — deleting things, spending money, sending data
off your computer. You get a clear message describing exactly what it wants to do.

This is covered fully in [Permissions](/c5/security/permissions).

## Built-in safety

Beyond asking you, C5 has guards that work on their own:

- **A tool that keeps failing gets switched off** for a while, instead of retrying
  forever. This stops one broken thing from burning your budget.
- **Information leaving your computer is checked** as a backstop against an accidental
  leak. It catches common patterns, not everything — do not rely on it to notice a
  secret.
- **Everything is recorded**, so you can look back at what happened.
- **A placeholder is never saved as a result.** `write_file` (and its other name,
  `create_file`) refuses to write an empty file, and refuses any text written to a video,
  image, PDF, Office or ZIP file (`.mp4`, `.mov`, `.webm`, `.mkv`, `.avi`, `.png`, `.jpg`,
  `.jpeg`, `.webp`, `.gif`, `.pdf`, `.docx`, `.xlsx`, `.pptx`, `.zip`) — except a PDF whose
  text really is a PDF. Its refusal tells the agent which tool makes the real thing, or to
  write Markdown that C5 turns into the deliverable. So an agent that cannot make a file
  says so, rather than leaving a file that only looks like one.

## Pictures and video

Agents can make images and short videos on this machine, and fetch images from the web:

- **`render_svg`** draws an image (PNG by default, or JPEG or WebP), from the agent's own
  drawing or from a ready-made card: `editorial_card` (a headline card), `stat_callout` (a
  big number), `quote_card` (a quotation) or `badge_banner` (a slim header banner, 1200×240
  unless asked otherwise, with an optional badge, a one-line title and subtitle, and the
  source and date).
- **`render_video`** makes a video from slides: an H.264 `.mp4`, 1920×1080 unless asked
  otherwise, with each slide's caption shown on it and, for a task, written beside it as a
  `.vtt` caption file. It uses **ffmpeg** on this machine, which C5 does not ship. C5 looks
  for it first at the **FFmpeg location** in **Settings › Tools**, then in `FFMPEG_PATH`,
  then on your `PATH`, then in `/opt/homebrew/bin`, `/usr/local/bin`, `/opt/local/bin` and
  `/usr/bin`. Set the location when ffmpeg is anywhere else, or when C5 starts at sign-in,
  which does not see your shell's `PATH` or an `FFMPEG_PATH` you exported. It must be the
  full path to a file named `ffmpeg`, and only an administrator can set it; a save with
  anything else is refused and says why. C5 notices a newly installed ffmpeg within a
  minute, without a restart. Without it, the tool refuses and suggests `render_svg`
  instead, and a task that asks for a video is told when it is planned that ffmpeg was not
  found, so it delivers the frames and a storyboard rather than a video.
- **`fetch_web_image`** downloads one image from an address into the task, as an attachment
  with a readable file name and a line naming where it came from. To find a page's main
  image, `read_url` reads the image the page itself names for sharing (its Open Graph,
  Twitter Card or Schema.org image) and can attach it. Reading a page asks nothing in an
  unattended run, but a `read_url` that attaches the image saves a file, so it is treated
  like `fetch_web_image`: it asks for approval unless a grant or its master switch covers
  `read_url`, and the guardian checks it.

A result is kept with the task, up to 25 MB; a larger one is refused, as a video or an
image, by its kind. Each of these tools has a switch under **Master
Tool Authorizations** (see [Permissions](/c5/security/permissions#setting-the-level)).

## Adding more tools

Two ways:

- **Integrations** connect C5 to services you already use. See
  [Integrations](/c5/tools/integrations).
- **MCP servers** are a standard way to add new abilities. See
  [MCP servers](/c5/tools/mcp-servers).

## Seeing which tools get used

The **Tools** view in [Analytics](/c5/using-c5/analytics) shows which tools your agents
reach for most, and which ones fail. A tool that fails often is usually misconfigured
rather than broken.

## Where to go next

- [Permissions](/c5/security/permissions) — set the rules.
- [MCP servers](/c5/tools/mcp-servers) — add new abilities.
- [Computer use](/c5/tools/computer-use) — let an agent drive your screen.
