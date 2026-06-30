#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
THEME_FILE="${1:-$SCRIPT_DIR/claude-warm-codex.codex-theme-v1}"

if ! command -v pbcopy >/dev/null 2>&1; then
  echo "pbcopy is not available. Theme payload:" >&2
  cat "$THEME_FILE"
  exit 1
fi

pbcopy < "$THEME_FILE"
echo "Copied Claude Warm codex-theme-v1 payload to the clipboard."
