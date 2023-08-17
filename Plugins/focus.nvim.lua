require("focus").setup({
    width = 86,
    minwidth = 0,
    bufnew = false,
    autoresize = {
        enable = false,
    },
    excluded_buftypes = {"help", "terminal", "nofile", "promp", "popup"},
    excluded_filetypes = {
        "rbrowser",
        "floaterm",
        "rdoc",
        "fzf",
        "voomtree",
        'neo-tree',
    },
    compatible_filetrees = {"nerdtree"},
    colorcolumn = {enable = true, width = 100},
    signcolumn = false,
})

