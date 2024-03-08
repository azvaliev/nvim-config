local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })

  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename);
  vim.keymap.set("n", "<leader>fa", vim.lsp.buf.format);
  vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action);

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev);
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next);

  vim.keymap.set("n", "gd", vim.lsp.buf.definition);
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration);
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation);
  vim.keymap.set("n", "go", vim.lsp.buf.type_definition);
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
    "tsserver",
    "kotlin_language_server",
    "marksman",
    "sqlls",
    "tailwindcss",
    "vuels",
    "yamlls"
  },
  handlers = {
    lsp_zero.default_setup,
    yamlls = function()
      require("lspconfig").yamlls.setup({
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.*",
              ["https://json.schemastore.org/catalog-info.json"] = ".backstage/*.yaml",
              ["https://raw.githubusercontent.com/iterative/dvcyaml-schema/master/schema.json"] = "**/dvc.yaml",
              ["https://json.schemastore.org/swagger-2.0.json"] = "**/swagger.yaml",
            },
          },
        },
      })
    end
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
