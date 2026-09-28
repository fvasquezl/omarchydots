-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Find the nearest virtualenv (any directory with a pyvenv.cfg, whatever its
-- name) walking up from dir, then an already-activated $VIRTUAL_ENV.
local function venv_for(dir)
  for _, d in ipairs({ dir, unpack(vim.iter(vim.fs.parents(dir)):totable()) }) do
    for _, cfg in ipairs(vim.fn.glob(d .. "/{*,.*}/pyvenv.cfg", true, true)) do
      local venv = vim.fs.dirname(cfg)
      if vim.fn.executable(venv .. "/bin/python") == 1 then
        return venv
      end
    end
  end
  local active = vim.env.VIRTUAL_ENV
  if active and vim.fn.executable(active .. "/bin/python") == 1 then
    return active
  end
end

-- Pick the interpreter for a file: its venv's python, else the system python3.
local function python_for(file)
  local venv = venv_for(vim.fs.dirname(file))
  return venv and venv .. "/bin/python" or "python3"
end

-- Ctrl+/ terminal (overrides LazyVim's) with the project's venv activated
local function focus_terminal()
  local root = LazyVim.root()
  local venv = venv_for(root)
  local env = venv and { VIRTUAL_ENV = venv, PATH = venv .. "/bin:" .. vim.env.PATH } or nil
  Snacks.terminal.focus(nil, { cwd = root, env = env })
end
vim.keymap.set({ "n", "t" }, "<c-/>", focus_terminal, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", focus_terminal, { desc = "which_key_ignore" })

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

-- Close the current buffer, keeping the window layout
vim.keymap.set("n", "<C-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
