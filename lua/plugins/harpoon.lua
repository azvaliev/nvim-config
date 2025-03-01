return {
  -- Storing common files for a repo that navigate to/from
  {
    "ThePrimeagen/harpoon",
    lazy = true,
    keys = {
      {
        "<leader>ha",
        function() 
          harpoon:list():add()
          print(
            "Added " .. vim.api.nvim_buf_get_name(0) .. " to harpoon"
          )
        end,
        desc = "Add file to harpoon list"
      },
      {
        "<C-h>",
        function() harpoon:list():select(1) end
      },
      {
        "<C-t>",
        function() harpoon:list():select(2) end
      },
      {
        "<C-n>",
        function() harpoon:list():select(3) end
      },
      {
        "<C-s>", function() harpoon:list():select(4) end
      },
      -- Toggle previous & next buffers stored within Harpoon list
      {
        "<C-S-P>",
        function() harpoon:list():prev() end
      },
      {
        "<C-S-N>",
        function() harpoon:list():next() end
      },
      -- Harpoon 🤝 Telescope
      {
        "<leader>fh",
        function()
          harpoon_toggle_telescope(harpoon:list()) 
        end,
        desc = "Open harpoon window",
      }
    },
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function() 
      harpoon = require("harpoon")
      local conf = require("telescope.config").values

      harpoon.setup()

      function harpoon_toggle_telescope(harpoon_files)
        local finder = function()
          local paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
          end

          return require("telescope.finders").new_table({
            results = paths,
          })
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = finder(),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            -- Allow removing files from harpoon
            map("i", "<C-d>", function()
                local state = require("telescope.actions.state")
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                vim.notify("Removed entry " .. harpoon_files.items[1].value, "info")

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(finder())
            end)
            return true
          end,
        }):find()
      end
    end
  }
}
