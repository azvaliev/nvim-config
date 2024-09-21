vim.opt.nu = true
vim.opt.relativenumber = true

-- This will enable both absolute & relative line numbers.
-- vim.cmd [[
--   highlight LineNrAbsolute guifg=#3E3E3E
--   highlight LineNrRelative guifg=#6A6A69
-- ]]
-- vim.opt.statuscolumn = "%s %#LineNrAbsolute#%3l %#LineNrRelative#%3r "

-- 2 line tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Use 4-space tabs for golang
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "setlocal noexpandtab tabstop=4 shiftwidth=4",
})

vim.opt.smartindent = true

-- Wrapping sucks
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = false

-- No error bells
vim.opt.errorbells = false
vim.opt.visualbell = false

-- vim.opt.autochdir = true
vim.opt.cursorline = true

-- Don't redraw while executing macros (good performance config)
vim.opt.lazyredraw = true

-- How many tenths of a second to blink when matching brackets
vim.opt.mat = 2

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Non case sensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Autoscroll 8 lines away
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

-- Use full colors
vim.opt.termguicolors = true

-- Column line at 80
vim.opt.colorcolumn = "80"

vim.cmd [[set clipboard^=unnamed]]
