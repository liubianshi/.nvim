local yanky    = require('yanky')
local mapping  = require("yanky.telescope.mapping")
local mappings = mapping.get_defaults()
mappings.i["<c-p>"] = nil

yanky.setup({
    highlight = { timer = 200 },
    ring = {
        storage = jit.os:find("Windows") and "shada" or "sqlite",
        ignore_registers = {"_"},
    },
    picker = {
        telescope = {
            use_default_mappings = false,
            mappings = mappings,
        },
    },
    textobj = { enabled = true,}
})

require("telescope").load_extension("yank_history")
vim.keymap.set("n", "<leader>sp", "<cmd>Telescope yank_history<cr>", {
    desc = "Telescope: yank history",
    silent = true,
})

