return {
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_enabled = false

      -- Disable for large files
      vim.cmd[[
        autocmd BufReadPre *
         \ let f=getfsize(expand("<afile>"))
         \ | if f > 100000 || f == -2
         \ | let b:copilot_enabled = v:false
         \ | endif
        ]]

      -- Shift-Tab to accept suggestions
      vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
    end,
  }
}
