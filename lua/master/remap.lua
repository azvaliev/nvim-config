vim.g.mapleader = "\\"
-- <leader>pv to go to file system
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore)

-- Shift-J and Shift-K in visual mode to move lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set ("n", "J", "mzJ`z")

-- Cursor in the middle when going to next option
vim.keymap.set("n", "n", "nzzzv");
vim.keymap.set("n", "N", "Nzzzv");

-- Cursor in the middle when jumping half pages
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")
