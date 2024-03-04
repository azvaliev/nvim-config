-- Optional but recommended if you enabled the diagnostic option of neotest.
-- Especially testify makes heavy use of tabs and newlines in the error messages, which reduces the readability of the generated virtual text otherwise.
local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message =
        diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

function get_current_file_dir()
  local full_path = vim.api.nvim_buf_get_name(0)
  local dir = full_path:match(".+[^/\\:]+") -- Adapt regex if needed for your OS
  return dir
end

function getJestDir ()
  local cwd = get_current_file_dir()  -- Get initial working directory
  local max_depth = 8  -- Adjust this limit as needed

  for i = 0,max_depth-1,1 do
    local config_path = cwd .. "/jest.config.ts"
    local config_file = io.open(config_path, "r")
    if config_file then
      config_file:close()
      return cwd, config_path
    end

    cwd = vim.fn.fnamemodify(cwd, ':h') -- Move up one directory
  end

  return vim.fn.getcwd(), "jest.config.ts" -- Or provide a default if not found
end

-- Configure test adapters
require("neotest").setup({
  adapters = {
    require("neotest-go"),
    require("neotest-jest")({
      jestCommand = "npm test --",
      jestConfigFile = function()
        local _, config_path = getJestDir()
        return config_path
      end,
      cwd = function()
        local jestCWD, _ = getJestDir()
        return jestCWD
      end
    }),
    require("rustaceanvim.neotest")
  }
})

-- Setup bindings
local neotest = require("neotest")
local wk = require("which-key")

wk.register({
  o = {
    function()
      neotest.output_panel.toggle()
    end,
    "See test output"
  },
  r = { 
    function()
      neotest.run.run()
      neotest.output_panel.open()
    end,
    "Run nearest test"
  },
  f = {
    function() 
      neotest.run.run(vim.fn.expand("%"))
      neotest.output_panel.open()
    end,
    "Run all tests in file"
  }
}, { prefix = "<leader>t" })

