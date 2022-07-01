lua << EOF
require("focus").setup({
    width = 90,
    minwidth = 50,
    bufnew = true,
    autoresize = false,
    excluded_buftypes = {"help", "terminal", "nofile", "promp", "popup"},
    excluded_filetypes = {"rbrowser", "floaterm", "rdoc"},
    compatible_filetrees = {"nerdtree"},
    colorcolumn = {enable = TRUE, width = 100},
    signcolumn = false,
})
EOF
