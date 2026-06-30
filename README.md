# Claude Warm for Codex App

A warm light and dark theme preset for the Codex desktop app.

Theme name: **Claude Warm**

This adapts the small Claude Warm palette used by
[claude-warm-craft-agent-theme](https://github.com/YuChenSSR/claude-warm-craft-agent-theme)
to Codex's `codex-theme-v1` export format and the corresponding settings in
`~/.codex/config.toml`.

Codex's `codeThemeId` stays on the built-in `absolutely` code highlighter. The
app chrome theme itself is named **Claude Warm** in this repository and installer
output.

## Palette

### Light

| Codex role | Color |
| --- | --- |
| Theme name | `Claude Warm Light` |
| Code highlighter | `Absolutely` built into Codex |
| Surface | `#f9f9f7` |
| Ink | `#2d2d2b` |
| Accent | `#cc7d5e` |
| Diff added | `#00c853` |
| Diff removed | `#ff5f38` |
| Skill | `#cc7d5e` |

### Dark

| Codex role | Color |
| --- | --- |
| Theme name | `Claude Warm Dark` |
| Code highlighter | `Absolutely` built into Codex |
| Surface | `#2d2d2b` |
| Ink | `#f9f9f7` |
| Accent | `#cc7d5e` |
| Diff added | `#00c853` |
| Diff removed | `#ff5f38` |
| Skill | `#cc7d5e` |

## Apply To Current Config

Run the installer to apply Claude Warm to the active Codex config:

```bash
curl -fsSL https://raw.githubusercontent.com/YuChenSSR/claude-warm-codex-app-theme/main/install.sh | bash
```

Or clone the repository and run:

```bash
./install.sh
```

Restart Codex after installation so the desktop app reloads
`~/.codex/config.toml`.

The installer creates a timestamped backup under
`~/.codex/backups/claude-warm-codex-app-theme/` before changing the config.

This script applies the theme to the current light/dark appearance settings. It
does not register a new named theme entry inside Codex's UI theme picker.

The installer is self-contained and applies the two bundled
`codex-theme-v1:` lines from
[`claude-warm-codex.codex-theme-v1`](./claude-warm-codex.codex-theme-v1).

To apply a different copied Codex theme payload with the same script, set
`CODEX_THEME_V1`:

```bash
CODEX_THEME_V1='codex-theme-v1:{"codeThemeId":"absolutely","theme":{...},"variant":"light"}' ./install.sh
```

To restore the previous config, copy back the newest backup from:

```bash
~/.codex/backups/claude-warm-codex-app-theme/
```

## Copy For UI Import

If your Codex build has an in-app theme import action, copy the raw
`codex-theme-v1:` payload instead:

```bash
curl -fsSL https://raw.githubusercontent.com/YuChenSSR/claude-warm-codex-app-theme/main/claude-warm-codex.codex-theme-v1 | pbcopy
```

Or from a local clone:

```bash
./copy-theme.sh
```

## Manual Install

Copy the contents of
[`claude-warm-codex-light.toml`](./claude-warm-codex-light.toml) into
`~/.codex/config.toml`, replacing any existing
`[desktop.appearanceLightChromeTheme]` block and its nested tables.

For dark mode, also copy
[`claude-warm-codex-dark.toml`](./claude-warm-codex-dark.toml), replacing any
existing `[desktop.appearanceDarkChromeTheme]` block and its nested tables.

## Notes

Codex theme exports use lines that start with `codex-theme-v1:`. Each line
contains one JSON payload with:

- `variant`
- `codeThemeId`
- `theme`

The installer parses those payloads and writes the equivalent config keys:

- `appearanceLightCodeThemeId`
- `appearanceDarkCodeThemeId`
- `appearanceLightChromeTheme`
- `appearanceDarkChromeTheme`

The chrome theme model includes:

- `surface`
- `ink`
- `accent`
- `contrast`
- `opaqueWindows`
- `semanticColors`

This repository only changes those stable user-configurable fields. It does
not patch the Codex application bundle.

## Attribution

Palette adapted from
[claude-warm-craft-agent-theme](https://github.com/YuChenSSR/claude-warm-craft-agent-theme),
which itself credits
[Claude Warm for Obsidian](https://github.com/amm10090/claude-warm-obsidian-theme).

## License

MIT. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE).
