# omarchydots

Backup of dotfiles for an Omarchy/Hyprland setup, snapshotted from `~/.config/`.

## Contents

- **`hypr/`** — Hyprland config. Dual 4K@60 monitor setup: `DP-1` on the left
  (`0x0`), `DP-2` on the right (`auto-right`), both at scale `1.5`
  (`monitors.lua`). Workspaces are handled by Omarchy's per-monitor blocks. Uses `AQ_NO_ATOMIC=1` / `AQ_NO_MODIFIERS=1` to work around
  a DRM/i915 bandwidth issue that otherwise blocks dual 4K@60. `bindings.lua`
  adds a Herdr launcher on `SUPER+CTRL+RETURN` (opens foot with
  JetBrainsMono Nerd Font size 12, overriding `foot.ini`) and the legacy
  dictation keys. `input.lua` sets the keyboard to US English with AltGr dead
  keys (`kb_variant = "altgr-intl"`): `AltGr+'` then a vowel gives á é í ó ú,
  `AltGr+n` gives ñ.
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

  Completion (`lua/plugins/blink.lua`): `<Tab>` or `<CR>` accepts the
  preselected item, no ghost text. Also re-applies blink.cmp's buffer keymaps
  on `BufEnter` in insert mode, since its `InsertEnter` hook misses buffers you
  switch to while already inserting (e.g. by mouse click).
  `lua/plugins/basedpyright-watch.lua` lets basedpyright watch files on disk,
  so packages newly installed in the venv are picked up without a restart.
  `lua/plugins/digraphs.lua` frees insert-mode `<C-k>` for digraphs (LazyVim
  maps it to signature help). `plugin/resaltar_definiciones.lua` draws a
  separator line above each Python `def`/`class` and bolds method names;
  `:ResaltarDefs` toggles it. Swap files are disabled (`options.lua`).
- **`omarchy/`** — Omarchy branding, hooks, themes, and shell config.
  `hooks/theme-set.d/10-owe-sync` pings the owe daemon on theme change.
- **`foot/foot.ini`** — foot terminal config, font JetBrainsMono Nerd Font
  size 15.
- **`herdr/config.toml`** — Herdr config (tmux-style keys, prefix
  `Ctrl+Space`, theme `catppuccin-latte` with blue accent). `prefix+b` collapses/expands the workspaces sidebar, which
  shrinks to a narrow strip (`sidebar_collapsed_mode = "compact"`).
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
cp herdr/config.toml ~/.config/herdr/config.toml
```

Restart the affected component afterward (e.g. `omarchy restart terminal` for
foot, `herdr server reload-config` for Herdr, a full Hyprland session restart for monitor/env changes).
