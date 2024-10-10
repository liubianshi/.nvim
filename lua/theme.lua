local default_opts = {
  background = "dark",
  colorscheme = {
    dark = "kanagawa-wave",
    -- dark = "everforest",
    -- dark = "default",
    light = "default",
  },
  palette = {
    dark = {
      bg       = "#202328",
      fg       = "#bbc2cf",
      fg_float = "#D1E3FA",
      yellow   = "#ECBE7B",
      cyan     = "#008080",
      darkblue = "#003152",
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
      fg_float = "#D1E3FA",
      bg_dim   = "#F2EFDF",
      yellow   = "#FBD26A",
      cyan     = "#35A77C",
      darkblue = "#003152",
      green    = "#8DA101",
      orange   = "#F57D26",
      violet   = "#DF67BA",
      magenta  = "#E66868",
      blue     = "#3A94C5",
      red      = "#900021",
    }
  },
}
local patch_pallete_from_colorscheme = {
  github_theme = function(light)
    light = light or true
    local valid, github = pcall(require, 'github-theme.palette')
    if not valid then return end
    local p = light and github.load('github_light') or github.load('github_dark')
    return {
      bg       = p.canvas.defaut,
      fg       = p.fg.default,
      yellow   = p.yellow.base,
      cyan     = p.cyan.base,
      blue     = p.blue.base,
      darkblue = p.scale.blue[-1],
      green    = p.green.base,
      orange   = p.orange,
      violet   = p.scale.purple[-3],
      magenta  = p.magenta.base,
      red      = p.red.base,
      pink     = p.pink.base,
    }
  end,
  ['kanagawa-wave'] = function(theme)
    theme = theme or 'wave'
    local valid,kanagawa = pcall(require, "kanagawa.colors")
    if not valid then return end
    local colors = kanagawa.setup({theme = 'wave'})
    local palette = colors.palette
    local ui = colors.theme.ui
    return {
      bg        = ui.bg,
      bg_float  = ui.float.bg,
      bg_border = ui.float.bg_border,
      bg_pmenu  = ui.pmenu.bg,
      fg        = ui.fg,
      fg_float  = ui.float.fg,
      fg_border = ui.float.fg_border,
      fg_pmenu  = ui.pmenu.fg,
      special   = ui.special,
      nontext   = ui.nontext,
      aqua      = palette.waveAqua1,
      yellow    = palette.dragonYellow,
      cyan      = palette.lotusCyan,
      blue      = palette.waveBlue1,
      darkblue  = palette.waveBlue2,
      green     = palette.dragonGreen,
      orange    = palette.surimiOrange,
      violet    = palette.dragonViolet,
      magenta   = palette.dragonPink,
      red       = palette.waveRed,
    }
  end,
}

-- set colorscheme ------------------------------------------------------
vim.o.background = string.lower(vim.env.NVIM_BACKGROUND or default_opts.background)
local colorscheme = vim.env.NVIM_COLOR_SCHEME_LIGHT or default_opts.colorscheme.light
if vim.o.background == "dark" then
  colorscheme = vim.env.NVIM_COLOR_SCHEME_DARK or default_opts.colorscheme.dark
end

-- adjust palette according to color scheme -----------------------------
vim.g.lbs_colors = default_opts.palette[vim.o.background]

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
      highlight NormalFloat    guibg=NONE
      highlight FloatBorder    guibg=NONE
      highlight FloatTitle     guibg=NONE
      highlight DiagnosticSignInfo guibg=NONE
      highlight DiagnosticSignHint guibg=NONE
      highlight DiagnosticSignWarn guibg=NONE
      highlight DiagnosticSignError guibg=NONE
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
    if vim.fn.exists('g:neovide') == 1 then
      vim.cmd("highlight MyBorder guifg=bg guibg=NONE")
    else
      vim.cmd("highlight MyBorder guifg="  .. vim.g.lbs_colors.orange .. " guibg=NONE")
    end
    vim.cmd("highlight DiagnosticSignInfo guibg=NONE")
    -- Setting the color scheme of the Complement window
    local pallete = {
      background = vim.g.lbs_colors.yellow,
      fg = vim.g.lbs_colors.darkblue,
      strong = vim.g.lbs_colors.red,
    }
    if vim.o.background == "dark" then
      pallete = {
          background = vim.g.lbs_colors.darkblue,
          fg = vim.g.lbs_colors.fg_float,
          strong = vim.g.lbs_colors.red,
        }
    end

    vim.cmd("highlight MyPmenu guibg="          .. pallete.background)
    vim.cmd("highlight CmpItemAbbr guifg="      .. pallete.fg)
    vim.cmd("highlight CmpItemAbbrMatch guifg=" .. pallete.strong)
    vim.cmd("highlight MsgSeparator guibg=bg guifg=" .. pallete.strong)
    vim.cmd("highlight ObsidianHighlightText guifg=" .. pallete.strong)
    vim.cmd("highlight @markdown.strong gui=underline")


    vim.cmd.highlight('link IndentLine LineNr')
    vim.cmd.highlight('IndentLineCurrent guifg=' .. vim.g.lbs_colors.orange)
  end,
  desc = "Define personal highlight group",
})

vim.cmd("colorscheme " .. colorscheme)
