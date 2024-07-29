local color = vim.g.lbs_colors
local color_bg = "none"
local trans = { bg = color_bg }
local bufferline = require("bufferline")
bufferline.setup {
  highlights = {
    background = { bg = color_bg, underline = true },
    fill = { bg = color_bg },
    buffer_selected = {
      fg = color.orange,
      bg = color_bg,
      bold = false,
      italic = true,
      underline = true,
    },
    buffer_visible = { bg = color_bg, fg = color.cyan, underline = true },
    close_button_selected = {
      fg = color.orange,
      bg = color_bg,
      underline = false,
    },
    separator = { bg = color_bg, fg = "bg" },
    separator_selected = {
      bg = color_bg,
      fg = color.bg_pmenu,
    },
    separator_visible = trans,
    tab = trans,
    tab_separator = { bg = color_bg, fg = color.bg_pmenu },
    tab_separator_selected = { bg = color_bg, fg = color.bg_pmenu },
    tab_selected = { fg = color.orange, bg = color_bg, underline = true },
    numbers = { underline = true },
    numbers_visible = {underline = true, fg = color.cyan},
    numbers_selected = {underline = true, fg = color.orange},
    pick = { underline = true },
    pick_visible = {underline = true},
    pick_selected = {underline = true},
    tab_close = trans,
    close_button = trans,
    trunc_marker = trans,
    offset_separator = trans,
  },
  options = {
    themable = true,
    style_preset = bufferline.style_preset.minimal,
    buffer_close_icon = "",
    tab_size = 20,
    enforce_regular_tabs = true,
    show_buffer_close_icon = false,
    show_buffer_icons = false,
    color_icons = false,
    show_close_icon = false,
    separator_style = {" ", " "},
    always_show_bufferline = false,
    indicator = { style = "none" },
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
      {
        filetype = "kittypreview",
      },
    },
  },
}
