local color = vim.g.lbs_colors
local trans = { bg = "bg"}
require"bufferline".setup{
    highlights = {
        background = { bg = "bg", fg = color['bg_pmenu'] },
        fill = { fg = color['cyan'], bg = "bg" },
        buffer_selected = { fg = color.orange, bg = "bg", bold = true, italic = true, underline = false},
        buffer_visible = {bg = "bg", fg = color.cyan},
        close_button_selected = {bg = "bg", underline = false, fg = color.orange},
        separator = {bg = "bg", fg = color.bg_pmenu},
        separator_selected = {bg = "bg", fg = color.bg_pmenu},
        separator_visible = trans,
        tab = trans,
        tab_separator = {bg = "bg", fg = color.bg_pmenu},
        tab_separator_selected = {bg = "bg", fg = color.bg_pmenu},
        tab_selected = { bg = "bg", underline = false},
        tab_close = trans,
        close_button = trans,
        trunc_marker = trans,
        offset_separator = trans,
    },
    options = {
        themable = true,
        indicator = { icon = ' 📌 ', style = 'none', },
        show_buffer_close_icon = false,
        separator_style = "thick",
        always_show_bufferline = false,
        color_icons =  true,
        offsets = {
            {
                filetype = "neo-tree",
                text = "Neo-tree",
                highlight = "Directory",
                text_align = "left",
            },
            {
                filetype = "kittypreview",
            }
        }
    }
}
