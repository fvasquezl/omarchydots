return {
  "saghen/blink.cmp",
  opts = {
    -- VSCode-like: <Tab> or <CR> accepts the preselected item; with no menu
    -- open they fall back to their normal behavior. LazyVim chains
    -- snippet_forward/AI accept onto <Tab> for this preset.
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      -- Don't preview the selected item inline as you type.
      ghost_text = {
        enabled = false,
      },
    },
  },
}
