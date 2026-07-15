<p align="center">
  <pre>
 ██████╗ ██████╗ ███████╗███╗   ██╗███████╗███████╗██████╗
██╔═══██╗██╔══██╗██╔════╝████╗  ██║╚══███╔╝██╔════╝██╔══██╗
██║   ██║██████╔╝█████╗  ██╔██╗ ██║  ███╔╝ █████╗  ██║  ██║
██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║ ███╔╝  ██╔══╝  ██║  ██║
╚██████╔╝██║     ███████╗██║ ╚████║███████╗███████╗██████╔╝
 ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝
  </pre>
</p>

> Zed + [OpenCode](https://opencode.ai) — zero-config AI dev stack for Fedora.

<p align="center">
  <img src="https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=fff" alt="Fedora">
  <img src="https://img.shields.io/badge/Zed-084?logo=zedindustries&logoColor=fff" alt="Zed">
  <img src="https://img.shields.io/badge/OpenCode-6366f1?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNmZmYiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMTIgM2wxMCA2djZsLTEwIDYtMTAtNlY5eiIvPjxwb2x5bGluZSBwb2ludHM9IjEyIDE1IDkgMTIgMTIgOSAxNSAxMiIvPjwvc3ZnPg==&logoColor=fff" alt="OpenCode">
  <img src="https://img.shields.io/badge/license-Unlicense-blue" alt="License">
  <br>
  <img src="https://img.shields.io/badge/ai_model-deepseek--v4--flash-FF6F00?logo=deepseek&logoColor=fff" alt="Default model">
  <img src="https://img.shields.io/badge/ai_router-OpenRouter-8B5CF6?logo=openrouter&logoColor=fff" alt="OpenRouter">
</p>

---

## Features

- **One command setup** — installs OpenCode, Zed, configs, and themes
- **Preconfigured AI** — wired to OpenRouter with DeepSeek V4 Flash out of the box
- **Zed inline completions** — Zeta model (free, built-in) for ghost-text autocomplete
- **Custom agents** — `ask` (read-only), `build`, `plan`, or whatever you need
- **Auto-activated skills** — project conventions that load when relevant
- **`/slash` commands** — fixed recipes for code review, deploy, etc.
- **Everything in `~/.local/bin`** — no sudo, no clutter

---

## Quick start

```bash
git clone https://github.com/thenry42/OpenZed.git
cd OpenZed
cp .env.example .env   # add your OPENROUTER_API_KEY
./install.sh
```

> **Zed only?** `./scripts/install-zed.sh` (no OpenCode).

OpenCode-provided models (see below) require an `OPENCODE_API_KEY` and at least **$20 of base credits** on your OpenCode Zen account to route requests through their API. Without either key, the installer falls back to `opencode/deepseek-v4-flash` but it will not work — bring your own key.

---

## Use

```bash
opencode
```

Make sure `~/.local/bin` is on your `PATH` (the installer adds it to `.zshrc`/`.bashrc`).

**In Zed:** OpenCode is already configured as an agent server (`agent: new thread → OpenCode`). Inline completions use Zed's built-in Zeta model — free, no config needed.

---

## Configuration

Override the default model before installing:

```bash
BASE_MODEL=deepseek/deepseek-v4-flash ./install.sh
```

| Env var | Default | What it does |
|---|---|---|
| `OPENROUTER_API_KEY` | — | API key for OpenRouter. Required for OpenRouter models. |
| `OPENCODE_API_KEY` | — | API key for OpenCode-provided models |
| `BASE_MODEL` | `deepseek/deepseek-v4-flash` | Primary coding model (OpenRouter). |

---

## Customizing

All config lives in `config/opencode/`. Edit files here, then `./install.sh` to sync.

### Agents — different personas

Each agent has its own tool permissions. `ask` can only read — safe for quick questions:

```markdown
---
description: Answers codebase questions without making changes
mode: primary
permission:
  read: allow
  edit: deny
  write: deny
  bash: deny
---
```

Add a `deploy` agent with SSH access, or a `review` agent that only reads and comments.

`cat`, `head`, `tail`, and similar file-reading shell commands are denied globally — agents use the `read` tool instead, which respects project ignore rules.

### Skills — auto-activated instructions

Skills encode project conventions and load automatically:

```markdown
---
name: python-flake8
description: activated when working with python files
---

- Run `flake8` before committing
- Fix all lint warnings
```

### Commands — `/slash` recipes

Type `/review` in chat to run a fixed workflow:

```markdown
---
description: "Request a code review of the current changes"
---

1. Run `git diff` to see uncommitted changes
2. Check for error handling, edge cases, and security issues
3. Summarize findings in a bullet list
4. Suggest specific improvements
```

---

## Project structure

```
OpenZed/
├── config/
│   ├── opencode/
│   │   ├── agents/            # custom agent definitions (ask)
│   │   ├── command/           # /slash command recipes
│   │   ├── rules/             # global rules (context7 doc lookup)
│   │   ├── skills/            # auto-activated project skills
│   │   ├── themes/            # OpenCode TUI themes
│   │   ├── opencode.json      # provider, model, permission config
│   │   └── tui.json           # TUI layout
│   ├── zed/
│   │   ├── settings.json      # Zed editor settings + agent server
│   │   └── themes/            # Zed editor themes
│   └── patch.py               # env-aware config renderer
├── scripts/
│   ├── install-opencode.sh
│   ├── install-zed.sh
│   ├── install-config.sh
│   ├── install-themes.sh
│   └── lib.sh                 # shared helpers
├── install.sh                 # one-shot installer
├── .env.example               # env template
├── .gitignore
├── .ignore                    # tool-ignore rules
├── LICENSE
└── README.md
```

---

## License

[The Unlicense](http://unlicense.org/) — public domain. Do whatever you want.
