-- Searching and finding files
return {
  {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim"
    },

    config = function()
      require("telescope").setup({})

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.fd, {})
      vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
      vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "re-open the previous telescope window" })
      vim.keymap.set("n", "<leader>pws", function()
          local word = vim.fn.expand("<cword>")
          builtin.grep_string({ search = word })
      end)
      vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end
  },
  {

    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
  }
}
