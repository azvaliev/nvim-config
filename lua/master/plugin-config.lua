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

---------------
-- which-key
---------------

local wk = require("which-key")

------------
-- telescope
------------
local builtin = require('telescope.builtin')
wk.register({
  f = {
    name = "file", -- optional group name
    f = { builtin.find_files, "Find File" },
    b = { builtin.buffers, "Buffers" },
  },
  gf = { builtin.git_files, "Find Git Files" },
  lg = { builtin.live_grep, "Live Grep" }
}, { prefix = "<leader>" })

------------
-- harpoon
------------

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

wk.register({
  a = { mark.add_file, "Mark file" },
  d = { mark.clear_all, "Clear marks" },
  p = { ui.toggle_quick_menu, "Mark Menu" }
}, { prefix = "<leader>h" })

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)


----------------
-- Undotree
----------------

wk.register({
  ["<leader>u"] = { vim.cmd.UndotreeToggle, "Toggle undo tree" }
})

----------------
-- Fugitive
----------------

wk.register({
  ["<leader>gs"] = { vim.cmd.Git, "Git helpers" }
})


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

wk.register({
  ["<leader>tt"] = { vim.cmd.TroubleToggle, "Toggle Trouble Menu" } 
})
