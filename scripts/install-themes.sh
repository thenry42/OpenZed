#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Installing themes"

ZED_DIR="$HOME/.config/zed"
OPENCODE_DIR="$HOME/.config/opencode"

# Install themes into ZED
if [[ -d "$OPENZED_ROOT/config/zed/themes" ]]; then
  mkdir -p "$ZED_DIR/themes"
  count=0
  for theme in "$OPENZED_ROOT/config/zed/themes"/*.json; do
    [[ -f "$theme" ]] || continue
    cp -f "$theme" "$ZED_DIR/themes/"
    count=$((count + 1))
  done
  if (( count > 0 )); then
    ok "Installed $count theme(s) into $ZED_DIR/themes"
  fi
fi

# Install themes into OpenCode
if [[ -d "$OPENZED_ROOT/config/opencode/themes" ]]; then
  mkdir -p "$OPENCODE_DIR/themes"
  count=0
  for theme in "$OPENZED_ROOT/config/opencode/themes"/*.json; do
    [[ -f "$theme" ]] || continue
    cp -f "$theme" "$OPENCODE_DIR/themes/"
    count=$((count + 1))
  done
  if (( count > 0 )); then
    ok "Installed $count theme(s) into $OPENCODE_DIR/themes"
  fi
fi

TUI_SRC="$OPENZED_ROOT/config/opencode/tui.json"
TUI_DEST="$OPENCODE_DIR/tui.json"

if [[ -f "$TUI_SRC" ]]; then
  python3 "$OPENZED_ROOT/config/patch.py" generic "$TUI_SRC" "$TUI_DEST"
  ok "Wrote $TUI_DEST"
fi
