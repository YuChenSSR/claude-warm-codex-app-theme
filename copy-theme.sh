#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
VARIANT="${1:-light}"

case "$VARIANT" in
  light)
    THEME_FILE="$SCRIPT_DIR/claude-warm-codex-light.codex-theme-v1"
    ;;
  dark)
    THEME_FILE="$SCRIPT_DIR/claude-warm-codex-dark.codex-theme-v1"
    ;;
  both)
    THEME_FILE="$SCRIPT_DIR/claude-warm-codex.codex-theme-v1"
    ;;
  *)
    if [[ -f "$VARIANT" ]]; then
      THEME_FILE="$VARIANT"
    else
      echo "Usage: $0 [light|dark|both|path-to-codex-theme-v1]" >&2
      exit 2
    fi
    ;;
esac

if ! command -v pbcopy >/dev/null 2>&1; then
  echo "pbcopy is not available. Theme payload:" >&2
  cat "$THEME_FILE"
  exit 1
fi

pbcopy < "$THEME_FILE"
echo "Copied Claude Warm ${VARIANT} codex-theme-v1 payload to the clipboard."
