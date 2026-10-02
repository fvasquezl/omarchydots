return {
  "saghen/blink.cmp",
  init = function()
    -- blink.cmp sets its keymaps per buffer on InsertEnter, which doesn't fire
    -- when switching buffers while already in insert mode (e.g. mouse click).
    -- Apply them on BufEnter too, so <CR>/<Tab> still accept there.
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if not package.loaded["blink.cmp"] or vim.fn.mode() ~= "i" then
          return
        end
        local config = require("blink.cmp.config")
        if config.enabled() then
          local mappings = require("blink.cmp.keymap").get_mappings(config.keymap, "default")
          require("blink.cmp.keymap.apply").keymap_to_current_buffer(mappings)
        end
      end,
    })
  end,
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
