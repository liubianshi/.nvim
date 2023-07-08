local yanky    = require('yanky')
local mapping  = require("yanky.telescope.mapping")
local mappings = mapping.get_defaults()
mappings.i["<c-p>"] = nil

yanky.setup({
    highlight = { timer = 200 },
    ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    picker = {
        telescope = {
            use_default_mappings = false,
            mappings = mappings,
        },
    },
})
