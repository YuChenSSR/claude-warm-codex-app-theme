#!/usr/bin/env bash
set -euo pipefail

CONFIG="${CODEX_CONFIG:-$HOME/.codex/config.toml}"
BACKUP_DIR="${CODEX_CONFIG_BACKUP_DIR:-$HOME/.codex/backups/claude-warm-codex-app-theme}"

DEFAULT_CODEX_THEME_V1='codex-theme-v1:{"codeThemeId":"absolutely","theme":{"accent":"#cc7d5e","contrast":40,"fonts":{"code":null,"ui":null},"ink":"#2d2d2b","opaqueWindows":true,"semanticColors":{"diffAdded":"#00c853","diffRemoved":"#ff5f38","skill":"#cc7d5e"},"surface":"#f9f9f7"},"variant":"light"}
codex-theme-v1:{"codeThemeId":"absolutely","theme":{"accent":"#cc7d5e","contrast":60,"fonts":{"code":null,"ui":null},"ink":"#f9f9f7","opaqueWindows":false,"semanticColors":{"diffAdded":"#00c853","diffRemoved":"#ff5f38","skill":"#cc7d5e"},"surface":"#2d2d2b"},"variant":"dark"}'

if [[ -z "${CODEX_THEME_V1:-}" && "$#" -eq 0 ]]; then
  export CODEX_THEME_V1="$DEFAULT_CODEX_THEME_V1"
fi

python3 - "$CONFIG" "$BACKUP_DIR" "$@" <<'PY'
from __future__ import annotations

from datetime import datetime
from pathlib import Path
import json
import os
import re
import shutil
import sys

try:
    import tomllib
except ModuleNotFoundError:
    tomllib = None

config_path = Path(sys.argv[1]).expanduser()
backup_dir = Path(sys.argv[2]).expanduser()
extra_inputs = sys.argv[3:]


def toml_value(value):
    if isinstance(value, str):
        return json.dumps(value)
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    raise TypeError(f"Unsupported TOML value: {value!r}")


def read_theme_text() -> str:
    chunks = []
    env_input = os.environ.get("CODEX_THEME_V1", "")
    if env_input.strip():
        chunks.append(env_input)

    for item in extra_inputs:
        path = Path(item).expanduser()
        if path.exists():
            chunks.append(path.read_text())
        else:
            chunks.append(item)

    if not chunks:
        raise SystemExit(
            "No codex-theme-v1 input found. Pass a file path, a literal theme "
            "string, or set CODEX_THEME_V1."
        )

    return "\n".join(chunks)


def parse_theme_specs(source: str) -> dict[str, dict]:
    specs = {}
    prefix = "codex-theme-v1:"

    for raw_line in source.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if not line.startswith(prefix):
            raise SystemExit(f"Expected codex-theme-v1 line, got: {line[:80]}")

        payload = json.loads(line[len(prefix) :])
        variant = payload.get("variant")
        if variant not in {"light", "dark"}:
            raise SystemExit(f"Unsupported variant: {variant!r}")
        if not isinstance(payload.get("theme"), dict):
            raise SystemExit(f"Theme payload for {variant} must contain an object")

        specs[variant] = payload

    if not specs:
        raise SystemExit("No codex-theme-v1 entries were parsed")

    return specs


def render_theme_block(variant: str, spec: dict) -> str:
    title = variant.title()
    theme = spec["theme"]
    required = ["accent", "contrast", "ink", "opaqueWindows", "surface"]
    missing = [key for key in required if key not in theme]
    if missing:
        raise SystemExit(f"{variant} theme is missing keys: {', '.join(missing)}")

    lines = [f"[desktop.appearance{title}ChromeTheme]"]
    for key in required:
        lines.append(f"{key} = {toml_value(theme[key])}")

    lines.append("")
    lines.append(f"[desktop.appearance{title}ChromeTheme.fonts]")
    fonts = theme.get("fonts") or {}
    for key in ["code", "ui"]:
        value = fonts.get(key)
        if value is not None:
            lines.append(f"{key} = {toml_value(value)}")

    lines.append("")
    lines.append(f"[desktop.appearance{title}ChromeTheme.semanticColors]")
    semantic = theme.get("semanticColors") or {}
    for key in ["diffAdded", "diffRemoved", "skill"]:
        value = semantic.get(key)
        if value is not None:
            lines.append(f"{key} = {toml_value(value)}")

    return "\n".join(lines) + "\n"


def upsert_desktop_keys(source: str, specs: dict[str, dict]) -> str:
    keys = {}
    for variant, spec in specs.items():
        code_theme_id = spec.get("codeThemeId")
        if code_theme_id:
            keys[f"appearance{variant.title()}CodeThemeId"] = code_theme_id

    if not keys:
        return source

    key_lines = [f"{key} = {toml_value(value)}" for key, value in keys.items()]
    desktop_pattern = re.compile(r"(?ms)^\[desktop\]\n(?P<body>.*?)(?=^\[|\Z)")
    match = desktop_pattern.search(source)

    if not match:
        return "[desktop]\n" + "\n".join(key_lines) + "\n\n" + source.lstrip("\n")

    body = match.group("body")
    inserted = []
    for key_line in key_lines:
        key = key_line.split(" = ", 1)[0]
        key_pattern = re.compile(rf"(?m)^{re.escape(key)}\s*=.*$")
        if key_pattern.search(body):
            body = key_pattern.sub(key_line, body, count=1)
        else:
            inserted.append(key_line)

    if inserted:
        body = "\n".join(inserted) + "\n" + body

    return source[: match.start("body")] + body + source[match.end("body") :]


def upsert_theme_block(source: str, variant: str, block: str) -> str:
    title = variant.title()
    table = f"desktop.appearance{title}ChromeTheme"
    pattern = re.compile(
        rf"(?ms)^\[{re.escape(table)}\]\n.*?"
        rf"(?=^\[(?!{re.escape(table)}(?:\.|\]))|\Z)"
    )

    replacement = block.rstrip("\n") + "\n\n"
    if pattern.search(source):
        return pattern.sub(replacement, source, count=1)

    if source and not source.endswith("\n"):
        source += "\n"
    return source + "\n" + replacement


specs = parse_theme_specs(read_theme_text())

config_path.parent.mkdir(parents=True, exist_ok=True)
backup_dir.mkdir(parents=True, exist_ok=True)

text = config_path.read_text() if config_path.exists() else ""
backup_path = None

if text:
    timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")
    backup_path = backup_dir / f"config.toml.{timestamp}.bak"
    shutil.copy2(config_path, backup_path)

text = upsert_desktop_keys(text, specs)
for variant in ["light", "dark"]:
    if variant in specs:
        text = upsert_theme_block(text, variant, render_theme_block(variant, specs[variant]))

if tomllib is not None:
    tomllib.loads(text)

config_path.write_text(text)

installed = ", ".join(sorted(specs))
print(f"Imported Codex theme variants ({installed}) into {config_path}")
if backup_path:
    print(f"Backup saved to {backup_path}")
PY
