-- Debugger in Neovim
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Language support
    ---- Rust is already covered via rustaceanvim, which will auto setup and work with dap continue
    "mxsdev/nvim-dap-vscode-js",
    { "microsoft/vscode-js-debug", build = "npm ci --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out" },
    "leoluz/nvim-dap-go",
    -- UI
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    -- Misc dependencies
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim"
  },
  keys = {
    {
      "<leader>dc",
      desc = "start/continue debugging",
      function()
        require("dap").continue()
      end,
      noremap = true
    },
    {
      "<leader>db", 
      desc = "toggle a breakpoint on the current line",
      function()
        require("dap").toggle_breakpoint()
      end,
      noremap = true
    },
    {
      "<leader>gb",
      desc = "continue debugging until cursor",
      function()
        require("dap").run_to_cursor()
      end,
      noremap = true
    },
    {
      "<space>?",
      desc = "eval variable under cursor",
      function()
        require("dapui").eval(nil, { enter = true })
      end,
      noremap = true
    },
    {
      "<leader>du",
      desc = "open/close the debug ui",
      function()
        require("dapui").toggle()
      end,
      noremap = true
    },
    {
      "<leader>di",
      desc = "step into",
      function()
        require("dap").step_into()
      end,
      noremap = true
    },
    {
      "<leader>do",
      desc = "step over",
      function()
        require("dap").step_over()
      end,
      noremap = true
    },
    {
      "<leader>dO",
      desc = "step out",
      function()
        require("dap").step_out()
      end,
      noremap = true
    },
    {
      "<leader>dp", 
      desc = "step back",
      function()
        require("dap").step_back()
      end,
      noremap = true
    },
    {
      "<leader>dr",
      desc = "restart debugging",
      function() 
        require("dap").restart()
      end,
      noremap = true
    },
    { 
      "<leader>td", 
      desc = "run test (go)",
      function()
        require("dap-go").debug_test()
      end,
      ft = "go"
    }
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dapgo = require("dap-go")

    dapui.setup()
    dapgo.setup()
    require("nvim-dap-virtual-text").setup()
    require("dap-vscode-js").setup({
      -- Command to use to launch the debug server.
      debugger_cmd = { 
        "node",
        vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/vsDebugServer.js"
      }, 
      -- which adapters to register in nvim-dap
      adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal', 'pwa-extensionHost' }, 
      -- Path for file logging
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" 
      -- Logging level for output to file. Set to false to disable file logging.
      -- log_file_level = false 
      -- Logging level for output to console. Set to false to disable console output.
      -- log_console_level = vim.log.levels.ERROR 
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          -- trace = true, -- include debugger info
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        }
      }
    end

    -- auto-open/close dap ui when starting/stopping
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end
}
