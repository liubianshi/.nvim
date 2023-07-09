local vkey = vim.api.nvim_set_keymap
local vimcmd = ":lua require('focus')"
local mapopts = { silent = true}

require("focus").setup({
    width = 86,
    minwidth = 0,
    bufnew = false,
    autoresize = false,
    excluded_buftypes = {"help", "terminal", "nofile", "promp", "popup"},
    excluded_filetypes = {"rbrowser", "floaterm", "rdoc", "fzf", "voomtree"},
    compatible_filetrees = {"nerdtree"},
    colorcolumn = {enable = TRUE, width = 100},
    signcolumn = false,
})

