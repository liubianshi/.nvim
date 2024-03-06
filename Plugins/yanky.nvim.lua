local yanky    = require('yanky')
local mapping  = require("yanky.telescope.mapping")
local mappings = mapping.get_defaults()
mappings.i["<c-p>"]      = nil
mappings.n["o"]   = mapping.special_put("YankyPutAfterFilter")
mappings.n["O"]   = mapping.special_put("YankyPutBeforeFilter")
mappings.n["]"]   = mapping.special_put("YankyPutIndentBeforeShiftRight")
mappings.n["["]   = mapping.special_put("YankyPutIndentBeforeShiftLeft")
mappings.n[">"] = mapping.special_put("YankyPutIndentAfterShiftRight")
mappings.n["<"] = mapping.special_put("YankyPutIndentAfterShiftLeft")

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


