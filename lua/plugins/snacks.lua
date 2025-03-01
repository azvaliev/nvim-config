return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Disable all LSP stuff for big files
      bigfile = { enabled = true },
      -- Show blame
      git = {
        enabled = true,
      },
      -- Open the current file in the remote git website
      gitbrowse = {
        enabled = true,
        opts = {
          gitbrowse = {
            url_patterns = {
              ["github%.com"] = {
                branch = "/tree/{branch}",
                file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
                commit = "/commit/{commit}",
              },
              [{"gitlab%.com", "gitlab.homee.io"}] = {
                branch = "/-/tree/{branch}",
                file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
                permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
                commit = "/-/commit/{commit}",
              },
              ["bitbucket%.org"] = {
                branch = "/src/{branch}",
                file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
                permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}",
                commit = "/commits/{commit}",
              },
              ["git.sr.ht"] = {
                branch = "/tree/{branch}",
                file = "/tree/{branch}/item/{file}",
                permalink = "/tree/{commit}/item/{file}#L{line_start}",
                commit = "/commit/{commit}",
              },
            },
          }
        }
      },
      -- Shows fancy indents to indicate scope
      -- indent = { enabled = true },
      -- Trivial UI stuff
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 8000
      },
      -- Open lazygit from neovim
      lazygit = { enabled = true },
      -- Telescope replacement on steroids
      picker = { enabled = true },
      -- Load file don't block for LSP and stuff
      quickfile = { enabled = true },
      -- Let's the picker know when a file has been renamed
      rename = {
        enabled = true,
        config = function()
          vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(event)
                if event.data.actions.type == "move" then
                    Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
                end
            end,
          })
        end
      },
      -- ]i and [i to jump to start/end of a scope
      scope = { enabled = true },
      scratch = { 
        enabled = true,
      },
      scroll = { enabled = true },
    },
    keys = {
      -- Git utils
      {
        "<leader>gb",
        function() Snacks.git.blame_line() end,
        desc = "open git blame for line"
      },
      {
        "<leader>go",
        function() Snacks.gitbrowse.open() end,
        desc = "open current file/line in remote git repo"
      },
      {
        "<leader>gg",
        function() Snacks.lazygit.open() end
      },

      -- File Picker
      { "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },

      -- Fuzzy search
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },

      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },

      -- Quick navigation
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },

      -- Git utils
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },

    },
  },
}

