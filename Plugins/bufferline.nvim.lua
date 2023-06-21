require"bufferline".setup{
    highlights = {
        fill = {
            guibg = {
                attribute = "bg",
                highlight = "bg",
            }
        },
    },
    options = {
        separator_style = "thin",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        }
    }
}
