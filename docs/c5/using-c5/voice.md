---
title: Voice
description: Talk to C5 instead of typing, have it read replies back to you, and how the offline speech model is downloaded, checked and placed by hand.
order: 10
---

# Voice

You can talk to C5 instead of typing, and you can have it read replies out loud. Both
are optional. Neither does anything until you turn it on.

Look for the small microphone at the left of the box where you type. It appears wherever you
would write something in your own words:

| Where         | Which boxes                            |
| ------------- | -------------------------------------- |
| **Chat**      | The message box                        |
| **Schedules** | Title, description, and instructions   |
| **Tasks**     | Title, description, and your reasoning |

Click the microphone, say what you want, and click it again to stop. Your words appear in the box
as text, where you can read them and fix anything before you send.

You will not find a microphone on a date picker or on a field that wants a web address. Saying a
GitHub URL aloud is slower than typing it and far easier to get wrong, so those fields are left
alone deliberately.

> **Tip**
> The text stays in the box until you send it. That pause is deliberate — read it back
> before pressing enter, especially if you are asking for something you cannot undo.

## Knowing it is listening

While you are recording, a ring around the microphone grows and shrinks with your voice. It is
driven by what the microphone is actually picking up, not by a timer — so if the ring sits still
while you are talking, the microphone is not hearing you, and that is worth knowing before you
speak a paragraph into nothing.

C5 releases the microphone shortly after you stop. Your computer's own "microphone in use"
indicator goes out at that point, and the next time you click, C5 picks it up again.

## You do not have to turn it on

The two built-in options are **already on**. You only need the **Voice** tab if you want a paid
provider, or if you want to turn the built-in ones off.

Nothing listens until you press a microphone. Being switched on only means the built-in option is
there when you do.

### The built-in option

**Built-in (on-device)** — the offline option — turns your speech into text using your
own computer. Your audio is not sent anywhere. Once its model is on your machine it works with no internet
connection at all — it is the only option that does.

