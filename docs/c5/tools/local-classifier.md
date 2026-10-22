---
title: Classifier
description: How C5 answers its own routine questions with a small model — the built-in one it downloads and runs on your machine, or one you choose from your providers. What it downloads, what it records, what it sends where, when it starts to act, how to turn it off or delete it, and what to do when it cannot run.
order: 6
---

# Classifier

While it works, C5 keeps asking itself small questions with a fixed set of answers: which
categories a new task belongs to, which skill area a step draws on, whether a repeating error
is just noise. Normally each of those questions goes to one of the AI models you configured.
In the rest of this page, **the usual model** means that model: the one C5 would ask without
the classifier. Settings also calls it the **teacher model**, because the classifier is
measured against it.

The **classifier** answers the same kind of question with a small model that picks from the
fixed answers directly instead of writing a reply. It can use two kinds of model:

- **The built-in model**, also called the **local classifier**: **decider-0.8b**, which C5
  downloads once and runs on your own machine. An answer takes a fraction of a second and
  costs nothing: no provider, no account, no tokens. It is on by default.
- **A model from your providers**: a model that one of the model providers you set up in
  **Settings › Integrations** serves, which an administrator chooses. None is chosen by
  default. See [A model from your providers](#a-model-from-your-providers).

The built-in model runs in a process of its own, apart from C5's server, so if it crashes C5
carries on. C5 never depends on the classifier: whenever it is off, busy, slow, unsure or
broken, C5 asks the usual model, exactly as before.

The section in **Settings › Learning** is called **Classifier**. Before C5 could use a model
from your providers it was called **Local Classifier**, and this page was called _Local
classifier_; its address has not changed. Outside the section on
[a model from your providers](#a-model-from-your-providers), **the classifier** on this page
means the built-in model.

**In short:**

- You do not need to do anything. C5 downloads the model (about 812 MB) once, and at first
  only records the classifier's answers beside the usual ones, for every kind of decision.
- Want a model you already run to answer instead — on llama.cpp, Ollama, LM Studio, vLLM or a
  cloud API? An administrator can choose one; see
  [A model from your providers](#a-model-from-your-providers).
- On a machine where it runs on the CPU, it records only one in four Step quality questions,
  so it stays out of your agents' way; see
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

The built-in model uses none of your providers and none of your accounts. What it gains from
your install is evidence: it records its answers beside the usual ones, C5 measures them against
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
2. On the **Classifier** card, flip the **Built-in model** switch off. It is in the
   **Built-in model** row, under **Classifier models**.
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

Turned off, the built-in model is completely quiet. C5 does not start its process, load the
model, download anything, run its nightly jobs or print anything about it in the log.

**With a model from your providers chosen**, the question is **Turn off the built-in
model?**, and it says who answers once it is off. While the chosen model answers: _M keeps
answering. With the built-in model off, nothing stands behind it: if M stops answering, C5
answers those questions as it did before._ While the chosen model is turned off, or cannot
be asked now, it says that once the built-in model is off nothing answers C5's routine
questions, and C5 answers them as it did before. It also names any kind of decision that
only the built-in model answers (Tool-call safety, beside a model that is not on this
machine), where turning it off ends the classifier, and any kind that acts on the built-in
model's record, where acting ends and the chosen model's answers are only recorded. Its
delete button reads **Turn off and delete the built-in model**. See
[Who answers](#who-answers).

You can also reach the same question from the **Terms** dialog: **Turn off the local
classifier…** (**Turn off the built-in model…** while a model from your providers is chosen).

## Turn it back on

Flip the switch on again.

- If the checked model is already here, or the model's path is a symbolic link to the checked
  model, it turns on at once.
- If the model is missing, partly downloaded, or not yet checked, C5 asks first:
  **Turn on the local classifier?** The dialog shows the model, its size, its licence and its
  notice. **Download and turn on** turns it on and starts the download; **Cancel** leaves it off.
- If a file is at the model's path but C5 already knows it is not the model, the dialog says
  so, and that C5 downloads the model and replaces that file.
- With a [model from your providers](#a-model-from-your-providers) in use, the dialog adds
  _M stays first; the built-in model answers when it cannot._, or, with
  [Use as fallback](#use-as-fallback) off, _M stays first; with Use as fallback off, the
  built-in model does not answer in its place._
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
or **Authoritative** for you. With the built-in model switched off and no model from your
providers in use, none of them is asked, whatever its mode says.

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

**Step quality** is asked as often as C5 works, once for each step that is graded, and it
arrives in bursts: a busy install can grade 20 or 30 steps in one minute. On an Apple-silicon
Mac's GPU, one answer takes a fraction of a second. On a CPU it takes a second or more, on the
same cores your agents' builds, tests and local models use.

So on a machine where the classifier runs on the CPU (see [GPU or CPU](#gpu-or-cpu)), or is
marked slow (see [Slow machines](#slow-machines)), Step quality records only **one question
in four** while it is in Shadow:

- **The question decides, not the timing.** Whether a question is recorded depends on the
  question itself, so the same question is always recorded, or never. A label you give later
  always finds the classifier's answer beside it, and **Teach the classifier** only asks about
  recorded questions.
- **A step outside the sample leaves nothing in the classifier's records**: neither the
  classifier's grade nor the copy of C5's usual grade it is compared with. C5 still grades
  the step and uses that grade exactly as before. Only the comparison record is skipped.
- **Every other kind is recorded every time, on every machine.** That includes **Tool-call
  safety**, asked once for each tool call the guardian checks, and **Skill routing**, asked
  once for each specialist step. Task categories and Alert triage are asked far less often.
  A kind set to **Assisted** or **Authoritative** is never sampled either.
- **There is nothing to set.** It applies on its own, and the **Last 7 days** count of Step
  quality is about a quarter of what it would otherwise be.

Under Step quality, the card says so:

> Sampling 1 in 4 on this machine: the local classifier runs on this machine's CPU, so it
> records only one in 4 of these questions, always the same ones, to keep the rest of C5 fast.

On a slow machine the reason reads _the local classifier answers slowly on this machine_
instead.

### When the classifier is busy

The classifier answers one question at a time. So C5 asks it only one background question
at once — a question for a kind in **Shadow**, whose answer is only recorded — and starts
none while it is waiting on the classifier for an answer it will use. Questions C5 is
waiting on never queue behind a backlog of background ones.

A background question that finds the classifier busy **waits for its turn** instead of
being dropped, first come, first asked. So a burst of work still records every question
chosen for recording (for Step quality on a CPU or a slow machine, the one in four above).
Up to 32 can wait, each for up to a minute. One that arrives when 32 are already waiting, or
that waits longer than a minute, is given up and not recorded. Giving up is never counted as a
failure, so it never pauses the classifier. A question that waited is checked again before
it is asked: if the classifier, or that kind of decision, was switched off meanwhile, it
asks nothing and records nothing.

A question C5 is waiting on gets at most 1.5 seconds. One that arrives while a background
question is being answered waits for it to finish, because an answer in progress is not
interrupted, so on a slow processor it can run out of time. That counts as a time-out, not
a failure, and C5 uses the usual model's answer.

In the **Classifier** tab under **Ops**, background questions given up after a minute's
wait are counted as _Shed after a minute's wait_. Those turned away because 32 were
already waiting are counted under _Skipped: busy_.

## When it starts to act

Only **Task categories** can be raised to **Assisted** or **Authoritative**, and only after the
classifier has been measured on your own install. The other four offer only Off and Shadow.

The measurement is called the **promotion gate**. It compares the classifier's recorded
answers with the usual model's, and with the answers people gave when they corrected or
labelled tasks.

**It counts the last 200 labelled answers, up to 180 days back.** A labelled answer is a
question both the classifier and the usual model answered, and a person or an outcome
labelled. When the last 30 days hold 200 of them, the gate measures those 30 days; otherwise
it reaches back as far as it takes to hold 200, but never past 180 days. Only the answers of
the model answering now count, so a model new to C5 starts from none. The nightly re-check
and the calibration fit read the same window, and **Teach the classifier** asks about task
categories up to 180 days old for the same reason.

Its line in Settings says when it was measured and over what, for example _Promotion gate:
not enough evidence yet (12 labelled states), measured at 14:05 over the last 180 days._
Until a kind has its 200 labelled answers, the parts that cannot be judged yet are one line,
_Needs 200 labelled answers before its accuracy can be judged; has 12._, followed by how
long the 200 take at the pace of the last 30 days:

- _At the current rate (60 labelled in the last 30 days): about 70 days._
- _At the current rate: never — 25 new answers came in over the last 30 days, and 180 days
  at that pace hold 150, however many are labelled._ Here labelling cannot help: the kind
  gets too few questions for 200 to fit in 180 days.
- _At the current rate: never — none were labelled in the last 30 days._

A part that failed, Speed included, is still listed beside that line. Once there are 200,
the line shows each part that has not passed yet: **Labels**, **Accuracy against your
labels**, **Telling cases apart**, **Agreement with the teacher model**, **Calibration**,
**Confident answers** and **Speed**.

**Telling cases apart** does not compare the classifier with the usual model. It checks
that the classifier's answer actually changes when the right answer changes. A classifier
that gives much the same answer every time fails it, even if the usual model does no
better. For task categories each category is checked on its own, so a classifier that gives
each category the same confidence on every task fails too.

It is measured only on answers that people's labels show to be the correct answer in at
least 10 separate tasks (or runs), and not the correct answer in at least 10, whatever the
classifier itself said. Until at least one answer has that many labels, this part reads
_not enough data_ rather than passing, because a handful of tasks would decide it by
chance. Labelling more tasks, in **Teach the classifier** or by correcting the categories C5
gave a task, fixes that.

- **Assisted** and **Authoritative** can be chosen only once the gate has passed, and once a
  **calibration** has been fitted for that kind of decision. A calibration is the adjustment
  that turns the classifier's raw confidence into a measured one. C5 fits it itself, every night
  at 23:50, from the labelled answers, once there are enough of them.
- C5 keeps a calibration only if it is useful: once calibrated, the classifier's answers
  must get clearly different confidences, and higher confidence must go with more right
  answers, not fewer. A fit that fails this is not stored, and the **Calibration** line
  under that kind says why. A calibration stored by an earlier version is checked the same
  way, against the answers the classifier gives now. If it fails, the kind cannot be raised
  on it, and a kind already acting on it stops acting at its next fit (nightly, or
  **Fit calibration now**) and is fitted again.
- Nothing raises the classifier for you. Someone with permission to change settings chooses the
  mode.
- Even when raised, it acts only at the confidence level its gate measured, only on answers
  from the model the gate measured, and only on answers calibrated the way the gate measured
  them. Below that level, the usual model answers.
- Every night C5 re-checks each kind of decision that acts. It moves it back to **Shadow**, and
  sends administrators a notification, **Local classifier: … moved back to shadow**, saying
  why, when:
  - its gate now fails. This includes **Telling cases apart**, which v322 and earlier did
    not measure: a kind raised before the update is moved back the first night after it if
    its answers do not tell cases apart;
  - the classifier now answers as a different model;
  - the calibration its confidence level was measured on has been replaced; or
  - its calibration error has more than doubled since it was raised.
- If the gate only lacks enough new evidence, it keeps acting for up to 60 days after its
  last verification: a night it passed on something answered or labelled since the one
  before. Because the window reaches back for its 200 answers, a kind nobody labels any more
  would otherwise pass every night on the answers it was raised on; a pass on nothing new
  counts as too little evidence. Administrators are told that its evidence is thin (**Local
  classifier: … is acting on evidence from …**), and after the 60 days it goes back to
  Shadow. Answering its questions in **Teach the classifier** re-checks it.
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

The answers people give are what the gate measures. While some model answers the
classifier's questions — the built-in model, or a
[model from your providers](#a-model-from-your-providers) that C5 asks — and has something
to ask, administrators see a **Teach the classifier** tab in the **HITL: Human-in-the-Loop
Signoffs** window, which opens from the HITL (clipboard) button in the sidebar (see
[Human review (HITL)](../using-c5/hitl.md)). It is never shown on a paired device, and the
account needs a second factor, unless the install was set up without any sign-in. What
counts is the administrator role, not where the browser runs: on an install bound beyond
this machine (`GROWTHER_BIND_HOST`), an administrator signed in from another computer sees
it too. It shows a task's categories to confirm, or a step's output to rate. It never shows
what the classifier answered, so your answer cannot lean towards it.

You need not open the window to find out whether anything is asked. A small grey count on
the lower corner of the HITL button says how many questions are waiting here and in
**Guardian blocks**. It is never added to the button's own count and never plays a sound:
these questions hold up no work. It is shown only to administrators, never on a paired
device, and is hidden while no model answers. See
[Opening it](../using-c5/hitl.md#opening-it).

Three other actions count as answers too:

- **Changing the categories C5 gave a task**, a task one of your schedules created included.
- **A verdict in Guardian blocks**, for tool-call safety. **Confirm block** says the
  guardian was right to refuse the call; **Dismiss** says it was a false alarm. These are
  the only answers people give tool-call safety there, and they cover only calls the
  guardian blocked (see [Guardian blocks](../using-c5/hitl.md#guardian-blocks)).
- **Muting or unmuting an alert**, for alert triage. The **Auto-Suppression Ledger**, in the
  **Errors** tab of the same HITL window, has **Mute Noise** and **Unmute** beside each
  repeating error. Muting says "this is noise, hide it"; unmuting says "this should not have
  been hidden". Only your latest act on an alert counts: unmuting takes back an earlier mute,
  and the other way round. It counts for an alert C5 triaged while Alert triage was recording.
  An alert the Sense-Maker (C5's own alert triage) suppresses by itself is not an answer.

Because both kinds of answer can arrive, alert triage can be measured and calibrated like
the others.

## A model from your providers

An administrator can choose a model that one of your model providers serves — a llama.cpp or
Ollama server on this machine, LM Studio, vLLM, or a cloud API — to answer the classifier's
questions, asked before the built-in model. None is chosen by default, and nothing changes
until someone chooses one. C5 does not download such a model: it asks it where your provider
serves it, as set up in **Settings › Integrations**.

### Who answers

**By default C5 uses the built-in model.** Once an administrator chooses a model from your
providers, C5 asks that model first. What answers when it cannot depends on two switches on
the built-in model's panel:

- **The built-in model on, and Use as fallback on** (the default): the built-in model
  answers whenever the chosen model cannot.
- **The built-in model on, and Use as fallback off**: nothing answers in the chosen model's
  place, and C5 uses its usual checks. The built-in model still answers what the chosen
  model is not asked (below). See [Use as fallback](#use-as-fallback).
- **The built-in model off** — for example because its notice does not fit your use: the
  chosen model is the only one asked. Whenever it cannot answer, no classifier answers, and
  C5 answers those questions as it did before.

The card says which, under both panels, in these words (M is the model's name):

| The built-in model | The chosen model answers | The chosen model cannot be asked now |
| --- | --- | --- |
| On | _C5 asks M first. If it stops answering, the built-in model answers._ | _Using the built-in model while M is unavailable._ |
| On, with **Use as fallback** off | _C5 asks M first. If it stops answering, nothing answers in its place, and C5 uses its usual checks._ | _Nothing answers in place of M while it is unavailable, and C5 uses its usual checks._ |
| Off | _C5 asks only M. If it stops answering, no classifier answers, and C5 answers as it did before._ | _No classifier while M is unavailable. C5 answers as it did before._ |

Where the built-in model answers a kind of decision that the chosen model is not asked, the
line names it, for example _Tool-call safety is answered only by the built-in model._

"Cannot be asked now" covers a model that is not loaded, is busy, does not answer, is paused
after repeated failures, is refused by a policy or by **Models allowed from**, or whose
provider is turned off in **Settings › Integrations**. A chosen model waiting for a test
reads _… until M passes its test again_, and one that has changed since its test _… until M is
chosen again_. On a machine that cannot run the built-in model, the line reads _C5 asks only
M: the built-in model cannot run here. …_

A chosen model you [turned off](#turn-the-chosen-model-off-for-a-while) reads _Using the
built-in model while M is turned off._ (or _No classifier while M is turned off. C5 answers
as it did before._ with the built-in model off). It is not asked at all, and the built-in
model answers as it does with nothing chosen.

The chosen model is not asked everything:

- **Tool-call safety stays on this machine.** Whether a tool call is safe is asked only of a
  model C5 can show runs on this machine — an address on this machine is not enough, because
  a program there can pass questions on to another computer. Any other model is never sent
  those questions: the built-in model answers them while it is on, and C5's usual checks
  decide either way, as before. Beside such a model, Tool-call safety reads _Tool-call safety
  stays on this machine, so M is not asked it._

  **One gap: llama.cpp's `--rpc`.** A llama.cpp server can hand part of its model to RPC
  servers on other computers (`--rpc host:port`), which then work on what is derived from
  each question. A llama.cpp router lists each model's `--rpc`, and C5 reads it: RPC servers
  on this machine still count as this machine, one on your network makes the model **Your
  network**, and one further away makes it **Online**. But a single-model llama.cpp server
  started with `--rpc`, or a router's model given its RPC servers through `LLAMA_ARG_RPC` in
  its environment, does not show it anywhere C5 can read, so C5 counts it as **This
  machine** and asks it Tool-call safety too. If you offload a model that way, do not choose
  it, or keep its RPC servers on this machine. (Only a llama.cpp build with RPC support
  accepts `--rpc`; Homebrew's 0.6.0 refuses it.)
- **Questions with more choices than the model can read.** Some models read only a few
  choices per question (10 for LM Studio, for example, and fewer for some cloud providers).
  Skill routing offers one choice for every skill area you have turned on — 11 on a new
  install — so such a model is not asked it. The card says why beside it, and the built-in
  model answers it.

### Choose a model

Only an administrator at the machine running C5 can choose or test a model — the same people
who can [delete the built-in model](#delete-the-model), never from a device paired through
Remote Control.

1. Make sure the provider is turned on in **Settings › Integrations**. If it runs the model
   on your machine or network, load the model there first: C5 never loads a model itself.
2. In **Settings › Learning**, on the **Classifier** card, under **A model from your
   providers**, choose **Choose a model…** (**Change…** once one is chosen).
3. Pick a model. The list has one group for each provider you turned on, in the same order
   as the cards in Integrations, and a search box. A group's heading says where its models
   run (_On this machine_, _At this machine's address_, _Your network_ or _Online_). A provider
   C5 cannot ask, or a model it cannot use here, says why.
4. For a model on this machine, choose **Test and use**. For a model on your network or
   online, choose **Next**: C5 first shows where it runs and what it would send there, and
   asks you to confirm (see [Before a model off this machine is asked](#before-a-model-off-this-machine-is-asked)).
5. C5 tests the model, which can take up to a minute and a half. If it passes, it is in use
   at once, and a message says where it starts.

**The test.** The model must answer C5's test questions in a way the classifier can read: it
must return, for each answer it could give, how likely it thinks that answer is. The list
shows the result of a model's last test beside it:

| Badge | The card then says | What happens |
| --- | --- | --- |
| **Worked** | _Tested <day>: it answers the classifier's questions._, then what the test found, for example _11 of its 26 top answers differed from the built-in model's (the largest difference in a probability was 1.00)._ | A model made for this kind of decision, or the built-in model's own weights served by your provider. It is used. |
| **Experimental** | _Tested <day>: it answers, but it is a general model, so expect it to stay in Shadow._ | It is used; see [Experimental models](#experimental-models). |
| **Did not work** | _Tested <day>: it cannot answer the classifier's questions._ and the reason, for example that the model gives no probabilities | Nothing is chosen, and nothing changes. |

**The test does not check that the answers are right.** It checks that C5 can read them, and
compares them with the built-in model's answers to the same questions. A model trained for
decisions elsewhere can differ from the built-in model on many and still be chosen. Whether
its answers are right is what its own [promotion gate](#when-it-starts-to-act) measures, on
your install's labels.

A test that could not judge the model — it was not loaded, its provider did not answer —
changes nothing either, and says so: _M is not loaded in P. C5 never loads a model itself;
load it there and try again. Nothing was changed._

C5 tests a model only when an administrator chooses it or presses **Test again** on its
panel, never on a schedule. A model that has changed since its test — new weights at the
same name, or a provider moved to another address — is not asked until it is chosen again,
which tests it again.

### What each provider needs

| Provider | Where C5 counts it as running | What it needs |
| --- | --- | --- |
| **llama.cpp** | On this machine when its server says it runs the model here (a server that hands part of the model to other computers with `--rpc` may not say so; see [Who answers](#who-answers)); otherwise your network, or online, by its address | The model loaded, with at least 4,096 tokens of context. A server that applies a LoRA adapter is refused |
| **Ollama** | On this machine for a model Ollama runs here (never a cloud model); otherwise your network, or online, by its address | Ollama 0.12.11 or newer, with the model loaded. C5 never changes how long Ollama keeps a model loaded, but its questions do reset the model's idle timer. Ollama's cloud models cannot be chosen: Ollama passes them on to its own servers |
| **LM Studio** | Never on this machine: your network, even at this machine's address, because LM Studio can serve a model that runs on another device and cannot show C5 where it runs. At an address outside your network, online | LM Studio 0.4.0 or newer, with the model loaded with at least 4,096 tokens of context, and its reasoning switched off. C5 asks only a model LM Studio lists as loaded, so it never makes LM Studio load or swap a model |
| **vLLM** | Never on this machine: your network, even at this machine's address. At an address outside your network, online | vLLM 0.26.0 or newer, entered as the address on the **llama.cpp** card. Its model needs at least 4,096 tokens of context |
| **OpenAI**, **MS Azure**, **OpenRouter**, **DeepSeek**, **xAI Grok**, **Alibaba Cloud Qwen**, **Moonshot Kimi**, **Meta**, **Google Gemini** | Online | A key set up in Integrations, and a model that returns probabilities for its answers. Each question is billed; see [Models your provider bills](#models-your-provider-bills) |
| **Anthropic**, **Groq**, **Mistral**, **Cohere**, **Amazon Bedrock** | — | Cannot be used: their APIs do not return the probabilities the classifier reads. The list says why for each |
| **OpenClaw**, **PicoClaw**, **Hermes Agent** | — | Not listed. They pass each question to an agent, which may hand it to any model. Choose the model they use from that model's own provider instead |
| **Hugging Face \| Inferencer** | — | Not yet: C5 cannot read the probabilities it needs from it |

**Models allowed from** decides which of these places a model may run; see below.

### Models allowed from

**Models allowed from**, on the **A model from your providers** panel, says how far away a
model may run:

| Choice | Lets C5 ask |
| --- | --- |
| **This machine** (the default) | Only a model C5 can show runs on this machine |
| **Your network** | Also a model on another computer on your network, and LM Studio or vLLM |
| **Anywhere** | Also a cloud provider's models |

Under it, the card always reminds you: _LM Studio counts as Your network: C5 cannot show that
a model it serves runs on this machine._ and _Widening this does not skip your confirmation:
C5 still asks you before it sends questions to each model that is not on this machine._

- **Who can change it.** An administrator at the machine. A paired device, or an account that
  is not an administrator, sees it with the reason it cannot be changed. An administrator
  without a second factor is refused and told how to add one; **Models allowed from**,
  **Choose a model…** and **Test again** then stay unavailable until the page is opened
  again, because each refused attempt is a critical entry in the audit log.
- **In the list.** A model the setting does not reach says what to change, for example
  _C5 cannot tell that it runs on this machine, and Models allowed from is This machine: set
  it to Your network on the Classifier card to choose it._, or _Runs online through OpenAI,
  and Models allowed from is Your network: set it to Anywhere on the Classifier card to choose
  it._
- **Narrowing it** stops C5 asking a chosen model that is now too far away. Its panel reads
  _Not used._ with the reason, and the built-in model answers while it is on and
  [Use as fallback](#use-as-fallback) is on.
- **Your organisation's policy** comes first. A policy that locks
  `classifier_external_allowed` shows the setting locked, with the reason and where the
  policy is set; locked to `off`, it reads _Your organisation's policy does not allow a
  model from your providers here._ A value the policy only recommends is the default an
  administrator may change. `off` is a value only a policy can give: whether locked or only
  recommended, the setting then shows a fourth choice, **Off — set by your organisation**.
  Recommended, it reads _Models allowed from is Off, so C5 asks no model from your providers
  here: choose where they may run on the Classifier card._, and an administrator at the
  machine can still choose **This machine**, **Your network** or **Anywhere**, after which
  **Off** is gone. See
  [Classifier models from your providers](../configuration/enterprise-policy.md#classifier-models-from-your-providers).

### Before a model off this machine is asked

A model on your network or online is sent none of your work until an administrator at the
machine has confirmed it. To find out where a model runs, C5 only reads what its provider
says about itself, with read-only requests (LM Studio's list of models, Ollama's version
and model list, llama.cpp's properties and health); no test question is sent before you
confirm. After **Next** (or, if those reads show that the model is not on this machine,
after **Test and use**), C5 shows **Send these questions to another machine?**:

- **Where it runs**, for example _M runs at 192.168.1.20:8080, not on this machine._, _M runs
  online at api.openai.com, not on this machine._, or, for a program at this machine's address
  such as LM Studio, _M is served at localhost:1234, an address on this machine, but C5 cannot
  tell whether the program there runs it here or passes the questions on to another machine._
- **What it would be sent**: _C5 would send it the questions it asks itself while it works:
  the goal of each new task, the output of steps it grades, and error messages and logs it
  triages. Tool-call safety questions are never sent there; they stay on this machine._ Where
  the model is asked skill routing, those questions also carry the step a specialist is about
  to take.
- **The part of the Terms that covers it**: the paragraph of Section 14 about a provider's
  model, word for word.
- For a model your provider bills, **what its test costs** (below).

Tick _I have read Section 14 and want C5 to send these questions to H._ (H is the model's
address) and choose **Allow and test**. **Back** returns to the list with your choice kept.

The confirmation is for that address. A model at another address asks again. The Terms
dialog then shows the chosen model and when you allowed it, for example _M through LM
Studio, at localhost:1234. You allowed this on 2026-11-02 under Terms v1.10._

Those questions then go from your machine to that provider like any other work you send it,
under your agreement with the provider. They do not go through Growther.si.

### Models your provider bills

The cloud providers bill your account for each question C5 asks their models, the test's
included. So C5 says what a test costs before anything is sent:

- Under the provider's group in the list: _P bills your account for each question C5 asks its
  models, a test's included; C5 says what a test costs before sending it._
- In the confirmation, with where the model runs: _Testing M sends N questions (about T
  tokens) to H, which P bills to your account (about $0.02). Once it is in use, P bills each
  question C5 asks it._ If **Settings › Budget** has no price for the model, the line ends
  _…; Settings › Budget has no price for it, so C5 counts them at $0 until you add one_.
  **Allow and test** confirms the cost and the confirmation together.
- **Test again** asks first as well: **Test M again?**, with the same line, and **Test it**.

Once a billed model is in use:

- C5 adds what each question costs to **Settings › Budget**, beside your other spending.
- While your global cost cap is reached and set to block, C5 asks the model nothing. The
  built-in model answers meanwhile, if it is on and [Use as fallback](#use-as-fallback) is
  on.
- Every question to OpenRouter carries the routing limits you set on OpenRouter's **Config**
  tab in Settings — data collection, the providers allowed, ignored or preferred,
  quantizations and price caps, never its fallback models (see
  [OpenRouter routing settings](../configuration/model-providers.md#what-the-classifiers-questions-carry))
  — and asks OpenRouter to use only a provider that returns the probabilities. If C5 cannot
  read those limits, it asks OpenRouter nothing they might rule out. A model tested by an
  earlier version keeps that version's note, which names **Settings › Integrations ›
  OpenRouter**, until it is tested again.
- A name the provider moves to another model by itself cannot be chosen — one ending in
  `latest`, `openrouter/auto`, or a name starting with `~`: _choose a dated or versioned model
  instead_.

Not every cloud model returns the probabilities the classifier reads, and the list says so
where a provider's own documentation leaves it open: xAI ignores the request on grok-4.20 and
newer models, Moonshot Kimi and Meta do not document it, and Google no longer returns them
for most Gemini models. A test of a model that does not return them ends after its first
question, so it costs one question.

### Experimental models

A general model — one not made for this kind of decision — can still answer. Its test reads
_it answers, but it is a general model, so expect it to stay in Shadow_, and the list marks
it **Experimental**. Every model C5 asks through a chat is one of these: every LM Studio
model and every cloud model.

An experimental model is used like any other. It records its answers in Shadow, and acts on a
kind of decision only if its own promotion gate passes on your install, which a general
model rarely does. Choosing one does not stop the built-in model acting: until the chosen
model's own gate passes, the built-in model's record keeps acting wherever it had been allowed
to act, while the built-in model is on.

### How a chosen model earns its place

Every answer is recorded under the model that gave it. Each model has its own
[promotion gate](#when-it-starts-to-act), calibration and record for each kind of decision:
the chosen model is never measured on the built-in model's answers, nor the other way round.

- **A model new to C5 starts in Shadow** on every kind of decision, from no answers of its
  own. Its gate line adds _It started from no answers when you chose it, so this takes as
  long as collecting labels does._ One of the last three models chosen picks up its own
  records again.
- **Each kind of decision says whose answers count.** Beside a chosen model, its row says who
  is asked now (_Asked: M._ or _Asked: the built-in model._, and why not, where the chosen
  model is not), then M's gate (_M — Promotion gate: …_), then the built-in model's while it
  is on (_Built-in model — Promotion gate: …_). Where the built-in model's record acts and M is
  still being measured, it reads _Acts on the built-in model's answers; M's are recorded
  beside them until its own gate passes._
- **Raising a kind** into Assisted or Authoritative is judged on the gate of the model the
  raise is for: the chosen model's, wherever it is asked that kind. So a kind acts on the
  chosen model's answers only once that model has been measured, however well the built-in
  model did.
- **Act on M's answers** moves a kind that already acts onto the chosen model's own record,
  once that model's gate has passed on a fitted calibration. Nothing stops acting in
  between. If the gate refuses, the kind says _Not acting on M's answers: …_
- **Fit calibration now** is offered once per model, each named for whose calibration it
  fits (… _on M_, … _on the built-in model_), to an administrator at the machine.
- **Teach the classifier** stays available while C5 asks the chosen model, even with the
  built-in model off: then the answers you give there are what the chosen model is measured
  against.

### Turn the chosen model off for a while

The chosen model's panel has a switch of its own, at its top right. Turned off, the model
stays chosen, with its test and its records, but C5 asks it nothing until it is turned on
again. Meanwhile the built-in model answers as it does with nothing chosen, while it is on.

1. Flip the switch off. A small box under it asks **Turn off M?** and says what happens:
   _The built-in model answers instead._ (or _Nothing answers; C5 uses its usual checks._
   while the built-in model is off or cannot run here), then _C5 keeps it chosen, with its
   test and its records; turn it on again to use it._
2. Choose **Turn off**. **Cancel**, where the focus starts, or Escape leaves it on.

While it is off, its panel reads _Turned off. C5 keeps it chosen, with its test and its
records, and asks it nothing until it is turned on again._, followed by what answers
meanwhile. The header's badge is then the built-in model's own, and the **Primary** tag and
**Use as fallback** are not shown.

**Who can.** Turning it off is open to anyone who may change settings, from a paired device
too. Turning it on is for an administrator at the machine running C5, with a second factor,
as for choosing a model; anyone else sees why beside the switch, for example _Only an
administrator can turn on the classifier's model._

**Turning it on checks it again.** One click turns it on, and C5 first judges it as it would
a model being chosen: the Terms, your organisation's policy (and the providers and models it
allows), **Models allowed from**, its provider turned on in **Settings › Integrations**, a
passing test, your confirmation for a model off this machine, and whether it has changed
since its test. If anything fails, it stays off, and a message says why:

| The message says | What to do |
| --- | --- |
| _Could not turn on M: M has no passing test kept, so C5 does not ask it: …_ | Choose it again with **Change…**, which tests it and turns it on |
| _Could not turn on M: M has changed since it was tested: …_, or _… M's provider is set up at another address than the one it was tested at, …_ | Choose it again with **Change…** to test it again |
| _Could not turn on M: C5 has no consent of yours, under the Terms in force, to send the classifier's questions to M: …_ | Choose it again, and confirm where it runs |
| _Could not turn on M: Models allowed from is set to …, and this one runs …_ | Widen **Models allowed from**, or choose another model |
| _Could not turn on M: Your organisation's policy …_ | Only the policy can change it |
| _Could not turn on M: The provider … is not turned on in Settings › Integrations. …_ | Turn the provider on, then turn the model on |

**Change…** offers the model again while it is off: choosing it tests it again and turns it
on.

### Use as fallback

**Use as fallback** is a switch on the built-in model's panel, directly under the built-in
model's own switch. It is there while a model from your providers is chosen and turned on,
and the built-in model is on. It is on by default.

- **On**: whenever the chosen model cannot be asked — not loaded, busy, not answering,
  paused after failures, waiting for a test, changed since its test, or not allowed for now
  (its provider turned off, your organisation's policy, or **Models allowed from**) — the
  built-in model answers in its place.
- **Off**: nothing answers in its place, and C5 uses its usual checks, as it did before the
  classifier. The built-in model still answers what the chosen model is not asked (see
  [Who answers](#who-answers)), and still acts where it has a promotion record of its own
  and the chosen model has none. To keep it from answering anything at all, turn the
  built-in model off.

Under the switch a line says which: _If M can't answer, the built-in model answers. Turn the
built-in model off to never use it._, or, with it off, _If M can't answer, nothing answers
in its place, and C5 uses its usual checks. The built-in model still answers where M is not
asked or has no record of its own. Turn the built-in model off to never use it._ (The last
sentence is left out while your organisation's policy decides the built-in model's switch.)
The last step of choosing a model shows the same line, before anything is tested.

**Who can change it.** Turning it off is open to anyone who may change settings, from a
paired device too. Turning it back on is for an administrator at the machine running C5,
with a second factor; anyone else sees why under the switch, for example _Only an
administrator can use the built-in model as a fallback._ or _You can use the built-in model
as a fallback only on the machine running C5._ Each change is recorded in the audit log.

**Your organisation's policy** can set it, with `classifier_builtin_fallback` (see
[For administrators](#managed-policy-classifier_builtin_fallback)). Locked, the switch is
greyed out, with _Your organisation's policy sets this. The policy is set by …_ under it.

Use as fallback comes with version 1.10 of the Terms of Service, whose Section 14 says the
built-in model need not answer in the chosen model's place (see
[The Terms that cover it](#the-terms-that-cover-it)).

### Remove, or choose another

- **Remove**, on the chosen model's panel, clears the choice. It is open to anyone who may
  change settings, from a paired device too, whatever your organisation's policy says:
  removing is always the safe direction. Where a kind of decision acts on the model's
  answers, C5 asks first (**Remove M?**) and says what acts there afterwards, for example
  _Task categories acts on its answers now. Removed, the built-in model acts there on its
  own record; a family without one only records, and C5 answers as it did before._ The
  model's records are kept: choose it again while it is one of the last three models chosen,
  and it picks them up.
- To stop asking it for a while and keep it chosen, turn it off instead (see
  [Turn the chosen model off for a while](#turn-the-chosen-model-off-for-a-while)).
- **Change…** opens the list to choose another model. If a kind of decision acts on the
  current model's answers, the list says what acts there until the new model has been
  measured.
- **Turning its provider off** in **Settings › Integrations** stops C5 asking the model, and
  the question that turns the provider off says the classifier uses it. The row then reads
  _Not used: P is turned off in Settings › Integrations._

### When the chosen model is not answering

The model's panel says what is wrong, then what answers meanwhile: _Meanwhile the built-in
model answers._, _Meanwhile no classifier answers, and C5 answers as it did before._, or,
with [Use as fallback](#use-as-fallback) off, _Meanwhile nothing answers in its place, and
C5 uses its usual checks._

What the panel says about the model is what C5 found the last time it asked it: nothing
reads the provider's server in between. So the line says when that was, for example
_Answering when C5 last asked it, at 05:52._, or ends _As of its last question, at 14:03._ A
server that came back, or swapped its model, shows its old state until C5 next asks it.

| The panel says | What it means | What to do |
| --- | --- | --- |
| _Not loaded in P. C5 never loads a model itself; load it there and C5 uses it again._ | The provider has unloaded the model | Load it in the provider |
| _P is busy with other work, so recent questions went elsewhere._ | The provider's server was busy, often with your own work: where it answers one request at a time, C5 never makes a question wait behind your own chat | Nothing |
| _P is not answering (since 14:03)._ | The provider's server is not reachable | Start it, or check its address in **Settings › Integrations** |
| _Paused. …_ | The provider refused (a key it does not accept, a rate limit), or the model failed repeatedly, so C5 holds it back for a while. This is not the model's own switch. The reason follows | Follow the reason. C5 picks up a key you fix in **Settings › Integrations** within seconds |
| _Changed since it was tested. …_ | New weights at the same name, or the provider moved to another address | Choose the model again to test it again |
| _Not used until it passes a test._ | No passing test of it is kept | Press **Test again** |
| _Not used. …_ | Your organisation's policy, **Models allowed from**, or a confirmation that no longer holds; the reason follows | Follow the reason |
| _Not used: P is turned off in Settings › Integrations._ | | Turn the provider back on, or **Remove** the model |
| _Turned off. C5 keeps it chosen, …_ | Someone turned it off with its own switch | Turn it on again; see [Turn the chosen model off for a while](#turn-the-chosen-model-off-for-a-while) |

## What you see in Settings › Learning

The **Classifier** card has a **Terms** button and a short status badge in its header. Under
**Classifier models** are two panels. With nothing chosen, the built-in model's comes first;
once a model is chosen, its panel comes first, whether it is on or off:

- **A model from your providers**: what is chosen and where it runs, its last test, its
  state and what answers meanwhile, **Models allowed from**, its own switch at the top right
  (see [Turn the chosen model off for a while](#turn-the-chosen-model-off-for-a-while)), and
  the buttons **Choose a model…** (**Change…** once one is chosen), **Test again** and
  **Remove**. See [A model from your providers](#a-model-from-your-providers).
- **Built-in model**, with its switch, **Use as fallback** under it while a model is chosen
  and on (see [Use as fallback](#use-as-fallback)), and the status lines below.

Two tags beside the panels' titles say how they stand. **Primary**, on the chosen model's
panel, is shown while C5 asks that model and the built-in model can run; it does not
promise that the built-in model takes over, which is what **Use as fallback** decides.
**Fallback**, on the built-in model's panel, is shown while it stands behind a chosen model
that is answering, with Use as fallback on. Under both panels a line says who answers now
(see [Who answers](#who-answers)). Then comes one row for each kind of decision.

### The badge

While no model from your providers is chosen, or the chosen one is turned off, the badge in
the header is the built-in model's, as below. With one chosen and on, the header's badge
says how the classifier answers — **Running** (the chosen model answers), **Fallback** (it
cannot be asked now, and the built-in model answers in its place), **Unavailable** (it
cannot be asked now, and nothing answers in its place: always so with Use as fallback off,
even where the built-in model still answers some kinds of decision), **Testing** (a test of
it is running) or **Off** (your organisation's policy keeps every model off) — and the
built-in model's own badge moves into its panel. While a change is being saved, the badge
says **Turning off…**, **Turning on…** or **Saving…** instead.

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
| **Paused** | It failed three times in a row, so C5 is giving it a 60-second rest. The usual answers stand meanwhile. A question that ran out of time behind a background question, or a background question given up after waiting, is not a failure. | If it keeps happening, read the **Runtime** line and run `growther doctor`. |
| **Not running** | It was started but cannot run here, or it stopped. The **Runtime** line says why. | Find that message under [Troubleshooting](#troubleshooting). |
| **Not answering** | Its process is running but did not answer a status check in time. | It usually clears on its own. If it lasts, turn the classifier off and on, and run `growther doctor`. |
| **Starting** | It is being started. | Nothing. |
| **Error** | The download failed, or the classifier stopped with an error. | Read the **Model** or **Runtime** line, then find that message under [Troubleshooting](#troubleshooting). |

While a change you made is being saved the badge says **Turning on…**, **Turning off…**,
**Deleting the model…** or **Saving…** instead.

### The status lines

| Line | What it tells you |
| --- | --- |
| **This Mac** (on a Mac, often its model name, such as **This Mac Studio**), or **This machine** elsewhere | The machine and whether it can run the classifier, for example _Apple M4 Max, 16 cores (12 performance and 4 efficiency), 64 GB memory — supported._ Under it, where the classifier runs and why: _Runs on the GPU (Metal)._, or _Runs on the CPU (8 threads), because LM Studio is configured and the built-in model leaves the GPU to your local model._ Just after you change providers, the line also says where it is about to go: _It moves to the CPU when the built-in model restarts, because …_ C5 restarts it within a few seconds; you need not restart anything (see [GPU or CPU](#gpu-or-cpu)). On a machine that cannot run it, the line ends _— not supported._ and the reason follows. |
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
- Under Step quality, on a machine where it applies, _Sampling 1 in 4 on this machine: …_ (see
  [On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu)).
- **Promotion gate** — _passed_, _not passed_, _not enough evidence yet_, or _not measured
  yet_, when it was measured and over how many days, and each part that did not pass with
  what was measured (see [When it starts to act](#when-it-starts-to-act)). C5 measures it in
  the background, at most every ten minutes.
- What it is really doing, when it is set to act: _Acting in Authoritative at confidence 0.83 or
  more._, _Set to Assisted, but only recording its answers._ with the reason, or _Set to
  Assisted, but not running: this machine is too slow for its answers to be used in time, so
  only Shadow runs here._ A kind an administrator raised on a gate that had not passed also
  shows _Unvalidated: an administrator raised it on a gate that had not passed …_
- **Calibration** — the one stored, when it was fitted and by what. An administrator on the
  machine can press **Fit calibration now** for task categories, tool-call safety and alert
  triage while the classifier is on. When the last fit was not stored because it could not
  tell answers apart, the line says so, for example _Its last fit, on 2026-10-08, was not
  stored: calibrated, every answer would get about the same probability, so no confidence
  level could tell them apart._ (see [When it starts to act](#when-it-starts-to-act)).
- **Last 7 days** — how many decisions were recorded and how many by the local classifier, and
  how many labels people gave.
- For task categories, **Saved, last 7 days** — how many calls to the usual model its
  Authoritative answers replaced, and roughly what they would have cost, provider by provider.
  Local models are counted in model time, not money, and a model with no price set is never
  called free.

## What you see in Ops › Classifier

The **Classifier** tab on the **Ops** page shows the classifier as it runs: whether it is on
and acting, how many decisions it made and how fast, the calls to the usual model it replaced,
the labels still waiting, and where each learning loop stands. Its **Since the server
started** chart counts every question by outcome, including the background questions
given up after a minute's wait (see
[When the classifier is busy](#when-the-classifier-is-busy)). Only accounts that may view
Settings see this tab. It only reports; the switch and the modes are in **Settings ›
Learning**.

**Labels** counts, for the kind of decision you pick, the answered questions still waiting
for a label (_Answered states waiting_), how far it is from its gate's floor (_Toward the
gate's floor_), and the held-out answers an acting kind needs to stay verified. Where
questions wait for a kind that **Teach the classifier** asks about, an administrator gets
**Answer in Teach the classifier**, which opens that tab of the HITL window and waits for its
questions to load; if they cannot be read, the tab says why. On a paired device the panel
says _Answer them in Teach the classifier on the machine running C5._, and to anyone else
that an administrator answers them.

### Analytics › Classifier and Labs › Classifier

Two more tabs show the classifier's record in detail. Both need permission to view Settings,
and both show the built-in model's record; a model from your providers has no view of its
own there yet.

- **Analytics › Classifier** follows one kind of decision at a time (**Family**), over 7, 14
  or 30 days (**Window**): how it does against the usual model on the answers people or
  outcomes labelled, with 95% intervals; its gate's history, day by day; a calibration chart
  of its confidence against how often it was right; how often it gives the same answer as
  the usual model, week by week (agreement, not accuracy); Cohen's κ against each source of
  answers; and how the questions people answered were chosen. For Step quality it also
  compares the reward model with people's ratings. It reads once when opened; press
  **Refresh** to read again.
- **Labs › Classifier** has **What a threshold would do**: pick a confidence threshold (τ)
  and see how many decisions it would cover, how many tasks the classifier would answer
  alone, the error it would make and the calls it would replace a week. _This changes
  nothing._ Beside it, **Evidence budget** says how many questions it is asked a week and
  how many have been labelled so far.

## The Terms that cover it

The **Terms** button on the card opens **The classifier — Terms of Service, Section 14**:
section 14 of the Growther.si Terms of Service, _Models C5 downloads and runs on your
machine_, word for word, under the Terms version and its effective date (_Terms v1.10 ·
effective …_ in this release). Below it are this install's built-in model, its size, its
licence, whether it is on this machine, and its notice. The **On this machine** row says
what is at the model's path, without claiming C5 downloaded it (you may have placed it by
hand):

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

With a [model from your providers](#a-model-from-your-providers) chosen, a **Your model**
row names it too: _M through Ollama, on this machine._, or, for a model off this machine,
where it runs and when an administrator allowed it, for example _M through LM Studio, at
localhost:1234. You allowed this on 2026-11-02 under Terms v1.10._

At the bottom are **Full Terms of Service**
([growther.si/t=models](https://growther.si/t=models)), **Third-party notices** (the licences of
everything C5 ships or downloads), **Turn off the local classifier…** (**Turn off the built-in
model…** while a model from your providers is chosen) and **Close**. That button is offered to
someone who may change settings, while the built-in model is on and not locked by policy.
Reading the Terms asks you to accept nothing.

In short, section 14 says: C5 downloads these models from Hugging Face only while the feature
that needs one is on, checks each one before using it, keeps it on your machine, and sends
nothing about it or your use of it to Growther.si. Each model stays under its publisher's own
licence. The classifier is on by default, first only records, and acts only after it has been
measured on your install and only for the kinds of decision allowed in Settings.

Section 14 also covers **a provider's model, if you choose one**: an administrator at the
machine may choose a model one of your providers serves, and none is chosen by default. C5
does not download it. That model, and the questions C5 sends it, are governed by your
agreement with the provider and the model's own terms; Growther.si is not a party to that
and does not receive them, and the provider may charge you for them. It is measured on its
own record and acts only where it has been measured. While the built-in model is on, it
keeps acting where it has been measured and the chosen model has not, and answers whenever
the chosen model cannot be reached, unless its use as a fallback has been turned off in
Settings › Learning or by your organisation's policy. While the built-in model is off, or
its use as a fallback is turned off, no classifier answers when the chosen model cannot be
reached, and C5 answers as it did before. (Version 1.10 of the Terms added the words about
its use as a fallback.) A model not served on your machine can be chosen only where your
organisation's policy allows it, and only after C5 has shown what it will send there and you
have confirmed. Questions about whether a tool call is safe are never sent to such a model.

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

Each time the classifier starts, once the model has loaded, C5 times how long the model
takes to answer one question about a text of about a page. It times the model's own work,
not how long C5 waited: a question that had to wait behind others, or behind the model
loading, says nothing about the machine. If the answer takes more than two seconds, the
machine is marked slow: the first status line adds _This machine is slow for it, so its
answers may arrive late._ On a slow machine only kinds of decision set to Shadow run; one set
to Assisted or Authoritative is not asked at all, and records nothing either. Step quality
also records only one question in four there (see
[On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu)).

**A slow result is measured again.** A machine busy with something else at that moment —
other programs starting, say — can time ten times slower than it is. So when the first
timing is slow, C5 times it again, quietly, two minutes and fifteen minutes later. Each
retiming waits until the classifier has nothing to answer and its model is loaded, and it
never loads the model just to time it. The machine stays marked slow only while the
fastest timing is over two seconds: a fast one clears the mark at once, with no restart,
and kinds set to Assisted or Authoritative start acting again. Every restart of the
classifier times it afresh.

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
else the classifier uses the CPU, with up to 8 threads, leaving two cores free. A Mac with no
usable GPU, such as a virtual machine, is moved to the CPU automatically the first time the
classifier loads.

**A change of providers applies by itself.** When you add or remove such a provider while
the classifier runs, C5 restarts the classifier on the new choice about two seconds after
your last change; several changes in a row make one restart. The restart unloads the model,
and C5 loads it again straight away, timing one answer on the new choice (loading takes
about a second on Apple silicon). A change that does not move it between GPU and CPU
restarts nothing. With the classifier off, or without its model, nothing restarts and
nothing is downloaded; the choice applies when it next starts.

The card says which, and why, under the machine line. The thread count is the classifier's
own, not your machine's:

| The card says | Why |
| --- | --- |
| _Runs on the GPU (Metal)._ | An Apple-silicon Mac with no local model runner configured |
| _Runs on the CPU (8 threads), because LM Studio is configured and the built-in model leaves the GPU to your local model._ | A local model runner is configured; the line names it (or them) |
| _… because C5 could not read which models are configured, and a local one may be using the GPU._ | C5 could not read which model runners are configured, so it leaves the GPU alone to be safe |
| _… because this Mac has no Metal GPU it can use (a virtual machine looks like this)._ | No usable GPU |
| _… because Metal could not be used when the model loaded._ | The GPU was chosen, but the model could not use it and loaded on the CPU. Restarting would not change that, so the card does not say it will move |
| _… because this is C5's Intel build running under Rosetta; the Apple-silicon build uses the GPU._ | You are running the Intel build on an Apple-silicon Mac. Install the Apple-silicon build to use the GPU |
| _Runs on the CPU (8 threads); the built-in model uses the GPU only on Apple silicon._ | An Intel Mac, Windows or Linux |

The card describes where the classifier runs now. Just after you change providers, it also
says where it is about to go, for example _Runs on the GPU (Metal). It moves to the CPU
when the built-in model restarts, because LM Studio is configured and the built-in model
leaves the GPU to your local model._, or _… It moves to the GPU (Metal) when the built-in
model restarts._ You do not need to restart anything: C5 restarts the classifier itself
within a few seconds, and the line then shows where it runs.

On the CPU, Step quality records only one question in four (see
[On a machine where it runs on the CPU](#on-a-machine-where-it-runs-on-the-cpu)); every other
kind is recorded every time. That goes by where the classifier runs now, not where it moves
next.

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
  this machine. The built-in model runs on this machine, in its own process.
- The built-in model's only network traffic is the one download of the model from Hugging
  Face. C5 sends nothing about the model, or your use of it, to Growther.si.
- A [model from your providers](#a-model-from-your-providers), if an administrator chooses one,
  is sent the classifier's questions like any other work you send that provider: from your
  machine to the provider, under your agreement with it, never through Growther.si. A model off
  this machine is sent none of your work until an administrator has confirmed it, and is never
  asked whether a tool call is safe. Its answers are recorded in C5's database on this machine,
  like the built-in model's.
- **How long it is kept.** The classifier's records of its answers, and the usual model's
  beside them, are deleted 180 days after they were made, every night at 23:55 (not while
  a legal hold is on). The labels people gave are kept. The text of a step that Step quality
  was asked about (its task, step name, instruction and output) is deleted 31 days after the
  step unless someone rated it there; its scores and its agent's role are kept.
- **What is kept, and what is masked.** Secret values (API keys, tokens, private keys) are
  masked in that text before it is stored. A guardian decision's record keeps its verdict,
  the tool's name and the length of its reasoning; the reasoning itself stays only on the
  audit log. A guardian block's stored reason keeps the first 50 characters of the call,
  with secrets masked in the whole call before it is cut, and the reasoning, masked too. A
  skill-routing record keeps
  what the router chose, never the text of its reply.
- **Who sees it.** **Teach the classifier** shows administrators any task's title and the
  start of its description, a step's instruction and output, and an agent's tool call with
  its arguments, secrets masked. That is how a question can be answered without the
  classifier's answer beside it.
- C5's status address, `GET /health`, answers without any sign-in, so that supervisors can
  see C5 is up. It includes the classifier's details (use counts, answer times, how many
  questions are in progress or waiting, whether it is paused) only for someone signed in
  to C5 on this machine or its network, or for a request made directly on the machine
  itself. Everyone else gets `"classifier": null`, including a phone or tablet paired
  through Remote Control and anyone reaching C5 through a Remote Control address.

The binding text on where these questions go is the
[Privacy Policy](https://license.growther.si/privacy), under _Local by default_, and Section
14 of the Terms (see [The Terms that cover it](#the-terms-that-cover-it)).

## For administrators

### Managed policy: `classifier_enabled`

`classifier_enabled` is a boolean key you can set and lock through Group Policy or Intune,
macOS managed preferences, `/etc/growther/policy.d`, or a signed policy document. See
[Managed configuration](../configuration/enterprise-policy.md#keep-the-local-classifier-on-or-off).

- **Locked to `false`**: the classifier stays off, and C5 never downloads the model — not even
  through `growther classifier pull`. An administrator can still delete a model that is already
  there. No model from your providers answers either, unless the policy also sets
  `classifier_external_allowed` at the same level or a higher one (see below).
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

### Managed policy: `classifier_external_allowed`

`classifier_external_allowed` (`off`, `loopback`, `lan` or `any`) decides how far away a
[model from your providers](#a-model-from-your-providers) may run. It is delivered the same
ways as `classifier_enabled`. Locked, it replaces **Models allowed from** on the card, which
is then shown locked with the reason; only recommended, it is the default an administrator at
the machine may change; not set at all, **Models allowed from** starts at **This machine**.
`allowedProviders` and `allowedModels` apply to the classifier's models too. See
[Classifier models from your providers](../configuration/enterprise-policy.md#classifier-models-from-your-providers).

### Managed policy: `classifier_builtin_fallback`

`classifier_builtin_fallback` (a boolean) decides whether the built-in model answers in
place of a chosen model that cannot be reached: **Use as fallback** on the card (see
[Use as fallback](#use-as-fallback)). It is delivered the same ways as
`classifier_external_allowed`, never by the Mothership, and applies without a restart.

- **Locked to `false`**: the built-in model never answers in the chosen model's place, and
  nobody can turn Use as fallback on in C5. It still answers what the chosen model is not
  asked, and acts where it has a record of its own and the chosen model has none.
- **Locked to `true`**: it always does, and nobody can turn it off in C5.
- **Recommended, or under User Configuration**: a default, which anyone allowed to change
  it on the card may change.
- **Not set**: on, until someone changes it on the card.
- **A locked value that cannot be read** counts as `false`.

It matters only while a model from your providers is chosen and turned on, and the built-in
model is on. Builds that ship Terms of Service earlier than v1.10 ignore it. See
[Classifier models from your providers](../configuration/enterprise-policy.md#classifier-models-from-your-providers).

### Downloads only by hand or on request

Start C5 with `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` (exactly `1`) and C5 does not download
the model on its own. It then arrives only when someone runs `growther classifier pull`, or by
hand. C5 also never downloads it automatically when the `CI` environment variable is set. See
[Environment variables](../cli/environment.md).

### Network

A [model from your providers](#a-model-from-your-providers) is asked at the address its
provider is set up with in **Settings › Integrations**, never at an address taken from
anywhere else, and through the same proxy settings as the rest of C5. While the Egress
posture is **Offline**, C5 asks — and tests — only a model at an address on this machine.

The built-in model's download goes through the proxy and certificate authorities set under **Settings ›
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

When the download fails on the network, the message gives the cause itself. The **Model**
line in **Settings › Learning** reads, after _The download failed:_

```text
Could not download the classifier model: the proxy refused to open a tunnel to huggingface.co:443: it answered CONNECT with 407 Proxy Authentication Required; it wants credentials — put them in the proxy URL (http://user:password@host:port), C5 speaks Basic proxy authentication only. Once that is fixed, turn the classifier off and on, restart C5 or run `growther classifier pull` to download it; or fetch https://huggingface.co/… on a connected machine and place it at … (sha256 …).
```

The card never shows your proxy's address. `growther classifier pull` prints the same
message in your terminal with the proxy named (_the proxy http://proxy.corp.example:3128
refused …_), and `growther doctor` shows which proxy is configured. See
[The proxy address stays out of logs and alerts](../configuration/network.md#the-proxy-address-stays-out-of-logs-and-alerts).

When the cause is the proxy (it refused, or its setting cannot be used) or a certificate,
the machine is connected and a network setting is what to fix. So the message says what
starts the download again once it is fixed — C5 does not retry on its own until it next
starts — and offers placing the file by hand as the alternative. (From
`growther classifier pull` run with `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD=1` or `CI` set —
most build servers set `CI` — it names only running the pull again as the way to download,
because C5 would not download on its own there, and still offers placing the file by hand.)
The other causes end with the steps to place the file by hand. How each cause reads:

- the proxy's answer, as above;
- a certificate C5 does not trust: _the certificate presented on the way to
  huggingface.co:443 is not trusted (…)_ through a proxy, or the system's own words, such
  as _self-signed certificate in certificate chain_, without one;
- a proxy setting C5 cannot use: _C5 refused to connect to huggingface.co:443: the
  configured proxy cannot be used (growther doctor says why). …_;
- a host that refused the connection: _connect ECONNREFUSED …_, or _the connection to
  huggingface.co:443 through the proxy failed (ECONNREFUSED)_.

See [When the proxy says no](../configuration/network.md#when-the-proxy-says-no).

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

- `` ✗ model not downloaded (run `growther classifier pull`, or place … at …) ``
- `✗ model not downloaded: this deployment's network posture is offline, so C5 does not
  download it.`, then the address, path and fingerprint to place it by hand — the Egress
  posture is **Offline**.
- `✗ model not downloaded: your organisation's policy keeps the local classifier off`
- `✗ <path> is a link whose file cannot be reached (a share that is not mounted?); it is used
  once it can be, and never downloaded over`
- `✗ <path> is not the pinned model (wrong size)` (or `sha256 mismatch`), followed by what
  happens to it: `` `growther classifier pull` replaces it `` for a file; for a link to the
  wrong file, _it is a link, and C5 does not replace a link: point it at the model …, or
  remove it to have C5 fetch the model_; under Offline or a policy that keeps the classifier
  off, the same reason as the lines above.

`status` does not suggest a pull that Offline, your organisation's policy or a link would
refuse. To check, it reads your organisation's policy whenever the model is not here and
checked, as `pull` does: the device's own policy and, if you use one, the signed policy
document. **If that document is at a web address, each such `status` run makes one request
to it, even while C5 is set to Offline.** `status` never creates or changes a database.

It exits with `0` when the machine is supported and the model is verified, and `1` otherwise.

`pull` downloads the model now. It prints the model's notice, then, once the first bytes
arrive, _About 812 MB is downloaded once from Hugging Face._ and
`Downloading decider-0.8b-q8_0 (~812 MB) to <path>…`, then progress in 5% steps, and
finally `✓ downloaded and verified — <path>`. A pull that is refused, or finds the model
already here, prints neither of those two lines. If the model is already here and checked,
it says `✓ already present and verified — <path>` and downloads nothing.

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
- When the download fails, the `✗` line gives the cause itself, naming the proxy if one
  refused (see [Network](#network)).

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
C5 could not reach Hugging Face. The reason is the network's own: what the proxy answered (a
`407` wants credentials in the proxy URL), a certificate C5 does not trust (add your proxy's
root certificate to the CA bundle), a host that refused the connection, or a proxy setting C5
cannot use (_… the configured proxy cannot be used …_ — fix or remove the proxy URL; run
`growther doctor` to see why) — see
[When the proxy says no](../configuration/network.md#when-the-proxy-says-no). The card says
_the proxy_ without its address; `growther doctor` shows which proxy is configured. Otherwise
check your proxy, and that it allows the [Hugging Face hosts](#network). The message ends
with the address, path and fingerprint to place the file by hand. To retry, turn the
classifier off and on, restart C5, or run `growther classifier pull`.

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

**Step quality says _Sampling 1 in 4 on this machine: …_**
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
  after a warning; from a paired device they cannot. When the part is **Telling cases
  apart**, either the classifier's answer does not change when the right answer does, or no
  answer has yet been the correct one in 10 labelled tasks and not the correct one in 10.
  Labelling more tasks fixes the second, not the first.
- No calibration is fitted yet. C5 fits one at 23:50 once there are enough labels, or an
  administrator can press **Fit calibration now**. A fit that cannot tell answers apart is
  not stored; the **Calibration** line says so when that happened.

If you can choose it but the line reads _Set to Assisted, but not running: this machine is too
slow …_, see [Slow machines](#slow-machines). On Windows this lasts until the model's first
timing.

**Task categories went back to Shadow after an update.**
The nightly re-check measures every part of the promotion gate, including **Telling cases
apart**, which v322 and earlier did not measure. If the classifier's answers do not tell
cases apart on your install, the kind goes back to **Shadow** and administrators get the
**Local classifier: … moved back to shadow** notification saying why. Its answers keep being
recorded; once the gate passes again, raise it again. A kind that was acting on a
calibration from an earlier version that cannot tell its answers apart stops acting too, and
is fitted again.

**After going back to v319, a _Local classifier_ entry appears under Settings › Extensions.**
v319 does not know the classifier and treats it as an ordinary extension. Switch **Local
classifier** off there and v319 leaves it alone. See
[Going straight back to v319](../getting-started/updating.md#going-straight-back-to-v319).

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

### Choosing a model from your providers

**There is no Choose a model… button.**
Choosing and testing are for an administrator at the machine running C5, never from a paired
device. The row says why it is not offered to you. If your organisation's policy keeps every
model off, or does not allow a model from your providers, choosing is not offered at all; a
model already chosen can still be turned off or removed. See
[Classifier models from your providers](../configuration/enterprise-policy.md#classifier-models-from-your-providers).

**_None of your enabled providers lists a model right now. Turn one on in Settings › Integrations._**
The list shows only providers turned on in **Settings › Integrations**, and only the models
each one lists. Turn the provider on, start it if it runs on your machine or network, and
press **Refresh list**.

**_Not listed: … They pass questions to an agent, …_**
The line names the agent gateways turned on in **Settings › Integrations** — OpenClaw,
PicoClaw or Hermes Agent. A gateway hands each question to an agent, which may pass it to any
model. The classifier needs one model's own probabilities for each answer. Choose the model
the gateway uses from that model's own provider instead.

**A provider's group says _… cannot answer the classifier._** (Anthropic, Groq, Mistral, Cohere, Amazon Bedrock)
Their APIs do not return the probabilities the classifier reads, so none of their models can
be used. The rest of the line says why for each.

**_C5 cannot tell that it runs on this machine, and Models allowed from is This machine: …_**
The model's provider cannot show that it runs the model here: LM Studio, vLLM, or a server on
another computer. Set **Models allowed from** to **Your network** on the Classifier card (an
administrator at the machine can), then choose it and confirm where it runs. If the line
names your organisation's policy instead, only the policy can change it.

**_Runs online through P, and Models allowed from is …_**
A cloud model needs **Anywhere**. Ollama's cloud models cannot be chosen at all: Ollama passes
them on to its own servers.

**_M is not loaded in P. C5 never loads a model itself; load it there and try again. Nothing was changed._**
Load the model in the provider (in LM Studio or Ollama, say), then choose it again.

**The test says the model reasoned before it answered.**
A model that thinks before it answers cannot be read this way. In LM Studio, turn the model's
reasoning off, then test it again. A cloud model that cannot answer without reasoning cannot be
used.

**_… names whichever model the provider points it at; choose a dated or versioned model instead_**
The name moves to a newer model by itself (one ending in `latest`, or `openrouter/auto`), so
its record would mean nothing. Choose a dated or versioned name.

**_This machine now requires Terms v1.10, and this page shows v1.9. Reload C5 to read the current text._**
The page was loaded before C5 was updated. Reload it, read Section 14 again, and confirm.

**The chosen model's panel says _Not used._, _Paused._ or _Changed since it was tested._**
See [When the chosen model is not answering](#when-the-chosen-model-is-not-answering).

**_Could not turn on M: …_**
Turning the chosen model on checks it again, as choosing it would, and it stays off when a
check fails. The message says which; see
[Turn the chosen model off for a while](#turn-the-chosen-model-off-for-a-while). From a
paired device, or as an account that is not an administrator, it cannot be turned on at all.

**There is no Use as fallback switch, or it is greyed out.**
It is shown only while a model from your providers is chosen and turned on and the built-in
model is on. Greyed out, the line under it says why: your organisation's policy sets it, you
need permission to edit settings, or turning it on needs an administrator at the machine.
See [Use as fallback](#use-as-fallback).

## Related

- [Memory search](memory-search.md) — the other models C5 downloads, for semantic search
- [Network and egress](../configuration/network.md) — the Egress posture, proxies and every host C5 contacts
- [Managed configuration](../configuration/enterprise-policy.md) — locking `classifier_enabled`, `classifier_external_allowed` and `classifier_builtin_fallback` across a fleet
- [Model providers](../configuration/model-providers.md) — setting up the providers a classifier model can come from
- [Running doctor](../cli/doctor.md) — every check, and how to read the results
- [Environment variables](../cli/environment.md) — `GROWTHER_CLASSIFIER_NO_AUTO_DOWNLOAD` and `GROWTHER_CACHE_DIR`
