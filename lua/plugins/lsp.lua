return {
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
        vim.keymap.set('n', '<leader>s', function() telescope.lsp_workspace_symbols() end, opts)
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
          "rust_analyzer",
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
          end
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
        }), 
      })
    end
  }
}
