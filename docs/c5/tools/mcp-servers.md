---
title: MCP servers
description: Add new abilities to your agents using a shared open standard.
order: 2
---

# MCP servers

**MCP** stands for Model Context Protocol. It is an open standard for giving SI agents
new abilities.

Because it is a standard, tools built for it work with C5 without anyone writing special
code for each one. If someone publishes an MCP server for a service, your agents can use
it.

## What an MCP server gives you

Each server adds a set of abilities. There are servers for things like:

- Working with a particular database
- Using a specific company's service
- Reading a certain kind of file
- Talking to an internal system your team runs

## Adding one

1. Go to **Settings**.
2. Open the **Integrations** tab.
3. Choose **Add MCP server**.
4. Give it a name and the command or address it runs at.
5. Add any keys or settings it needs.
6. Save.

C5 connects and lists the abilities the server offers. You then choose which ones your
agents may use.

## Checking it worked

After adding a server, C5 shows its state:

- **Connected** — working, and its tools are available.
- **Connecting** — still starting up.
- **Failed** — could not connect. C5 shows the reason.

If it failed, the usual causes are a wrong command or address, a missing key, or the
server needing something installed first.

## Turning individual abilities on and off

A server might offer ten abilities when you only want two. You can switch them on and
off one by one, so agents only get what you meant to give them.

Start with less. Turn on more when you find you need it.

> **Warning**
> An MCP server is a program running on your computer with the access you give it. Only
> add servers from sources you trust, the same way you would with any software.

## Permissions still apply

Adding a server does not bypass your rules. Anything an MCP tool does still goes through
the same permission checks as everything else, and still gets recorded. See
[Permissions](/c5/security/permissions).

## Removing one

Open **Integrations**, find the server, and remove it. Its abilities disappear right
away. Work that already finished is unaffected.

## Where to go next

- [What tools do](/c5/tools/what-tools-do) — the basics.
- [Integrations](/c5/tools/integrations) — connecting services you already use.
