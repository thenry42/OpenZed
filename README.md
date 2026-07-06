# OpenZed

Zed + OpenCode with prewired config.

## Install

```bash
git clone https://github.com/thenry42/OpenZed.git
cd OpenZed
cp .env.example .env   # add your OPENROUTER_API_KEY
./install.sh
```

This installs OpenCode, Zed, and configures everything.

Zed alone: `./scripts/install-zed.sh`

## Use

```bash
export PATH="$HOME/.local/bin:$PATH"
opencode
```

Or open Zed and start an `OpenCode` thread.

## Config

- Default models via OpenRouter: `~anthropic/claude-haiku-latest` (primary), `qwen/qwen3-8b` (small)
- Override: `OPENZED_MODEL=~anthropic/claude-sonnet-latest ./install.sh`
- Set `OPENROUTER_API_KEY` in `.env` before installing
