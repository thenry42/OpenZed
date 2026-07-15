<div align="center">
<pre>
 ██████╗ ██████╗ ███████╗███╗   ██╗███████╗███████╗██████╗
██╔═══██╗██╔══██╗██╔════╝████╗  ██║╚══███╔╝██╔════╝██╔══██╗
██║   ██║██████╔╝█████╗  ██╔██╗ ██║  ███╔╝ █████╗  ██║  ██║
██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║ ███╔╝  ██╔══╝  ██║  ██║
╚██████╔╝██║     ███████╗██║ ╚████║███████╗███████╗██████╔╝
 ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝
</pre>

> Zed + [OpenCode](https://opencode.ai) — zero-config AI dev stack for Fedora.

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
