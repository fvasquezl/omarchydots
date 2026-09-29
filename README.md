# omarchydots

Backup of dotfiles for an Omarchy/Hyprland setup, snapshotted from `~/.config/`.

## Contents

- **`hypr/`** — Hyprland config. Dual 4K@60 monitor setup: `DP-2` on the left
  (`0x0`), `DP-1` on the right (`auto-right`), both at scale `1.3`
  (`monitors.lua`). Uses `AQ_NO_ATOMIC=1` / `AQ_NO_MODIFIERS=1` to work around
  a DRM/i915 bandwidth issue that otherwise blocks dual 4K@60.
- **`nvim/`** — LazyVim config. Python LSP set to `basedpyright` (instead of
  the default `pyright`) plus `ruff` for linting/formatting. The
  `vim.g.lazyvim_python_lsp` setting lives in `lua/config/options.lua` (must
  load before `lazy.nvim` starts, not from `lua/plugins/`). Custom keymaps
  (`lua/config/keymaps.lua`):
  - `<leader>rr` — run the current Python file with the project's virtualenv.
  - `<C-/>` — terminal at the project root with its virtualenv activated.
  - `<C-q>` — close the current buffer, keeping the window layout.
  - `x` — delete a character without yanking it.
  - `<leader>p` / `<leader>P` — paste the last yank (`"0`) after/before the
    cursor, even after deleting something.
  - `<leader>k{motion}` / `<leader>kk` — delete without yanking (`"_d`), e.g.
    `<leader>kiw`, `<leader>kap`, `<leader>kag`; also on a visual selection.
  - `<leader>C{motion}` — change without yanking (`"_c`), e.g. `<leader>Ciw`.
- **`omarchy/`** — Omarchy branding, hooks, themes, and shell config.
- **`foot/foot.ini`** — foot terminal config, font size 13.
- **`starship.toml`** — Starship prompt config, includes a `[python]` module
  so an active virtualenv shows up in the prompt.

## Restoring

Copy the relevant directory/file back into `~/.config/`, e.g.:

```sh
cp -r hypr ~/.config/
cp -r nvim ~/.config/
cp -r omarchy ~/.config/
cp foot/foot.ini ~/.config/foot/foot.ini
cp starship.toml ~/.config/starship.toml
```

Restart the affected component afterward (e.g. `omarchy restart terminal` for
foot, a full Hyprland session restart for monitor/env changes).
