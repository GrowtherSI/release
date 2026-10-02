---
title: Open-source licences and downloaded models
description: Where to read the third-party notices, what they list, whose terms govern each model C5 downloads, and how to run C5 on your own copy of libvips.
order: 13
---

# Open-source licences and downloaded models

C5 is built with open-source software and ships with the Node.js runtime inside it. To keep
your content on your machine, it also downloads up to five machine-learning models (about
3.1 GB in all) and runs them locally. Each of these is someone else's work, under its own
licence.

This page explains:

- where to read the licences and notices;
- what they contain;
- which terms govern each model C5 downloads;
- how to run C5 with your own build of libvips, the image library inside it.

The [Terms of Service, Section 14 — Models C5 downloads and runs on your machine](https://growther.si/t=models)
gives the legal position. This page is the practical side.

## Read the notices in C5

1. Open the **Options** menu (`⋯`) at the bottom of the left sidebar.
2. Choose **About**, then **Copyright & Legal** at the bottom of the About window.
   (**Options › Legal** opens the same window directly.)
3. Under **Third-Party Software and Models**, press **Third-party notices**.

The notices open as plain text, exactly as the file is written. Long lines are not re-wrapped,
so on a narrow screen you scroll sideways. The line above the text gives the counts in this
build, for example _1,259 packages, 10 native components, 5 models_.

To keep a copy, press **Download THIRD-PARTY-NOTICES.txt**. It saves the same file the build
produced.

Anyone signed in to C5 can open the notices, including a paired phone. They stay available
when your licence is paused, lapsed or revoked. The licences ask that their notices go with
every copy of the software, so C5 does not lock them away.

The same **Third-party notices** button is in the local classifier's Terms window
(**Settings › Learning**, then **Terms** on the **Local Classifier** card).

**If the notices do not load:**

| Message | What it means | What to do |
| --- | --- | --- |
| _Could not reach this machine to read the notices._ | The browser could not reach C5. | Check C5 is running, then press **Try again**. |
| _This build carries no THIRD-PARTY-NOTICES.txt…_ | (Developers only.) You are running C5 from source code, and the notices have not been built. | Build them with `node scripts/gen-third-party-notices.mjs` in the source folder. A released C5 always has the file. |

## Print them from the command line

```bash
growther licenses
```

This prints the full notices to your terminal. `growther licences` (British spelling) does the
same thing.

For the counts and where the file is, without the whole text:

```bash
growther licenses --summary
```

On macOS or Linux the output looks like this:

```
1259 npm packages (150 in the memory-search payload), 10 native and runtime components, 5 downloaded models
THIRD-PARTY-NOTICES.txt is built into this binary; `growther licenses > THIRD-PARTY-NOTICES.txt` writes a copy.
A copy was installed beside it: /opt/growther/bin/THIRD-PARTY-NOTICES.txt
```

The last line appears only when a copy of the file sits next to the program (see
[Find the file beside the program](#find-the-file-beside-the-program)). The numbers change from
release to release, and a little from platform to platform. On Windows the second line names
`cmd /c "growther licenses > THIRD-PARTY-NOTICES.txt"` instead, and says it works from
PowerShell too, because PowerShell's own `>` re-encodes the text (see
[Save the notices to a file](#save-the-notices-to-a-file)).

Piping works as you would expect. `growther licenses | less` and `growther licenses | grep -i gemma`
both behave normally.

### Save the notices to a file

On **macOS and Linux**, redirect the output. The file you get is an exact copy of the one
inside C5:

```bash
growther licenses > THIRD-PARTY-NOTICES.txt
```

On **Windows**, the redirect works the same way in **Command Prompt**:

```bat
growther licenses > THIRD-PARTY-NOTICES.txt
```

**In PowerShell, do not use `>` directly.** Windows PowerShell saves redirected text as UTF-16.
It can also garble characters such as `—` and `›` on the way. Ask Command Prompt to do the
redirect instead:

```powershell
cmd /c "growther licenses > THIRD-PARTY-NOTICES.txt"
```

You can also skip the command line: **Download THIRD-PARTY-NOTICES.txt** in the notices window
saves the exact file. An MSI install already has a copy beside `growther.exe`.

## Find the file beside the program

Most downloads and packages put `THIRD-PARTY-NOTICES.txt` next to the program as a plain file:

| What you have | Where the file is |
| --- | --- |
| The `.zip` from the website or the [Downloads](/c5/getting-started/downloads) page | In the folder inside the zip, beside the program you downloaded and its `.sha256` file |
| The archive `growther update` downloads (`.tar.gz`, or `.zip` on Windows), also published on the [release page](https://github.com/GrowtherSI/release) | At the top of the archive, beside the program |
| The Windows **MSI** | `C:\Program Files\Growther\C5\THIRD-PARTY-NOTICES.txt`, beside `growther.exe` |
| The macOS **PKG**, installed by MDM or `installer -pkg` | `/opt/growther/bin/THIRD-PARTY-NOTICES.txt`, beside `growther` |

Four kinds of install leave only the program in place, so there is no file beside the copy
of C5 you actually run:

- **The install commands** (`curl … | bash` and `irm … | iex`) copy the program to
  `~/.local/bin` (Windows: `%LOCALAPPDATA%\Growther\bin`).
- **Homebrew** (`brew install GrowtherSI/tap/growther-c5`) installs the program and its
  signed build record only.
- **The program from the website zip or an archive.** The first time you run it, C5 copies
  itself to `~/.local/bin` (Windows: `%LOCALAPPDATA%\Growther\bin`) and runs from there from
  then on. It copies the program only. The notices file stays in the folder you downloaded,
  which C5 tells you that you can delete. To keep C5 running where it is, so the file stays
  beside it, start it with `GROWTHER_NO_SELF_INSTALL=1`.
- **A PKG you double-click** sets C5 up for your user account in `~/.local/bin`, the same way
  the install command does. It then removes the machine-wide copy it placed in
  `/opt/growther`, including the notices file.

On those installs, the notices are inside the program. Read them in **About › Copyright & Legal**,
or write a copy with `growther licenses > THIRD-PARTY-NOTICES.txt` (in PowerShell, use the
`cmd /c` form above).

The notices are written for each platform's own build. Each platform carries slightly different
native packages, so each archive carries the list that is true of the program inside it.

### After an update or a rollback

When `growther update` replaces the program, it also refreshes a `THIRD-PARTY-NOTICES.txt` that
is already beside it, so the file matches the new version. The new text comes from the release
archive. Some updates download only the changed parts of the program, with no archive; then
the new program writes the file itself. Either way the old file is replaced in one step, so it
is never left half-written.

`growther update` never creates the file where there was none.

If the refresh fails, the update still completes, and C5 prints:

```
  ! THIRD-PARTY-NOTICES.txt beside the binary still describes the previous release: <reason>. `growther licenses` prints the current notices.
```

The program itself already carries the new notices. To bring the file up to date, write it
again with `growther licenses > THIRD-PARTY-NOTICES.txt`. If an update was interrupted
after the program was replaced, running `growther update` again also puts the file back in
step with the program you run, writing it from that program's own notices. It then prints
`✓ the files beside the binary (notices, checksum) now describe this release`. If it had to
leave the checksum file as it was (below), it prints a warning about that file and then
`✓ the notices beside the binary now describe this release`.

A re-run of `growther update` also checks the program's checksum file, if there is one
(`growther.sha256`, or `growther.exe.sha256` on Windows, which comes with a website
download). It rewrites that file only when C5's signed build manifest on this machine
(`build_manifest.json` in your C5 folder) lists the program's SHA-256 fingerprint. Otherwise
it leaves the file alone, because a mismatch can also mean the program was damaged or
altered, and prints:

```
  ! growther.sha256 does not match the running binary, and no signed build manifest on this machine names the binary's hash, so it was left as it is. Run `growther verify`: the binary may have been altered on disk.
```

Run `growther verify` and follow what it reports (see
[Verifying releases](/c5/security/verifying-releases)).

`growther rollback` puts back the notices file that matches the version it restores.

MSI and PKG installs are updated by installing the newer package. `growther update` does not
replace a program a package installed. The package brings its own notices file.

### For scripts: the API

The same text is served at `GET /api/v1/legal/third-party-notices` as `text/plain`. It needs a
signed-in or paired caller, like every other data route. It is served while the licence is
paused, lapsed or revoked.

When the build has a summary, the `X-Third-Party-Counts` response header carries the counts as
JSON. A build without the file (a source checkout) answers `404` with the code
`THIRD_PARTY_NOTICES_ABSENT`.

## See what the notices list

The file opens with the C5 version it belongs to and a short contents line. It then has four
parts:

| Part | What is in it |
| --- | --- |
| **1. Models C5 downloads to your machine** | One entry per model: who publishes it, its licence, where it comes from, and its exact size. |
| **2. Native and runtime components** | Software inside C5 that is not an ordinary npm package. |
| **3. npm packages, by licence text** | Every open-source package that ships in C5, with its copyright lines. |
| **4. Standard licence texts** | The full texts the other parts refer to. |

In more detail:

- **Part 1** gives each model's name and the feature that uses it, its publisher (and who
  converted it to the format C5 runs), its licence, its source on Hugging Face, the file name,
  its exact size in bytes, and any notice the publisher asks to be passed on. A licence of the
  publisher's own, such as the Gemma Terms of Use, comes with a link. A standard licence, such as
  Apache-2.0 or MIT, is printed in full in Part 4.
- **Part 2** lists:
  - **Node.js**, with its full licence, which itself carries the licences of the parts Node.js
    bundles (V8, ICU, OpenSSL, libuv, zlib and others);
  - **llama.cpp** and **whisper.cpp**, which run the models;
  - **SQLCipher**, the encrypted database;
  - **OpenSSL 1.1.1** (see below);
  - **cloudflared**, which C5 downloads only when
    [Remote Control](/c5/remote-control/overview) starts a Cloudflare tunnel — the
    issued address or a tunnel of your own;
  - **libvips**, with every library inside it (see below);
  - **the fonts** in the web interface.
- **Part 3** gives the copyright lines from each package's own licence file. Packages with the
  same licence text share one copy of it. A package's own `NOTICE` file is printed in full under
  it. A package that ships no licence text is listed with the licence it declares, and the file
  says that it ships none. The memory-search component's packages are included.
- **Part 4** has the full texts of Apache-2.0, BSD-2-Clause, BSD-3-Clause, GPL-3.0, ISC,
  LGPL-3.0, MIT, MPL-2.0 and the SIL Open Font License 1.1.

A few entries are worth knowing about:

- **libvips** (C5's image library) and each library built into it (27 of them in current
  releases) are listed with their version and licence. libvips and several others are under the
  GNU LGPL. The entry says where their source code is published and how to run C5 on your own
  copy. Both are covered in [Run C5 on your own libvips](#run-c5-on-your-own-libvips) below.
- **OpenSSL 1.1.1** is built into the encrypted-database component on macOS and Windows. On
  Linux, C5 carries its own copy of the OpenSSL 1.1 libraries. The entry prints the OpenSSL and
  SSLeay licences and the acknowledgements they require.
- **Fonts.** The web interface ships VT323, Liberation Sans 2.1.5 (used for 3D text) and Noto
  Emoji, all under the SIL Open Font License 1.1. Each font's licence also sits beside it in
  the web client.
- **Reference lists in PDFs** (citations in APA style) are formatted by C5's own code, so no
  outside citation library is listed. The library C5 used for this before, citeproc, is under a
  copyleft licence (CPAL or AGPL), which puts conditions on the software that includes it. It
  has been replaced and no longer ships with C5.

### How the list is kept complete

The file is generated from the real dependency tree when each release is built. It is not
written by hand. The build fails, rather than shipping an incomplete list, in any of these
cases:

- a package's licence information cannot be read;
- a package's licence is not a permissive one, unless that exact licence has been reviewed and
  approved. Permissive licences, such as MIT, BSD, ISC and Apache-2.0, let anyone use and pass
  on the code as long as the notice goes with it;
- libvips carries a library, or a library version, whose licence has not been reviewed.

C5's own tests also fail when a model C5 knows how to download is missing from Part 1, or is
listed with the wrong size. Before anything is published, the release checks that each download
has the file in the right place.

## Check which models C5 downloads

C5's installer does not include these models. C5 downloads each one from Hugging Face when the
feature that uses it needs it, and keeps it in its own folders on your machine.

| Model | Used for | Publisher | Licence | Size |
| --- | --- | --- | --- | --- |
| EmbeddingGemma-300M | Memory search: finding notes by meaning | Google DeepMind (converted by ggml-org) | [Gemma Terms of Use](https://ai.google.dev/gemma/terms), including Google's prohibited-use policy | 333,590,944 bytes (about 334 MB) |
| Qwen3-Reranker-0.6B | Memory search: ranking results by relevance | Alibaba Cloud, Qwen (converted by ggml-org) | Apache-2.0 | 639,153,184 bytes (about 639 MB) |
| qmd-query-expansion-1.7B | Memory search: widening a query with related terms | tobil, the author of the QMD search engine (fine-tuned from Alibaba Cloud's Qwen3-1.7B, Apache-2.0) | MIT | 1,282,438,912 bytes (about 1,282 MB) |
| Whisper base.en | Voice: speech to text on your machine | OpenAI (converted for whisper.cpp by Georgi Gerganov) | MIT | 59,721,011 bytes (about 60 MB) |
| decider-0.8b | The [local classifier](/c5/tools/local-classifier): small decisions with a fixed set of answers, such as which categories a task belongs to, made on your machine | Mapika (converted by mradermacher; fine-tuned from Alibaba Cloud's Qwen3.5-0.8B-Base, Apache-2.0) | Apache-2.0 | 811,844,032 bytes (about 812 MB) |

**Whose terms apply.** Each model's own licence governs your use of it, and C5 passes those
terms on unchanged. Two points to check:

- **EmbeddingGemma** is under the Gemma Terms of Use, which include a prohibited-use policy that
  applies to your use of it.
- **decider-0.8b**: its publisher says its training data includes datasets released for
  research use. The publisher's page for the model,
  [huggingface.co/Mapika/decider-0.8b](https://huggingface.co/Mapika/decider-0.8b), is where to
  check that training mixture against your use. C5 shows that notice beside the model in
  **Settings › Learning**. If research-use data does not fit your use, turn the local classifier off there, and
  [delete the model](/c5/tools/local-classifier#delete-the-model) if you do not want it on the
  machine.

### When each one is downloaded

| Model | When C5 fetches it | Where it is kept |
| --- | --- | --- |
| The three memory-search models | Soon after C5 starts, in the background, when a model file is missing. Memory search is part of C5 and has no off switch. | `qmd/cache/qmd/models/` |
| Whisper base.en | At start-up, while **Built-in (on-device)** voice is on and the model is missing. | `speech/` |
| decider-0.8b | While the [local classifier](/c5/tools/local-classifier) is on (it is on by default), on a machine that can run it — and never over a symbolic link you placed at its path. | `classifier/models/` |

These folders sit in C5's cache folder. That is your C5 folder (`~/.growther`) unless you moved
the cache with `GROWTHER_CACHE_DIR`, a policy, or `growther cache relocate`. See
[Where C5 keeps your data](/c5/configuration/data-location).

You can also fetch a model yourself, on your own schedule: `growther qmd-run pull`,
`growther voice pull` or `growther classifier pull`. See [Commands](/c5/cli/commands).

### What C5 checks, and what it sends

- **Each model is pinned.** C5 fetches one exact, recorded version of each file. It never takes
  "whatever is latest".
- **Each model is checked before use.** C5 checks the file's exact size and its SHA-256
  fingerprint against values built into C5. A model that does not match is never loaded. (A
  memory-search model you name yourself in QMD's own settings is your choice, and C5 does not
  check it.)
- **A wrong file is never used, and what happens to it depends on the feature.**
  - For **memory search and voice**, C5 renames a file that fails the check to `<file>.rejected`
    (or `.rejected.1`, `.rejected.2`, … when that name is taken) and keeps it. It never deletes
    or overwrites a file you placed, and it fetches nothing over one until you move it.
  - For the **local classifier**, C5 leaves a wrong file where it is and never loads it. Its next
    good download then takes that file's place, so move the file elsewhere first if you want to
    keep it. A symbolic link at the model's path is never downloaded over: C5 uses the file it
    points to once that file can be reached and is the model.
- **Only C5 downloads.** The memory-search engine runs as a separate process, and C5 blocks it
  from downloading a model itself. It reads models only from a folder of files C5 has checked.
  Where possible, that folder holds C5's own checked copy of each model, which nothing done at
  the model's name can reach. Otherwise it holds a link, which C5 re-checks every five seconds
  and takes out of the engine's reach as soon as the file changes. On a disk that cannot clone
  files (Windows, or ext4 on Linux), those copies take up to about 2.3 GB more, so allow about
  5.4 GB for the models rather than 3.1 GB. C5 makes a copy only if 1 GB would still be free.
  See [Memory search](/c5/tools/memory-search#where-they-go).
- **Nothing goes to Growther.si.** The download is a request from your machine to Hugging Face.
  C5 tells Growther.si nothing about which models you have or how you use them.

The downloads use the proxy and certificate authority you set under
**Settings › Enterprise › Network**. They start at `huggingface.co`, which redirects to a
download server:

- `cas-bridge.xethub.hf.co`
- `cdn-lfs.hf.co`
- `cdn-lfs-us-1.hf.co`
- `cdn-lfs-eu-1.hf.co`
- `cdn-lfs.huggingface.co`

A firewall or proxy that allows `huggingface.co` but blocks these servers makes every model
download fail. See [Network and egress](/c5/configuration/network).

### Stop every model download

Set **Egress posture** to **Offline** under **Settings › Enterprise › Network**. C5 then makes no
automatic model downloads, and the three `pull` commands are refused as well.

To set it for a fleet, lock `networkPosture` to `offline` through device policy (Group
Policy, macOS managed preferences or `/etc/growther/policy.d`). A lock sent only in a signed
policy document reaches the running C5 and `growther classifier pull`, but not
`growther voice pull` or `growther qmd-run pull`, which do not read a signed policy document.
See [Details worth knowing](/c5/configuration/network#details-worth-knowing).

### Stop the automatic download of one kind of model

Set one of these variables to `1` (exactly `1`; any other value leaves the download on):

| Variable | Stops |
| --- | --- |
| `GROWTHER_QMD_NO_AUTO_DOWNLOAD` | The memory-search models |
| `GROWTHER_VOICE_NO_AUTO_DOWNLOAD` | The voice model |
| `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD` | The local classifier's model |

Set the variable where C5 starts, then restart C5. For a C5 started from a terminal, set it in
that terminal. For a C5 that starts at sign-in, a variable typed in a terminal does not reach
it: put it in `c5.yaml` as a custom key, or follow
[When C5 starts at sign-in](/c5/cli/environment#when-c5-starts-at-sign-in). The
[Environment variables](/c5/cli/environment#stop-c5-downloading-models-on-its-own) page has the
details.

These variables stop only the download C5 starts on its own. The matching `pull` command still
works, so the model arrives only when someone asks for it.

If your organisation's policy keeps the local classifier off, `growther classifier pull` is
refused too, with: _Your organisation's policy keeps the local classifier off, so its model is
not downloaded._ See the [local classifier's administrator notes](/c5/tools/local-classifier#for-administrators).

### Without a model

Without its model, a feature waits and everything else works:

- memory search keeps working with keyword search;
- built-in voice is unavailable;
- the local classifier does not start, so C5 makes those small decisions with your configured
  models, exactly as when the classifier is off.

On a machine with no internet, you can copy a model in by hand. C5 checks it exactly as it
checks a download. The pages for
[memory search](/c5/tools/memory-search#placing-the-models-by-hand),
[voice](/c5/using-c5/voice#placing-it-by-hand) and the
[local classifier](/c5/tools/local-classifier#offline-and-air-gapped-installs) give the exact
file names, addresses and folders.

## Run C5 on your own libvips

C5 resizes and converts images (profile pictures, attachment thumbnails, images sent to agents,
SVG rendering) with **sharp**, which drives a native library called **libvips**. libvips and
several of the libraries built into it are under the **GNU LGPL**.

The LGPL gives you the right to run C5 with a modified version of libvips: your own build,
with your own changes. **Copyright & Legal** says so too. Nothing in C5's licence limits that
right, or your right to reverse engineer C5 to debug such a change.

C5 supports this with one environment variable, `GROWTHER_LIBVIPS_DIR`. Most people never need
it. The rest of this section is for anyone who wants to use that right.

### What the folder must contain

Point `GROWTHER_LIBVIPS_DIR` at a folder laid out the way sharp lays out its own files:

```
<your folder>/
  sharp-<platform>/lib/sharp-<platform>-<sharp version>.node      the sharp binding
  sharp-libvips-<platform>/lib/<the libvips library>              your libvips
```

`<platform>` is the platform name sharp uses, for example `darwin-arm64`, `darwin-x64`,
`linux-x64`, `linux-arm64` or `win32-x64`. With today's releases (sharp 0.35.4, libvips 8.18.6)
the files are named:

| Platform | Binding | libvips |
| --- | --- | --- |
| macOS | `sharp-darwin-arm64/lib/sharp-darwin-arm64-0.35.4.node` | `sharp-libvips-darwin-arm64/lib/libvips-cpp.8.18.6.dylib` |
| Linux | `sharp-linux-x64/lib/sharp-linux-x64-0.35.4.node` | `sharp-libvips-linux-x64/lib/libvips-cpp.so.8.18.6` |
| Windows | `sharp-win32-x64/lib/sharp-win32-x64-0.35.4.node` | In the same `lib` folder as the binding: `libvips-42.dll` and `libvips-cpp-8.18.6.dll`, plus any other DLLs your build needs |

**The exact names for your copy of C5 are in its own notices.** Look for the libvips entry in
Part 2, under _Your own libvips_. A different release may use different version numbers.

Your libvips must be interface-compatible: it must work with the same binding. If you would
rather build sharp's binding yourself against your own libvips, put that one file directly in
the folder as `<your folder>/sharp-<platform>-<sharp version>.node`.

**A quick way to start** is to copy C5's own files and replace only the library you changed.
The first time C5 processes an image, it writes its copy to `.cache/pkg/<hash>/@img` in your
home folder. The same files are published on npm as `@img/sharp-<platform>` and
`@img/sharp-libvips-<platform>`, at the versions your notices name.

### Set the variable

C5 reads `GROWTHER_LIBVIPS_DIR` only from the environment it starts in. It is ignored in
`c5.yaml` and cannot be set in Settings, because it makes C5 load native code. Where you set
it depends on how C5 starts.

**From a terminal.** Set it for that one launch.

On macOS and Linux:

```bash
GROWTHER_LIBVIPS_DIR="$HOME/my-libvips" growther
```

In PowerShell:

```powershell
$env:GROWTHER_LIBVIPS_DIR = "C:\Users\you\my-libvips"; growther
```

In Command Prompt:

```bat
set GROWTHER_LIBVIPS_DIR=C:\Users\you\my-libvips
growther
```

This does not change how C5 starts at sign-in. For that, follow the steps for your platform.

#### macOS

1. If you downloaded your libvips build rather than building it on this Mac, clear the
   quarantine flag macOS puts on downloaded files:

   ```bash
   xattr -dr com.apple.quarantine "$HOME/my-libvips"
   ```

2. Sign each library or binding you built or changed. An ad hoc signature is enough:

   ```bash
   codesign --force --sign - "$HOME/my-libvips/sharp-libvips-darwin-arm64/lib/libvips-cpp.8.18.6.dylib"
   ```

3. If C5 starts when you sign in, add the variable to C5's startup file:

   ```bash
   plutil -insert EnvironmentVariables.GROWTHER_LIBVIPS_DIR -string "$HOME/my-libvips" \
     ~/Library/LaunchAgents/ai.growther.c5.plist
   ```

   To change it later, run the same command with `-replace` in place of `-insert`. C5 rewrites
   this file each time it starts, but it keeps this one setting.

4. Sign out and back in, so the sign-in start uses the new setting.

Without step 3, a C5 started at sign-in keeps using its own libvips.

#### Linux

If C5 starts at sign-in through systemd, add the variable in a drop-in file. C5 only ever
rewrites its main unit, so a drop-in stays in place:

```bash
systemctl --user edit growther-c5
```

In the editor that opens, add:

```ini
[Service]
Environment=GROWTHER_LIBVIPS_DIR=/home/you/my-libvips
```

Save and close. The change applies the next time systemd starts C5: at your next sign-in, or
straight away with `systemctl --user restart growther-c5` if C5 is running under systemd now.

On a desktop without systemd, C5 starts from your desktop's autostart. Set the variable in the
environment your desktop session starts with (often `~/.profile`), then sign out and back in.

#### Windows

1. Put the DLLs your libvips needs in the same folder as the binding.
2. Make the variable a user environment variable, so C5's start at sign-in sees it too:

   ```bat
   setx GROWTHER_LIBVIPS_DIR "C:\Users\you\my-libvips"
   ```

3. Sign out and back in.

`setx` affects programs started after it runs, not ones already running, so a C5 that is already
open keeps its old setting until you sign out and in.

### Check that C5 is using your copy

C5 decides which libvips to use the first time it processes an image, not at start-up. When it
loads yours, it prints one line:

```
[sharp] using libvips 8.18.6 from GROWTHER_LIBVIPS_DIR: binding <path to the binding>, library <path to the library>
```

The line names the files the operating system actually loaded, so you can see that your library
is the one in use. If the operating system does not report the library it loaded, the line ends
with _library (not reported by this platform)_.

Where to find the line:

| How C5 started | Where the line is |
| --- | --- |
| From a terminal | In that terminal |
| At sign-in on macOS | `logs/service.out.log` in your C5 folder |
| At sign-in on Linux, through systemd | In the journal: `journalctl --user -u growther-c5` |
| At sign-in on Windows, or from a Linux desktop's autostart | Not kept in a file. Use `growther doctor`, below. |

To check without waiting for an image, run `growther doctor` from a terminal where the variable
is set. It shows a **libvips** row:

| What doctor shows | Meaning |
| --- | --- |
| `✓ libvips  your copy from GROWTHER_LIBVIPS_DIR=<folder>: binding …, library …` | Your copy loads. |
| `! libvips  override refused — <reason>` | Your copy could not be used. The reason says why (see below). |

The row adds _(checked in this shell's environment; C5 started at sign-in reads the variable
from its service definition)_ as a reminder that a C5 started at sign-in gets the variable from
the places above, not from your terminal. When the variable is not set, doctor shows no libvips
row: C5 is using its own copy.

### If your folder cannot be used

C5 does **not** quietly fall back to its own libvips. If you set the variable, you meant to run
your copy, and a silent fallback would make a failed experiment look like it worked. Instead:

- the image features are turned off: profile-picture resizing, thumbnails, image compression
  for agents and SVG rendering report themselves unavailable;
- the reason is recorded once in C5's error log (`logs/errors.log` in your C5 folder), and
  `growther doctor` shows it.

Everything else in C5 works as normal. The message has this form:

```
GROWTHER_LIBVIPS_DIR=<folder>: <reason> Image features that need libvips are off until this is fixed; unset GROWTHER_LIBVIPS_DIR to use the copy bundled with C5 (it is not used as a fallback while the variable is set).
```

| Reason | What to do |
| --- | --- |
| `is not a directory.` | Check the path. It must be an existing folder. |
| `no sharp <version> binding for <platform> in it (looked for … and …)` | Put the binding at one of the two paths it lists. The version must be the sharp version this C5 uses. |
| `could not load <binding>: …` | The operating system refused the file. On macOS, sign it and clear the quarantine flag. On Windows, check the DLLs it needs are beside it. The text after the colon is the system's own error. |
| `<binding> is not a sharp binding.` | The file at that name is something else. |
| `it provides libvips <x>; sharp <version> needs <y> or later.` | Your libvips is too old for this sharp. Build a newer one. |
| `sharp or libvips was already loaded in this process …` / `sharp loaded another binding as well …` | Something loaded C5's own copy first. Restart C5. If it happens again, report it with the full message. |
| Any other message | C5 could not prepare your copy, and the text is the error itself. Report it with the full message. |

To go back to C5's own libvips, remove the variable (and the plist entry, drop-in or user
variable), then restart C5.

### Find the libvips source code

The libvips entry in your notices names the exact source for your build. In current releases:

- **macOS and Linux:** the source of libvips and of every library built into it is the
  [sharp-libvips v1.3.3 release](https://github.com/lovell/sharp-libvips/releases/tag/v1.3.3).
  Its [build scripts](https://github.com/lovell/sharp-libvips/tree/v1.3.3) fetch each library's
  source, at the listed version, from that library's own publisher.
- **Windows:** sharp-libvips repackages the DLLs of the
  [libvips/build-win64-mxe v8.18.6 release](https://github.com/libvips/build-win64-mxe/releases/tag/v8.18.6).
  That project's [build recipes and patches](https://github.com/libvips/build-win64-mxe/tree/v8.18.6)
  fetch and build each library. `libvips-cpp-8.18.6.dll` is libvips' own C++ interface, compiled
  by [sharp 0.35.4's build](https://github.com/lovell/sharp/tree/v0.35.4) (`src/binding.gyp`).
- **sharp itself** (the binding) is Apache-2.0. Its source is the
  [sharp repository](https://github.com/lovell/sharp) at the version your notices name.

The LGPL and GPL texts are in Part 4 of the notices. Each library's own licence is printed with
it in Part 2.

## Questions

For questions about licences or notices, email [help@growther.si](mailto:help@growther.si).

## Related

- [Verifying releases](/c5/security/verifying-releases): how C5 checks the program itself.
- [Local classifier](/c5/tools/local-classifier): what decider-0.8b does, turning it off, and
  deleting it.
- [Memory search](/c5/tools/memory-search) and [Voice](/c5/using-c5/voice): the other features
  that use the downloaded models.
- [Network and egress](/c5/configuration/network): every host C5 contacts, the proxy, and the
  offline switch.
- [Environment variables](/c5/cli/environment): the download switches, `GROWTHER_LIBVIPS_DIR`,
  and how to set variables for a C5 that starts at sign-in.
- [Commands](/c5/cli/commands): `growther licenses`, `growther doctor` and the `pull` commands.
