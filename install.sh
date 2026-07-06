#!/usr/bin/env bash
# OpenZed — local AI dev stack for Fedora: Zed + OpenCode + Ollama
#
# Usage:
#   ./install.sh              # full install
#   ./install.sh --skip-models  # skip ollama pull (large downloads)
#   OPENZED_MODEL=qwen2.5-coder:7b ./install.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib.sh
source "$ROOT/scripts/lib.sh"

SKIP_MODELS=false

for arg in "$@"; do
  case "$arg" in
    --skip-models) SKIP_MODELS=true ;;
    -h|--help)
      cat <<EOF
OpenZed installer

  ./install.sh              Install Ollama, OpenCode, Zed, configs, and pull models
  ./install.sh --skip-models  Skip model download

Environment (see .env.example):
  OPENZED_MODEL         Primary coding model (default: gemma4:latest)
  OPENZED_SMALL_MODEL   Lightweight model (default: qwen3.5:9b)
  OPENZED_BIN_DIR       Binary install dir (default: ~/.local/bin)
EOF
      exit 0
      ;;
    *) die "Unknown option: $arg (try --help)" ;;
  esac
done

echo ""
echo "  OpenZed"
echo "  Zed + OpenCode + Ollama on Fedora"
echo ""

"$ROOT/scripts/install-ollama.sh"
"$ROOT/scripts/install-opencode.sh"
"$ROOT/scripts/install-zed.sh"
"$ROOT/scripts/install-config.sh"

if [[ "$SKIP_MODELS" == false ]]; then
  "$ROOT/scripts/pull-model.sh"
else
  warn "Skipped model pull — run: ollama pull $OPENZED_MODEL"
fi

echo ""
ok "OpenZed setup complete"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell (or: export PATH=\"$OPENZED_BIN_DIR:\$PATH\")"
echo "    2. In Zed: agent: new thread → OpenCode"
echo "    3. Or in a terminal: opencode"
echo ""
