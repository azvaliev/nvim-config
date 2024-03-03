--------------
-- treesitter
--------------

local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = {
    "astro", "css", "scss", "dockerfile", "go", "gomod", "gosum", "graphql", "html", "gitcommit", "gitignore",
    "javascript", "java", "jsdoc", "jsonc", "make", "python", "prisma", "regex", "sql", "typescript", "c", "rust"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})

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

vim.keymap.set("n", "<leader>ha", mark.add_file)
vim.keymap.set("n", "<leader>hd", mark.clear_all)
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
