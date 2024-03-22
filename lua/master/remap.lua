vim.g.mapleader = " "
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

-- U to redo
vim.keymap.set("n", "U", "<C-r>")

-- Copy file path
vim.keymap.set("n", "<leader>wf", function()
    vim.fn.setreg('+', vim.fn.expand('%'))
end, {desc = "Copy current file path"})

-- bc to close current buffer
vim.keymap.set("n", "<leader>bc", ":bufdo bd<CR>")

-- translate this to lua
vim.keymap.set("n", "<leader>l", ":bnext<cr>")
vim.keymap.set("n", "<leader>h", ":bprevious<cr>")

-- Useful mappings for managing tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<cr>")
vim.keymap.set("n", "<leader>to", ":tabonly<cr>")
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>")
vim.keymap.set("n", "<leader>tm", ":tabmove")
vim.keymap.set("n", "<leader>t", ":tabnext<cr>")

-- switch cwd to that of open buffer
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>")

-- Return to last edit position when opening files (You want this!)
vim.cmd[[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]

