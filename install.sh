#!/usr/bin/env bash
set -euo pipefail

CONFIG="${CODEX_CONFIG:-$HOME/.codex/config.toml}"
BACKUP_DIR="${CODEX_CONFIG_BACKUP_DIR:-$HOME/.codex/backups/claude-warm-codex-app-theme}"

python3 - "$CONFIG" "$BACKUP_DIR" <<'PY'
from __future__ import annotations

from datetime import datetime
from pathlib import Path
import re
import shutil
import sys
import tomllib

config_path = Path(sys.argv[1]).expanduser()
backup_dir = Path(sys.argv[2]).expanduser()

theme_block = """[desktop.appearanceLightChromeTheme]
accent = "#B7791F"
contrast = 40
ink = "#494536"
opaqueWindows = true
surface = "#F8F7F2"

[desktop.appearanceLightChromeTheme.fonts]

[desktop.appearanceLightChromeTheme.semanticColors]
diffAdded = "#4B6F3D"
diffRemoved = "#7C1B13"
skill = "#8A5E16"
"""

config_path.parent.mkdir(parents=True, exist_ok=True)
backup_dir.mkdir(parents=True, exist_ok=True)

text = config_path.read_text() if config_path.exists() else ""
backup_path = None

if text:
    timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")
    backup_path = backup_dir / f"config.toml.{timestamp}.bak"
    shutil.copy2(config_path, backup_path)


def upsert_desktop_code_theme(source: str) -> str:
    desktop_header = "[desktop]\n"
    key_line = 'appearanceLightCodeThemeId = "notion"\n'
    desktop_block_pattern = re.compile(r"(?ms)^\[desktop\]\n(?P<body>.*?)(?=^\[|\Z)")
    key_pattern = re.compile(r'(?m)^appearanceLightCodeThemeId\s*=.*$')

    match = desktop_block_pattern.search(source)
    if not match:
        prefix = desktop_header + key_line + "\n"
        return prefix + source.lstrip("\n")

    body = match.group("body")
    if key_pattern.search(body):
        new_body = key_pattern.sub(key_line.rstrip("\n"), body, count=1)
    else:
        new_body = key_line + body

    return source[: match.start("body")] + new_body + source[match.end("body") :]


text = upsert_desktop_code_theme(text)

theme_pattern = re.compile(
    r"(?ms)^\[desktop\.appearanceLightChromeTheme\]\n.*?"
    r"(?=^\[(?!desktop\.appearanceLightChromeTheme(?:\.|\]))|\Z)"
)

if theme_pattern.search(text):
    text = theme_pattern.sub(theme_block.rstrip("\n") + "\n\n", text, count=1)
else:
    if text and not text.endswith("\n"):
        text += "\n"
    text += "\n" + theme_block

tomllib.loads(text)
config_path.write_text(text)

print(f"Installed Claude Warm for Codex App in {config_path}")
if backup_path:
    print(f"Backup saved to {backup_path}")
PY
