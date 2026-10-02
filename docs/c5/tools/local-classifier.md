---
title: Local classifier
description: The small model C5 runs on your machine to answer its own routine questions — what it downloads, what it records and how much, what it does before and after it is trusted, how to turn it off or delete it, and what to do when it cannot run.
order: 6
---

# Local classifier

While it works, C5 keeps asking itself small questions with a fixed set of answers: which
categories a new task belongs to, which skill area a step draws on, whether a repeating error
is just noise. Normally each of those questions goes to one of the AI models you configured.
In the rest of this page, **the usual model** means that model: the one C5 would ask without
the classifier. Settings also calls it the **teacher model**, because the classifier is
measured against it.

The **local classifier** is a small model, **decider-0.8b**, that answers the same kind of
question on your own machine. It does not write a reply. It picks from the fixed answers
directly, so an answer takes a fraction of a second and costs nothing: no provider, no
account, no tokens.

It runs in a process of its own, apart from C5's server, so if it crashes C5 carries on. C5
never depends on it: whenever the classifier is off, busy, slow, unsure or broken, C5 asks the
usual model, exactly as before.

**In short:**

- You do not need to do anything. C5 downloads the model (about 812 MB) once, and at first
  only records the classifier's answers beside the usual ones, for every kind of decision.
- On a machine where it runs on the CPU, it records only one in four of its most frequent
  questions, so it stays out of your agents' way; see
  [On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu).
