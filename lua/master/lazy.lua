-- STUFF TO INSTALL lazy itself

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- CONFIG

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  -- Colorscheme
  {
    "kvrohit/rasmus.nvim",
    config = function()
      vim.cmd.colorscheme("rasmus")
    end
  },

  -- Navigation
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  "tpope/vim-vinegar",
  { "theprimeagen/harpoon", lazy = true },

  -- Autocomplete
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip" },


  -- Language tools
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
  },
  "prisma/vim-prisma",
  {
    "iamcco/markdown-preview.nvim",
    config = function() vim.fn["mkdp#util#install"]() end,
    lazy = true
  },


  -- Git integration
  { "tpope/vim-fugitive", lazy = true },
  {
    "lewis6991/gitsigns.nvim",
    config = function() require('gitsigns').setup() end
  },

  ---- Quality of life improvements

  -- Autocomplete for keybindings
  "folke/which-key.nvim",

  -- Makes undo 1000x better
  { "mbbill/undotree", lazy = true },

  -- gcc to comment stuff
  {
    "numToStr/Comment.nvim",
    config = function() require('Comment').setup() end
  },

  -- Bottom line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "kyazdani42/nvim-web-devicons"
  },
})
