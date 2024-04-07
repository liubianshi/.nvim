local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>H", function() harpoon:list():add()     end, { desc = "harpoon: add"} )
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "harpoon: first file"} )
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "harpoon: second file"} )
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "harpoon: third file"} )
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "harpoon: fourth file"} )

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>hl", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })
