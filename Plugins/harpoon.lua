local harpoon = require "harpoon"
harpoon:setup()

vim.keymap.set("n", "<leader>la", function() harpoon:list():add() end, { desc = "harpoon: add" })
vim.keymap.set("n", "<leader>l1", function() harpoon:list():select(1) end, { desc = "harpoon: first file" })
vim.keymap.set("n", "<leader>l2", function() harpoon:list():select(2) end, { desc = "harpoon: second file" })
vim.keymap.set("n", "<leader>l3", function() harpoon:list():select(3) end, { desc = "harpoon: third file" })
vim.keymap.set("n", "<leader>l4", function() harpoon:list():select(4) end, { desc = "harpoon: fourth file" })

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local make_finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
        end

        return require("telescope.finders").new_table(
            {
            results = paths
            }
        )
    end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = make_finder(),
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_buffer_number, map)
        map(
          "i",
          "<C-d>", -- your mapping here
          function()
            local state = require "telescope.actions.state"
            local selected_entry = state.get_selected_entry()
            local current_picker =
              state.get_current_picker(prompt_buffer_number)

            harpoon:list():remove_at(selected_entry.index)
            current_picker:refresh(make_finder())
          end
        )

        return true
      end,
    })
    :find()
end

vim.keymap.set("n", "<leader>lh", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

harpoon:extend {
  UI_CREATE = function(cx)
    vim.keymap.set("n", "<C-v>", function()
      harpoon.ui:select_menu_item { vsplit = true }
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-x>", function()
      harpoon.ui:select_menu_item { split = true }
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-t>", function()
      harpoon.ui:select_menu_item { tabedit = true }
    end, { buffer = cx.bufnr })
  end,
}
