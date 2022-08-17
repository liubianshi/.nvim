lua << EOF
require"bufferline".setup{
    highlights = {
        fill = {
            guibg = {
                attribute = "bg",
                highlight = "bg", 
            }
        }
    }
}
EOF
