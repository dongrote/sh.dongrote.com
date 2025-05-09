return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup {
      view = {
        float = { enable = true, },
        width = {
          min = 30,
          max = -1,
        },
      },
      actions = {
        open_file = { quit_on_open = true, },
      },
    }
  end,
}
