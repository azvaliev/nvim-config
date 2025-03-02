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
          vim.notify(
            "Added " .. vim.api.nvim_buf_get_name(0) .. " to harpoon",
            "info"
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
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() 
      harpoon = require("harpoon")

      harpoon.setup()

      local function generate_harpoon_picker()
          local file_paths = {}
          for _, item in ipairs(harpoon:list().items) do
              table.insert(file_paths, {
                  text = item.value,
                  file = item.value
              })
          end
          return file_paths
      end


      vim.keymap.set("n", "<leader>fh", function() Snacks.picker({
        finder = generate_harpoon_picker,
        win = {
          input = {
            keys = {
              ["<C-d>"] = { "harpoon_delete", mode = { "i" } },
              ["dd"] = { "harpoon_delete", mode = { "n", "x" } }
            }
          },
          list = {
            keys = {
              ["<C-d>"] = { "harpoon_delete", mode = { "i" } },
              ["dd"] = { "harpoon_delete", mode = { "n", "x" } }
            }
          },
        },
        actions = {
          harpoon_delete = function(picker, item)
            local to_remove = item or picker:selected()
            local harpoon_items = harpoon:list().items

            vim.notify("Removed " .. harpoon_items[to_remove.idx].value, "info")
            table.remove(harpoon_items, to_remove.idx)
            picker:find({
                refresh = true -- refresh picker after removing values
            })
          end
        },
      }) end)
    end
  }
}
