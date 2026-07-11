#!/usr/bin/env python3
"""JSON config patching utility for OpenZed install scripts."""

import json
import os
import sys
from pathlib import Path


def _openrouter_auth_available():
    """True when OpenRouter creds exist in env or opencode auth.json."""
    if os.environ.get("OPENROUTER_API_KEY", ""):
        return True
    auth_path = Path.home() / ".local/share/opencode/auth.json"
    try:
        auth = json.loads(auth_path.read_text())
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        return False
    return bool(auth.get("openrouter", {}).get("key"))


def patch_opencode(src, dest):
    """Render opencode.json with env vars — falls back to free models when no API key."""
    openrouter_key = os.environ.get("OPENROUTER_API_KEY", "")
    opencode_key = os.environ.get("OPENCODE_API_KEY", "")
    model = os.environ.get("OPENZED_MODEL", "deepseek/deepseek-v4-flash")
    small = os.environ.get("OPENZED_SMALL_MODEL", "deepseek/deepseek-v4-flash")

    with open(src) as f:
        cfg = json.load(f)

    openrouter = cfg.setdefault("provider", {}).setdefault("openrouter", {})
    opencode = cfg.setdefault("provider", {}).setdefault("opencode", {})
    openrouter_options = openrouter.setdefault("options", {})

    if _openrouter_auth_available():
        cfg["model"] = f"openrouter/{model}"
        cfg["small_model"] = f"openrouter/{small}"

        models = openrouter.setdefault("models", {})
        models.clear()
        models[model] = {"name": model, "tools": True}
        models[small] = {"name": small, "tools": True}

        # Never write {env:...} placeholders to the installed config — when the
        # env var is missing at runtime OpenCode resolves them to "" and that
        # empty apiKey overrides auth.json (/connect credentials).
        if openrouter_key:
            openrouter_options["apiKey"] = openrouter_key
        else:
            openrouter_options.pop("apiKey", None)
    else:
        cfg["model"] = "opencode/claude-sonnet-4-5"
        cfg.pop("small_model", None)
        openrouter_options.pop("apiKey", None)

        if opencode_key:
            opencode.setdefault("options", {})["apiKey"] = opencode_key
        else:
            opencode.pop("options", None)

    with open(dest, "w") as f:
        json.dump(cfg, f, indent=2)
        f.write("\n")


def patch_zed(src, dest):
    """Merge Zed settings and inject opencode command path."""
    opencode_cmd = os.path.join(os.environ.get("OPENZED_BIN_DIR", ""), "opencode")

    with open(src) as f:
        patch = json.load(f)

    if "agent_servers" in patch and "opencode" in patch["agent_servers"]:
        patch["agent_servers"]["opencode"]["command"] = opencode_cmd

    try:
        with open(dest) as f:
            settings = json.load(f)
    except (FileNotFoundError, IsADirectoryError, json.JSONDecodeError):
        settings = {}

    if "agent_servers" in settings and "OpenCode" in settings["agent_servers"]:
        settings["agent_servers"]["opencode"] = settings["agent_servers"].pop("OpenCode")

    for key, value in patch.items():
        if key == "agent_servers" and key in settings:
            settings[key].update(value)
        else:
            settings[key] = value

    with open(dest, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")


def patch_generic(src, dest):
    """Generic merge: load patch file and merge into dest (or create if missing)."""
    with open(src) as f:
        patch = json.load(f)

    try:
        with open(dest) as f:
            data = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        data = {}

    data.update(patch)

    with open(dest, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(f"Usage: {sys.argv[0]} <mode> <src> <dest>")
        print("  Modes: opencode, zed, generic")
        sys.exit(1)

    mode, src, dest = sys.argv[1], sys.argv[2], sys.argv[3]

    if mode == "opencode":
        patch_opencode(src, dest)
    elif mode == "zed":
        patch_zed(src, dest)
    elif mode == "generic":
        patch_generic(src, dest)
    else:
        print(f"Unknown mode: {mode}")
        sys.exit(1)