--------------
-- treesitter
--------------

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
	  "astro", "css", "scss", "dockerfile", "go", "gomod", "graphql",
	  "javascript", "jsdoc", "json", "prisma", "typescript", "c", "lua", "rust" 
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

------------
-- telescope
------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})

------------
-- harpoon
------------

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>d", mark.clear_all)
vim.keymap.set("n", "<leader>hp", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

----------------
-- Undotree
----------------

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

----------------
-- Fugitive
----------------

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

----------------
-- Netrw
----------------

vim.g.netrw_list_hide = "(^|\\s\\s)\zs.\\S+";
----------------
-- Lualine
----------------

require('lualine').setup{
  options = { theme = 'modus-vivendi' }
}

----------------
-- trouble
----------------

vim.keymap.set("n", "<leader>tt", vim.cmd.TroubleToggle)

----------------
-- Copilot
----------------

vim.g.copilot_no_tab_map = true;
vim.keymap.set({ "n", "i" }, "<C-j>", 'copilot#Accept("<CR>")', { expr = true, silent = true });

---------------
-- Conquer of Completion
---------------

vim.cmd('source ~/.config/nvim/lua/after/plugin/coc.vim')
