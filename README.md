# OpenZed

Zed + OpenCode + Ollama with prewired config.

## Install

```bash
git clone https://github.com/thenry42/OpenZed.git
cd OpenZed
./install.sh
```

This installs Ollama, OpenCode, Zed, and configures everything.

Zed alone: `./scripts/install-zed.sh`

## Use

```bash
export PATH="$HOME/.local/bin:$PATH"
opencode
```

Or open Zed and start an `OpenCode` thread.

## Config

- Local Ollama at `http://localhost:11434/v1`
- Default: `OPENZED_MODEL=gemma4:latest`
- Override: `OPENZED_MODEL=qwen2.5-coder:7b ./install.sh`
- Skip models: `./install.sh --skip-models`

Export `ANTHROPIC_API_KEY` or `OPENROUTER_API_KEY` before running for paid models.