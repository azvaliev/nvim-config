-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use ({
    'arcticicestudio/nord-vim',
    config = function()
      vim.cmd [[colorscheme nord]]
    end
  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  use('theprimeagen/harpoon')

  use('mbbill/undotree')

  use('tpope/vim-fugitive')

  use{
    'neoclide/coc.nvim',
    branch = 'release',
  }

  use('prisma/vim-prisma')

  use ({
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup()
    end
  })

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use('kyazdani42/nvim-web-devicons')

  use('folke/lsp-colors.nvim')

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup{}
    end
  }

  use('simrat39/rust-tools.nvim')

  use('tpope/vim-vinegar')

  use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
  })

  use('github/copilot.vim')

  use{
    'dmmulroy/tsc.nvim',
    config = function()
      require('tsc').setup()
    end
  }
end)
