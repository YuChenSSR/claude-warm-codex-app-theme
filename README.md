# Claude Warm for Codex App

A warm light and dark theme preset for the Codex desktop app.

Theme name: **Claude Warm**

This adapts the small Claude Warm palette used by
[claude-warm-craft-agent-theme](https://github.com/YuChenSSR/claude-warm-craft-agent-theme)
to Codex's `codex-theme-v1` export format and the corresponding settings in
`~/.codex/config.toml`.

The `codex-theme-v1` payload uses `codeThemeId` to select a built-in Codex code
theme. This preset uses lowercase `absolutely` for both variants, matching
Codex's import requirements.

## Palette

### Light

| Codex role | Color |
| --- | --- |
| Theme name | `Claude Warm Light` |
| Code theme ID | `absolutely` |
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
| Code theme ID | `absolutely` |
| Surface | `#2d2d2b` |
| Ink | `#f9f9f7` |
| Accent | `#cc7d5e` |
| Diff added | `#00c853` |
| Diff removed | `#ff5f38` |
| Skill | `#cc7d5e` |

## Copy For UI Import

If your Codex build has an in-app theme import action, copy one raw
`codex-theme-v1:` payload at a time. Codex imports one variant per payload.

Light:

```bash
curl -fsSL https://raw.githubusercontent.com/YuChenSSR/claude-warm-codex-app-theme/main/claude-warm-codex-light.codex-theme-v1 | pbcopy
```

Dark:

```bash
curl -fsSL https://raw.githubusercontent.com/YuChenSSR/claude-warm-codex-app-theme/main/claude-warm-codex-dark.codex-theme-v1 | pbcopy
```

Or from a local clone:

```bash
./copy-theme.sh light
./copy-theme.sh dark
```

`./copy-theme.sh` defaults to `light`. `./copy-theme.sh both` copies the
combined two-line payload used by the config installer, but most UI import
flows expect the split light/dark payloads above.

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

This theme uses `codeThemeId = "absolutely"` for both variants. Codex expects
this field to match one of its built-in code theme IDs, and the ID must start
with a lowercase letter.

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

## More Claude Themes

For Claude-inspired themes and app-specific setup notes across more apps, see
[Claude Theme Hub](https://github.com/YuChenSSR/claude-theme-hub).

## Attribution

Palette adapted from
[claude-warm-craft-agent-theme](https://github.com/YuChenSSR/claude-warm-craft-agent-theme),
which itself credits
[Claude Warm for Obsidian](https://github.com/amm10090/claude-warm-obsidian-theme).

## License

MIT. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE).
