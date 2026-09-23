return {
  "nvim-neo-tree/neo-tree.nvim",
  -- Avoid a known race between neo-tree's own lazy-loading (v3.30+) and
  -- LazyVim's "start directory" detection when launching `nvim .`, which
  -- shows a blank buffer the first time you open a file.
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1699
  lazy = false,
}
