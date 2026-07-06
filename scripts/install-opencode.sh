#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Installing OpenCode"

ensure_bin_dir
ensure_path

if command -v opencode &>/dev/null; then
  ok "OpenCode already installed ($(opencode --version 2>/dev/null || echo unknown))"
  if [[ ! -x "$OPENZED_BIN_DIR/opencode" ]]; then
    installed="$(command -v opencode)"
    if [[ "$installed" != "$OPENZED_BIN_DIR/opencode" ]]; then
      ln -sf "$installed" "$OPENZED_BIN_DIR/opencode"
      ok "Linked opencode into $OPENZED_BIN_DIR"
    fi
  fi
  exit 0
fi

require_cmd curl

# Official installer; pin to ~/.local/bin when supported.
# Some installer versions ignore XDG_BIN_DIR — we fix up below if needed.
XDG_BIN_DIR="$OPENZED_BIN_DIR" curl -fsSL https://opencode.ai/install | bash

if [[ ! -x "$OPENZED_BIN_DIR/opencode" ]] && command -v opencode &>/dev/null; then
  installed="$(command -v opencode)"
  if [[ "$installed" != "$OPENZED_BIN_DIR/opencode" ]]; then
    ln -sf "$installed" "$OPENZED_BIN_DIR/opencode"
    ok "Linked opencode into $OPENZED_BIN_DIR"
  fi
elif [[ -x "$HOME/.opencode/bin/opencode" && ! -e "$OPENZED_BIN_DIR/opencode" ]]; then
  ln -sf "$HOME/.opencode/bin/opencode" "$OPENZED_BIN_DIR/opencode"
  ok "Linked opencode from ~/.opencode/bin into $OPENZED_BIN_DIR"
fi

if command -v opencode &>/dev/null || [[ -x "$OPENZED_BIN_DIR/opencode" ]]; then
  ok "OpenCode installed"
else
  die "OpenCode install finished but binary not found on PATH"
fi
