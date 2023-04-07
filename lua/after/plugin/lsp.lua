local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'rust_analyzer',
  'tailwindcss',
  'marksman',
  'cssls',
  'astro',
  'prismals',
  'gopls',
  'sqlls',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
})

require("typescript").setup({})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  if client.name == "eslint" then
    vim.keymap.set('n', '<Leader>fa', ':EslintFixAll<CR>', opts)
    return
  end

  if client.name == "gopls" then
    vim.keymap.set('n', '<leader>fa', ':w<CR>:!go fmt %<CR>', {silent = true})
  end

  if client.name == "tsserver" then
    vim.keymap.set('n', '<leader>rf', ':TypescriptRenameFile<CR>')
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})
