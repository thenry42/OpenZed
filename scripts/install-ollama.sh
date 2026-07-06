#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Installing Ollama"

if command -v ollama &>/dev/null; then
  ok "Ollama already installed ($(ollama --version 2>/dev/null || echo unknown))"
else
  require_cmd curl
  curl -fsSL https://ollama.com/install.sh | sh
  ok "Ollama installed"
fi

if systemctl --user is-enabled ollama.service &>/dev/null; then
  ok "Ollama user service already enabled"
elif systemctl --user list-unit-files ollama.service &>/dev/null 2>&1; then
  systemctl --user enable --now ollama.service
  ok "Ollama user service enabled"
else
  warn "No Ollama user service found — starting ollama serve"
  if ! curl -sf http://localhost:11434/api/tags &>/dev/null; then
    nohup ollama serve >/dev/null 2>&1 &
    sleep 2
  fi
fi

if curl -sf http://localhost:11434/api/tags &>/dev/null; then
  ok "Ollama API reachable at http://localhost:11434"
else
  warn "Ollama is not responding yet — it may still be starting"
fi
