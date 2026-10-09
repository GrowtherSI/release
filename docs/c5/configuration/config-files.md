---
title: Config files
description: Manage your keys, coordinator addresses, and settings in ~/.growther/config/c5.yaml.
order: 3
---

# Config files

Most of the time, you manage C5 through the web interface in **Settings**.

Behind the scenes, C5 keeps your API keys, local coordinator addresses, and bootstrap
settings in a single file on your computer:

```text
~/.growther/config/c5.yaml
```

*(If you used an older version of C5, this replaces the deprecated `~/.growther/.env` file.)*

## What is in `c5.yaml`

The file is organized into clear sections:

- **Core & System Settings** — Your license key seed and port. The home directory is **not**
  one of them: as a *setting*, `GROWTHER_HOME` in `c5.yaml` is ignored and C5 says so, because
  the home has to be known before this file can be found. It is resolved from the launcher
  environment and `home.json` instead. (One exception: a legacy `GROWTHER_HOME:` line in the
  *default* home's `c5.yaml` is still honoured once at boot and migrated into `home.json`.)
  Confirm what your install actually uses with `growther home show` — see
  [Where your data lives](/c5/configuration/data-location).
- **API & MCP Services** — Search tokens (Brave), GitHub access tokens, and chat integrations.
- **LLM Coordinators & Agent Platforms** — Base URLs and keys for local model runners like LM Studio, Ollama, and llama.cpp, and, if you set them, the addresses of the OpenClaw, Hermes and PicoClaw gateways (`OPENCLAW_GATEWAY_URL`, `HERMES_GATEWAY_URL`, `HERMES_DASHBOARD_URL`, `PICOCLAW_GATEWAY_URL`). A gateway address set here wins over the **Host** and **Port** on that gateway's card, which then cannot be edited. See [Local model servers and gateways](/c5/cli/environment#local-model-servers-and-gateways).
- **Cloud LLM Providers** — API keys for Anthropic, OpenAI, Google Gemini, AWS Bedrock, and others.
- **Custom Keys** — Any extra environment variables you add yourself.

Here is a short example of what it looks like:

```yaml
# --- 1. C5 Core & System Settings ---
PORT: "4299"

# --- 2. API & MCP Services ---
BRAVE_API_KEY: "BSAHohpa..."
GITHUB_PERSONAL_ACCESS_TOKEN: ""

# --- 3. LLM Coordinators & Agent Platforms ---
LMSTUDIO_BASE_URL: "http://127.0.0.1:1234/v1"
LMSTUDIO_API_KEY: ""
OLLAMA_BASE_URL: "http://127.0.0.1:11434/v1"
LLAMACPP_BASE_URL: "http://127.0.0.1:8080/v1"
OPENROUTER_API_KEY: ""

# --- 4. Cloud LLM Providers ---
ANTHROPIC_API_KEY: "sk-ant-api03-..."
OPENAI_API_KEY: ""
GEMINI_API_KEY: ""
```

## How changes take effect

You can update your settings in two ways:

1. **In the web interface** — Go to **Settings › Integrations**, paste your key or address, and click **Save**.
2. **By editing the file** — Open `~/.growther/config/c5.yaml` in your favorite text editor, make your changes, and save the file.

### Live updates (Hot reloading)

When you update a coordinator Base URL (like moving LM Studio or Ollama to another machine or port) or add an API key:

- C5 picks up the changes **immediately**.
- You do **not** need to restart the C5 server.
- The model scanner instantly uses your new address to find available models.
- Every other connection C5 makes to that server — health and latency checks, image checks — uses it too.
- To go back to the default address, clear the address on the server's card in **Settings › Integrations** and click **Save**. Deleting the line from this file is not enough: C5 can keep using the address until it restarts, and after that it uses the address stored in Settings. Pressing **Save** there stores the address the card shows, so that is usually the one you deleted.
- A gateway address (`OPENCLAW_GATEWAY_URL` and the others) is never stored in Settings. Delete its line, and once C5 restarts it goes back to the **Host** and **Port** on that gateway's card, or the default.

When C5 writes to this file after you click **Save** in the app, it preserves your existing comments, blank lines, and custom keys.

## File permissions and security

Your `c5.yaml` file holds sensitive passwords and tokens. C5 saves it with owner-only (`0600`) permissions:

- Only your user account can read or write to it.
- Other user accounts on the same computer cannot open it.

> **Warning**
> Treat `c5.yaml` like a password file. Do not commit it to public version control or paste its contents into public messages.
> See [Local encryption](/c5/security/encryption).

## The CLI configuration file (cli.yaml)

Along with `c5.yaml`, C5 keeps your terminal log filter preferences in:

```text
~/.growther/config/cli.yaml
```

This file remembers which log categories (such as `agents`, `database`, `skills`, or `voice`) you
have toggled on or off while running the `growther` command.

- When you press a category hotkey in the terminal, C5 updates `cli.yaml` immediately.
- You can also edit `cli.yaml` in a text editor to choose which logs you want to see before starting C5.
- See [Log filtering](/c5/cli/log-filtering) for the full guide and list of categories.

## Where to go next

- [Log filtering](/c5/cli/log-filtering) — live category filtering and CLI hotkeys.
- [Model providers](/c5/configuration/model-providers) — how to connect cloud and local models.
- [Settings](/c5/configuration/settings) — a full map of the settings screen.
- [Guardrails](/c5/security/guardrails) — safety limits and network allowlists.
