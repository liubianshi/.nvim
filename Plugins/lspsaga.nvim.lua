-- local keymap = vim.keymap.set
local saga = require('lspsaga')
saga.setup({
    symbol_in_winbar = { enable = false },
    lightbulb = {enable = false},
})

local sagamap = function(key, desc, cmd, opts)
    opts = opts or {}
    local mode = opts.mode or 'n'
    opts.mode = nil
    opts = vim.tbl_extend("keep", opts or {}, {
        desc = "Lspsaga: " .. desc,
        silent = true,
        noremap = true,
    })
    vim.keymap.set(mode, key, cmd, opts)
end
sagamap("<localleader>ca", "Code Action",   "<cmd>Lspsaga code_action<cr>")
sagamap("<localleader>cv", "Outline",       "<cmd>Lspsaga outline<cr>")
sagamap("<localleader>cb", "Toggle winbar", "<cmd>Lspsaga winbar_toggle<cr>")

require('which-key').register(
    {
        ["c"] = { name = "LSP"}
    },
    { prefix = "<localleader>"}
)
