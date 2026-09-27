-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Pick the interpreter for a file: the nearest virtualenv (any directory with a
-- pyvenv.cfg, whatever its name) walking up from the file, then an
-- already-activated $VIRTUAL_ENV, then the system python3.
local function python_for(file)
  local dir = vim.fs.dirname(file)
  for _, d in ipairs({ dir, unpack(vim.iter(vim.fs.parents(dir)):totable()) }) do
    for _, cfg in ipairs(vim.fn.glob(d .. "/{*,.*}/pyvenv.cfg", true, true)) do
      local python = vim.fs.dirname(cfg) .. "/bin/python"
      if vim.fn.executable(python) == 1 then
        return python
      end
    end
  end
  local active = vim.env.VIRTUAL_ENV
  if active and vim.fn.executable(active .. "/bin/python") == 1 then
    return active .. "/bin/python"
  end
  return "python3"
end

-- Run the current Python file in a floating terminal
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(event)
    vim.keymap.set("n", "<leader>rr", function()
      vim.cmd.write()
      local file = vim.fn.expand("%:p")
      Snacks.terminal({ python_for(file), file }, { auto_close = false })
    end, { desc = "Run Python File", buffer = event.buf })
  end,
})
