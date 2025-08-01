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
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "yioneko/nvim-vtsls",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "olexsmir/gopher.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        lazy = true,
        ft = { "gosum", "gomod", "go" },
        keys = {
          {
            "<leader>ie",
            desc = "generate if err != nil",
            "<cmd>GoIfErr<CR>",
            noremap = true
          },
        }
      }
    },
    config = function()
      --------- LSP Zero
      local lsp_zero = require('lsp-zero')
      local picker = require('snacks').picker

      -- lsp_attach is where you enable features that only work
      -- if there is a language server active in the file
      local lsp_attach = function(client, bufnr)
        local opts = {buffer = bufnr}
        vim.lsp.inlay_hint.enable(true);

        -- Pickers
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', 'gd', function() picker.lsp_definitions() end, opts)
        vim.keymap.set('n', 'gD', function() picker.lsp_declaration() end, opts)
        vim.keymap.set('n', 'gi', function() picker.lsp_implementations() end, opts)
        vim.keymap.set('n', 'gy', function() picker.lsp_type_definitions() end, opts)
        vim.keymap.set('n', 'gr', function() picker.lsp_references() end, opts)
        vim.keymap.set('n', '<leader>ss', function() picker.lsp_symbols() end, opts)
        vim.keymap.set('n', '<leader>sS', function() picker.lsp_dynamic_workspace_symbols() end, opts)

        vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)

        local ft = vim.bo[bufnr].filetype

        if string.match(ft, "javascript") or string.match(ft, "typescript") then
          -- Autofix entire buffer with eslint_d:
          vim.keymap.set({ 'n', 'v' }, "<leader>fa", function()
            vim.cmd("mark F")
            vim.cmd('%!eslint_d --stdin --fix-to-stdout --stdin-filename "' .. vim.fn.expand("%") .. '"')
            vim.cmd("write")
            vim.cmd("normal! `F") -- Jump back to mark F
          end, { noremap = true, silent = true, buffer = bufnr })

          -- -- Autofix visual selection with eslint_d:
          -- -- This doesn't work but I didn't spend any time on it bc dont' really care for it
          -- vim.keymap.set("v", "<leader>fa", function()
          --   vim.cmd('!eslint_d --stdin --fix-to-stdout')
          --   vim.cmd("normal! gv") -- Reselect visual block
          -- end, { noremap = true, silent = true, buffer = bufnr })
        else
          vim.keymap.set('n', '<leader>fa', function() vim.lsp.buf.format({async = true}) end, opts)
        end

        vim.keymap.set({ 'n', 'v' }, '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
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

      ---------- Mason, Language Servers
      require('mason').setup({})
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "eslint_d", -- js linter
        },
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          -- Frontend
          -- "cssls",
          -- "cssmodules_ls",
          -- "tailwindcss",
          "graphql",
          "html",
          -- Prisma
          "prismals",
          -- JavaScript/TypeScript
          "vtsls",
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
          ['jsonls'] = function()
            local lspconfig = require("lspconfig")

            lspconfig.jsonls.setup({
              on_attach = function(client, bufnr)
                local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

                if ft == 'json' then
                  -- Auto format JSON on save
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    pattern = { "*.json" },
                    callback = function() format_json_with_jq() end
                  })

                  -- Have `fa` use json formatter for json files
                  vim.keymap.set('n', '<leader>fa', function() format_json_with_jq() end, { buffer = bufnr, noremap = true, silent = true })
                end

              end
            })
          end,
          ['yamlls'] = function()
            local lspconfig = require("lspconfig")

            lspconfig.yamlls.setup {
              settings = {
                yaml = {
                  schemas = {
                    ["https://moonrepo.dev/schemas/tasks.json"] = ".moon/tasks/*.yml",
                    ["https://moonrepo.dev/schemas/project.json"] = "**/moon.yml",
                    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/refs/heads/main/schemas/v3.0/schema.yaml"] = { "*openapi*.yml" },
                    ["https://raw.githubusercontent.com/oapi-codegen/oapi-codegen/HEAD/configuration-schema.json"] = { "*oapi*.yml", "*oapi*.yaml" },
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/refs/heads/main/schema/compose-spec.json"] = {"*compose.yml", "*compose.yaml" },
                  }
                }
              }
            }
          end,
          ["vtsls"] = function() 
            local lspconfig = require("lspconfig")
            
            lspconfig.vtsls.setup({
              -- Disable auto format
              on_attach = function(client)
                client.flags.debounce_text_changes = 150;
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false

              end,
              settings = {
                typescript = {
                  tsserver = {
                    maxTsServerMemory = 16384, -- 16GB memory
                  },
                  parameterNames = { enabled = "literals" },
                  inlayHints = { parameterNames = "all" },
                  preferences = {
                    -- performance improvements
                    autoImportFileExcludePatterns = { "**/build/**", "**/out/**", "**/*.test.ts", "**/*.spec.ts" },
                    includeCompletionsForModuleExports = false,
                    includePackageJsonAutoImports = "off",
                    preferTypeOnlyAutoImports = true
                  }
                },
                vtsls = {
                  -- autoUseWorkspaceTsdk = true,
                  experimental = {
                    completion = {
                      enableServerSideFuzzyMatch = true,
                      entriesLimit = 20,
                    }
                  }
                }
              }
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
              },
              on_attach = function(client, bufnr)
                client.flags.debounce_text_changes = 5000;
              end
            }
          end,
        }
      })

      -- FIX for floating window "No Information Available" on hover
      -- I think it shows up because some LSPs don't have info available
      vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
        config = config or {}
        config.focus_id = ctx.method
        if not (result and result.contents) then
          return
        end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
        if vim.tbl_isempty(markdown_lines) then
          return
        end
        return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
      end

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
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require('lint')

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        go = { "golangcilint" }
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end
  }
}

