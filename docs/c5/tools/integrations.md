---
title: Integrations
description: Connect C5 to the services and programs you already use.
order: 4
---

# Integrations

An **integration** connects C5 to something you already use, so your agents can work
with it directly.

## Which services can I connect?

The current list is in the app — it is the accurate answer, and it grows between
releases, which is why this page does not try to repeat it. It is spread over three tabs:

- **Settings › Integrations** — the model providers and agent gateways (OpenClaw, Hermes
  Agent, PicoClaw) your agents run on, and GitHub for backups. See
  [Model providers](/c5/configuration/model-providers).
- **Settings › Communications** — chat platforms such as Slack, Discord, Teams and Telegram.
- **Settings › Extensions** — everything else, as [MCP servers](/c5/tools/mcp-servers), an
  open standard for adding abilities. Many services already have one.

## Setting one up

1. Go to **Settings**.
2. Open the tab that holds the service (above).
3. Pick the service you want.
4. Follow the steps to connect it.
5. Click **Save** (on **Communications**, **Save Platform**). On **Extensions**, installing the
   server is the last step.

Most services connect by pasting in a key, or by signing in and approving access.

## Choosing what it can do

Every integration lets you pick how much access to give. Give the least that gets the
job done.

If an agent only needs to read your calendar, do not also let it delete events. You can
always add more later.

> **Tip**
> Where a service supports it, make a separate key just for C5. If you ever want to cut
> access, you can turn off that one key without disturbing anything else.

## Checking the connection

Each provider and gateway on **Settings › Integrations** shows whether C5 can reach it:
**Online** or **Offline**, or **Key rejected** or **No key** when the problem is C5's key for
it. MCP servers show their own state on **Settings › Extensions**
(see [Checking it worked](/c5/tools/mcp-servers#checking-it-worked)).

C5 tests the connection when you save, so you find out immediately rather than when a
task fails at midnight.

## Keys and secrets

Keys you paste in are stored encrypted on your own computer. They are never sent
anywhere except to the service they belong to.

You can replace or remove a key at any time. Removing it stops all access right away.

See [Local encryption](/c5/security/encryption) for how storage works.

## When something stops working

Integrations usually break for boring reasons:

- **The key expired.** Make a new one and paste it in.
- **A password changed.** Reconnect.
- **Access was revoked** on the other service's side.
- **The service is down.** Check its status page.

Open the service's tab in **Settings** and reconnect. C5 tests the connection as you save, so
you find out immediately rather than when a task fails at midnight.

## Removing an integration

Open its tab in **Settings**, find it, and turn it off or remove it. Access stops
immediately. Work that
already used it stays in your Library.

## Where to go next

- [MCP servers](/c5/tools/mcp-servers) — add abilities beyond the built-in list.
- [Permissions](/c5/security/permissions) — control what agents may do with a connection.
