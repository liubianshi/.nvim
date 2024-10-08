--- @diagnostic disable: missing-fields
require("notify").setup {
  -- background_colour = "#000000",
  timeout = 3000,
  minimum_width = 30,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { zindex = 100 })
  end,
}
