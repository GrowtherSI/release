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
