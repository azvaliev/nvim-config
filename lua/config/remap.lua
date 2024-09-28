vim.g.mapleader = " "

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

-- Disable arrow keys for normal mode
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")

local function format_json_with_jq()
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get all lines in the current buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Combine the lines into a single string
  local input = table.concat(lines, "\n")

  -- Use the `jq` command to format JSON, capturing both stdout and stderr
  local handle = io.popen('echo "' .. input:gsub('"', '\\"') .. '" | jq . 2>&1', 'r')
  if not handle then
    print("Error: Failed to run jq command.")
    return
  end

  -- Read the output from jq
  local output = handle:read("*a")
  handle:close()

  -- Check for errors in jq output
  if output:match("^parse error") then
    print("Error: Invalid JSON detected.")
    return
  end

  -- Split the output into lines to handle multiline JSON properly
  local output_lines = vim.split(output, "\n", { trimempty = true })

  -- Replace the buffer contents with the formatted output
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output_lines)
end

vim.keymap.set('n', '<leader>jp', function() format_json_with_jq() end, { noremap = true, silent = true })
