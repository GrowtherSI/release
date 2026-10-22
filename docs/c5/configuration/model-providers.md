---
title: Model providers
description: Connect the SI models your agents think with, including local ones.
order: 2
---

# Model providers

A **provider** is a source of SI models. C5 needs at least one before it can do anything.

You are not locked into a single company. You can connect several and use them for
different jobs.

## Adding a provider

1. Go to **Settings**.
2. Open the **Integrations** tab.
3. Pick the provider you want.
4. Paste in your API key.
5. Click **Save**.

C5 checks the key immediately and tells you if it does not work.

**OpenRouter is set up differently.** Its card in Integrations has no key field: C5 reads
its key from your `.env` file. The card shows whether the connection works, and the
account's credits and usage. Its routing settings have a tab of their own; see
[OpenRouter routing settings](#openrouter-routing-settings).

**Which models a provider lists.** A cloud provider lists the models its own listing named
the last time C5 asked it. Before the first answer, after a failed one, or without a key,
the model pickers fall back to C5's built-in list. MS Azure lists only the deployment you
configured. For your agents, OpenRouter lists the models you picked under **Model
Selection** on its **Config** tab. The classifier's model list is the exception: it offers
every model OpenRouter itself lists (see
[What the classifier's questions carry](#what-the-classifiers-questions-carry)).

## Where keys come from

An **API key** is a long password that lets a program use a service on your behalf. You
get one from the provider's website, usually in a section called API keys or Developers.

> **Warning**
> Treat an API key like a password. Anyone who has it can spend money on your account.
> Never paste one into a chat message or an email.

Your keys are stored encrypted on your own computer and are only ever sent to the
provider they belong to. See [Local encryption](/c5/security/encryption).

## Using many providers at once

Connecting more than one is a good idea:

- **Different strengths.** Some models are better at some things.
- **Different prices.** Cheap models for easy work, strong models for hard work.
- **A backup.** If one provider goes down, C5 can use another.

See [Choosing models](/c5/agents/model-routing) for how to match jobs to models.

## Running models on your own computer

You can run models locally with no outside service at all. This means:

- **No cost per use**
- **Nothing leaves your machine**
- **It keeps working with no internet**

The trade-off is that local models are usually less capable than the best paid ones, and
they need a reasonably powerful computer.

To connect one, choose the local option under **Integrations** and point C5 at where your local
model is running. C5 checks the connection and lists the models it finds.

## Gateways

A gateway is a service that gives you many models through a single key. If you use one,
connect it like any other provider and C5 will list everything it offers.

This is a simple way to try lots of models without signing up everywhere.

## OpenRouter routing settings

While OpenRouter is turned on in **Settings › Integrations**, Settings has a tab for its
routing settings. The tab is labelled **Config**, with OpenRouter's icon; hover it to read
_OpenRouter Config_. (Each provider and gateway you turn on can add a **Config** tab of its
own, so look for the icon.) The settings are grouped as **Auto-Router & Models**,
**Complexity Routing**, **Provider Preferences**, **Hardware & Data** and **Plugins**, and
**Raw JSON** shows the whole file, `openrouter_config.json`. Nothing applies until you
press **Save**, which needs permission to edit settings.

### Price caps

**Max Prompt Price** and **Max Completion Price**, under **Provider Preferences**, are in US
dollars per million tokens. They are hard limits: OpenRouter uses only providers at or
below them, and a request fails when no provider is that cheap. **0** means free providers
only. A negative or non-numeric entry is saved as no limit.

**A stored 0 waits for you.** An earlier version of this tab showed a stored 0 as blank, so
a 0 could be saved without anyone seeing it. Until you confirm such a 0, C5 leaves it out
of chat and task requests, and **Provider Preferences** says so: _Not applied to chats and
tasks: Max Prompt Price is 0, which allows free providers only. …_ Choose **Keep 0 as the
limit** or **Clear the 0**, then **Save**. Saving another setting does not confirm it.
Questions the classifier sends to an OpenRouter model apply a stored 0 either way, so they
use free providers only.

### Other settings

- **Model Selection**: the models to use, in order. _A request carries at most three: the
  agent's own model first, then the next ones in this order._ The models you pick here are
  also the OpenRouter models your agents can choose from. They are not the classifier's
  choice: its list offers the models OpenRouter lists that it could choose, and choosing
  one there never adds it here or changes the order a chat or task tries.
- **Allow Fallbacks**: whether OpenRouter may use a backup _provider_ for the same model
  when the first is unavailable (true by default). It is not about fallback models; those
  are the Model Selection list.
- **Sort Strategy**: **Price**, **Throughput** or **Latency**, or **-- (Balanced)**.
  **Global Sort Partition** ranks the providers of every model in the list together, and
  needs a sort strategy: while Balanced it is off and nothing is sent for it.
- **Data Collection**: **deny** routes only to providers that do not collect your data. It
  is not Zero Data Retention, a stricter OpenRouter filter you set in **Raw JSON** as
  `"zdr": true`.
- **Response Healing**: OpenRouter repairs malformed JSON in a reply, only for replies that
  are not streamed and were asked for as JSON.
- **Middle-out compression** has no control on the tab: set `"middle_out_compression": true`
  in **Raw JSON**, and chat and task requests carry OpenRouter's context compression.

**A reply is asked for as JSON only where the work needs one**, for every agent, whether or
not this tab was ever saved. Up to v329, once the tab had been saved, a request from an agent
whose name contains `planner` was always asked for JSON, which broke the plans and routing
answers C5 reads line by line; such plans now work as with every other provider.

### Provider lists and plugins

- **Provider Order**, **Allowed Providers** and **Ignored Providers** take OpenRouter
  _provider_ slugs — who serves a model, such as `deepinfra` or `together` — not who made
  it. The tab shows them; set them in **Raw JSON** as `"order"`, `"only"` and `"ignore"`.
- **Plugins**: the switches under **Plugins** turn a plugin on or off by its name (`"web"`,
  `"response_healing"`, `"context-compression"`). To give a plugin options, write it in
  **Raw JSON** as an entry with an `id`, such as `{"id": "web", "max_results": 3}`; to keep
  one off, give it `"enabled": false`. A save from the tab keeps such an entry with its
  options. Its switch shows what requests carry: on, unless the entry says
  `"enabled": false`. Flipping that switch changes only `enabled`, and keeps the options.

### When a save is refused

If a value cannot be used, nothing is saved, and the message names the first problem, for
example _OpenRouter settings were not saved: sort must be one of price, throughput, latency,
exacto (got "fastest")._ While **Raw JSON** holds something that does not parse, the tab
says so and keeps the last valid settings.

### If C5 cannot read these settings

Your price caps and provider limits travel with every chat and task request to OpenRouter.
If C5 cannot read them at the moment of a request — the database did not answer, or what is
stored is not a settings object — it never sends that request without them:

- **It sends the limits it last read** since C5 started, so a passing fault changes nothing
  you would notice.
- **If it has not read them once since starting**, it refuses the request instead: _C5
  cannot read your OpenRouter routing limits (OpenRouter's Config tab in Settings), so it did
  not send this request: it never sends one without your price caps and provider limits.
  Check them in OpenRouter's Config tab in Settings._ The request is not retried on its own.

(That is the **Config** tab with OpenRouter's icon, the same place the classifier's notes
name.) C5 writes this to its log once per start, not once per request. If the refusal persists, open the
**Config** tab: if the tab cannot show your settings either, run `growther doctor`.

**Fleet › Assignment** never erases these settings either. Giving agents an OpenRouter
model there saves it with the rest of OpenRouter's settings, so when C5 cannot read them
first, it changes nothing and says so: _Could not set M for OpenRouter: C5 could not read
its current settings, so it changed nothing._ The same holds for the local model pool.
Try again once the settings can be read.

### What the classifier's questions carry

The classifier's model list for OpenRouter (see
[A model from your providers](/c5/tools/local-classifier#a-model-from-your-providers)) offers
the models OpenRouter lists, read from OpenRouter's public list of models, with your key,
through your proxy if you set one. C5 reads it only where a classifier model from OpenRouter
could be chosen — **Models allowed from** at **Anywhere**, OpenRouter turned on, and your
organisation's policy allowing it — and offers only the models that policy's
`allowedModels` allows. C5 keeps the list for ten minutes. If it cannot read it, the list
shows only your **Model Selection** models and says so: _C5 could not read the models
OpenRouter lists, so this shows only those under Model Selection on its Config tab.
Choosing one here never changes that list._ Choosing or testing a classifier model never
changes these settings, and never changes which models a chat or task tries.

A classifier model chosen from OpenRouter is asked with your data collection, Zero Data
Retention and distillable-text settings, the provider order and the allowed and ignored
providers, quantizations, the sort, the price caps (a stored 0 included), and **Allow
Fallbacks** when it is false. It is never sent the fallback models or the plugins, and C5
asks OpenRouter to use only providers that support every part of the question. If C5 cannot
read these settings, it asks OpenRouter nothing they might rule out.

### If OpenRouter requests fail after an update

Up to C5 v326, the price caps and the sort were sent under names OpenRouter does not read,
so they had no effect. From v327 they work, so a cap below the price of the model a request
is routed to now makes that request fail. Check **Max Prompt Price** and **Max Completion
Price** on the **Config** tab, and confirm or clear a stored 0 there.

## When a provider fails

The usual causes:

- **The key is wrong.** Copy it again — trailing spaces are a classic.
- **The key expired or was revoked.** Make a new one.
- **You are out of credit.** Check your account with the provider.
- **The provider is down.** Check their status page.
- **You hit a rate limit.** C5 slows down and retries by itself.

To re-check a provider's key, open **Settings → Integrations** and save it again. C5 tests
the key as you save and tells you straight away if it does not work.

**A coordinator that keeps failing is tried last.** When 3 of its last 5 answers come back
as an error or empty, or 3 of its last 5 attempts get a server error, a refused connection
or a dead gateway, C5 moves it to the end of the order for a while: a minute at first,
doubling each time it fails again, up to 15 minutes. Saving the provider again does not end
that; a good answer, the time running out, or restarting C5 does. Hover a chip for why and
for how long:

- **Skipped — repeated failed generations**: its answers came back empty or broken.
- **Tried last — repeated gateway errors**, in amber beside its status: its gateway answered
  with server errors, refused the connection, or was down. Its status check can still
  answer, so the card may read **Online** at the same time. It is still tried, after every
  other coordinator.

When both apply, only **Skipped** is shown. See
[Choosing models](/c5/agents/model-routing#when-a-model-is-unavailable).

## Where to go next

- [Choosing models](/c5/agents/model-routing) — match the model to the job.
- [Budgets](/c5/using-c5/ops) — keep spending under control.
