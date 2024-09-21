return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-plenary",
      { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
      "nvim-neotest/neotest-jest",
      { "mrcjkb/rustaceanvim", version = "^5", lazy = false }
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-vitest"),
          require("neotest-golang"),
          require('neotest-jest')({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
          require('rustaceanvim.neotest')
        }
      })

      vim.keymap.set("n", "<leader>tr", function()
        neotest.output_panel.open()
        neotest.output_panel.clear()
        neotest.run.run()
      end)

      vim.keymap.set("n", "<leader>tc", function()
        neotest.output_panel.close()
      end)
    end,
  },
}
