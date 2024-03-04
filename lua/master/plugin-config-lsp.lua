local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })

  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename);
  vim.keymap.set("n", "<leader>fa", vim.lsp.buf.format);
  vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action);

  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })

  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

  if filetype == 'rust' then
    vim.notify("Current filetype: " .. filetype)
    vim.keymap.set(
      "n", 
      "<leader>a", 
      function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
      end,
      { silent = true, buffer = bufnr }
    )
  end
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",
    "cssls",
    "dockerls",
    "docker_compose_language_service",
    "efm",
    "eslint",
    "gopls",
    "golangci_lint_ls",
    "gradle_ls",
    "graphql",
    "html",
    "htmx",
    "biome",
    "java_language_server",
    "tsserver",
    "kotlin_language_server",
    "marksman",
    "ruby_ls",
    "sqlls",
    "tailwindcss",
    "vuels",
    "hydra_lsp"
  },
  handlers = {
    lsp_zero.default_setup,
  },
})

local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- confirm completion
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),

    -- scroll up and down the documentation window
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
