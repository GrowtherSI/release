---
title: Installation
description: Install Growther.ai C5 on macOS, Linux, or Windows.
order: 2
---

# Installation

C5 is a single program file. Pick the way you like to install it below.

> **Note**
> You do not need Node, Docker, or any other tool installed first. C5 brings
> everything it needs with it.

## macOS and Linux

Open your terminal and run:

```bash
curl -fsSL https://growther.ai/install.sh | bash
```

## Windows

Open PowerShell and run:

```powershell
irm https://growther.ai/install.ps1 | iex
```

## Homebrew (macOS and Linux)

If you already use Homebrew, you can install C5 this way instead:

```bash
brew install growtherai/tap/growther-c5
```

## What the installer does

The installer takes care of a few things for you:

1. It looks at your computer and picks the right version of C5.
2. It downloads that version.
3. It checks the download against a known fingerprint, called a **SHA‑256**. If even one
   byte is wrong, the install stops. This makes sure you got the real file.
4. It puts the `growther` command on your PATH, so you can run it from any folder.
5. It creates your data folder at `~/.growther`.

## Check that it worked

Run this to see the help screen:

```bash
growther --help
```

If you see a list of commands, C5 is installed.

Now turn it on and set it up for the first time:

```bash
growther activate
```

This pairs your computer with your license. C5 will show you a code and open a page
where you confirm it. This only happens once per computer.

You need a license first — get one from [growther.ai](https://growther.ai). If you do not
have one yet, do that before running this step. Someone sent you a referral link or
a discount code? See [Referrals and discount codes](/c5/getting-started/referrals).

## Start C5

Run the command by itself to start C5:

```bash
growther
```

C5 starts and prints the address it is running on:

```text
C5 API running on http://localhost:4299
```

Open that address in your browser to use the app.

> **Tip**
> Want a different port? Set the `PORT` value before you start:
> `PORT=5000 growther`

## Start C5 without using the terminal

You do not have to type anything to start C5. Installing it also adds an icon named
**Growther.ai C5**, and double-clicking that opens a window showing C5 starting up, the
same as the command does.

| System  | Where the icon is                                                            |
| ------- | ---------------------------------------------------------------------------- |
| macOS   | Your **Applications** folder. It also appears in Launchpad and in Spotlight.  |
| Windows | The **Start menu**. Type "Growther" to find it.                              |
| Linux   | Your applications menu, if your desktop has one.                             |

The icon and the `growther` command start the **same** C5 — there is only ever one copy
of the program on your computer, and updates reach both. The icon is only a pointer to it.

A window opens with C5's log in it, which is the same information the command shows. C5 is
running for as long as that window is open, so **closing the window stops C5**. If you
would rather it kept running in the background, use "Keep growther running" in Settings.

> **No icon?**
> It is created the first time C5 runs, so start it once from the terminal with `growther`
> and it will appear. On Linux it also needs a desktop environment with an applications
> menu and a terminal program installed; on a server without one, use the command.

### Start directly from your browser

If C5 was stopped while your browser tab is still open, you do not even need to find the icon or open a terminal. The page displays a green **Start C5** button in the sidebar menu and in **Settings → System**. Clicking it triggers your operating system's built-in `growther://start` link, launching C5 and reconnecting the page automatically.

## Supported platforms

| System  | Chips supported            |
| ------- | -------------------------- |
| macOS   | Apple Silicon and Intel    |
| Windows | x86_64 and ARM64           |
| Linux   | x86_64                     |

## If the command is not found

If your terminal says `growther: command not found`, your shell probably has not picked
up the new PATH yet. Close the terminal window and open a new one, then try again.

Still stuck? Run the built-in checkup:

```bash
growther doctor
```

It looks at your install, your license, and your files, and tells you what is wrong.
See [Common issues](/c5/troubleshooting/common-issues) for more help.

## Next steps

- [Quickstart](/c5/getting-started/quickstart) — run your first task.
- [Updating C5](/c5/getting-started/updating) — keep C5 current.
- [Deploying across an organisation](/c5/configuration/deploying) — for IT, the Windows and
  macOS installer packages.