- To stop it, see [Turn the classifier off](#turn-the-classifier-off).
- Managing many machines? Lock `classifier_enabled` to `false` in your organisation's policy before
  C5 first starts, and the model is never downloaded; see
  [For administrators](#for-administrators). To let the download through a proxy, allow
  `huggingface.co` and the five download hosts listed under [Network](#network).
- To get the disk space back, see [Delete the model](#delete-the-model).
- If this machine cannot run it, nothing is downloaded; see
  [Machines it cannot run on](#machines-it-cannot-run-on).
- No network access? See [Offline and air-gapped installs](#offline-and-air-gapped-installs).

## Why it is on by default

The classifier uses none of your providers and none of your accounts. What it gains from your
install is evidence: it records its answers beside the usual ones, C5 measures them against
the answers people give, and fits a small calibration from them. The model file itself is
never retrained or changed on your machine, and none of this leaves it. (Settings calls this
"learning".) An install that never turns it on never collects that evidence, so it could
never take over any work. So C5 switches it on for you:

- On a new install, and on an install updated to a version that has it, C5 turns the switch on
  the first time it starts — but only if nobody has ever set it. If you turned it off before, it
  stays off. If your organisation's policy sets it, the policy decides.
- Administrators get one notification, **The local classifier is on**, saying what this machine
  will do: download the model, use a model that is already here, or not download it (and
  why — for example, the Egress posture is Offline, or the model's path is a link C5 will not
  download over). A machine that cannot run the classifier gets no notification, because
  nothing will happen there.

Turning it on changes nothing at first. It only records its answers beside the usual ones (see
[What it does at first](#what-it-does-at-first)).

## What it downloads

C5 does not ship the model inside its installer. It downloads it once:

| | |
| --- | --- |
| Model | decider-0.8b, by Mapika, fine-tuned from Qwen3.5-0.8B-Base |
| File | `decider-0.8b.Q8_0.gguf` (a conversion published by mradermacher) |
| Size | 811,844,032 bytes — about **812 MB** |
| Licence | Apache License 2.0 (the base model too) |
| From | Hugging Face, at a fixed version of the file, never "the latest" |
| Checked by | its exact size and its **SHA-256 fingerprint** (a code worked out from the file's contents; any change to the file changes it), before it is ever used |
| Kept in | `classifier/models/` under C5's cache folder — `~/.growther/classifier/models/` by default, `%USERPROFILE%\.growther\classifier\models\` on Windows |

If you have moved C5's caches (with `GROWTHER_CACHE_DIR`, your organisation's policy, or
`growther cache relocate`), the `classifier` folder is under that location instead.
`growther cache show` prints where it is. See [Where your data lives](../configuration/data-location.md).

**When it downloads.** In the background, a moment after C5 has started, and only when all of
these hold:

- the classifier is switched on;
- this machine can run it (see [Machines it cannot run on](#machines-it-cannot-run-on));
- the model's path is not a symbolic link: C5 never downloads over a link you placed (see
  [Offline and air-gapped installs](#offline-and-air-gapped-installs));
- the **Egress posture** under **Settings › Enterprise › Network** is not **Offline** (see
  [Network and egress](../configuration/network.md#turn-off-every-outbound-connection));
- `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` is not set, and the `CI` environment variable is unset
  or empty (automated build servers set it);
- there is enough free space for the rest of the model plus about 64 MB to spare.

C5 keeps working while the model arrives. The download picks up where it stopped if it is
interrupted. Turning the classifier off stops the download and keeps what has arrived; turning
it back on carries on from there.

If an automatic download fails, C5 does not keep retrying it while it runs. It tries again the
next time C5 starts, or when you turn the classifier off and on, or when you run
`growther classifier pull`.

The model's publisher states that its training data includes datasets released for research
use. C5 shows the model's notice next to it in **Settings › Learning**:

> decider-0.8b by Mapika (Apache-2.0), fine-tuned from Qwen3.5-0.8B-Base (Apache-2.0) on public
> datasets and labels from local Qwen models. Its published training mixture includes datasets
> released for research use; check that this fits your use, and if it does not, turn the local
> classifier off in Settings › Learning. About 812 MB is downloaded once from Hugging Face.

To check the training mixture, see the publisher's page for the model:
[huggingface.co/Mapika/decider-0.8b](https://huggingface.co/Mapika/decider-0.8b).

### Files in the classifier folder

| File | What it is |
| --- | --- |
| `models/decider-0.8b.Q8_0.gguf` | The model. |
| `models/decider-0.8b.Q8_0.gguf.partial` | An unfinished download. The next download resumes from it. The **Model** line reports its size, for example _300 of 812 MB_. |
| `models/decider-0.8b.Q8_0.gguf.partial.lock` | Present only while a download runs, so that two C5 processes never write the same file. One left behind by a process that crashed is taken over automatically. |
| `models/decider-0.8b.Q8_0.gguf.verified.json` | C5's record that it checked the model, so it does not read all 812 MB again at every start. If the model file changes, it is checked again. |
| `runtime.json` | Settings for the classifier's own process, written by C5 each time it starts the classifier. |

## Turn the classifier off

Anyone with permission to change settings can turn it off.

1. Go to **Settings › Learning**.
2. Flip the **Local classifier** switch off.
3. C5 asks **Turn off the local classifier?** and explains that, while off, it stops learning and
   C5 answers those questions as it did before. Choose one:

| Button | What happens |
| --- | --- |
| **Turn off** | The classifier stops. The model stays on this machine, so turning it back on costs no download. |
| **Turn off and delete the model** (**Turn off and remove the link** when the model is a symbolic link; **Turn off and delete the file** when the file at the model's path is not the model) | The classifier stops, and the model is deleted from this machine (for a link, only the link is removed). Only shown to an administrator, not on a paired device, and only when something is on this machine to delete: the model, a partial download, or a file at the model's path that is not the model. |
| **Cancel** | Nothing changes. Closing the dialog or pressing Escape does the same. |

The question also says what is on the disk. If the file at the model's path is not the model,
it says so (_The file at the model's path is not the model (…), so C5 does not use it._) and
that turning off leaves the file where it is. If the model's path is a link whose file cannot
be reached, it says turning off leaves the link, and that C5 uses the model once that file can
be reached.

Turned off, the classifier is completely quiet. C5 does not start its process, load the model,
download anything, run its nightly jobs or print anything about it in the log.

You can also reach the same question from the **Terms** dialog: **Turn off the local
classifier…**.

## Turn it back on

Flip the switch on again.

- If the checked model is already here, or the model's path is a symbolic link to the checked
  model, it turns on at once.
- If the model is missing, partly downloaded, or not yet checked, C5 asks first:
  **Turn on the local classifier?** The dialog shows the model, its size, its licence and its
  notice. **Download and turn on** turns it on and starts the download; **Cancel** leaves it off.
- If a file is at the model's path but C5 already knows it is not the model, the dialog says
  so, and that C5 downloads the model and replaces that file.
- On a machine that will not download the model — the Egress posture is Offline, automatic
  downloads are turned off, there is not enough disk space, or the model's path is a symbolic
  link C5 cannot use yet (one whose file cannot be reached, one it has not checked, or one to
  a file that is not the model) — the dialog says so and why, and the button reads
  **Turn on**. The classifier then answers nothing until the model is on the machine; the
  dialog tells you how to get it there.
  - For a link whose file cannot be reached (a share that is not mounted, say): make that file
    reachable, or remove the link so that C5 can fetch the model.
  - For a link C5 has not checked yet: C5 checks the file it points to first and uses it only
    if it is the model.
  - For a link to a file that is not the model: point the link at the model, or remove it.

## Delete the model

The model takes about 812 MB. To get that space back:

- **While the classifier is on**: turn it off and choose **Turn off and delete the model**
  (**Turn off and remove the link** for a symbolic link).
- **While it is already off**: the **Model** line has a delete button, and C5 asks before it
  deletes anything. What you see depends on what is at the model's path:

  | What is at the model's path | Button on the Model line | C5 asks | Button in the dialog |
  | --- | --- | --- | --- |
  | The model | **Delete the model (812 MB)** | **Delete the classifier's model?** | **Delete the model** |
  | An unfinished download | **Delete the partly downloaded model (300 MB)** | **Delete the classifier's model?** | **Delete the model** |
  | A file that is not the model | **Delete the file (N MB)** | **Delete the file at the classifier model's path?** | **Delete the file** |
  | A symbolic link to a file elsewhere (see [Offline and air-gapped installs](#offline-and-air-gapped-installs)) | **Remove the link to the model** | **Remove the link to the classifier's model?** | **Remove the link** |

**Who can.** An administrator, on the machine running C5 rather than from a paired device (a
phone or tablet paired through [Remote Control](../remote-control/overview.md)). The account
needs MFA: a passkey, or a directory sign-in your identity provider marks as multi-factor. (An
account on an install set up without any sign-in does not need MFA.) An administrator without
MFA who chooses **Turn off and delete the model** still gets the classifier turned off; the
message says the model was not deleted, and why.

**What it removes.** The model, any unfinished download (`.partial`), C5's record that it
checked the model (`.verified.json`), and a download lock left behind by a crashed process.
Nothing outside the classifier's `models` folder; `runtime.json` stays. If the model was a
symbolic link to a shared copy, only the link is removed and no space is freed. The classifier
stays off afterwards, and turning it back on downloads the model again, on a machine that
downloads it at all. Every delete is recorded in the audit log.

While a delete runs, the **Runtime** line reads _Not running: The classifier's model is being
deleted._ It ends in seconds.

**When it is refused:**

- _Another process is downloading the model right now._ — `growther classifier pull` is running.
  Let it finish or stop it, then try again.
- _Your organisation's policy keeps the local classifier on, so its model was not deleted: C5
  would download it again._ — see [For administrators](#for-administrators).
- _Some of its model's files could not be removed …_ — usually another program (often an
  antivirus scanner on Windows) has the file open. The message names the files and the folder;
  close whatever holds them and delete them by hand.

You can also delete the `classifier` folder yourself while C5 is stopped. It is a download, not
your data. Turn the classifier off first: if it is still on, C5 downloads the model again the
next time it starts.

## What it does at first

The classifier is asked about one **kind of decision** at a time. Each kind has its own setting
in **Settings › Learning**:

| Setting | What the classifier is asked | Its answer is recorded beside | Default | What it can do |
| --- | --- | --- | --- | --- |
| **Task categories** | Which categories a new task belongs to | The categories the usual model gave | Shadow | Record, or act once it has been measured |
| **Skill routing** | Which skill area a specialist's step draws on | The skill area C5's **router** chose (the part of C5 that hands a step to a specialist) | Shadow | Record only |
| **Step quality** | How good a step's output is, on five levels | The **rubric** score, C5's usual grade for a step | Shadow | Record only |
| **Tool-call safety** | Whether a tool call is unsafe | The verdict of C5's **guardian**, which checks agents' tool calls before they run and still makes the decision | Shadow | Record only |
| **Alert triage** | Whether a repeating error is noise to suppress | Whether the **Sense-Maker** (C5's own alert triage) chose to suppress it | Shadow | Record only |

Each setting has up to four modes:

| Mode | What happens |
| --- | --- |
| **Off** | The classifier is never asked. |
| **Shadow** | It is asked in the background, after the usual answer. Its answer is recorded and never used. |
| **Assisted** | The usual model answers as before. Only where the usual model could not answer at all is the classifier's confident answer used instead of nothing. |
| **Authoritative** | The classifier is asked first. When it is confident about every part of the answer, that answer is used and the usual model is not called. Otherwise the usual model answers as before. |

So when it is first on, the classifier only **records** its answers, for every kind of
decision, beside the answers C5 already uses. Nothing C5 does changes. Recording is how a kind
earns the evidence its promotion gate measures (see
[When it starts to act](#when-it-starts-to-act)); a kind left off never could. In this
version only Task categories can act on that evidence. The other four are recorded so their
gate line shows how well the classifier does at them; for Tool-call safety, for example,
Settings says it has measured at chance so far. If you do not want a kind recorded, set it to
**Off**, and that choice is kept.

**A mode someone chose is kept.** The defaults apply only to a kind of decision nobody has
set. If you set a kind to **Off**, it stays off. Nothing ever raises a kind into **Assisted**
or **Authoritative** for you. With the classifier switched off, none of them is asked,
whatever its mode says.

**After updating from an earlier version.** Earlier versions saved the mode of every kind as
soon as anyone changed one of them. So a kind nobody chose could be saved at the old default:
Task categories in Shadow, every other kind Off. Once per install, at the first start of a
version with the new defaults, C5 looks in its audit log for the kinds someone actually set:

- a kind still at its old default, with no record that anyone chose it, is reset, so it takes
  today's default (Shadow);
- a kind someone set is kept exactly as they set it, and so is a kind at any mode that was
  never a default;
- if the audit log may no longer reach back to 27 September 2026, when C5 first saved these
  modes, C5 cannot tell which were chosen, so it changes nothing. While the classifier is on,
  it then logs `[classifier] site modes kept as stored: the audit trail no longer shows which
  were chosen, so none is taken for a default`.

A kind that was reset is recorded in the audit log as a change made by `system`. **Settings ›
Learning** shows every kind's mode, so you can check the result and change any of them.

### On a machine where it runs on the CPU

Three kinds of decision are asked as often as C5 works: **Step quality** once for each step
that is graded, **Tool-call safety** once for each tool call the guardian checks, and **Skill
routing** once for each specialist step. On an Apple-silicon Mac's GPU, one answer takes a
fraction of a second. On a CPU it takes a second or more, on the same cores your agents'
builds, tests and local models use.

So on a machine where the classifier runs on the CPU (see [GPU or CPU](#gpu-or-cpu)), or is
marked slow (see [Slow machines](#slow-machines)), these three kinds record only **one question
in four** while they are in Shadow:

- **The question decides, not the timing.** Whether a question is recorded depends on the
  question itself, so the same question is always recorded, or never. A label you give later
  always finds the classifier's answer beside it, and **Teach the classifier** only asks about
  recorded questions.
- **For Step quality, a step outside the sample leaves nothing in the classifier's records**:
  neither the classifier's grade nor the copy of C5's usual grade it is compared with. C5
  still grades the step and uses that grade exactly as before. Only the comparison record is
  skipped.
- **Task categories and Alert triage are never sampled.** Each is asked far less often. A kind
  set to **Assisted** or **Authoritative** is never sampled either.
- **There is nothing to set.** It applies on its own, and the **Last 7 days** counts of these
  kinds are about a quarter of what they would otherwise be.

Under each kind it applies to, the card says so:

> Sampling 1 in 4 on this machine: the local classifier runs on this machine's CPU, so it
> records only one in 4 of these questions, always the same ones, to keep the rest of C5 fast.

On a slow machine the reason reads _the local classifier answers slowly on this machine_
instead.

## When it starts to act

Only **Task categories** can be raised to **Assisted** or **Authoritative**, and only after the
classifier has been measured on your own install. The other four offer only Off and Shadow.

The measurement is called the **promotion gate**. It compares the classifier's recorded answers
over the last 30 days with the usual model's, and with the answers people gave when they
corrected or labelled tasks. Its line in Settings shows each part that has not passed yet:
**Labels**, **Accuracy against your labels**, **Agreement with the teacher model**,
**Calibration**, **Confident answers** and **Speed**.

- **Assisted** and **Authoritative** can be chosen only once the gate has passed, and once a
  **calibration** has been fitted for that kind of decision. A calibration is the adjustment
  that turns the classifier's raw confidence into a measured one. C5 fits it itself, every night
  at 23:50, from the labelled answers, once there are enough of them.
- Nothing raises the classifier for you. Someone with permission to change settings chooses the
  mode.
- Even when raised, it acts only at the confidence level its gate measured, only on answers
  from the model the gate measured, and only on answers calibrated the way the gate measured
  them. Below that level, the usual model answers.
- Every night C5 re-checks each kind of decision that acts. It moves it back to **Shadow**, and
  sends administrators a notification, **Local classifier: … moved back to shadow**, saying
  why, when:
  - its gate now fails;
  - the classifier now answers as a different model;
  - the calibration its confidence level was measured on has been replaced; or
  - its calibration error has more than doubled since it was raised.
- If the gate only lacks enough new evidence, it keeps acting for up to 60 days after its last
  pass. Administrators are told that its evidence is thin (**Local classifier: … is acting on
  evidence from …**), and after the 60 days it goes back to Shadow. Answering its questions in
  **Teach the classifier** re-checks it.
- On a machine where the classifier is too slow (see [Slow machines](#slow-machines)), only
  kinds set to Shadow run. A kind set to Assisted or Authoritative is not asked at all: it
  does not even record, so it gathers no new evidence for its promotion gate while the
  machine is marked slow. To keep collecting evidence there, set it back to **Shadow**. On
  Windows you can raise it again once the first timing has cleared the slow mark.

An administrator can raise Task categories on a gate that has not passed, after a warning. That
needs an administrator account with MFA (see [Who can](#delete-the-model)), on the machine
running C5 rather than from a paired device. It is recorded in the audit log, and the setting
shows **Unvalidated** until it is raised again on a passing gate. It still needs a fitted
calibration. A kind raised this way is not moved back for its gate result, only for the other
reasons above.

### Let task categories act

1. Leave the classifier on, with **Task categories** in **Shadow**.
2. Confirm or correct task categories: in the **Teach the classifier** tab (see below), or by
   changing the categories C5 gave a task.
3. Wait until the **Promotion gate** line under Task categories reads _passed_ and a
   **Calibration** is listed. C5 fits one every night at 23:50, or an administrator can press
   **Fit calibration now**.
4. Choose **Assisted** or **Authoritative**.

If a mode cannot be chosen, the option says why; see
[I cannot choose Assisted or Authoritative](#troubleshooting).

### Teaching it

The answers people give are what the gate measures. While the classifier is on and has
something to ask, administrators on the machine running C5 (never on a paired device) see a
**Teach the classifier** tab in the **HITL: Human-in-the-Loop Signoffs** window, which opens
from the HITL (clipboard) button in the sidebar. It shows a task's categories to confirm, or a
step's output to rate. It never shows what the classifier answered, so your answer cannot lean
towards it.

Two other actions count as answers too:

- **Changing the categories C5 gave a task.**
- **Muting or unmuting an alert**, for alert triage. The **Auto-Suppression Ledger**, in the
  **Errors** tab of the same HITL window, has **Mute Noise** and **Unmute** beside each
  repeating error. Muting says "this is noise, hide it"; unmuting says "this should not have
  been hidden". Only your latest act on an alert counts: unmuting takes back an earlier mute,
  and the other way round. It counts for an alert C5 triaged while Alert triage was recording.
  An alert the Sense-Maker (C5's own alert triage) suppresses by itself is not an answer.

Because both kinds of answer can arrive, alert triage can be measured and calibrated like
the others.

## What you see in Settings › Learning

The **Local Classifier** card has a switch, a **Terms** button and a short status badge, then a
few status lines and one row for each kind of decision.

### The badge

| Badge | What it means | What to do |
| --- | --- | --- |
| **Unsupported** | This machine cannot run the classifier. The first status line (**This Mac**, or **This machine**) says why. | See [Machines it cannot run on](#machines-it-cannot-run-on). |
| **Off** | The classifier is switched off. | Nothing. |
| **Downloading** | The model is downloading. The **Model** line shows how far it has got. | Nothing. |
| **No model** | It is on, but the model is not here and C5 will not download it on its own — for example the Egress posture is Offline, or the model's path is a link whose file cannot be reached. The **Model** line says why. | Follow the Model line; see [Troubleshooting](#troubleshooting). |
| **Waiting** | Another C5 process (usually `growther classifier pull`) is downloading the model. C5 uses it when that finishes. | Let it finish. |
| **Loading** | The classifier is loading the model. | Nothing. |
| **Not loaded** | The classifier's process is running; the model loads with the first question. | Nothing. |
| **Running** | The model is loaded and answering. | Nothing. |
| **Paused** | It failed three times in a row, so C5 is giving it a 60-second rest. The usual answers stand meanwhile. | If it keeps happening, read the **Runtime** line and run `growther doctor`. |
| **Not running** | It was started but cannot run here, or it stopped. The **Runtime** line says why. | Find that message under [Troubleshooting](#troubleshooting). |
| **Not answering** | Its process is running but did not answer a status check in time. | It usually clears on its own. If it lasts, turn the classifier off and on, and run `growther doctor`. |
| **Starting** | It is being started. | Nothing. |
| **Error** | The download failed, or the classifier stopped with an error. | Read the **Model** or **Runtime** line, then find that message under [Troubleshooting](#troubleshooting). |

While a change you made is being saved the badge says **Turning on…**, **Turning off…**,
**Deleting the model…** or **Saving…** instead.

### The status lines

| Line | What it tells you |
| --- | --- |
| **This Mac** (on a Mac, often its model name, such as **This Mac Studio**), or **This machine** elsewhere | The machine and whether it can run the classifier, for example _Apple M4 Max, 16 cores (12 performance and 4 efficiency), 64 GB memory — supported._ Under it, where the classifier runs and why: _Runs on the GPU (Metal)._, or _Runs on the CPU (8 threads), because LM Studio is configured and the classifier leaves the GPU to your local model._ (see [GPU or CPU](#gpu-or-cpu)). On a machine that cannot run it, the line ends _— not supported._ and the reason follows. |
| **Model** | Whether the model is here and checked, partly downloaded (for example _300 of 812 MB_), downloading, or not downloaded — and on a machine that will not download it, why not and what to do. It also tells you when the file at the model's path is not the model, or when the path is a link whose file cannot be reached (see [Troubleshooting](#troubleshooting)). |
| **Notice** | The model's notice, quoted above. |
| **Runtime** | What the classifier's process is doing: for example _Running on the Metal GPU, 742 MB in memory, loaded in 1.9 s._ This is where you read its real memory use. When the **Model** line already says why nothing was downloaded, Runtime reads only _Not running: the model is not on this machine._ |
| **Health** | How many questions it answered, how fast (p50 is the typical answer time, p95 the slow end), and how many timed out, failed, or were skipped because the text was not in the Latin alphabet. |

**The machine line uses your operating system's own figures**: the machine's model name, its
processor, its physical cores by kind, and its installed memory — what System Information
shows on a Mac, and the equivalent on Windows and Linux. On a PC the line starts with the
operating system, for example _Windows (x64), Dell XPS 15 9520, 12th Gen Intel Core
i9-12900HK, 14 cores, 64 GB memory — supported._ A figure the system does not give is left out, never
guessed:

- On Linux, installed memory can only be read by the administrator account, so the line gives
  the memory the system can use instead: _31.1 GB usable memory_.
- Where the system can use at least half a gigabyte less than is installed, both are given,
  for example _16 GB memory (15.2 GB usable)_.

The 8 GB minimum is checked against the **usable** figure, rounded to the nearest whole
gigabyte, so 7.5 GB usable or more passes. Most 8 GB machines report 7.6 to 7.9 GB and
qualify. An 8 GB laptop that keeps more for its built-in graphics shows _… 8 GB memory
(7.4 GB usable) — not supported._ with _This machine has 7.4 GB of memory; the classifier
needs at least 8 GB._, and cannot run the classifier.

C5 reads these figures once, the first time the card asks for the classifier's status — never
when C5 starts — and keeps them until C5 restarts. It reads no serial number or hardware
identifier. On a slow first read (Windows can take a few seconds) the line fills in a moment
later.

**How C5 reads them**, for administrators whose endpoint protection watches new processes:

- On a Mac it runs `system_profiler SPHardwareDataType -json -detailLevel mini` and `sysctl`.
- On Windows it starts one `powershell.exe -NoProfile -NonInteractive`, which reads the
  registry key `HKLM\HARDWARE\DESCRIPTION\System\BIOS` and the CIM classes `Win32_Processor`
  and `Win32_PhysicalMemory`.
- On Linux it starts nothing: it reads files under `/sys` and `/proc` only.

Each command has 10 seconds. The read happens when the card asks for the classifier's status,
and when you run `growther classifier status` on a machine that can run the classifier. If
your endpoint protection blocks it, the line shows only what C5 knows without it (the
processor and the memory the system can use), and nothing else about the classifier changes.

The model is unloaded after 10 minutes without a question, and loaded again by the next one.
The Runtime line then reads _Started; the model is not loaded yet and loads with the first
question._

### Each kind of decision

Under each setting you see:

- A short note on what its modes mean there, starting with its default, for example _Shadow by
  default: recorded beside the usual model's answer, never used._ Each kind names what it is
  recorded beside: the router's choice, the rubric's score, the guardian's verdict or the
  Sense-Maker's suppress decision (see the table in
  [What it does at first](#what-it-does-at-first)).
- On a machine where it applies, _Sampling 1 in 4 on this machine: …_ (see
  [On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu)).
- **Promotion gate** — _passed_, _not passed_, _not enough evidence yet_, or _not measured
  yet_, with each part that did not pass and what was measured. C5 measures it in the
  background, at most every ten minutes.
- What it is really doing, when it is set to act: _Acting in Authoritative at confidence 0.83 or
  more._, _Set to Assisted, but only recording its answers._ with the reason, or _Set to
  Assisted, but not running: this machine is too slow for its answers to be used in time, so
  only Shadow runs here._ A kind an administrator raised on a gate that had not passed also
  shows _Unvalidated: an administrator raised it on a gate that had not passed …_
- **Calibration** — the one stored, when it was fitted and by what. An administrator on the
  machine can press **Fit calibration now** for task categories, tool-call safety and alert
  triage while the classifier is on.
- **Last 7 days** — how many decisions were recorded and how many by the local classifier, and
  how many labels people gave.
- For task categories, **Saved, last 7 days** — how many calls to the usual model its
  Authoritative answers replaced, and roughly what they would have cost, provider by provider.
  Local models are counted in model time, not money, and a model with no price set is never
  called free.

## What you see in Ops › Classifier

The **Classifier** tab on the **Ops** page shows the classifier as it runs: whether it is on
and acting, how many decisions it made and how fast, the calls to the usual model it replaced,
the labels still waiting, and where each learning loop stands. Only accounts that may view
Settings see this tab. It only reports; the switch and the modes are in **Settings ›
Learning**.

## The Terms that cover it

The **Terms** button on the card opens **The local classifier — Terms of Service, Section 14**:
section 14 of the Growther.si Terms of Service, _Models C5 downloads and runs on your machine_,
word for word, with this install's model, its size, its licence, whether it is on this machine,
and its notice. The **On this machine** row says what is at the model's path, without claiming
C5 downloaded it (you may have placed it by hand):

| It reads | Meaning |
| --- | --- |
| _present and verified_ | The model is here and checked |
| _a link to the model, verified_ | The model's path is a link to a shared copy, and that copy is the model |
| _present, not yet verified_ | A file of the model's size, not checked yet |
| _a file that is not the model (wrong size), so it is not used_, or _(its checksum does not match)_ in the brackets | C5 has found that the file is not the model. For a link: _a link to a file that is not the model (…), so it is not used_ |
| _a link whose file cannot be reached; used once it can be_ | A link to a share that is not mounted, say |
| _partly downloaded: 300 of 812 MB_ | An unfinished download |
| _not downloaded_ | Nothing is there |

While the model is not here (or the file there is not the model), on a machine that will not
download it (see [Turn it back on](#turn-it-back-on)), a line under the notice says so and why:
_On this machine it is not downloaded: …_

At the bottom are **Full Terms of Service**
([growther.si/t=models](https://growther.si/t=models)), **Third-party notices** (the licences of
everything C5 ships or downloads), **Turn off the local classifier…** and **Close**. **Turn off
the local classifier…** is offered to someone who may change settings, while the classifier is
on and not locked by policy. Reading the Terms asks you to accept nothing.

In short, section 14 says: C5 downloads these models from Hugging Face only while the feature
that needs one is on, checks each one before using it, keeps it on your machine, and sends
nothing about it or your use of it to Growther.si. Each model stays under its publisher's own
licence. The classifier is on by default, first only records, and acts only after it has been
measured on your install and only for the kinds of decision allowed in Settings.

## Machines it cannot run on

The classifier runs on macOS (Apple silicon and Intel), Linux x64, and Windows x64 and arm64,
with at least 8 GB of memory. Where it cannot run, C5 itself downloads nothing and starts
nothing; the badge reads **Unsupported** and the first status line (**This Mac** or **This
machine**) says why. (Only
`growther classifier pull` downloads on such a machine, because you asked it to; see
[Command line](#command-line).)

| Reason | What you see | What to do |
| --- | --- | --- |
| Linux on arm64 | _C5's release for linux-arm64 is experimental, so the classifier is not offered there._ | Nothing. C5 works as before. |
| Any other platform | _No local classifier build ships for …_ | Nothing. |
| Less than 8 GB of memory | _This machine has 5.8 GB of memory; the classifier needs at least 8 GB._ | Nothing, unless you can add memory. C5 checks the memory your operating system can **use**, in the gigabytes your system shows (a 64 GB Mac shows 64), rounded to the nearest whole gigabyte, so 7.5 GB or more passes. Most machines sold with 8 GB report 7.6 to 7.9 GB usable and qualify. One that keeps more for its built-in graphics (7.4 GB usable) does not, and neither does a 6 GB one (5.8 GB). |
| macOS too old | _The classifier's runtime (llama.cpp, …) needs macOS 14.0 or later; this machine has macOS 13.6, so its model is not downloaded._ | Update macOS. C5 itself runs from macOS 13.5, but the classifier's runtime needs 14. |
| Linux system library too old (glibc) | _… needs glibc 2.NN or later; this machine has glibc 2.MM, so its model is not downloaded._ | Use a newer distribution. Check your version with `ldd --version`. |
| Linux C++ library too old (libstdc++) | _… needs a libstdc++ with GLIBCXX_3.4.NN or later; this machine's libstdc++ goes up to GLIBCXX_3.4.MM, so its model is not downloaded._ | Update your distribution's libstdc++ (often packaged as `libstdc++6`), then restart C5. Check yours with `strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 \| grep GLIBCXX`. |
| Windows without the Visual C++ runtime | _… needs the Microsoft Visual C++ 2015-2022 Redistributable (x64), which is not installed on this machine (… not found), so its model is not downloaded. Install it from https://aka.ms/vs/17/release/vc_redist.x64.exe, then restart C5._ | Install the redistributable from the link in the message (it names the x64 or arm64 one for your machine), then restart C5. |

`growther classifier status` and `growther doctor` show the same reason.

### Slow machines

The first time the model loads, C5 times how long it takes to answer one question about a text
of about a page. If that takes more than two seconds, the machine is marked slow: the first status line adds _This machine is slow for it, so its
answers may arrive late._ On a slow machine only kinds of decision set to Shadow run; one set
to Assisted or Authoritative is not asked at all, and records nothing either. Step quality, Tool-call safety and Skill
routing also record only one question in four there (see
[On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu)).

**Windows starts out marked slow**, because the classifier has not yet been timed on Windows
hardware. So until that first timing, task categories can only be recorded (Shadow) on Windows.
You do not need to do anything: the timing happens on its own the first time the model loads,
and a machine that answers in two seconds or less clears the mark.

### GPU or CPU

On Apple silicon the classifier uses the GPU (Metal), unless LM Studio, llama.cpp, Ollama or
Inferencer is one of the model providers C5 is set up to use (turned on in **Settings ›
Integrations**, or listed in the **Coordinator Priority** card there). C5 assumes such a
provider runs its model on this machine's GPU, so the classifier gives way and uses the CPU.
C5 decides this by the provider's name, not by its address: Inferencer pointed at Hugging
Face's cloud, or LM Studio on another machine, also moves the classifier to the CPU. To give
the GPU back to the classifier, remove that provider from C5's providers there. Everywhere
else the classifier uses the CPU, with up to 8 threads, leaving two cores free. A Mac with no usable GPU, such as a virtual
machine, is moved to the CPU automatically the first time the classifier loads.

The card says which, and why, under the machine line. The thread count is the classifier's
own, not your machine's:

| The card says | Why |
| --- | --- |
| _Runs on the GPU (Metal)._ | An Apple-silicon Mac with no local model runner configured |
| _Runs on the CPU (8 threads), because LM Studio is configured and the classifier leaves the GPU to your local model._ | A local model runner is configured; the line names it (or them) |
| _… because C5 could not read which models are configured, and a local one may be using the GPU._ | C5 could not read which model runners are configured, so it leaves the GPU alone to be safe |
| _… because this Mac has no Metal GPU it can use (a virtual machine looks like this)._ | No usable GPU |
| _… because this is C5's Intel build running under Rosetta; the Apple-silicon build uses the GPU._ | You are running the Intel build on an Apple-silicon Mac. Install the Apple-silicon build to use the GPU |
| _Runs on the CPU (8 threads); the classifier uses the GPU only on Apple silicon._ | An Intel Mac, Windows or Linux |

On the CPU, Step quality, Tool-call safety and Skill routing record only one question in four
(see [On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu)).

### Languages

The model is English-only. Text that is mostly outside the Latin alphabet (for example Hindi,
Thai, Japanese or Cyrillic) is not sent to it; the usual model answers. French, Vietnamese and
other languages written in the Latin alphabet are still asked.

## Offline and air-gapped installs

With the Egress posture set to **Offline**, C5 never downloads the model — not at start, not
from Settings, and not from `growther classifier pull`. Put it on the machine yourself. The
classifier can be on or off while you do this; it uses the file once it is on.

1. On a machine with internet access, download exactly this file:

   ```
   https://huggingface.co/mradermacher/decider-0.8b-GGUF/resolve/001df41ddc126176cab96c8aec9ada45008fbe62/decider-0.8b.Q8_0.gguf
   ```

2. Check its SHA-256 fingerprint. It must be:

   ```
   2665d08c1052b4e01dabcb08771d25579f6776f7066355e4a0ccc5f74e32d4a2
   ```

   ```bash
   shasum -a 256 decider-0.8b.Q8_0.gguf                 # macOS
   sha256sum decider-0.8b.Q8_0.gguf                     # Linux
   certutil -hashfile decider-0.8b.Q8_0.gguf SHA256     # Windows
   ```

3. Copy it, with exactly that name, to the classifier's `models` folder under C5's cache folder:
   `~/.growther/classifier/models/decider-0.8b.Q8_0.gguf` by default, or
   `%USERPROFILE%\.growther\classifier\models\decider-0.8b.Q8_0.gguf` on Windows. Create the
   folder if it does not exist. If you moved C5's caches, run `growther cache show` to find the
   folder.

   To share one copy between several installs on macOS or Linux, you can put a symbolic link at
   that name instead of the file. C5 checks the file it points to:

   ```bash
   ln -s /shared/decider-0.8b.Q8_0.gguf ~/.growther/classifier/models/decider-0.8b.Q8_0.gguf
   ```

   **C5 never downloads over a link.** Not at start, not from Settings, and not from
   `growther classifier pull`: the link is yours, and replacing it would cut this install off
   from the shared copy.
   - If the file the link points to cannot be reached — a share that is not mounted, say — C5
     waits. It uses the model as soon as that file can be reached. Mount the share, or remove
     the link if you would rather C5 downloaded its own copy.
   - If the link points to a file that is not the model, C5 does not use it and does not
     replace it. Point the link at the model, or remove it to have C5 fetch the model.
   - If you place a link while C5 is downloading the model, C5 leaves the link alone and keeps
     its checked download beside it as `decider-0.8b.Q8_0.gguf.partial`. Remove the link and
     run `growther classifier pull` to put that copy in place.

4. Run:

   ```bash
   growther classifier status
   ```

   It checks the file and should print `✓ model present and verified`. If it prints anything
   else, see [Troubleshooting](#troubleshooting).

You do not need to restart C5. While the classifier is on, a running C5 notices the file the
next time **Settings › Learning** is opened, checks it and starts the classifier. Otherwise it
picks it up at its next start.

**How C5 checks the file.** First its size, which must be exactly 811,844,032 bytes. Then its
SHA-256 fingerprint, worked out once. C5 records the result in a small file beside the model,
`decider-0.8b.Q8_0.gguf.verified.json`, so it does not read all 812 MB again at every start; if
the model file changes, it is checked again.

**A wrong file** at that name — the wrong size, the wrong contents, or a copy still in progress —
is never loaded. C5 leaves it where it is and does not delete or rename it. The **Model** line
says _The file at the model's path is not the model (it is N MB; the model is 812 MB), so C5
does not use it._ (or _its checksum does not match_), then what happens to it and what you can
do; `growther classifier status` says _… is not the pinned model (wrong size)_ or _(sha256
mismatch)_, and `growther doctor` warns about a file of the wrong size. Once C5 has worked out
that a file's fingerprint does not match, it remembers that until the file changes or C5
restarts, so it does not read all 812 MB again each time the classifier is turned on.

On a machine that may download, the next verified download replaces a wrong file (never a
link). Under Offline (and with automatic downloads turned off, or on a CI runner) nothing
replaces it, so delete it and copy the right file again. There C5's start-up log line — and,
under Offline, `growther classifier pull` — begins its reason with _The file at … is not the
classifier model (wrong size), so C5 does not use it; replace it._ (or _its sha256 does not
match_), followed by the placement step.

## Privacy

- The questions, the classifier's answers and the labels people give stay in C5's database on
  this machine. The model runs on this machine, in its own process.
- The only network traffic is the one download of the model from Hugging Face. C5 sends nothing
  about the model, or your use of it, to Growther.si.
- C5's status address, `GET /health`, answers without any sign-in, so that supervisors can
  see C5 is up. It includes the classifier's details (use counts, answer times, how many
  questions are in progress, whether it is paused) only for someone signed in to C5 on this
  machine or its network, or for a request made directly on the machine itself. Everyone else
  gets `"classifier": null`, including a phone or tablet paired through Remote Control and
  anyone reaching C5 through a Remote Control address.

## For administrators

### Managed policy: `classifier_enabled`

`classifier_enabled` is a boolean key you can set and lock through Group Policy or Intune,
macOS managed preferences, `/etc/growther/policy.d`, or a signed policy document. See
[Managed configuration](../configuration/enterprise-policy.md#keep-the-local-classifier-on-or-off).

- **Locked to `false`**: the classifier stays off, and C5 never downloads the model — not even
  through `growther classifier pull`. An administrator can still delete a model that is already
  there.
- **Locked to `true`**: it stays on. Nobody can turn it off or delete the model in Settings.
  If the file at the model's path is not the model, the card says so and adds _Your
  organisation's policy keeps the classifier on, so the file cannot be deleted here._ (for a
  link, _so the link cannot be removed here_). An administrator at the machine can put the
  model in its place (or point the link at it).
- Either way, the switch is shown disabled with a **Managed** lock and a line saying why. Locked
  on: _Your organisation's policy keeps the local classifier on, so it cannot be turned off
  here._ Locked off: _Your organisation's policy keeps the local classifier off, so it cannot be
  turned on here._ Each is followed by _The policy is set by …_ and where it came from.
- **It applies without a restart.** After each policy refresh (every fifteen minutes,
  `growther policy reload`, or **Reload policy** under **Settings › Enterprise**), C5 starts or
  stops the classifier to match, cancelling a download in progress when it is turned off.
- **Before the first start**: when a policy already sets the key the first time C5 starts, C5
  leaves the switch to the policy and sends no "is on" notification. Set it to `false` there and
  the model is never downloaded.
- If a signed policy can no longer be fetched and its grace period (how long C5 keeps using the
  last signed policy it fetched; fourteen days by default) runs out, a locked
  `classifier_enabled` falls back to `false`, its safe default. See
  [How a policy is applied](../configuration/enterprise-policy.md#how-a-policy-is-applied).

### Downloads only by hand or on request

Start C5 with `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` (exactly `1`) and C5 does not download
the model on its own. It then arrives only when someone runs `growther classifier pull`, or by
hand. C5 also never downloads it automatically when the `CI` environment variable is set. See
[Environment variables](../cli/environment.md).

### Network

The download goes through the proxy and certificate authorities set under **Settings ›
Enterprise › Network**, like every other C5 download (see
[Corporate proxy](../configuration/network.md#corporate-proxy)). `huggingface.co` answers a
model request by redirecting to its download network, so allow these hosts as well — a proxy
that allows only `huggingface.co` makes every model download fail:

- `huggingface.co`
- `cas-bridge.xethub.hf.co`
- `cdn-lfs.hf.co`
- `cdn-lfs-us-1.hf.co`
- `cdn-lfs-eu-1.hf.co`
- `cdn-lfs.huggingface.co`

When the download fails on the network, the message gives the cause itself, then the steps to
place the file by hand:

```text
Could not download the classifier model: the proxy http://proxy.corp.example:3128 refused to open a tunnel to huggingface.co:443: it answered CONNECT with 407 Proxy Authentication Required; it wants credentials — put them in the proxy URL (http://user:password@host:port), C5 speaks Basic proxy authentication only. Fetch https://huggingface.co/… on a connected machine and place it at … (sha256 …).
```

Other causes read the same way: a certificate C5 does not trust (_self-signed certificate in
certificate chain_), a host that refused the connection (_connect ECONNREFUSED …_), or a proxy
setting C5 cannot use (_C5 refused to connect to huggingface.co: the configured proxy … cannot
be used (…)_). See [When the proxy says no](../configuration/network.md#when-the-proxy-says-no).

With the Egress posture set to Offline, C5 logs this line, at most once an hour, when it skips
the download:

```text
[posture] offline — local classifier model download skipped; this deployment makes no outbound contact
```

See [Network and egress](../configuration/network.md).

## Command line

```bash
growther classifier status
growther classifier pull
```

`status` checks whether this machine can run the classifier and whether the model is here and
checked. It works out the model's SHA-256 fingerprint if that has not been done, which reads
all 812 MB and can take a few seconds. It prints, for example:

```text
✓ supported on Mac Studio (darwin-arm64): Apple M4 Max, 16 cores (12 performance and 4 efficiency), 64 GB memory
  GPU: Metal, unless a local model (LM Studio, llama.cpp, Ollama, Inferencer) is configured — then CPU
✓ model present and verified — /Users/ana/.growther/classifier/models/decider-0.8b.Q8_0.gguf
  decider-0.8b-q8_0, 812 MB, context 4096
  sha256 2665d08c1052b4e01dabcb08771d25579f6776f7066355e4a0ccc5f74e32d4a2
```

The first line describes the machine as the card does, from the operating system's own
figures: its name where the system gives one, then the platform, processor, physical cores
and memory, for example
`✓ supported on linux-x64: AMD Ryzen 9 7950X, 16 cores, 31.1 GB usable memory`.

On Apple silicon the second line gives both possibilities, as above, because this command
does not read C5's settings and so cannot see which model providers are configured. The
**This Mac** line in **Settings › Learning** says which one applies (see
[GPU or CPU](#gpu-or-cpu)). Off Apple silicon, the second line says why it runs on the CPU,
and with how many threads, for example
`CPU: GPU acceleration is only used on Apple silicon (this is linux-x64). It uses 8 CPU threads.`

The model line can also say:

- `✗ <path> is a link whose file cannot be reached (a share that is not mounted?); it is used
  once it can be, and never downloaded over`
- `✗ <path> is not the pinned model (wrong size)` (or `sha256 mismatch`) —
  `growther classifier pull` replaces a file, but not a link: for a link, point it at the model
  or remove it.

It exits with `0` when the machine is supported and the model is verified, and `1` otherwise.

`pull` downloads the model now. It prints the model's notice, then — only once the first bytes
arrive — `Downloading decider-0.8b-q8_0 (~812 MB) to <path>…`, progress in 5% steps, and finally
`✓ downloaded and verified — <path>`. A pull that is refused, or finds the model already here,
prints no `Downloading` line. If the model is already here and checked, it says
`✓ already present and verified — <path>` and downloads nothing.

- It exits with `0` when the checked model is in place (downloaded now or already there) and
  `1` when it is refused or fails. The reason is printed on one line starting with `✗`.
- It does not check whether this machine can run the classifier. Run
  `growther classifier status` first: on an unsupported machine the model downloads but never
  loads.
- It works while the classifier is switched off, and while
  `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` is set: running it is your explicit request.
- It goes through the proxy and certificate authorities set for C5.
- It is refused when the Egress posture is **Offline**, and prints the address, folder and
  fingerprint to place the file by hand instead.
- It is refused when your organisation's policy locks the classifier off: _Your organisation's
  policy keeps the local classifier off, so its model is not downloaded._
- It resumes an unfinished download, and replaces a wrong file at the model's name once the new
  one is checked.
- It is refused when the model's path is a symbolic link whose file cannot be reached, or a
  link to a file that is not the model: C5 never downloads over a link. The message says what to
  do: make the file reachable, point the link at the model, or remove the link.
- If C5 itself is downloading the model at the same time, `pull` says another C5 process is
  downloading and stops; C5's download carries on.
- When the download fails, the `✗` line gives the cause itself (see [Network](#network)).

While the classifier is on, a running C5 starts using a model you pulled the next time
**Settings › Learning** is opened, or at its next start.

### `growther doctor`

[`growther doctor`](../cli/doctor.md#local-classifier) has a **Local classifier** row. Doctor
does not work out the model's fingerprint; it reads the record C5 keeps beside it.

| Result | What it means |
| --- | --- |
| OK — _not available here (optional): …_ | This machine cannot run it; the reason follows. |
| OK — _model not downloaded yet — it is fetched while the classifier is on (Settings › Learning), or by `growther classifier pull`_ | Normal on a new install. |
| OK — _model not downloaded — this install's network posture is offline, so C5 never downloads it._ | The Egress posture is Offline. Followed by the address, path and fingerprint to place it by hand. |
| OK — _model not downloaded — GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1, so C5 does not fetch it on its own._ | Run `growther classifier pull`, or place it by hand. |
| OK — _model verified — \<path\>_ | All good. |
| OK — _model present, not yet verified — \<path\>_ | The file is the right size but has not been checked yet. `growther classifier status` checks it. |
| Warning — _\<path\> is N bytes, not the pinned model's 811844032; it will not load_ | A wrong file. `growther classifier pull` replaces it (by hand when offline). If the path is a symbolic link, pull does not replace it: point the link at the model, or remove it. |

A missing model is never a failure: C5 works without it. Doctor does not tell a symbolic link
whose file cannot be reached from a missing model: both read _model not downloaded_.
`growther classifier status` tells you about the link.

## Log lines

C5 prints these lines to its own output:

| How C5 started | Where the lines are |
| --- | --- |
| From a terminal | In that terminal |
| At sign-in on macOS | `logs/service.out.log` in your C5 folder; warnings and errors in `logs/service.err.log` beside it |
| At sign-in on Linux, through systemd | In the journal: `journalctl --user -u growther-c5` |
| At sign-in on Windows, or from a Linux desktop's autostart | Not kept in a file. Use the card in **Settings › Learning** and `growther doctor` |

While the classifier is on, C5 may print:

| Line | Meaning |
| --- | --- |
| `[classifier] model download 40%` | The first download, in 10% steps. |
| `[classifier] local classifier connected` | It started when C5 started. |
| `[mcp] [classifier] model decider-0.8b-q8_0 loaded in 883 ms (metal, 8 threads, context 4096)` | The model loaded. |
| `[mcp] [classifier] model unloaded (idle for 10 minutes)` | Unloaded after 10 minutes without a question; it loads again when asked. |
| `[mcp] [classifier] …` (any other line) | The classifier's own process explaining why it could not load the model, or why it stopped. The **Runtime** line in Settings shows the same reason. |
| `[classifier] local classifier not started (no-model): …` | No model when C5 started; the reason and what to do follow. |
| `[classifier] local classifier not started (error): …` | It could not be started; the reason follows. |
| `[classifier] settings unreadable at boot: …` | C5 could not read the switch from its database when it started. This is not the same as off; C5 tries again when the policy next refreshes. Run `growther doctor`. |
| `[classifier] its settings could not be read (…); it is not asked until they can be` | The same kind of database fault, later on. |
| `[classifier] local classifier lifecycle failed: …` | An unexpected fault while starting or stopping it. C5 itself carries on. |
| `[classifier] site modes kept as stored: the audit trail no longer shows which were chosen, so none is taken for a default` | Once, after an update: C5 could not tell which kinds of decision someone had set, so it changed none of them (see [What it does at first](#what-it-does-at-first)). Check the modes in **Settings › Learning** if you want today's defaults. |
| `[classifier-drift] categories: assisted → shadow — …` | The nightly re-check moved that kind of question back to Shadow, for the reason given. Administrators also get a notification. |
| `[classifier-drift] Check was PARTIAL — …`, `[classifier-gate-history] Nightly pass was PARTIAL — …`, `[classifier-calibration] Fit was PARTIAL — …` | A nightly job could not finish every part of its work; the failures follow. It runs again the next night. |
| `[classifier-drift] Nightly check failed: …`, `[classifier-gate-history] Nightly pass failed: …`, `[classifier-calibration] Nightly fit failed: …` | A nightly job failed outright; the error follows. It runs again the next night. |
| `[classifier-decisions-retention] Prune was PARTIAL — …`, `[classifier-gate-history-retention] Prune was PARTIAL — …` | The nightly clean-up of old classifier records could not remove everything due; it tries again the next night. |

C5 prints no `[mcp] Connected …` line for the classifier. Switched off, or on a machine that
cannot run it, the classifier prints nothing.

## Troubleshooting

**The badge says _No model_ and the Model line says _Not downloaded: This deployment's network
posture is offline, …_**
The Egress posture (this is the "network posture" in the message) is Offline, so C5 will not
download it. Place the file by hand (see
[Offline and air-gapped installs](#offline-and-air-gapped-installs)), or ask whoever manages
**Settings › Enterprise › Network**.

**_Not downloaded: GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1: the model is not fetched automatically. …_**
Automatic downloads are turned off for this install. Run `growther classifier pull`, or place
the file by hand.

**_Not downloaded: Not downloaded on a CI runner._**
The `CI` environment variable is set in the environment C5 started in. Any non-empty value
counts, even `false` or `0`. On a build server this is intended: run
`growther classifier pull` if you want the model there. On any other machine, remove `CI`
from the environment C5 starts with (your shell profile, or C5's start-at-sign-in
definition; see [When C5 starts at sign-in](../cli/environment.md#when-c5-starts-at-sign-in)),
then restart C5.

**The badge says _Error_ and the Model line says _The download failed: Not enough free space to download the classifier model: it needs about N MB under …, and M MB are free. …_**
C5 did not start the download, because the disk could not hold it. Free some space in that
folder, then restart C5 or turn the classifier off and on.

**_The download failed: Could not write the classifier model to disk (…); the partial download was removed. …_**
The disk filled up during the download, and C5 removed the unfinished file to give the space
back. Free space in the folder named, then restart C5, turn the classifier off and on, or run
`growther classifier pull`.

**_The download failed: Could not download the classifier model (HTTP 403). …_ or _The download failed: Could not download the classifier model: \<reason\>. …_**
C5 could not reach Hugging Face. The reason is the network's own: the proxy that refused and
what it answered (a `407` wants credentials in the proxy URL), a certificate C5 does not trust
(add your proxy's root certificate to the CA bundle), a host that refused the connection, or a
proxy setting C5 cannot use (_C5 refused to connect to huggingface.co: the configured proxy …
cannot be used_ — fix or remove the proxy URL) — see
[When the proxy says no](../configuration/network.md#when-the-proxy-says-no). Otherwise check
your proxy, and that it allows the [Hugging Face hosts](#network). The message ends with the
address, path and fingerprint to place the file by hand. To retry, turn the classifier off and
on, or run `growther classifier pull`.

**_The download failed: The downloaded classifier model does not match its pinned sha256 (got …); nothing was installed._**
What arrived was not the model, often because a proxy changed or cut it. Nothing was kept. Try
again; if it repeats, download it by hand on another network and check its fingerprint
yourself.

**_The classifier model downloaded incompletely (N of M bytes); the next attempt resumes it._**
The connection dropped. The next attempt carries on from where it stopped.

**The Model line says _Already attempted in this process; restart C5 or run `growther classifier pull` to try again._**
The download at start failed and C5 does not retry it until the next start. Turning the
classifier off and on also retries it.

**The badge says _Waiting_: _Another C5 process … is downloading the classifier model; it is used once that finishes._**
Usually `growther classifier pull` in a terminal. Let it finish. A download left behind by a
process that crashed does not block C5: it notices the process is gone and takes over.

**The Model line says _… its checksum has not been verified yet._ and the badge says _Not running_**
A file of the model's exact size is at its name, but C5 has not checked its fingerprint yet.
Nothing loads an unchecked file. Run `growther classifier status` to check it now; if it is
not the model, the line then says so (next entry).

**The Model line says _The file at the model's path is not the model (…), so C5 does not use it._**
Something else is at the model's name: a copy that failed or is still in progress, another
file, or a file whose fingerprint C5 found wrong. C5 never loads it, and never deletes or
renames it on its own. The rest of the line says what happens next and what you can do:

- _Only a verified download replaces it._ — the classifier is on and this machine downloads:
  the next download that passes its check takes the file's place.
- _Turning the classifier on downloads the model over it._ — the classifier is off; once on,
  this machine downloads the model in the file's place.
- _It is not replaced by a download here: …_ — Offline, opted out, or short of disk: delete it
  and copy the right file in (see [Offline and air-gapped installs](#offline-and-air-gapped-installs)).
- _C5 never downloads over a link._ — the model's path is a link to the wrong file: point it at
  the model, or remove it.

An administrator at the machine can delete it with **Delete the file (N MB)** while the
classifier is off, or **Turn off and delete the file** while it is on. Anyone else is told that
an administrator at this machine can do it.

**The Model line says _The model's path is a link whose file cannot be reached (a share that is not mounted?). …_**
The model's name is a symbolic link, and the file it points to is not there right now. C5 does
not download over the link: it uses the model as soon as that file can be reached. Mount the
share (or restore the file), or remove the link if you would rather C5 fetched its own copy. The
badge reads **No model** meanwhile, and turning the classifier on offers **Turn on**, not
**Download and turn on**.

**The Runtime line says _Not running: the model is not on this machine._**
The **Model** line above it says why nothing was downloaded (Offline, opted out, a CI runner,
or a link whose file cannot be reached); follow that line.

**A kind of decision says _Sampling 1 in 4 on this machine: …_**
Normal on a machine where the classifier runs on the CPU, or is marked slow. See
[On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu). There is
nothing to fix.

**_Restarting on the CPU: this Mac has no Metal device the classifier can use._**
Normal on a virtual machine without GPU access. C5 moves it to the CPU by itself.

**_Paused after repeated failures; the current answers stand alone meanwhile._**
Three questions in a row failed. C5 rests the classifier for 60 seconds, tries one question,
and carries on if it succeeds. If it keeps happening, check the **Runtime** line and run
`growther doctor`.

**I cannot choose Assisted or Authoritative.**
The option says why. Usually one of these:

- It is a setting other than **Task categories**. Those offer only Off and Shadow.
- The promotion gate has not passed. Its line names each part that has not. Keep answering in
  **Teach the classifier**. An administrator on the machine running C5 can raise it anyway,
  after a warning; from a paired device they cannot.
- No calibration is fitted yet. C5 fits one at 23:50 once there are enough labels, or an
  administrator can press **Fit calibration now**.

If you can choose it but the line reads _Set to Assisted, but not running: this machine is too
slow …_, see [Slow machines](#slow-machines). On Windows this lasts until the model's first
timing.

**The switch is greyed out.**
Hover or tap it. _Changing this needs permission to edit settings._ means you need that
permission. _This machine cannot run the local classifier._ means the machine is unsupported.
A **Managed** lock means your organisation's policy decides.

**There is no Delete button.**
Deleting is for administrators on the machine running C5, never from a paired device, and not
while your organisation's policy keeps the classifier on. While the classifier is on, delete it
through the switch: **Turn off and delete the model**. A link whose file cannot be reached
leaves nothing on this machine to delete: remove the link by hand if you no longer want it.

**Moving the cache.**
`growther cache relocate` refuses while C5 is running (run `growther stop` first), and while
another process, such as `growther classifier pull`, is downloading the model. Start C5 again
after the move. If the classifier is on, it starts from the new location.

**_Not running: The classifier's model is being deleted._**
A delete is in progress. It ends in seconds.

## Related

- [Memory search](memory-search.md) — the other models C5 downloads, for semantic search
- [Network and egress](../configuration/network.md) — the Egress posture, proxies and every host C5 contacts
- [Managed configuration](../configuration/enterprise-policy.md) — locking `classifier_enabled` across a fleet
- [Running doctor](../cli/doctor.md) — every check, and how to read the results
- [Environment variables](../cli/environment.md) — `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD` and `GROWTHER_CACHE_DIR`
