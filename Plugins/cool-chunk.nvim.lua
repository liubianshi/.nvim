local ft = require("cool-chunk.utils.filetype")
require("cool-chunk").setup {
  chunk = {
    notify = true,
    support_filetypes = {'json', 'lua', 'r', 'perl'},
    exclude_filetypes = ft.exclude_filetypes,
    hl_group = {
      chunk = "CursorLineNr",
      error = "Error",
    },
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "╭",
      left_bottom = "╰",
      left_arrow = "<",
      bottom_arrow = "v",
      right_arrow = ">",
    },
    textobject = "ah",
    animate_duration = 200,
    fire_event = { "CursorHold", "CursorHoldI" },
  },
}
