return {
  {
    "mrcjkb/rustaceanvim",
    version = '^5',
    lazy = false, -- This plugin is already lazy
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { 
      { "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- Fidget
      require('fidget').setup()

      --------- LSP Zero
      local lsp_zero = require('lsp-zero')
      local telescope = require('telescope.builtin')

      -- lsp_attach is where you enable features that only work
      -- if there is a language server active in the file
      local lsp_attach = function(client, bufnr)
        local opts = {buffer = bufnr}

        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', 'gd', function() telescope.lsp_definitions() end, opts)
        vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set('n', 'gi', function() telescope.lsp_implementations() end, opts)
        vim.keymap.set('n', 'go', function() telescope.lsp_type_definitions() end, opts)
        vim.keymap.set('n', 'gr', function() telescope.lsp_references() end, opts)
        vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('n', '<leader>fa', function() vim.lsp.buf.format({async = true}) end, opts)
        vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>s', function() telescope.lsp_dynamic_workspace_symbols() end, opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      ---------- Mason, Language Servers
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          -- Frontend
          "cssls",
          "cssmodules_ls",
          "eslint",
          "tailwindcss",
          "graphql",
          "html",
          -- Prisma
          "prismals",
          -- JavaScript/TypeScript
          "ts_ls",
          -- Python
          "pyright",
          -- PHP
          "intelephense",
          -- Golang
          "gopls",
          "templ",
          -- Rust
          -- Now covered through rustaceanvim
          -- "rust_analyzer",
          -- Docker
          "docker_compose_language_service",
          "dockerls",
          -- Markdown
          "marksman",
          -- Protobuf
          "pbls",
          -- SQL
          "sqls",
          -- JSON/YAML/TOML
          "jsonls",
          "yamlls",
          "taplo",
          -- Gitlab CI
          "gitlab_ci_ls",
          -- Spelling
          "typos_lsp"

        },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
          ["eslint"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.eslint.setup({
              on_attach = function(client, bufnr)
                -- Format on save for ESLint
                -- vim.api.nvim_create_autocmd("BufWritePre", {
                --   buffer = bufnr,
                --   command = "EslintFixAll",
                -- })

                -- Have `fa` use ESLint
                vim.keymap.set('n', '<leader>fa', function() vim.cmd('EslintFixAll') end, opts)
              end,
            })
          end,
          -- Customize display of typos lsp
          -- - All warnings, no errors
          -- - No virtual text
          ['typos_lsp'] = function()
            require('lspconfig').typos_lsp.setup {
              on_attach = function(client, bufnr)
                -- Customize the diagnostic handler for Typos LSP
                vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
                  local client_id = ctx.client_id
                  local client = vim.lsp.get_client_by_id(client_id)

                  if client.name == "typos_lsp" then
                    for _, diagnostic in ipairs(result.diagnostics) do
                      -- Change diagnostic severity from Error to Warning
                      diagnostic.severity = vim.diagnostic.severity.WARN
                    end
                  end

                  -- Apply custom configuration for diagnostics
                  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, {
                    virtual_text = client.name ~= "typos_lsp", -- Disable virtual text for Typos LSP only
                    signs = true,
                    underline = true,
                    update_in_insert = false,
                  })
                end
              end,
            }
          end,
        }
      })

      -------- CMP Completion
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
        },
        snippet = {
          expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<Esc>'] = cmp.mapping.close()
        }), 
      })
    end
  }
}