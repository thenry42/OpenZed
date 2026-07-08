#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

info "Installing OpenZed configs"

require_cmd python3

OPENCODE_DIR="$HOME/.config/opencode"
ZED_DIR="$HOME/.config/zed"
mkdir -p "$OPENCODE_DIR" "$ZED_DIR"

# --- opencode.json (render model names from env) ---
OPENCODE_DEST="$OPENCODE_DIR/opencode.json"
OPENCODE_SRC="$OPENZED_ROOT/config/opencode/opencode.json"

if [[ -e "$OPENCODE_DEST" || -L "$OPENCODE_DEST" ]]; then
  rm -f "$OPENCODE_DEST"
fi

export OPENZED_MODEL OPENZED_SMALL_MODEL OPENZED_BIN_DIR
python3 "$OPENZED_ROOT/config/patch.py" opencode "$OPENCODE_SRC" "$OPENCODE_DEST"
ok "Wrote $OPENCODE_DEST"

# --- custom commands, skills, and agents ---
for dir in command skills agents rules; do
  src="$OPENZED_ROOT/config/opencode/$dir"
  if [[ -d "$src" ]]; then
    cp -r "$src/" "$OPENCODE_DIR/"
    ok "Copied $dir/ to $OPENCODE_DIR"
  fi
done


# --- Zed settings.json (merge agent_servers) ---
ZED_DEST="$ZED_DIR/settings.json"
ZED_SRC="$OPENZED_ROOT/config/zed/settings.json"

python3 "$OPENZED_ROOT/config/patch.py" zed "$ZED_SRC" "$ZED_DEST"
ok "Merged Zed settings into $ZED_DEST"

"$SCRIPT_DIR/install-themes.sh"
