-- Free insert-mode <C-k> for digraphs (LazyVim maps it to signature help).
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          { "<c-k>", false, mode = "i" },
        },
      },
    },
  },
}
