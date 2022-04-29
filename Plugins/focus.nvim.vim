lua << EOF
require("focus").setup({
    excluded_filetypes = {"rbrowser"},
    excluded_buftypes = {"help"},
    compatible_filetrees = {"nerdtree"},
    colorcolumn = {enable = true, width = 100},
})
EOF
