lua << EOF
require("focus").setup({
    excluded_filetypes = {"rbrowser", "floaterm"},
    excluded_buftypes = {"help"},
    compatible_filetrees = {"nerdtree"},
    colorcolumn = {enable = false, width = 100},
})
EOF
