# OpenZed

Zed + [OpenCode](https://opencode.ai) — preconfigured AI dev stack.

## Quick start

```bash 
git clone https://github.com/thenry42/OpenZed.git
cd OpenZed
cp .env.example .env   # edit: add your OPENROUTER_API_KEY
./install.sh
```

Installs OpenCode, Zed, configs, and themes.

**Zed only** (no OpenCode): `./scripts/install-zed.sh`

## Use

```bash
opencode
```

Or open Zed → **agent: new thread** → pick `OpenCode`.

Make sure `~/.local/bin` is on your `PATH` (installer adds it to `.zshrc`/`.bashrc`).

## Configuration

Override the default model before installing:

```bash
OPENZED_MODEL=~anthropic/claude-sonnet-latest ./install.sh
```

| Env var | Default | What it does |
|---|---|---|
| `OPENROUTER_API_KEY` | — | API key for OpenRouter (required) |
| `OPENZED_MODEL` | `deepseek/deepseek-v4-flash` | Primary model |

## Customizing

All config lives in `config/opencode/`. Edit files here, then re-run `./install.sh` to sync to `~/.config/opencode/`.

The three customization types work at different levels:

| Type | Purpose | When it runs |
|---|---|---|
| **Agent** | A full persona with its own tool permissions (read-only, deploy, etc.) | You pick it from a list when starting a thread |
| **Skill** | Background instructions that activate automatically when the task matches | The model detects the right moment and loads it |
| **Command** | A fixed step-by-step recipe the model follows on request | You type `/command-name` in chat |

### Agents — different personas

Each agent is a separate mode with its own tool access. The `ask` agent can only read — useful for quick questions without risking changes.

`config/opencode/agents/ask.md`:

```markdown
---
description: Answers codebase questions without making changes
mode: primary
permissions:
  read: allow
  edit: deny
  write: deny
  bash: deny
---

You are a read-only Q&A agent. Use read/search tools only — never write or execute.
```

Add a `deploy` agent with ssh/bash access, or a `review` agent that can only read and comment.

### Skills — auto-activated instructions

Skills encode project conventions that the model loads automatically when relevant.

`config/opencode/skills/python-flake8/SKILL.md`:

```markdown
---
name: python-flake8
description: activated when working with python files
---

- Run `flake8` before committing
- Fix all lint warnings
```

### Commands — `/slash` recipes

Commands are fixed workflows the model runs when you type `/command-name`.

`config/opencode/command/review.md`:

```markdown
---
description: "Request a code review of the current changes"
---

1. Run `git diff` to see uncommitted changes
2. Check for error handling, edge cases, and security issues
3. Summarize findings in a bullet list
4. Suggest specific improvements
```

Type `/review` in chat to run it.
