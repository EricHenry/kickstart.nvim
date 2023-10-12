return {
  "mg979/vim-visual-multi",
  branch = "master",
  lazy = false,
  name = "vim-visual-multi",
  priority = 1000,
  config = function()
    vim.g.VM_maps = {
      ["Add Cursor Down"] = "<M-J>",
      ["Add Cursor Up"] = "<M-K>",
    }
  end,
}
