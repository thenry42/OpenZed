#!/usr/bin/env python3
"""JSON config patching utility for OpenZed install scripts."""

import json
import os
import sys


def patch_opencode(src, dest):
    """Render opencode.json with env vars (model names, API key)."""
    model = os.environ.get("OPENZED_MODEL", "deepseek/deepseek-v4-flash")
    small = os.environ.get("OPENZED_SMALL_MODEL", "deepseek/deepseek-v4-flash")

    with open(src) as f:
        cfg = json.load(f)

    cfg["model"] = f"openrouter/{model}"
    cfg["small_model"] = f"openrouter/{small}"
    if not os.environ.get("OPENROUTER_API_KEY"):
        cfg["provider"]["openrouter"]["options"].pop("apiKey", None)

    models = cfg["provider"]["openrouter"]["models"]
    models.clear()
    models[model] = {"name": model, "tools": True}
    models[small] = {"name": small, "tools": True}

    with open(dest, "w") as f:
        json.dump(cfg, f, indent=2)
        f.write("\n")


def patch_zed(src, dest):
    """Merge Zed settings and inject opencode command path."""
    opencode_cmd = os.path.join(os.environ.get("OPENZED_BIN_DIR", ""), "opencode")

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
