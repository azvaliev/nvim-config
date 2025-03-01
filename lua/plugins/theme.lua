return {
  {
    "kvrohit/rasmus.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme rasmus]]

      -- With inlay hints, contrast by default is rough
      vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = "#5E5E5D" })
      vim.api.nvim_set_hl(0, 'Comment', { fg = "#80807F", italic = true })

      -- Snacks picker directories are otherwise too dim to view
      vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#928374" })
      vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#928374" })
    end
  },
  {
    'shaunsingh/nord.nvim',
    lazy = true
  }
}
