require("colorful-winsep").setup({
  -- highlight for Window separator
  hi = {
    bg = "NONE",
    fg = "#E6C384",
  },
  -- This plugin will not be activated for filetype in the following table.
  no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
  -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
  symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
  -- Smooth moving switch
  smooth = true,
  exponential_smoothing = true,
  anchor = {
    left   = { height = 1, x = -1, y = -1 },
    right  = { height = 1, x = -1, y = 0 },
    up     = { width = 0,  x = -1, y = 0 },
    bottom = { width = 0,  x = 1,  y = 0 },
 },
})
