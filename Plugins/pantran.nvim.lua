local pantran = require('pantran')
pantran.setup({
    default_engine = "google",
    engines = {
        google = {
            fallback =  {
                default_source = "auto",
                default_target = "zh-CN",
            }
        }
    }
})

local opts = {noremap = true, silent = true, expr = true}
vim.keymap.set("n", "<leader>tr", pantran.motion_translate, opts)
vim.keymap.set("n", "<leader>trr", function() return pantran.motion_translate() .. "_" end, opts)
vim.keymap.set("x", "<leader>tr", pantran.motion_translate, opts)
