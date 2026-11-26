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
2. Open the **Extensions** tab.
3. Select **Add Extension**. The **Install MCP Server** card opens.
4. Pick a server from **Curated Marketplace**, fill in any keys it asks for, and select
   **Install Server**. Or choose **Custom Config** and fill in **Server Name**, **Command**
   (such as `npx`, `python` or `docker`), **Arguments** and any **Environment Variables**,
   then select **Install Custom Server**.

C5 connects and lists the abilities the server offers. You then choose which ones your
agents may use.

The keys and settings a server needs are kept in C5's configuration file, `c5.yaml`, and
removed with the server. A server cannot use that to change how C5 itself is run: C5
refuses any key that would change its network settings (the proxy, certificate
authorities, the platform address) or who may sign in (the identity provider, which group
becomes an administrator, whether single sign-on is required, the SCIM token). Removing a
server never removes your own values for those keys.

## Checking it worked

After adding a server, its row under **Settings › Extensions** shows its state:

- **CONNECTED** — working, and its tools are available.
- **OFFLINE** — not connected. The reason is shown beside it.
- **DISABLED** — you switched it off with its toggle.

If it is offline, the usual causes are a wrong command, a missing key, or the server
needing something installed first.

## Turning individual abilities on and off

A server might offer ten abilities when you only want two. Each ability is a tool with its
own rules, so agents only get what you meant to give them: set it to **Prompt** under
**Master Tool Authorizations**, on the same **Extensions** tab, to be asked every time, or
answer **Always Deny** when an agent asks for one you never want used. See
[Permissions](/c5/security/permissions#setting-the-level).

Start with less. Turn on more when you find you need it.

> **Warning**
> An MCP server is a program running on your computer with the access you give it. Only
> add servers from sources you trust, the same way you would with any software.

## Permissions still apply

Adding a server does not bypass your rules. Anything an MCP tool does still goes through
the same permission checks as everything else, and still gets recorded. See
[Permissions](/c5/security/permissions).

## Removing one

Open **Settings › Extensions**, find the server, select its delete button and confirm. Its
abilities disappear right away. Work that already finished is unaffected. To stop using a
server for a while without removing it, switch its toggle off instead.

## Where to go next

- [What tools do](/c5/tools/what-tools-do) — the basics.
- [Integrations](/c5/tools/integrations) — connecting services you already use.
