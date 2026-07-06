#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Pulling Ollama models"

require_cmd ollama

pull() {
  local model="$1"
  if ollama show "$model" &>/dev/null; then
    ok "$model already present"
  else
    info "Pulling $model (this may take a while)..."
    ollama pull "$model"
    ok "Pulled $model"
  fi
}

pull "$OPENZED_MODEL"

if [[ "$OPENZED_SMALL_MODEL" != "$OPENZED_MODEL" ]]; then
  pull "$OPENZED_SMALL_MODEL"
fi
