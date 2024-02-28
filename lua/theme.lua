local default_opts = {
  background = "dark",
  colorscheme = {
    dark = "catppuccin-mocha",
    light = "everforest",
  },
  palette = {
    dark = {
      bg       = "#202328",
      fg       = "#bbc2cf",
      yellow   = "#ECBE7B",
      cyan     = "#008080",
      darkblue = "#081633",
      green    = "#98be65",
      orange   = "#FF8800",
      violet   = "#a9a1e1",
      magenta  = "#c678dd",
      blue     = "#51afef",
      red      = "#ec5f67",
    },
    light = {
      bg       = "#FFFBEF",
      fg       = "#5c6A72",
      bg_dim   = "#F2EFDF",
      yellow   = "#DFA000",
      cyan     = "#35A77C",
      darkblue = "#93B259",
      green    = "#8DA101",
      orange   = "#F57D26",
      violet   = "#DF67BA",
      magenta  = "#E66868",
      blue     = "#3A94C5",
      red      = "#F85552",
    }
  },
}

-- custom highlight -----------------------------------------------------
local higroup = vim.api.nvim_create_augroup("HighlightGroup", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  group = higroup,
  callback = function()
    vim.cmd [[
            " 用于实现弹出窗口背景透明
            highlight VertSplit      cterm=None gui=None guibg=bg
            highlight FoldColumn     guibg=bg
            highlight Folded         gui=bold guifg=LightGreen guibg=bg
            highlight SignColumn     guibg=bg
            highlight LineNr         guibg=bg
        ]]
  end,
  desc = "remove unnecessary background",
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  group = higroup,
  callback = function()
    -- 解决 vim 帮助文件的示例代码的不够突显的问题
    vim.cmd "hi def link helpExample Special"
    vim.cmd(
      "highlight MyBorder guifg=" .. vim.g.lbs_colors.orange .. " guibg=NONE"
    )
  end,
  desc = "Define personal highlight group",
})

-- set colorscheme ------------------------------------------------------
vim.o.background =
  string.lower(vim.env.NVIM_BACKGROUND or default_opts.background)
if vim.o.background == "dark" then
  vim.cmd(
    "colorscheme "
      .. (vim.env.NVIM_COLOR_SCHEME_DARK or default_opts.colorscheme.dark)
  )
else
  vim.cmd(
    "colorscheme "
      .. (vim.env.NVIM_COLOR_SCHEME_LIGHT or default_opts.colorscheme.light)
  )
end

-- adjust palette according to color scheme -----------------------------
if not vim.g.lbs_colors then
  vim.g.lbs_colors = default_opts.palette[vim.o.background]
end
