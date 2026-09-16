---
title: Downloads
description: Every published C5 build, with file sizes and checksums you can verify.
order: 5
---

# Downloads

Most people should use the install commands on the
[Installation](/c5/getting-started/installation) page. They pick the right file for your
computer, check it, and set everything up for you.

This page is for when you want the file itself — to install by hand, to keep a copy, or
to check a download you already have.

## Install commands

**macOS and Linux**

```bash
curl -fsSL https://growther.ai/install.sh | bash
```

**Windows** (PowerShell)

```powershell
irm https://growther.ai/install.ps1 | iex
```

**Homebrew**

```bash
brew install growtherai/tap/growther-c5
```

## Direct downloads

Pick the file that matches your computer. If you are not sure which one you need, use an
install command above instead — it works this out for you.

<!-- RELEASES -->

**On a Mac, take the `.pkg`.** It is an installer: double-click it, enter your password,
and C5 sets itself up and starts, with its log in a Terminal window. Make sure you take
the one for your Mac — `arm64` for Apple silicon, `x64` for an Intel Mac. macOS will not
install the wrong one, and it says so only quietly, so it can look as though nothing
happened.

**On Windows and Linux, the file is a `.zip`** with the program inside it. Unzip it first.
On Windows, double-click the program to start it. On Linux, run it from a terminal — your
file manager will not start it for you.

Unzipping on a Mac and double-clicking the program inside **will not work**, which is why
the Mac download is the `.pkg` instead: macOS treats a double-clicked program file as a
document and refuses to open it, whoever published it. That is not a sign anything is
wrong with your download.

## Check your download

Every file has a **SHA-256** — a short string calculated from the file's contents. If
even one byte of the file is different, the string comes out completely different.

Each build in the table above has a **Copy** button next to its SHA-256. Copy it, then
compare it to what your computer calculates. (If no builds are listed yet, there is
nothing to check here — the install commands verify for you.)

**The macOS `.pkg`** checks itself. It is signed and carries Apple's approval inside the
file, so the Installer verifies it before it will open — even with no internet. You do not
need to compare anything by hand. To see who signed it:

```bash
pkgutil --check-signature growther-c5-<version>-arm64.pkg
```

It should say it is signed by a certificate issued by Apple for distribution, and trusted
by Apple's notary service.

**Linux** (check the `.zip` you downloaded, before unzipping it)

```bash
sha256sum growther-c5-linux-x64-<version>.zip
```

**Windows** (PowerShell)

```powershell
Get-FileHash growther-c5-win-x64-<version>.zip -Algorithm SHA256
```

If the two strings match, your download is genuine and undamaged. If they do not match,
delete the file and download it again.

> **Danger**
> Do not run a file whose SHA-256 does not match. A mismatch means the file is not the
> one Growther.ai published.

The install commands do this check for you automatically, and so does `growther update`.
See [Verifying releases](/c5/security/verifying-releases) for the full picture.

## Which channel should I use?

| Channel  | Who it is for                                        |
| -------- | ---------------------------------------------------- |
| `stable` | Everyone. Tested and ready for daily use.            |
| `beta`   | People who want new features early and can hit bugs. |
| `dev`    | Testing only. Expect rough edges.                    |

Stick with **stable** unless you have a reason not to. You can switch channels at any
time — see [Updating C5](/c5/getting-started/updating).

## Older versions

Every version ever published is kept, along with its checksums, in the
[release archive](https://github.com/growtherai/release/tree/main/dist/c5).

You do not normally need an old version. If a new one causes trouble, `growther rollback`
puts back the one you had before, which is easier and safer than downloading by hand.
