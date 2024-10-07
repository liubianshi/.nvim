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
    pad_amount = 0,
    sign = true,
    language_direction = "right",
  },
  inline_codes = {
    enable = false,
  },
  links = {
    enable = true,
  }
}

for i = 1, 6 do
  vim.api.nvim_set_hl(0, "MarkviewHeading" .. i, {
    bg = "NONE",
    bold = true,
  })
end

