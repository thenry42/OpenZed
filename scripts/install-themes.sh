#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Installing themes"

ZED_DIR="$HOME/.config/zed"
OPENCODE_DIR="$HOME/.config/opencode"

install_theme_dir() {
  local src="$1" dest="$2"
  [[ -d "$src" ]] || return 0

  local count=0
  mkdir -p "$dest"
  for theme in "$src"/*.json; do
    [[ -f "$theme" ]] || continue
    cp -f "$theme" "$dest/"
    count=$((count + 1))
  done

  if (( count > 0 )); then
    ok "Installed $count theme(s) into $dest"
  fi
}

install_theme_dir "$OPENZED_ROOT/config/zed/themes" "$ZED_DIR/themes"
install_theme_dir "$OPENZED_ROOT/config/opencode/themes" "$OPENCODE_DIR/themes"

TUI_SRC="$OPENZED_ROOT/config/opencode/tui.json"
TUI_DEST="$OPENCODE_DIR/tui.json"

if [[ -f "$TUI_SRC" ]]; then
  python3 - "$TUI_SRC" "$TUI_DEST" <<'PY'
import json, sys

src, dest = sys.argv[1], sys.argv[2]

with open(src) as f:
    patch = json.load(f)

try:
    with open(dest) as f:
        tui = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    tui = {}

tui.update(patch)

with open(dest, "w") as f:
    json.dump(tui, f, indent=2)
    f.write("\n")
PY
  ok "Wrote $TUI_DEST"
fi
