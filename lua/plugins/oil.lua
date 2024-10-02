return {
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        case_insensitive = true,
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          return name == '.git' or name == '..'
        end,
      },
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
