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
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              -- Start searching from the buffer's directory
              local current_dir = fn.fnamemodify(path, ":p:h")
              local root_dir = fn.getcwd()

              while current_dir and current_dir ~= root_dir do
                if Path:new(current_dir .. "/jest.config.ts"):exists() then
                  return current_dir
                end
                current_dir = fn.fnamemodify(current_dir, ":h")
              end

              return root_dir -- Stop searching once the root directory is reached
            end,
          }),
          require("rustaceanvim.neotest"),
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
