# Claude Warm for Codex App

A warm ivory, charcoal, and muted-gold theme preset for the Codex desktop app.

This adapts the small Claude Warm palette used by
[claude-warm-craft-agent-theme](https://github.com/YuChenSSR/claude-warm-craft-agent-theme)
to the Codex app's exposed light chrome theme settings in
`~/.codex/config.toml`.

## Palette

| Codex role | Color |
| --- | --- |
| Surface | `#F8F7F2` |
| Ink | `#494536` |
| Accent | `#B7791F` |
| Diff added | `#4B6F3D` |
| Diff removed | `#7C1B13` |
| Skill | `#8A5E16` |

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

## Manual Install

Copy the contents of
[`claude-warm-codex-light.toml`](./claude-warm-codex-light.toml) into
`~/.codex/config.toml`, replacing any existing
`[desktop.appearanceLightChromeTheme]` block and its nested tables.

## Notes

Codex currently exposes a compact light chrome theme model:

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
