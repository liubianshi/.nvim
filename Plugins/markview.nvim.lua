local opts = {
  heading = {
    style = "icon",
    sign = " ",
  }
}
local hl_normal = vim.api.nvim_get_hl(0, { name = "Normal"})
local hl_code = vim.api.nvim_get_hl(0, { name = "MarkviewCode"})
local hl_code_info = vim.api.nvim_get_hl(0, { name = "MarkviewCodeInfo"})
hl_code.bg = hl_normal.bg
hl_code_info.bg = hl_normal.bg

require("markview").setup {
	modes = { "n", "i", "c", ":", "no", "io", "co" },
	hybrid_modes = { "i", "n" },
  ignore_nodes = { "list_item", "fenced_code_block" },
  headings = {
    enable = true,
    shift_width = 0,
    heading_1 = opts.heading,
    heading_2 = opts.heading,
    heading_3 = opts.heading,
    heading_4 = opts.heading,
    heading_5 = opts.heading,
    heading_6 = opts.heading,
  },
  code_blocks = {
    enable = true,
    icons = "mini",
    style = "simple",
    hl = hl_code,
    info_hl = hl_code_info,
    pad_amount = 1,
    sign = false,
    language_direction = "right",
  },
  list_items = {
    enable = false,
  },
  inline_codes = {
    enable = false,
  },
  links = {
    enable = false,
  }
}

for i = 1, 6 do
  vim.api.nvim_set_hl(0, "MarkviewHeading" .. i, {
    bg = "NONE",
    bold = true,
  })
end

