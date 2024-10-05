return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'psql', 'plsql' },
      lazy = true,
    },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  keys = {
    { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Open DBUI" }
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'dbout' },
      callback = function()
        vim.opt.foldenable = false
      end,
    })
  end,
}
