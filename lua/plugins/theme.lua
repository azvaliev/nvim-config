return {
  {
    "kvrohit/rasmus.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme rasmus]]
    end
  },
  {
    'shaunsingh/nord.nvim',
    lazy = true
  }
}
