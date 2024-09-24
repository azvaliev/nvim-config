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
    end
  },
  {
    'shaunsingh/nord.nvim',
    lazy = true
  }
}
