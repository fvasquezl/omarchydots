-- Let basedpyright see files change on disk (e.g. a new pip install in the venv).
-- Neovim disables this on Linux by default.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        capabilities = {
          workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
        },
      },
    },
  },
}
