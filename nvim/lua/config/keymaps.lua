-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Run the current Python file in a floating terminal
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(event)
    vim.keymap.set("n", "<leader>rr", function()
      vim.cmd.write()
      Snacks.terminal(("python3 %s"):format(vim.fn.expand("%:p")), { auto_close = false })
    end, { desc = "Run Python File", buffer = event.buf })
  end,
})
