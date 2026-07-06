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
  if [[ -f "$OPENCODE_DEST" && ! -L "$OPENCODE_DEST" ]]; then
    cp "$OPENCODE_DEST" "${OPENCODE_DEST}.bak.$(date +%Y%m%d%H%M%S)"
    warn "Backed up existing opencode.json"
  else
    rm -f "$OPENCODE_DEST"
    warn "Removed existing opencode.json symlink or stale file"
  fi
fi

export OPENZED_MODEL OPENZED_SMALL_MODEL OPENZED_OLLAMA_URL OPENZED_BIN_DIR
python3 - "$OPENCODE_SRC" "$OPENCODE_DEST" <<'PY'
import json, os, sys

src, dest = sys.argv[1], sys.argv[2]
model = os.environ["OPENZED_MODEL"]
small = os.environ["OPENZED_SMALL_MODEL"]
base_url = os.environ["OPENZED_OLLAMA_URL"]

with open(src) as f:
    cfg = json.load(f)

cfg["provider"]["ollama"]["options"]["baseURL"] = base_url
cfg["model"] = f"ollama/{model}"
cfg["small_model"] = f"ollama/{small}"

models = cfg["provider"]["ollama"]["models"]
models.clear()
models[model] = {"name": model, "tools": True}
models[small] = {"name": small, "tools": True}

with open(dest, "w") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")
PY

ok "Wrote $OPENCODE_DEST"

# --- Zed settings.json (merge agent_servers) ---
ZED_DEST="$ZED_DIR/settings.json"
ZED_SRC="$OPENZED_ROOT/config/zed/settings.json"

python3 - "$ZED_SRC" "$ZED_DEST" <<'PY'
import json, os, sys

src, dest = sys.argv[1], sys.argv[2]
opencode_cmd = os.path.join(os.environ["OPENZED_BIN_DIR"], "opencode")

with open(src) as f:
    patch = json.load(f)

if "agent_servers" in patch and "OpenCode" in patch["agent_servers"]:
    patch["agent_servers"]["OpenCode"]["command"] = opencode_cmd

try:
    with open(dest) as f:
        settings = json.load(f)
except (FileNotFoundError, IsADirectoryError, json.JSONDecodeError):
    settings = {}

for key, value in patch.items():
    if key == "agent_servers" and key in settings:
        settings[key].update(value)
    else:
        settings[key] = value

with open(dest, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
PY

ok "Merged Zed settings into $ZED_DEST"

"$SCRIPT_DIR/install-themes.sh"
