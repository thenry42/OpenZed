# OpenZed

`OpenZed` gives you a simple `Zed` + `OpenCode` + `Ollama` setup with the config already wired.

The default flow is local-first with Ollama, but you can also export API keys for `Anthropic`, `OpenRouter`, and Ollama Cloud when you want hosted models.

## Install

```bash
git clone https://github.com/thenry42/OpenZed.git
cd OpenZed
./install.sh
```

What the installer does:

- installs `Ollama`
- installs `OpenCode`
- installs `Zed`
- writes `~/.config/opencode/opencode.json`
- merges `~/.config/zed/settings.json`
- pulls the default models unless you pass `--skip-models`

Or install Zed alone:

```bash
./scripts/install-zed.sh
```

## Use

After install:

```bash
export PATH="$HOME/.local/bin:$PATH"
opencode
```

Or open `Zed` and start a new thread with `OpenCode`.

## Defaults

OpenCode is pointed at local Ollama:

```text
http://localhost:11434/v1
```

Default models:

- `OPENZED_MODEL=gemma4:latest`
- `OPENZED_SMALL_MODEL=qwen3.5:9b`

Override them when installing:

```bash
OPENZED_MODEL=qwen2.5-coder:7b ./install.sh
```

Skip model downloads:

```bash
./install.sh --skip-models
```

## Optional cloud providers

If you want hosted providers, export the variables listed in `.env.example` before launching `OpenCode`:

```bash
ANTHROPIC_API_KEY=...
ANTHROPIC_BASE_URL=https://api.anthropic.com

OPENROUTER_API_KEY=...
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1

OLLAMA_API_KEY=...
OPENZED_OLLAMA_CLOUD_URL=https://ollama.com/v1
```

## Config

- `config/opencode/opencode.json` is the base OpenCode template
- `config/zed/settings.json` adds the `OpenCode` ACP server to Zed
- `scripts/install-config.sh` renders and installs both configs

The OpenCode config includes the `opencode-ponytail` plugin.

If you edit repo config, re-run:

```bash
./scripts/install-config.sh
```

## Troubleshooting

If `opencode` is not found, add `~/.local/bin` to your `PATH`.

If OpenCode cannot reach Ollama, check Ollama is running:

```bash
curl http://localhost:11434/api/tags
```

If Zed does not show `OpenCode`, make sure `opencode` is available in the environment Zed launches with.

## License

MIT
