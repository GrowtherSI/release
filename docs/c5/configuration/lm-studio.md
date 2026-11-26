---
title: LM Studio
description: Keep your local LM Studio model loaded between turns, and where LM Studio keeps its settings.
order: 10
---

# LM Studio

LM Studio runs SI models on your own computer. C5 talks to it like any other provider (see
[Model providers](/c5/configuration/model-providers#running-models-on-your-own-computer)).
This page covers the one LM Studio setting that matters most for C5, and how C5 can change
it for you.

## Why your model keeps unloading

LM Studio loads a model when a request asks for it, and unloads it again after it has sat
idle for a while. That idle time is LM Studio's own setting, and it can be as short as a
minute. C5's turns are often further apart than that, so the next request finds the model
gone: it fails with _Model is unloaded._ or waits while the whole model loads again.

C5 already retries that error on its own, so a turn usually still succeeds. But every reload
costs time, and on a busy day it happens hundreds of times. The fix is to let the model stay
loaded longer.

## The LM Studio app settings card

While LM Studio is turned on in **Settings › Integrations**, Settings has a tab for it,
labelled **Config** with LM Studio's icon; hover it to read _LM Studio Config_. When C5 finds
LM Studio's settings file, the tab shows an **LM Studio app settings** card, with the file's
location under its title.

The card has one button, **Keep warm**. Open it to see what C5 suggests:

| Suggestion | When you see it | What it does |
| --- | --- | --- |
| **Raise the idle unload time from … to 15 minutes** | LM Studio unloads idle models after less than 15 minutes | Keeps the model loaded for 15 minutes after its last request, long enough for a working session. |
| **Unload the previous model when another one loads** | This LM Studio option is off | Turns it back on (LM Studio's own default), so only one on-demand model is in memory at a time. With it off, a longer idle time can fill your computer's memory. |

You see no idle-time suggestion when LM Studio's idle unload is off (the model never idles
out), when the setting has never been changed (LM Studio's default is 60 minutes), or when it
is already 15 minutes or more.

### Saving the change

1. **Quit LM Studio completely.** LM Studio keeps its settings in memory and writes them
   back to the file itself, so a change saved while it is running can be overwritten with
   the old value.
2. In **Keep warm**, tick the suggestions you want and click **Apply**.
3. Click **Save to LM Studio**. C5 changes only those settings and leaves everything else in
   the file as it was. It keeps a backup copy of the file beside it (the last five).
4. **Reopen LM Studio.** The toast says _LM Studio settings saved. Reopen LM Studio to use
   them._

If you leave the tab with an applied change you have not saved, C5 asks whether to save it,
like any other unsaved setting. When you come back to C5 from LM Studio, the card reads the
file again, so if LM Studio wrote the old value back, the suggestion simply shows up again.

**Who can use it.** The card is shown only to an administrator using C5 on the machine
itself. Members, and administrators on a paired phone, do not see it. Saving also needs
permission to edit settings.

## Where LM Studio keeps its settings

The file is `settings.json` in LM Studio's home folder:

| System | Usual location |
| --- | --- |
| **macOS** | `~/.lmstudio/settings.json` (that is, `/Users/<you>/.lmstudio/settings.json`) |
| **Windows** | `%USERPROFILE%\.lmstudio\settings.json` (that is, `C:\Users\<you>\.lmstudio\settings.json`) |
| **Linux** | `~/.lmstudio/settings.json`, or `~/.cache/lm-studio/settings.json` on some older installs |

If you moved LM Studio's home folder, LM Studio leaves a small file named
`.lmstudio-home-pointer` in your home folder that says where it went; C5 follows it the same
way LM Studio does, and never creates or changes it. The card always shows the exact path it
is using.

You can also change the same settings in LM Studio itself: **Developer** tab › **Server
Settings**, the options for unloading unused on-demand models.

## Keeping C5's own requests loaded

There is also a per-request option. On the same tab, under **Advanced (LM Studio)**, **Keep
loaded (idle TTL, seconds)** asks LM Studio to keep a model that one of C5's requests loaded
for that many seconds after its last request. It is blank by default, which sends nothing and
leaves LM Studio's own setting in charge. Values run from 1 second to 7 days.

It covers only requests C5 sends to LM Studio directly. It does not cover requests that
reach LM Studio through OpenClaw or another gateway, or models you load yourself with
`lms load`. For those, the app settings card above is the fix.

## If something goes wrong

**The card does not appear.** C5 shows it only when it finds LM Studio's settings file and
can read it, and only to an administrator on the machine itself. Check that LM Studio has
been opened at least once on this machine (it creates the file), and look for the file at the
paths above. If LM Studio was writing the file at that moment, switch away and back: the card
reads it again.

**The suggestion comes back after saving.** LM Studio was still running and wrote its old
value back. Quit it completely, save again, then reopen it.

**"LM Studio's settings changed since they were loaded, so nothing was saved."** LM Studio
(or something else) changed the file after the card read it. The card reads it again; check
the suggestion and save once more.

**"LM Studio's settings.json is read-only, so nothing was saved."** C5 will not replace a
settings file that has been made read-only. Make the file writable again (or change the
setting in LM Studio itself), then save.

**"LM Studio's settings.json does not parse as JSON, so nothing was saved."** The file is
damaged or was being written. Open LM Studio once so it rewrites it, quit it, and try again.

**A model fails to load.** When LM Studio says it does not have the memory or resources for a
model, C5 does not keep retrying it; it moves on to your next provider. Choose a smaller
model, or close other apps that use a lot of memory.

## Where to go next

- [Model providers](/c5/configuration/model-providers) — connecting LM Studio and other providers.
- [OpenClaw and Hermes](/c5/configuration/agent-gateways) — when your agents run through a gateway.
- [Common issues](/c5/troubleshooting/common-issues#gateways-and-local-models)
