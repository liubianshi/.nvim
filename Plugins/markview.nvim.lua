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
local repeat_symbol = {
  type = "repeating",
  repeat_amount = function(_)
    local indent = vim.fn.indent(vim.fn.line('.'))
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    return math.floor(wininfo.width / 2) - wininfo.textoff - 1 - indent
  end,
  text = "─",
  hl = {
    "MarkviewGradient1", "MarkviewGradient2", "MarkviewGradient3",
    "MarkviewGradient4", "MarkviewGradient5", "MarkviewGradient6",
    "MarkviewGradient7", "MarkviewGradient8", "MarkviewGradient9",
    "MarkviewGradient10"
  },
  --- Placement direction of the gradient.
  ---@type "left" | "right"
  direction = "left"
}

require("markview").setup {
	modes = { "n", "i", "c", ":", "no", "io", "co" },
	hybrid_modes = { "i", "n" },
  ignore_nodes = { "list_item", "fenced_code_block", "block_quote" },
  headings = {
    enable = true,
    shift_width = 0,
    heading_1 = {
      style = "label",
      align = "left",
      icon = "",
      sign = " ",
      corner_left = " ░▒▓",
      padding_left = " ",
      corner_left_hl = "@comment.warning",

    },
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
    sign = false,
    language_direction = "left",
  },
  latex = {
    block = { enable = false },
  },
  list_items = {
    enable = false,
  },
  inline_codes = {
    enable = false,
  },
  links = {
    enable = false,
  },
  horizontal_rules = {
    enable = true,
    parts = {
      repeat_symbol,
      {
        type = "text",
        text = "  ",
        hl = "MarkviewGradient10"
      },
      repeat_symbol,
    }
  }
}

for i = 1, 6 do
  vim.api.nvim_set_hl(0, "MarkviewHeading" .. i, {
    bg = "NONE",
    bold = true,
  })
end

