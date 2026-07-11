#!/usr/bin/env bash
# OpenZed — AI dev stack for Fedora: Zed + OpenCode
#
# Usage:
#   ./install.sh
#   OPENZED_MODEL=~anthropic/claude-haiku-latest ./install.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib.sh
source "$ROOT/scripts/lib.sh"

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      cat <<EOF
OpenZed installer

  ./install.sh              Install OpenCode, Zed, and configs

Environment (see .env.example):
  OPENZED_MODEL         Primary coding model (default: deepseek/deepseek-v4-flash)
  OPENZED_SMALL_MODEL   Lightweight model (default: deepseek/deepseek-v4-flash)
  OPENZED_BIN_DIR       Binary install dir (default: ~/.local/bin)
  OPENROUTER_API_KEY    API key for OpenRouter models (required for OpenRouter models)
  OPENCODE_API_KEY      API key for OpenCode Zen models (optional)
EOF
      exit 0
      ;;
    *) die "Unknown option: $arg (try --help)" ;;
  esac
done

echo ""
echo "  OpenZed"
echo "  Zed + OpenCode on Fedora"
echo ""

"$ROOT/scripts/install-opencode.sh"
"$ROOT/scripts/install-zed.sh"
"$ROOT/scripts/install-config.sh"

echo ""
ok "OpenZed setup complete"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell (or: export PATH=\"$OPENZED_BIN_DIR:\$PATH\")"
echo "    2. Set OPENROUTER_API_KEY in .env for OpenRouter models"
echo "    3. In Zed: agent: new thread → OpenCode"
echo "    4. Or in a terminal: opencode"
echo ""
