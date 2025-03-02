return {
  {
    "github/copilot.vim",
    config = function()
      -- Disable for large files
      vim.cmd[[
        autocmd BufReadPre *
         \ let f=getfsize(expand("<afile>"))
         \ | if f > 100000 || f == -2
         \ | let b:copilot_enabled = v:false
         \ | endif
        ]]
    end,
  }
}
