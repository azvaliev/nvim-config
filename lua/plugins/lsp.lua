return {
  {
    "mrcjkb/rustaceanvim",
    version = '^5',
    lazy = false, -- This plugin is already lazy
    init = function()
      -- Format on save
      vim.g.rustfmt_autosave = 1
    end,
    -- Need lspconfig + mason to load first, otherwise it cannot find codelldb
    dependencies = { "neovim/nvim-lspconfig" }
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
      { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
      {
        "olexsmir/gopher.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" }
      }
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
        vim.lsp.inlay_hint.enable(true);

        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', 'gd', function() telescope.lsp_definitions() end, opts)
        vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set('n', 'gi', function() telescope.lsp_implementations() end, opts)
        vim.keymap.set('n', 'go', function() telescope.lsp_type_definitions() end, opts)
        vim.keymap.set('n', 'gr', function() telescope.lsp_references() end, opts)
        vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', 'rn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('n', '<leader>fa', function() vim.lsp.buf.format({async = true}) end, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>s', function() telescope.lsp_dynamic_workspace_symbols() end, opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        signs = true,
        float = { scope = "line" },
        jump = { float = true }
      })

      -- TypeScript specific stuff config, mostly doing this to enable inlay hints

      require("typescript-tools").setup {
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "literals",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false
          }
        }
      }

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
          -- no-op because the typescript plugin sets this up
          ["ts_ls"] = function() end,
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
          -- Tweak Go settings
          ["gopls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup({
              -- Format on save
              on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  command = "lua vim.lsp.buf.format()"
                })
              end,
              settings = {
                gopls = {
                  analyses = {
                    -- Report unused variables in LSP
                    unusedvariable = true
                  },
                  -- Additional static checks to catch bugs
                  staticcheck = true,
                  -- vulncheck = "Imports",
                  -- Enable inlay hints
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true
                  }
                }
              }
            })
          end,
          -- Customize display of typos lsp
          -- - All warnings, no errors
          -- - No virtual text
          ['typos_lsp'] = function()
            require('lspconfig').typos_lsp.setup {
              init_options = {
                -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
                -- Defaults to error.
                diagnosticSeverity = "Hint"
              }
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
          ['<C-k>'] = cmp.mapping.select_prev_item()
        }), 
      })

    end
  }
}
