#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Installing Zed"

if command -v zed &>/dev/null; then
  ok "Zed already installed ($(zed --version 2>/dev/null || echo unknown))"
  exit 0
fi

require_cmd curl
curl -f https://zed.dev/install.sh | sh
ok "Zed installed"

if command -v zed &>/dev/null; then
  ok "Zed available on PATH"
else
  warn "Zed install finished — restart your shell if zed is not found"
fi