It needs a one-time download of a file, the offline speech model, about 60 MB. **Each time
C5 starts with Built-in (on-device) switched on and the model missing, it fetches the model
in the background.** You do not have to do anything, and you can carry on working while it
downloads. The **Built-in (on-device)** row on the **Voice** tab shows the progress, and
says when the model is ready. How the model is
fetched, checked and placed by hand is in
[The offline speech model](#the-offline-speech-model) below.

If you would rather fetch it yourself, or the automatic download could not reach the network:

```bash
growther voice pull
```

**Built-in (this browser)** reads replies aloud using a voice your computer already has. It needs
no download at all and is ready immediately. Nothing leaves your machine, and it costs nothing.

> **Note**
> The offline option understands **English only**. If you speak another language, you
> will want one of the paid providers below, which all handle many languages.

### Which one gets tried first

Both lists are an order, not a set. C5 works down from the top and stops at the first provider
that answers, so the arrows beside each row decide what happens when one is unavailable — a
provider that is down, out of credit, or simply switched off is skipped rather than being an
error you have to deal with.

Put the built-in option last and you have a free fallback that works with no internet. Put it
first and nothing you say ever leaves the machine unless Built-in (on-device) fails outright.

### The paid options

OpenAI, Groq, xAI (Grok), OpenRouter and ElevenLabs all do a better job than the
built-in option, and all of them handle many languages. They are more accurate, and the
voices sound far more natural.

They work by sending your audio to that company. You will need an account with them.

## The offline speech model

Built-in (on-device) uses OpenAI's Whisper **base.en** model, in the version
converted for whisper.cpp by Georgi Gerganov. It is released under the MIT License. Section
14 of the Growther.si Terms of Service, [Models C5 downloads and runs on your
machine](https://growther.si/t=models), covers it, and its licence text is in C5 under
**About › Copyright & Legal** and in `growther licenses` (see [Open-source licences and
downloaded models](../security/open-source-and-models.md#check-which-models-c5-downloads)).

| | |
| --- | --- |
| File | `ggml-base.en-q5_1.bin` |
| Exact size | 59,721,011 bytes (about 60 MB) |
| sha256 | `4baf70dd0d7c4247ba2b81fafd9c01005ac77c2f9ef064e00dcf195d0e2fdd2f` |
| Downloaded from | `https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-base.en-q5_1.bin` |
| Kept at | `~/.growther/speech/ggml-base.en-q5_1.bin` (`%USERPROFILE%\.growther\speech\…` on Windows) |

If you moved C5's caches with `growther cache relocate`, `GROWTHER_CACHE_DIR` or an
organisation's policy, the `speech` folder is under the new location instead. See
[Where your data lives](../configuration/data-location.md).

### How C5 fetches and checks it

- **One exact file.** The address above names one commit of the repository, so every C5 of
  this release fetches the same bytes.
- **Checked before use.** Built-in (on-device) uses the file only once its size and sha256 match the
  values above. C5 records that it checked the file in `ggml-base.en-q5_1.bin.verified.json`
  beside it, so the full check happens once, not at every start.
- **Never over a file.** C5 downloads only when nothing is at the model's name, and never
  deletes or replaces a model file.
- **Through your network settings.** The automatic download and `growther voice pull` both
  go through the proxy and certificate authorities set under **Settings › Enterprise ›
  Network**. The request goes to `huggingface.co`, which redirects to Hugging Face's
  download servers; see
  [Hugging Face redirects to a download network](../configuration/network.md#hugging-face-redirects-to-a-download-network)
  for the hosts to allow.
- **Nothing goes to Growther.si.** The download is a request from your machine to Hugging
  Face, and nothing about the model or your use of it is sent to Growther.si.

The automatic download does not run when any of these is true:

- Built-in (on-device) is switched off on the **Voice** tab;
- the **Egress posture** is **Offline** under **Settings › Enterprise › Network** —
  `growther voice pull` is refused too, and tells you where to place the file;
- C5 was started with `GROWTHER_VOICE_NO_AUTO_DOWNLOAD=1` (exactly `1`) — `growther voice
  pull` still works, because you asked for it. See
  [Stop C5 downloading models on its own](../cli/environment.md#stop-c5-downloading-models-on-its-own)
  for where to set it when C5 starts at sign-in;
- C5 is running on a CI server (the `CI` environment variable is set).

### A file that is not the model

If the file at the model's name is not the one above — a different upload, a cut-off copy —
C5 renames it to `ggml-base.en-q5_1.bin.rejected` (or `.rejected.1`, … if that name is
taken). It is **never deleted**, and Built-in (on-device) never loads it. With the name free again,
C5 fetches the right file, unless automatic downloads are off; `growther voice pull` does
the same. Delete the `.rejected` file once you no longer need it.

A file that was written within the last minute is left where it is rather than renamed, so
a copy that is still arriving is not moved half-way. Built-in (on-device) does not use it
meanwhile.
It is checked again at the next start, or when you run `growther voice status`.

### Placing it by hand

On a machine that cannot reach Hugging Face:

1. On a machine that can, download the file from the address in the table above.
2. Check its fingerprint matches (`shasum -a 256` on macOS, `sha256sum` on Linux,
   `Get-FileHash -Algorithm SHA256` in PowerShell).
3. Copy it to the **Kept at** path, under exactly that file name.
4. Restart C5. To confirm the file first, run `growther voice status`, which checks it
   straight away.

### What you see in the log

C5's lines about the model are tagged `[voice]` and belong to the **voice** log category,
which is off by default — warnings included. Press `v` in the terminal running C5 to see
them (see [Log filtering](../cli/log-filtering.md)). `growther voice status` answers the
same questions without the log.

```text
[voice] built-in engine on, model missing — fetching ~60 MB in the background
[voice] offline speech model 10%
[voice] offline speech model ready
[voice] offline speech model not fetched: <why>
[voice] built-in engine off — nothing to fetch
```

When a file was set aside, the warning names it and the `.rejected` name it now has.

### From a terminal

To see whether voice is ready, run:

```bash
growther voice status
```

It prints two lines: whether Built-in (on-device) can run on this computer, and whether
the model is present and checked. It exits with `1` if either is not.

To download the model now, run:

```bash
growther voice pull
```

It prints its progress in 5% steps and ends with `✓ downloaded and checked — <path>`. If
the right file is already there, it says `✓ already present and checked` and downloads
nothing.

## Two switches that change how the microphone behaves

They sit at the top of the **Voice** tab and apply everywhere the microphone appears.

**Auto-volume** evens out how loud you are, so speaking quietly or sitting back from the
microphone still produces a usable recording. It is **on** to begin with. It makes no difference
to how accurately your words are transcribed — that was measured, not assumed — but it does keep
a quiet voice above the threshold where C5 decides a recording is silence and discards it. Turn
it off if you would rather the ring tracked how loudly you are actually speaking.

**Tap-and-hold** changes the microphone from a switch into a button: hold it down while you talk,
let go when you finish. It is **off** to begin with, and it behaves the same whether you use a
mouse or a touchscreen. Dragging away before you let go throws the recording away, which is
useful when you change your mind mid-sentence.

> **Note**
> Tap-and-hold applies to the mouse and to touch. A keyboard has no way to hold a button in any
> meaningful sense, so pressing space or enter on the microphone still starts and stops the way it
> always did. Nothing becomes unreachable if you turn this on.

## Voice from a paired phone

A phone or tablet you have paired through [Remote Control](/c5/remote-control/overview)
shows the same microphone, but it is **off until you turn it on**, and it can be turned on
only in C5 on the machine, under **Settings › Voice**. A paired device cannot switch it on
for itself.

When it is on, one tap on the phone records live microphone audio and sends it to the
machine — through the address Growther.si issues, if that is how the phone is connected — and
the machine passes it on to whichever speech provider you configured, or transcribes it
itself if your chain starts with the built-in option. Nothing about the recording goes to
Growther. You are responsible for any consent the people being recorded are entitled to.

## Adding a key for a paid provider

Voice keys live in your configuration file rather than being typed into the app:

```
~/.growther/config/c5.yaml
```

Open it in a text editor and add the key for the provider you want. The **Voice** tab
tells you the exact name to use for each one, and shows whether it is set yet.

Save the file, and the Voice tab updates on its own. You do not need to restart C5 or
reload the page.

See [Configuration files](/c5/configuration/config-files) for more about `c5.yaml`.

> **Warning**
> Treat an API key like a password. Anyone who has it can spend money on your account.

## What actually leaves your computer

This is worth being clear about, because the answer depends entirely on which option you
picked.

| Option                      | What leaves your computer                                    |
| --------------------------- | ------------------------------------------------------------ |
| **Built-in (on-device)**    | None of your audio or words. The model's one-time download is a request to Hugging Face |
| **Built-in (this browser)** | Nothing at all                                               |
| Any paid provider           | The audio you recorded, or the text you asked to be read out |

Three things are true whichever you choose:

- **Your recordings are never saved.** C5 turns them into text and throws the audio
  away. It is not written to your database, your logs, or your disk.
- **Your keys never reach your browser.** C5 talks to providers from your own machine.
- **The words are never recorded anywhere.** C5 keeps track of which provider answered
  and how long it took, so you can see what things cost. What you actually said is not
  part of that.

If you use a paid provider, that company's own terms decide what they do with the audio
you send them. C5 cannot promise anything on their behalf. That is exactly why the
offline option exists.

## Keeping the cost down

Paid providers charge by the minute of audio, or by the number of characters they read
out. C5 works out what a request will cost **before** making it, and refuses if it would
take you over your monthly voice budget.

You set that limit in **Settings → Budget**, in the **Voice Spending Limit** panel, alongside
C5's other spending controls. It works the same way as the hard budget cap: a switch, an amount,
and a choice of whether the allowance resets daily, weekly, monthly or yearly — on the day you
pick, not on an arbitrary one. See [Budgets & costs](/c5/using-c5/ops) for the rest.

Two things save you money without any effort:

- **Silence is never sent.** If you start recording and say nothing, C5 notices and
  throws the recording away. There is nothing to pay for.
- **The offline option is free**, and it is never counted against your budget — even if
  you have used the rest of it up.

## Reading replies out loud

Hover over any reply and press the speaker button.

If you would rather not press it each time, the **megaphone** switch on the right-hand edge of the
chat reads every new reply aloud as it arrives. It is **off** to begin with, and C5 remembers your
choice in this browser — turning it off in one window turns it off everywhere.

> **Note**
> Auto-speak starts from the _next_ reply, not the one already on screen. Turning it on and
> waiting at a finished conversation will look like nothing happened; send something and it will
> speak.

The built-in browser voice costs nothing and works offline, but it sounds like your
computer. A paid provider sounds far more natural and charges per character.

> **Tip**
> Think about where you are before you turn auto-speak on. A long reply narrating itself in an
> open-plan office is the reason this is off by default.

## Voice notes from Slack, Discord and Teams

If someone sends C5 a voice note on a chat platform you have connected, it is
transcribed the same way, using the same providers and the same budget. There is nothing
extra to set up.

You can turn this off for a specific platform in **Settings → Communications**, using the
**Voice/Audio** switch. When it is off, C5 does not download the voice note at all.

> **Note**
> A voice note has nobody to check it. When you dictate, you see the text and can fix it
> before sending — a voice note goes straight to your agent as though you had typed it.
> For anything important, dictate rather than sending a note.

## If something is not working

**There is no microphone button, or C5 says it needs a secure connection.**

Your browser only allows the microphone when the address bar shows `localhost` or an
`https://` address. If you reached C5 using an address like `192.168.1.50` or
`my-mac.local`, the browser blocks the microphone and there is nothing C5 can do about
it. Connect through an SSH tunnel and open `http://localhost` instead.

**C5 says no speech-to-text provider is set up.**

If you have just updated, Built-in (on-device) is probably still downloading — it is switched on,
but its model has not arrived yet. C5 will say so rather than this if it knows a download is in
flight; check the **Voice** tab, which shows the progress. Wait for it to finish and try again.

Otherwise you have turned the built-in option off and have not added a key. Turn it back on in
**Settings → Voice**, run `growther voice pull`, or add a key to `c5.yaml`.

**Dictation keeps coming back empty.**

C5 throws away recordings that are too quiet to contain speech. Check that the right
microphone is selected and that it is not muted. Watch the ring while you talk — if it does not
move, the microphone is not reaching C5, and no provider will fix that.

If you turned **auto-volume** off, a quiet or distant voice is more likely to fall below the
threshold. Turning it back on is the quickest test.

**The reply is not read aloud even though the megaphone is on.**

Auto-speak starts from the next reply, not the one already on screen. Send something and it will
speak.

If it stays silent after that, your browser may be refusing to play audio on a page you have not
interacted with yet — clicking anywhere in the page and sending again resolves it. Pressing the
speaker button on a reply is unaffected, because pressing it is itself the interaction.

**Voice stopped working after an update.**

Run this and read both lines:

```bash
growther voice status
```

It tells you two separate things: whether Built-in (on-device) can run on your computer,
and whether the model is present and checked. They are different problems with different
fixes. `growther doctor` reports the same in its **Offline speech** row, including the
download address and fingerprint if the model is missing.

**C5 says a file "is not the offline speech model this build records".**

The file at the model's name is not the right one, so Built-in (on-device) will not use it. C5 has
renamed it to `ggml-base.en-q5_1.bin.rejected` beside the model's path, or will once the
file stops changing. Run `growther voice pull` to fetch the right file, or place it by hand
— see [Placing it by hand](#placing-it-by-hand). If C5 says it could not
set the file aside, stop C5 and move the file away yourself.

**The model never downloads.**

Run `growther voice pull` in a terminal: it tries the same download and prints the reason
if it fails. (C5's own attempt at startup logs `[voice] offline speech model not fetched:`
and the reason, in the **voice** log category — press `v` in C5's terminal to show it.) If your network allows only named hosts, allow the Hugging Face hosts listed in
[Network and egress](../configuration/network.md). If the egress posture is **Offline**,
or C5 runs with `GROWTHER_VOICE_NO_AUTO_DOWNLOAD=1`, nothing is fetched automatically —
place the model by hand, or (when not offline) run `growther voice pull`.

**You want to remove the downloaded model.**

Turn Built-in (on-device) off on the **Voice** tab first; otherwise C5 downloads
the model again at its next start. Then delete the `speech` folder (see the **Kept at** row
above). `growther uninstall --purge-data` removes it along with everything else C5 stores.
