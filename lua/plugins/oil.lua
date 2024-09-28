return {
  {
    'stevearc/oil.nvim',
    opts = {
      {
        default_file_explorer = true,
        delete_to_trash = true,
        view_options = {
          case_insensitive = true,
        },
      }
    },
    -- Using it as default file explorer
    priority = 100,
    lazy = false,
    keys = {
      {
        "-",
        "<CMD>Oil<CR>",
        { desc = "Open parent directory" }
      }
    }
    -- Optional dependencies
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  }
}
