# Claude Warm for Codex App

A warm light and dark theme preset for the Codex desktop app.

This adapts the small Claude Warm palette used by
[claude-warm-craft-agent-theme](https://github.com/YuChenSSR/claude-warm-craft-agent-theme)
to Codex's `codex-theme-v1` export format and the corresponding settings in
`~/.codex/config.toml`.

## Palette

### Light

| Codex role | Color |
| --- | --- |
| Code theme | `absolutely` |
| Surface | `#f9f9f7` |
| Ink | `#2d2d2b` |
| Accent | `#cc7d5e` |
| Diff added | `#00c853` |
| Diff removed | `#ff5f38` |
| Skill | `#cc7d5e` |

### Dark

| Codex role | Color |
| --- | --- |
| Code theme | `absolutely` |
| Surface | `#2d2d2b` |
| Ink | `#f9f9f7` |
| Accent | `#cc7d5e` |
| Diff added | `#00c853` |
| Diff removed | `#ff5f38` |
| Skill | `#cc7d5e` |

## Install

Run the installer:

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

The installer is self-contained and imports the two bundled
`codex-theme-v1:` lines from
[`claude-warm-codex.codex-theme-v1`](./claude-warm-codex.codex-theme-v1).

To import a different copied Codex theme payload with the same script, set
`CODEX_THEME_V1`:

```bash
CODEX_THEME_V1='codex-theme-v1:{"codeThemeId":"absolutely","theme":{...},"variant":"light"}' ./install.sh
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
