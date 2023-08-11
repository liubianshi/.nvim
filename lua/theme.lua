local default_opts = {
    background = 'dark',
    colorscheme = {
	dark = 'kanagawa',
	light = 'github_light',
    },
    palette = {
	bg       = '#202328',
	fg       = '#bbc2cf',
	yellow   = '#ECBE7B',
	cyan     = '#008080',
	darkblue = '#081633',
	green    = '#98be65',
	orange   = '#FF8800',
	violet   = '#a9a1e1',
	magenta  = '#c678dd',
	blue     = '#51afef',
	red      = '#ec5f67'
    },
}

-- custom highlight -----------------------------------------------------
local higroup = vim.api.nvim_create_augroup('HighlightGroup', { clear = true})
vim.api.nvim_create_autocmd({'ColorScheme'}, {
    pattern = '*',
    group = higroup,
    callback = function()
	vim.cmd([[
	    " 解决 vim 帮助文件的示例代码的不够突显的问题
	    hi def link helpExample Special
	    highlight MyBorder guifg=#34c841 guibg=NONE
	    " 用于实现弹出窗口背景透明
	    highlight VertSplit      cterm=None gui=None guibg=bg
	    highlight FoldColumn     guibg=bg
	    highlight folded         gui=bold guifg=LightGreen guibg=bg
	    highlight SignColumn     guibg=bg
	    highlight LineNr         guibg=bg
	]])
    end,
    desc = "remove unnecessary background",
})

-- set colorscheme ------------------------------------------------------
vim.o.background = string.lower(vim.env.NVIM_BACKGROUND or default_opts.background)
if vim.o.background == "dark" then
    vim.cmd('colorscheme ' .. (vim.env.NVIM_COLOR_SCHEME_DARK or default_opts.colorscheme.dark))
else
    vim.cmd('colorscheme ' .. (vim.env.NVIM_COLOR_SCHEME_LIGHT or default_opts.colorscheme.light))
end

-- adjust palette according to color scheme -----------------------------
if not vim.g.lbs_colors then vim.g.lbs_colors = default_opts.palette end



