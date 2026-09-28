return {
  "saghen/blink.cmp",
  opts = {
    -- VSCode-like: <Tab> accepts the preselected item, <CR> always inserts a
    -- newline. LazyVim chains snippet_forward/AI accept onto <Tab> for this preset.
    keymap = {
      preset = "super-tab",
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
