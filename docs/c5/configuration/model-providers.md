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
configured. OpenRouter lists the models you picked under **Model Selection** on its
**Config** tab.

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
  also the OpenRouter models the agents and the classifier can choose from.
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

### Provider lists and plugins

- **Provider Order**, **Allowed Providers** and **Ignored Providers** take OpenRouter
  _provider_ slugs — who serves a model, such as `deepinfra` or `together` — not who made
  it. The tab shows them; set them in **Raw JSON** as `"order"`, `"only"` and `"ignore"`.
- **Plugins** are kept by name only (`"web"`, `"response_healing"`,
  `"context-compression"`). A plugin entry with options, such as
  `{"id": "web", "max_results": 3}`, cannot be set on the tab, **Raw JSON** included, and a
  save from the tab removes one that was stored some other way.

### When a save is refused

If a value cannot be used, nothing is saved, and the message names the first problem, for
example _OpenRouter settings were not saved: sort must be one of price, throughput, latency,
exacto (got "fastest")._ While **Raw JSON** holds something that does not parse, the tab
says so and keeps the last valid settings.

### What the classifier's questions carry

A classifier model chosen from OpenRouter (see
[A model from your providers](/c5/tools/local-classifier#a-model-from-your-providers)) is
asked with your data collection, Zero Data Retention and distillable-text settings, the
provider order and the allowed and ignored providers, quantizations, the sort, the price
caps (a stored 0 included), and **Allow Fallbacks** when it is false. It is never sent the
fallback models or the plugins, and C5 asks OpenRouter to use only providers that support
every part of the question. If C5 cannot read these settings, it asks OpenRouter nothing
they might rule out.

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

To re-check a provider, open **Settings → Integrations** and save it again. C5 tests the
key as you save and tells you straight away if it does not work.

## Where to go next

- [Choosing models](/c5/agents/model-routing) — match the model to the job.
- [Budgets](/c5/using-c5/ops) — keep spending under control.
