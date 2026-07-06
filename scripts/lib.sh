#!/usr/bin/env bash
# Shared helpers for OpenZed install scripts.

set -euo pipefail

OPENZED_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OPENZED_MODEL="${OPENZED_MODEL:-deepseek/deepseek-v4-flash}"
OPENZED_SMALL_MODEL="${OPENZED_SMALL_MODEL:-deepseek/deepseek-v4-flash}"
OPENZED_BIN_DIR="${OPENZED_BIN_DIR:-$HOME/.local/bin}"

if [[ -f "$OPENZED_ROOT/.env" ]]; then
  # shellcheck source=/dev/null
  source "$OPENZED_ROOT/.env"
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MUTED='\033[0;2m'
NC='\033[0m'

info()  { echo -e "${BLUE}==>${NC} $*"; }
ok()    { echo -e "${GREEN}   ✓${NC} $*"; }
warn()  { echo -e "${MUTED}   !${NC} $*"; }
die()   { echo -e "${RED}error:${NC} $*" >&2; exit 1; }

ensure_bin_dir() { mkdir -p "$OPENZED_BIN_DIR"; }

ensure_path() {
  mkdir -p "$OPENZED_BIN_DIR"
  case ":$PATH:" in
    *":$OPENZED_BIN_DIR:"*) return 0 ;;
  esac

  local shell_rc=""
  case "$(basename "${SHELL:-bash}")" in
    zsh)  shell_rc="${ZDOTDIR:-$HOME}/.zshrc" ;;
    fish) shell_rc="$HOME/.config/fish/config.fish" ;;
    *)    shell_rc="$HOME/.bashrc" ;;
  esac

  if [[ -f "$shell_rc" ]] && ! grep -qF "$OPENZED_BIN_DIR" "$shell_rc" 2>/dev/null; then
    {
      echo ""
      echo "# OpenZed"
      echo "export PATH=\"$OPENZED_BIN_DIR:\$PATH\""
    } >> "$shell_rc"
    ok "Added $OPENZED_BIN_DIR to PATH in $shell_rc"
  else
    warn "Ensure $OPENZED_BIN_DIR is on your PATH"
  fi
}

require_cmd() { command -v "$1" &>/dev/null || die "'$1' is required but not installed"; }
