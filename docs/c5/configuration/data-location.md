---
title: Where your data lives
description: Configuration, databases, keys and caches; the downloaded models, their check files and how to place one by hand; what is safe to delete; how to move C5 or its caches to another local disk; why a network folder is refused for databases.
order: 6
---

# Where your data lives

C5 keeps everything on your computer. This page explains what sits where, how to
move it, and what C5 will refuse to do with it.

## The four kinds of files

| Kind             | What it holds                                                                     | Where it may live                                          |
| ---------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Configuration    | your settings, `config/c5.yaml`, guardrails, the install record                   | your home folder, or a folder your organisation manages    |
| Databases        | tasks, notes, deliverables, runs, telemetry: four encrypted databases              | a local disk on this computer only                         |
| Secrets and keys | the device key that encrypts the databases, the deployment key, your API keys     | this computer only, or your keystore                       |
| Caches           | downloaded models, the memory-search engine and its index, temporary files        | a local disk; regenerable, never backed up — see [what is safe to delete](#what-is-safe-to-delete) |

By default all four sit under one folder:

```text
~/.growther                      macOS and Linux
%USERPROFILE%\.growther          Windows (configuration)
%LOCALAPPDATA%\Growther\C5       Windows (databases and keys on new installs)
```

New Windows installs keep the databases and keys under `%LOCALAPPDATA%` on purpose: that
folder never travels with a roaming profile, so signing in on another machine cannot
carry an encrypted database away from the key that opens it.

## See it in Settings

Open **Settings › Storage › Configuration & Data**. The card shows:

- **Source**: whether this device chose the location (**Local**) or your organisation
  did (**Managed by your organization**). The Local tile also carries a badge naming how
  the location was decided — Default, Pointer, Environment or Policy. A policy that names
  only the databases or the key set, and leaves the rest of the home to this device,
  still counts as managed: the card says which parts your organisation set.
- **Where things live**: one row per kind of file, with the path, a badge that says
  whether it is on this device, on a network folder, or in a synced folder, and a dot
  that goes amber when something is not where it should be.
- **Actions**: change the local folder, verify the layout, roll back a move, or remove a
  retired copy after a move.

If C5 is running from an older location than the one now configured, a banner says so
until you restart.

## Move C5 to another local disk

Use the card's **Change local folder** button, or the command line:

```bash
growther home migrate --to /Volumes/Work/growther
```

Both run the same procedure:

1. **Validate** the new folder: it must be on a local disk, writable, not inside a
   protected folder, and have room for one and a half times your current data.
2. **Review the plan**: what moves, what stays, and what you can prune (old encrypted
   backup copies can add up to gigabytes).
3. **Confirm**. In Settings, type `move`. At the command line, answer `y` — or pass
   `--yes`, which is required if you are scripting it, because C5 refuses to schedule a
   relocation from a non-interactive shell without it. C5 then stops, copies everything
   with a verified checkpoint of every database, checks each copy against your key before
   anything is switched, and restarts from the new folder.

The old folder is kept as a retired copy with its secrets shredded, so you can **Roll
back** from the card at any time until you choose **Remove retired copy**.

To see the current layout or check a folder first:

```bash
growther home show
growther home probe /Volumes/Work/growther
```

`probe` answers for the use you have in mind, and the answers differ — a share that is
refused for the databases is perfectly fine for backups:

```bash
growther home probe /Volumes/Work/growther --intent=home           # the default
growther home probe //fileserver/c5 --intent=backup
growther home probe //fileserver/c5 --intent=networkConfig
growther home probe /Volumes/Work/growther --intent=location
```

The move itself takes options worth knowing before you run it:

| Option | What it does |
| --- | --- |
| `--dry-run` | Print the plan and stop. Nothing is scheduled |
| `--yes` | Skip the confirmation. **Required** when stdin is not a terminal |
| `--include-imports` | Carry the imports folder across as well |
| `--include-backups` | Carry the newest set of database backups across (often the bulk of the size). Older sets stay with the retired copy |
| `--prune-baks` | Delete the old encrypted database backups (`repository.db.encrypted.bak…`) |
| `--prune-old` | Delete the old data folder, `data/old` |
| `--prune-env` | Delete the legacy `config/.env` file |

The three `--prune-…` options name things that are never copied to the new folder, with or
without the option. The option marks them in the plan (`[x]`) to be deleted with the retired
copy instead of kept there.

C5 refuses a folder that already holds a file the move would replace, and names the
files. Pick an empty folder, or move those aside first. Merging into a folder that
already holds unrelated subfolders is fine.

If a move or a roll back is interrupted — the machine loses power part way through, or
a rename fails — the next start deals with it, and your data is never left half-moved.
What it does depends on how far the job got:

- **Interrupted while copying or verifying**, which is most of the elapsed time: C5
  discards the partial copy and starts normally from the old folder. Run the move again.
  It does not resume, because the old folder may have been written to since.
- **Interrupted after the switch**: the next start finishes the job.

Either way nothing needs repairing by hand. To abandon a job instead of letting the next
start deal with it, run `growther home cancel` — or `growther home cancel --force` for
one that keeps failing at every start.

## What C5 refuses, and why

**Databases are never placed on a network folder, a mapped drive, a roaming profile, or
a synced folder** such as OneDrive, Dropbox or iCloud Drive. C5 checks the filesystem
at every start and refuses to run if the databases are on one of those. The reason is
not caution for its own sake: the database engine keeps part of its state in shared
memory that only one computer can see, so two computers opening the same folder would
corrupt it, and a sync client can copy a half-written file over a good one.

On a locked-down Windows image the check itself can be blocked from running. C5 then
decides from what it can see without help — a network path, a OneDrive folder, a synced
root — and starts with a warning rather than refusing. A folder that positively looks
like any of those is still refused.

If a configured folder is unreachable when C5 starts, it stops with a message naming
the folder and who set it, rather than silently starting an empty second copy somewhere
else.

**Two computers never share one folder.** The lock C5 takes on the data folder now
records which machine holds it. A second machine pointed at the same folder refuses to
start and tells you which machine has it. If a machine has been rebuilt and a stale lock
is in the way:

```bash
growther lock status
growther lock break --confirm
```

## Backups and network storage

Network storage is welcome for what belongs there: encrypted backups, exported audit
evidence, and the policy file your organisation may publish.

The backup folder under **Settings › Storage** is for a folder **on this computer** — it
must sit inside your home directory, and a UNC or network path is refused there. Anything
off this machine is set under **Settings › Enterprise › Enterprise storage**, which takes
a network folder, an Azure Blob container or an S3 bucket. A network folder is accepted
only if an administrator has first added its parent to the allowed enterprise roots on
that same screen; with no roots listed, every network target is refused.

## Downloaded models

Three features run small models on this machine: memory search, voice (offline speech
to text) and the local classifier. C5 downloads each model once and keeps it in the
**cache root**, a folder of its own that holds nothing you made. Nothing in it is backed
up, and every byte in it can be downloaded or rebuilt. Who publishes each model, and
under what licence, is in
[Open-source licences and downloaded models](../security/open-source-and-models.md).

### Where the cache root is

By default the cache root is your C5 folder itself (`~/.growther`, or
`%USERPROFILE%\.growther` on Windows). It moves when one of these says otherwise, the
first one that is set winning:

1. your organisation's policy (the `cacheDir` location key);
2. the `GROWTHER_CACHE_DIR` environment variable (ignored when the policy sets `cacheDir`);
3. the home pointer, which `growther cache relocate` writes (below).

`growther cache show` prints where the cache root is and what decided that, the home
pointer file, and each folder's size and file count.

### What is in it

| Folder | What it holds | Size |
| --- | --- | --- |
| `qmd/` | The memory-search engine (unpacked from the C5 program), its three models under `qmd/cache/qmd/models/`, its search index, and a `README.md` listing each model's address, size and sha256. Also `qmd/model-view/` (below), with C5's own checked copies of the models | about 2.3 GB with the models, plus up to about 2.3 GB more for the checked copies on a disk that cannot clone files |
| `speech/` | The offline speech model, `ggml-base.en-q5_1.bin` | about 60 MB |
| `classifier/` | The local classifier's model under `classifier/models/`, and `runtime.json`, the settings C5 writes for its process | about 812 MB |
| `cache/` | Model capability data and embeddings | small |
| `lib/` | Linux only: the OpenSSL 1.1 runtime C5 extracts for its encrypted databases | small |

The tunnel program Remote Control downloads, `cloudflared`, is not a cache: it sits in
`<C5 folder>/config/rc-tunnel/` with the tunnel's credentials, and C5 checks it against
the digest this build records every time it starts the tunnel.

### The model files, exactly

Each model is fetched from one fixed commit of its Hugging Face repository and must
match this size and sha256 before C5 uses it. Paths are relative to the cache root.

| Feature | File | Bytes | sha256 |
| --- | --- | --- | --- |
| Memory search (embedding) | `qmd/cache/qmd/models/hf_ggml-org_embeddinggemma-300M-Q8_0.gguf` | 333,590,944 | `b5ce9d77a3fc4b3b39ccb5643c36777911cc4eb46a66962eadfa3f5f60490d63` |
| Memory search (reranking) | `qmd/cache/qmd/models/hf_ggml-org_qwen3-reranker-0.6b-q8_0.gguf` | 639,153,184 | `22c9979ce4fbcdc5acdc310c6641c32797eff1aa980b8f7a2db8a8ea23429a48` |
| Memory search (query expansion) | `qmd/cache/qmd/models/hf_tobil_qmd-query-expansion-1.7B-q4_k_m.gguf` | 1,282,438,912 | `000dfb1c06efa6a049e9f64ba921c3740e2454f62abab6fa10e77bd30bb2bcc0` |
| Voice | `speech/ggml-base.en-q5_1.bin` | 59,721,011 | `4baf70dd0d7c4247ba2b81fafd9c01005ac77c2f9ef064e00dcf195d0e2fdd2f` |
| Local classifier | `classifier/models/decider-0.8b.Q8_0.gguf` | 811,844,032 | `2665d08c1052b4e01dabcb08771d25579f6776f7066355e4a0ccc5f74e32d4a2` |

Two earlier uploads of memory-search models are also accepted when they are already on
disk, so an install that downloaded them before is not made to download again: the
embedding model at 328,576,992 bytes, and the query-expansion model at 1,107,408,608
bytes. C5 only ever downloads the versions in the table.

### The other files you may see

| File | What it is |
| --- | --- |
| `<model>.partial` | A download in progress, or one that was interrupted. Memory search and the local classifier resume from it; the speech model's download starts over (it is small) and removes its `.partial` if it fails. It never has the model's name, so nothing loads it |
| `<model>.partial.lock` | Held while one C5 process downloads that model, so two processes — a running C5 and a `pull` in a terminal — never write the same file. A lock left behind by a process that has gone (a crash, a reboot) is recognised as stale and taken over |
| `<model>.verified.json` | The result of checking the model: its sha256, with the size and modification time it had. C5 hashes each model once, not at every start, and checks again if the file changes |
| `<model>.rejected`, `<model>.rejected.1`, … | Memory-search and voice only: a file that was at the model's name but is not the model this build records. C5 renamed it aside so it cannot be loaded. It is never deleted — it may be the only copy you have — so remove it yourself once you no longer need it |
| `<model>.ipull` | Memory search only: left by an older version's download. C5 installs it if it holds the whole model, and otherwise removes it once it is of no further use |
| `qmd/model-view/<number>/` | Memory search only: the folder the running search engine finds its models in, holding only the model files C5 has checked — as C5's own checked copy, a copy-on-write clone, a hard link or, failing those, a symbolic link — so the engine cannot load a file C5 has not checked. C5 removes it when the engine stops and removes any left behind at its next start. `growther cache show` does not count it and `growther cache relocate` does not move it. Safe to delete while C5 is stopped |
| `qmd/model-view/checked/<sha256>.gguf` | Memory search only: C5's own checked copy of each model, made in the background after the engine starts and checked by fingerprint before use, so a file later copied over the model's name cannot reach the engine. On a disk that can clone files it takes no extra space; otherwise each copy takes the model's size again (up to about 2.3 GB for all three), and is made only if 1 GB would still be free. Kept from one start to the next; copies no model needs are removed. Not counted by `growther cache show`, and not moved by `growther cache relocate` (C5 makes them again at the new location). Safe to delete while C5 is stopped: C5 makes them again |

A file set aside is reported in the log, for example:

```text
[mcp] QMD: <path> is not the embedding model this build records (<why>). C5 set it aside as <name>.rejected so QMD cannot load it — nothing was deleted. Where downloads are allowed C5 fetches the pinned file in its place; otherwise place it as <cache root>/qmd/README.md describes. Remove <path>.rejected once you no longer need it.
```

A memory-search or voice file that changed within the last minute is not judged yet — it
may be a copy still arriving — and is not used meanwhile. Memory search checks it again
once a minute has passed since it last changed; the speech model is checked again the
next time it is used or C5 starts.

**The local classifier is handled differently.** A wrong file at its name is not renamed:
it is left where it is, never loaded, and replaced by the next download that passes its
check. **Settings › Learning** says _The file at the model's path is not the model (…), so
C5 does not use it._, and `growther classifier status` reports it (*is not the pinned model
… `growther classifier pull` replaces it*). A **symbolic link** at its name is never
downloaded over or replaced, whatever it points to: one whose file cannot be reached (a
share that is not mounted) is used once it can be, and one that points to a file that is
not the model stays unused until you point it at the model or remove it.

### Place a model by hand

This is how a machine without internet access gets its models, and it works the same
everywhere:

1. On a connected machine, download the file. The exact addresses are in
   `<cache root>/qmd/README.md` for memory search, and are printed by
   `growther voice pull` and `growther classifier pull` when this machine is offline.
   Each is `https://huggingface.co/<repository>/resolve/<commit>/<file>`.
2. Check its sha256 against the table above.
3. Copy it to the path in the table, **under exactly that name**. A file under any other
   name is ignored. The memory-search files must be renamed: Hugging Face serves them as
   `embeddinggemma-300M-Q8_0.gguf`, `qwen3-reranker-0.6b-q8_0.gguf` and
   `qmd-query-expansion-1.7B-q4_k_m.gguf`; save each under the `hf_…` name in the table.
4. Let C5 find it:
   - **Memory search**: while C5 runs, about half a minute after the copy stops
     changing; C5 then restarts the search engine with it, with no restart of C5 needed.
     If C5 is not running, at its next start. `growther qmd-run pull` checks the files
     already there straight away, before it downloads anything. The search engine uses a
     placed file only once C5 has checked it.
   - **Voice**: the next time someone uses the offline speech engine.
   - **Local classifier**: while it is on, the next time **Settings › Learning** is
     opened, or at the next start, with no restart needed. While it is off, when it is
     next turned on.

For memory search and voice, C5 never downloads over a file that is already at a
model's name: a wrong file is set aside first and, where downloads are allowed, the
right one is downloaded in its place. For the local classifier, a download that passes
its check replaces whatever wrong file was at the name — but never a symbolic link.

### What is safe to delete

Everything in the cache root can come back. What matters is whether it comes back on its
own, and how big that is.

| To free | Do this | What happens next |
| --- | --- | --- |
| The local classifier's model (812 MB) | As an administrator, **Delete the model** in **Settings › Learning**. Or stop C5 and delete `classifier/` by hand | Turned off first, it stays gone. If it is still on, C5 downloads it again at the next start, unless the machine is offline or opted out |
| The memory-search models (about 2.3 GB) | Stop C5 and delete `qmd/cache/qmd/models/` | C5 downloads them again at the next start, unless the egress posture is offline or `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1`. Until they are back, memory search works by keywords only |
| The whole `qmd/` folder | Avoid this unless you mean to start memory search over: stop C5 and delete it | The engine is unpacked again from the C5 program and the models are downloaded again as above. It also deletes memory search's **index** of your folders, which does not come back by itself: memory search finds nothing in them until an administrator presses **Sync Now** on the **QMD Data Folders** card under **Settings › Locations**. Delete only `qmd/cache/qmd/models/` if model space is all you want back |
| The offline speech model (60 MB) | Stop C5 and delete `speech/` | Downloaded again at the next start while the built-in speech engine is on, unless offline or `GROWTHER_VOICE_NO_AUTO_DOWNLOAD=1` |
| A `.rejected` file | Delete it | Nothing; C5 never uses it |
| A `.partial` file | Stop C5 and delete it | The next download starts from the beginning |

Stop C5 before deleting by hand: a running C5 holds models open, and Windows refuses to
delete an open file. To keep a model from coming back, use the switch for its feature,
the opt-out variable, or the offline posture — see
[Network and egress](network.md#the-models-and-programs-c5-downloads).

### Move the caches to another disk

The caches can live somewhere other than the rest of C5's data, for example on a larger
local disk:

```bash
growther cache show
growther cache relocate --to /Volumes/Big/growther-cache --dry-run
growther cache relocate --to /Volumes/Big/growther-cache
```

Stop C5 first. `relocate` copies all five folders, checks each copy file for file, by
count and size, and only then switches C5 over and removes the old copies; if it is
interrupted, the old cache root is still the one in use. `--dry-run` shows the plan
and stops. `--yes` skips the confirmation, and is required when the command is not run
from an interactive terminal (a script, or a session with no terminal).

It refuses, and says why, when:

- C5 is running — run `growther stop` first, then relocate, then start C5 again;
- `GROWTHER_CACHE_DIR` is set — that variable outranks the move, so change or unset it
  instead;
- the cache root is already the target;
- the target is inside the current cache root, or contains it;
- the target is a network folder, a synced folder or another place that is not a local
  disk — the caches hold programs C5 loads and models it reads directly from disk;
- the target is not writable, or a folder there already holds files (move or remove
  them first);
- a `growther classifier pull`, `growther qmd-run pull` or `growther voice pull` is
  downloading a model in a terminal at that moment. Let it finish, or stop it, then move.

## Check the layout from the command line

```bash
growther doctor
growther doctor --json
```

The report includes *Home source*, *Data dir filesystem*, *Secrets location* and *Lock
host*. The `--json` form also writes `doctor-status.json` into the C5 folder for device
management tools to read.
