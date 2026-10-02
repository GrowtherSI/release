---
title: Memory search
description: How C5 searches everything your agents have written, the one-time model download it needs, how C5 checks those models, and how to place them by hand.
order: 5
---

# Memory search

C5 keeps an index of the notes, memories and documents your agents produce, so an agent
can find what it — or another agent — wrote weeks ago without you pointing at the file.

Two kinds of search sit behind it:

- **Keyword search** finds documents containing the words you typed.
- **Semantic search** finds documents that mean the same thing, even when they use
  different words. Asking about "customer churn" can surface a note titled "why people
  cancel".

Keyword search works the moment C5 starts. Semantic search needs three language
models, and those are the one part of memory search C5 does not ship inside its download.
Memory search is built into C5 and has no off switch; what you can control is how the
models reach your machine.

## The models

| Model | What it adds | Size | Published by | Licence |
| --- | --- | --- | --- | --- |
| EmbeddingGemma-300M | Semantic (meaning-based) search, and building the search index | 333,590,944 bytes (about 334 MB) | Google DeepMind; converted by ggml-org | [Gemma Terms of Use](https://ai.google.dev/gemma/terms) |
| Qwen3-Reranker-0.6B | Puts the most relevant results first | 639,153,184 bytes (about 639 MB) | Alibaba Cloud (Qwen); converted by ggml-org | Apache License 2.0 |
| qmd-query-expansion-1.7B | Turns one question into several searches, for the terminal commands `growther qmd-run query` and `vsearch` (see [Searching from a terminal](#searching-from-a-terminal)) | 1,282,438,912 bytes (about 1.28 GB) | tobil, the author of the QMD search engine C5 uses | MIT |

Together they come to about **2.26 GB**. Bundling them would add over 2 GB to every C5
download — making it roughly 25 times larger — to save a fetch that happens once, so C5
fetches them instead.

The search engine C5 uses is called **QMD**, so its log lines start `[mcp] QMD` or
`[qmd]`. In those lines the three models are called **embedding**, **reranking** and
**generation**: the generation model is the query-expansion model in the table.

Each model is someone else's work, under its publisher's own terms. The Gemma Terms of
Use include a prohibited-use policy that applies to your use of EmbeddingGemma. Section 14
of the Growther.si Terms of Service, [Models C5 downloads and runs on your
machine](https://growther.si/t=models), says how C5 handles these models. The current
list, with every licence text, is in C5 under **About › Copyright & Legal**, and in a
terminal (see [Open-source licences and downloaded
models](../security/open-source-and-models.md#check-which-models-c5-downloads) for
more):

```bash
growther licenses
```

## The one-time download

You do not have to do anything. Once C5 has started, it fetches each model that is
**missing** in the background, and you can keep working while they arrive. The startup
log says so:

```text
[mcp] QMD: fetching embedding, reranking, generation model(s) in the background (~2255 MB, one time; pinned and checked by sha256) → /Users/you/.growther/qmd/cache/qmd/models
```

When they have all arrived and been checked, C5 restarts the search engine so that it
uses them, and semantic search turns on by itself:

```text
[mcp] QMD models ready — semantic query is now available.
[mcp] restarting the QMD server so it sees the model files as they now are…
```

What C5 does, and does not do, when it fetches a model:

- **It fetches one exact file.** Each model is pinned to one commit of its repository on
  Hugging Face, never a branch that can move. C5 downloads
  `https://huggingface.co/<repository>/resolve/<pinned commit>/<file>`.
- **It checks the file before using it.** A model counts as installed only when its size
  and its sha256 fingerprint match what this C5 release records. A download that comes
  out different is thrown away and never used.
- **It only fills a gap.** C5 fetches a model only when there is no file at its name. It
  never deletes a model file and never writes over one, whether an earlier download put
  it there or you did.
- **It uses your network settings.** The download goes through the proxy and certificate
  authorities set under **Settings › Enterprise › Network**, like the rest of C5. See
  [Network and egress](../configuration/network.md).
- **Only C5 downloads.** The search engine's own processes cannot download a model at
  all. A model the engine needs but cannot find stays missing until C5 fetches it or you
  place it.
- **Nothing about the models goes to Growther.si.** The download is a request from your
  machine to Hugging Face.

The request goes to `huggingface.co`, which redirects to Hugging Face's download servers.
If your firewall or proxy allows only named hosts, allow all of these:

| Host | Why |
| --- | --- |
| `huggingface.co` | Where every download starts |
| `cas-bridge.xethub.hf.co` | Hugging Face's download servers, reached by following the redirect |
| `cdn-lfs.hf.co` | The same, for files stored the older way |
| `cdn-lfs-us-1.hf.co`, `cdn-lfs-eu-1.hf.co` | Regional copies of the above |
| `cdn-lfs.huggingface.co` | An older name for the same servers |

A proxy that admits `huggingface.co` and nothing else fails every model download.

### If the download does not finish

C5 says so in one line and carries on with keyword search:

```text
[mcp] QMD model download did not complete (embedding: …). Keyword search and document tools still work; C5 retries on the next start, and /Users/you/.growther/qmd/README.md covers doing it by hand.
```

It tries once per start. A partly downloaded file is kept as `<file>.partial`, and the
next attempt carries on from where it stopped. If some models arrived and others did not,
you also see `[mcp] QMD model fetch finished, still missing: …` after that line.

The reason in brackets is what the download reported. When the network is the cause, it
names it: a certificate C5 does not trust, or the proxy that refused and what it
answered (see [When the proxy says no](../configuration/network.md#when-the-proxy-says-no)).
Check that the proxy allows `huggingface.co` and the five download hosts above. An administrator can
press **Test connectivity** under **Settings › Enterprise › Network**, which asks each
host C5 contacts — these six included — through your proxy and shows which answered. See
[Network and egress](../configuration/network.md).

### Turning the automatic download off

Either of these stops C5 fetching the models on its own:

- start C5 with `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1` set (exactly `1`; any other value
  leaves the download on) — see
  [Stop C5 downloading models on its own](../cli/environment.md#stop-c5-downloading-models-on-its-own)
  for where to set it when C5 starts at sign-in or as a service, or
- set the **Egress posture** to **Offline** under **Settings › Enterprise › Network**,
  which stops every download C5 makes on its own.

The models then arrive only when you run `growther qmd-run pull` (refused while offline)
or place them yourself.

## While the models are missing or being checked

Keyword search, indexing and opening documents never need a model, so memory search is
never "down" for want of one. What each missing model takes away:

| Missing | What changes |
| --- | --- |
| Embedding | No semantic search; keyword search still works. The terminal commands `growther qmd-run query`, `vsearch` and `embed` are refused, and point you to `growther qmd-run search` |
| Reranking | Results come back without being reordered for relevance, for agents' searches and for `growther qmd-run query` |
| Query expansion (generation) | The terminal commands `growther qmd-run query` and `vsearch` are refused. Agents' searches are unaffected |

At startup C5 prints one line saying where things stand. With everything in place:

```text
[mcp] QMD ready (bundled runtime) — all 3 models present; full query, embedding and rerank available
```

Otherwise the line starts `[mcp] QMD query limited without download requirements` or
`[mcp] QMD ready with reduced capability`, then names each model that is missing, still
being checked, not the right file, or out of reach. C5 is running normally when you see
either line; it is telling you what semantic search is waiting for.

**A model that is a link C5 cannot follow.** If you made a model's name a link to a file
elsewhere — on a network share, say — and that file cannot be reached, the line says
_not using … the model's name is a link whose target cannot be reached_. C5 leaves the
link alone: it does not download over it or move it. Mount the share, or replace the link
with the file itself.

**On the first start after an update**, C5 checks each model file already on your disk
once — it reads the whole file to work out its fingerprint — and writes the result beside
it as `<file>.verified.json`, so later starts only need a quick look. On a slow disk this
can take a minute or two. Memory search waits for the check; the rest of C5 does not. This
line means the check finished and the files are fine:

```text
[mcp] QMD: checked the embedding, reranking, generation model(s) against the size and sha256 this build records — they match.
```

## If a model file is not the right one

A file at a model's name that does not match — a different upload, a truncated copy, a
file saved by a proxy's error page — is **set aside, never deleted**. C5 renames it to
`<file>.rejected` (or `.rejected.1`, `.rejected.2`, … if that name is taken) so the search
engine cannot load it, and says so:

```text
[mcp] QMD: …/hf_ggml-org_embeddinggemma-300M-Q8_0.gguf is not the embedding model this build records (its sha256 does not match). C5 set it aside as hf_ggml-org_embeddinggemma-300M-Q8_0.gguf.rejected so QMD cannot load it — nothing was deleted. …
```

With the name free again, C5 fetches the pinned file in its place, unless downloads are
off. The `.rejected` file stays until you remove it; once memory search works, you can
delete it to get the space back.

Two cases are handled more gently:

- **A file still being copied.** A file that does not match and changed within the last
  minute is left where it is and checked again a minute later, so a copy that is still
  arriving is not set aside half-way. (Some copy tools write the full length first and
  fill it in afterwards, which is why C5 waits for any file that is still changing.)
- **A file C5 cannot move.** On Windows, a file the search engine has open cannot be
  renamed. C5 restarts the engine to release it and tries again. If it still cannot, it
  says so at every start until you stop C5 and move the file yourself.

Meanwhile — and the same goes for a file C5 could not read to check it — memory search
keeps running for your agents, without that model. The search engine only ever sees the
model files C5 has checked (see [Where they go](#where-they-go)), so to it the model is
simply missing, and keyword search and the document tools work. The log says so:

```text
[mcp] [qmd] starting QMD with only the model files C5 has checked: … Until then QMD does without the embedding model(s); keyword search and the document tools work.
```

Earlier uploads of two of the models — the embedding model at 328,576,992 bytes and the
query-expansion model at 1,107,408,608 bytes — are recognised and kept as they are, because
an existing search index may have been built with them. C5 only ever downloads the pinned
upload.

## Where they go

```text
~/.growther/qmd/cache/qmd/models/              macOS and Linux
%USERPROFILE%\.growther\qmd\cache\qmd\models   Windows
```

That is the default. If you moved C5's caches — with `growther cache relocate`,
`GROWTHER_CACHE_DIR`, or an organisation's policy — the models live under
`<new location>/qmd/cache/qmd/models` instead. See
[Where your data lives](../configuration/data-location.md).

The files you will see there:

| File | What it is |
| --- | --- |
| `hf_ggml-org_embeddinggemma-300M-Q8_0.gguf` | The embedding model |
| `hf_ggml-org_qwen3-reranker-0.6b-q8_0.gguf` | The reranking model |
| `hf_tobil_qmd-query-expansion-1.7B-q4_k_m.gguf` | The query-expansion model |
| `<model>.verified.json` | C5's record that it checked this exact file |
| `<model>.partial` | A download in progress, or one that was interrupted |
| `<model>.rejected` | A file that did not match, set aside |

The search engine's server — the part your agents search through — does not look in
that folder. While it runs, C5 gives it a folder of its own, `qmd/model-view/<number>/`,
which holds only the model files C5 has checked. A file at a model's name that C5 has not
checked — still being copied, unreadable, or one you placed while C5 was running — is not
in that folder, so the search engine cannot load it before C5 has checked it.

**How the folder holds each model.** The aim is that nothing done to a file at the model's
name later — a copy over it, say — can reach the bytes the search engine reads. In order of
preference, each entry is:

1. **C5's own checked copy** of the model, once it has made one (below). Nothing done at the
   model's name reaches it.
2. **A copy-on-write clone** of the checked file, where the disk can make one in an instant
   at no extra space: on macOS an APFS volume, on Linux a file system that supports cloning
   (such as Btrfs, or XFS with reflink), and only on the same disk as the model. Not on
   Windows.
3. **A hard link**, which takes no extra space.
4. **A symbolic link**, where neither is possible (a model on another disk, say).

A hard or symbolic link still sees a file overwritten in place, so C5 watches those entries
every five seconds and takes one out of the search engine's reach as soon as its file's
size, time or identity changes.

**C5's own checked copies.** After it builds the folder, C5 makes — in the background, one
model at a time — its own copy of each model under `qmd/model-view/checked/` (named by the
model's sha256), checks that copy's fingerprint itself, and swaps it in for the link. Later
starts use these copies directly. Where the disk can clone, a copy takes no extra space.
Where it cannot, a copy takes the model's full size again — up to about 2.3 GB for all
three — and C5 makes it only if that would still leave 1 GB free. Otherwise the link stays
(watched, as above), and the log says so:

```text
[mcp] [qmd] not enough free space beside <folder> for C5's own checked copy of <path> (the embedding model, 334 MB); QMD keeps it by a link, which C5 takes out of reach within 5 s if the file changes.
```

The copies stay from one start to the next; ones no model needs any longer are removed. On
Windows, a swap the system refuses while the search engine has the file open waits for the
next start.

While C5 runs, it notices a model file you place at its name. About half a minute after
the copy stops changing, C5 checks it and restarts the search engine with it, and the log
says so:

```text
[mcp] QMD: <path>, placed while C5 was running, is the embedding model this build records (size and sha256 checked).
```

If C5 is not running, it checks the file at its next start. Either way you do not need to
restart C5. (The terminal commands in
[Searching from a terminal](#searching-from-a-terminal) are checked differently: one that
needs a model C5 has not checked is refused before it starts.)

If a model file C5 had already checked **changes** while the search engine runs — copied
over in place, for example — C5 restarts the search engine at once, without that model,
and checks the file again once it stops changing. Then the search engine is restarted with
it, or the file is set aside if it is not the model. The log says:

```text
[mcp] QMD: <path>, which C5 had checked, changed; QMD is restarted without it until C5 has checked it again.
```

Each of these lines is written to the log once, even though both C5 and the search engine's
own process check the files.

C5 removes the numbered `model-view` folder when the search engine stops, and removes any
left behind at the next start; the `checked` copies stay. `growther cache show` does not
count `model-view` — copies included — and `growther cache relocate` does not move it (C5
rebuilds it at the new location). Only if C5 cannot make that folder at all does
it keep the search engine stopped; the QMD entry under **Settings › Extensions** then shows
a warning. If C5 makes the folder but cannot put one checked model in it, the search
engine starts without that model until its next start, and the log says so:

```text
[mcp] [qmd] <path> (the embedding model) is checked, but C5 could not put it in QMD's folder of checked files (<reason>), so QMD does without it until its next start.
```

In the top `qmd` folder (`~/.growther/qmd/` by default) there is a `README.md` listing each model's
download address, exact size and sha256 for this release, and the exact models folder on
your machine. C5 writes it when it is missing and never overwrites it, so your own notes in
it survive. If yours was written by an older release, delete it and C5 writes a current
one at its next start.

## Placing the models by hand

On a machine that cannot reach Hugging Face — an air-gapped network, or a proxy you cannot
open — fetch the files on a machine that can, and copy them across.

1. Download each model from its pinned address. Use these addresses, not the repository
   pages: a repository's download button follows its latest upload, which may not be the
   file this release checks for.

   | Model | Download from | Save as | Exact size | sha256 |
   | --- | --- | --- | --- | --- |
   | Embedding | `https://huggingface.co/ggml-org/embeddinggemma-300M-GGUF/resolve/0f741b5a6585bd53aeb15cd1372c56f2a0f65e12/embeddinggemma-300M-Q8_0.gguf` | `hf_ggml-org_embeddinggemma-300M-Q8_0.gguf` | 333,590,944 bytes | `b5ce9d77a3fc4b3b39ccb5643c36777911cc4eb46a66962eadfa3f5f60490d63` |
   | Reranking | `https://huggingface.co/ggml-org/Qwen3-Reranker-0.6B-Q8_0-GGUF/resolve/a02f48bb4f057028298c21fa033da2b30d7742d5/qwen3-reranker-0.6b-q8_0.gguf` | `hf_ggml-org_qwen3-reranker-0.6b-q8_0.gguf` | 639,153,184 bytes | `22c9979ce4fbcdc5acdc310c6641c32797eff1aa980b8f7a2db8a8ea23429a48` |
   | Query expansion | `https://huggingface.co/tobil/qmd-query-expansion-1.7B-gguf/resolve/7816de0b72572c6c860ca1eddf97ba9e7fb8cc65/qmd-query-expansion-1.7B-q4_k_m.gguf` | `hf_tobil_qmd-query-expansion-1.7B-q4_k_m.gguf` | 1,282,438,912 bytes | `000dfb1c06efa6a049e9f64ba921c3740e2454f62abab6fa10e77bd30bb2bcc0` |

   The `README.md` in your `qmd` folder lists the same addresses and fingerprints.

2. If you like, check a file before copying it. Its fingerprint must match the table
   exactly:

   ```bash
   shasum -a 256 embeddinggemma-300M-Q8_0.gguf      # macOS
   sha256sum embeddinggemma-300M-Q8_0.gguf          # Linux
   ```

   ```powershell
   Get-FileHash embeddinggemma-300M-Q8_0.gguf -Algorithm SHA256   # Windows
   ```

3. Copy each file into the models folder (see [Where they go](#where-they-go)) under its
   **Save as** name.

   **The name matters.** The search engine finds a model by its file name. The right file
   under any other name is ignored, and the model counts as missing.

4. That is all: you do not need to restart C5. A running C5 checks each file you placed
   about half a minute after the copy stops changing, exactly as it checks its own
   downloads, and starts using it (see [Where they go](#where-they-go)). If C5 is not
   running, it checks the files at its next start and prints the `checked … they match`
   line above. A file that does not match is set aside as `.rejected`; nothing is
   deleted.

You do not have to place all three. Each one adds something on its own — the embedding
model alone turns on semantic search.

## Fetching them from a terminal

To fetch the models on your own schedule — before taking a laptop somewhere without
signal, say — run:

```bash
growther qmd-run pull
```

It runs the same pinned, checked fetch as C5's startup, and prints each step:

```text
✓ embedding present and checked — …/hf_ggml-org_embeddinggemma-300M-Q8_0.gguf
Downloading the reranking model (~639 MB, pinned at a02f48bb, sha256-checked) to …/hf_ggml-org_qwen3-reranker-0.6b-q8_0.gguf…
  10%
  …
✓ reranking downloaded and checked — …
```

- It fetches only what is missing and replaces nothing. It takes no options.
- It works even with `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1` set, because you asked for it.
- It goes through the proxy and certificate authorities C5 is configured with.
- It is refused while the egress posture is **Offline**, and tells you which files to
  place by hand instead.
- A file that does not match is set aside as `.rejected` and the right one fetched, as at
  startup. If that file is still being copied (it changed in the last minute), or could
  not be set aside, `pull` does not download over it. It says so: wait for the copy to
  finish, or stop C5 and move the file away, and run the command again.
- It exits with `0` when every model is on disk and checked afterwards, and `1` otherwise.
  Run it again to resume an interrupted download.

This is C5's own command, not the search engine's built-in `pull`, which C5 never runs:
that one follows each repository's latest upload, and deletes the files already in the
folder before downloading them again, even when it cannot reach Hugging Face.

## Searching from a terminal

Besides `pull` and `doctor`, `growther qmd-run` passes other commands straight to the
search engine. Agents do not need them; they are for searching your memory from a
terminal:

| Command | What it does | Needs |
| --- | --- | --- |
| `growther qmd-run search <words>` | Keyword search | No model |
| `growther qmd-run vsearch <question>` | Semantic search | The embedding and query-expansion models |
| `growther qmd-run query <question>` | Semantic search with query expansion and reranking | The embedding and query-expansion models; without the reranking model it runs without reranking |
| `growther qmd-run embed` | Builds the semantic index | The embedding model |

When a model a command needs is missing or not yet checked, the command is refused before
it starts, says which model it is waiting for, and points you to
`growther qmd-run search` and `growther qmd-run pull`.

## Checking it

```bash
growther qmd-run doctor
```

This reports which models the search engine can see and whether the search index is
healthy.

The search engine also appears as **QMD** under **Settings › Extensions**. It is part of
C5, so it has no on/off switch there. If a file at a model's name is still being copied,
could not be read, or could not be set aside, C5 still starts the search engine, but
leaves that file out of its reach: keyword search and the document tools work, and that
model counts as missing until C5 has checked the file. Only if C5 cannot give the search
engine its folder of checked files (see [Where they go](#where-they-go)) does it keep the
search engine stopped; the QMD entry then shows a warning rather than a failure.

## Changing the models

The three models above are the only ones C5 downloads and the only ones it checks. If you
point the search engine at a different Hugging Face model in its own configuration (a
`models:` block in its config file, or the `QMD_EMBED_MODEL` variable), that model is
never downloaded, because the engine's processes cannot download. If you point it at a
model file on your disk by its path instead, the engine loads that file as it is: C5 does
not check a model you name by path.

If you change the embedding model after the index was built, rebuild the index
with `growther qmd-run embed -f`. Results from different embedding models cannot be
compared, so semantic search returns nothing until the index is rebuilt.

## Windows on ARM

Windows on ARM has no build of the component that stores the semantic search index. On
that platform keyword search, indexing and document access all work normally; semantic
search does not. Every other platform has the full set.

C5 still downloads all three models there (about 2.26 GB). If you do not want the
download, set
`GROWTHER_QMD_NO_AUTO_DOWNLOAD=1` or use the offline posture, as in
[Turning the automatic download off](#turning-the-automatic-download-off).

## Related

- [Network and egress](../configuration/network.md) — the offline switch, the proxy, and
  every host C5 contacts
- [Where your data lives](../configuration/data-location.md) — moving the caches to
  another disk
- [Common issues](../troubleshooting/common-issues.md) — disk space, and a model set aside
  as `.rejected`
- [Open-source licences and downloaded models](../security/open-source-and-models.md) —
  every model C5 downloads, its licence, and the notices that ship with C5
- [Environment variables](../cli/environment.md) — where to set
  `GROWTHER_QMD_NO_AUTO_DOWNLOAD` when C5 starts at sign-in
