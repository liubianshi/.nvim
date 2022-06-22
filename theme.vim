set background=dark        " 设置颜色模式
set guifont=monospace:h14
"colorscheme sonokai
colorscheme kanagawa
"colorscheme OceanicNext

" 用于实现透明效果
highlight Normal      ctermbg=none guibg=none
highlight NonText     ctermbg=none guibg=none
highlight EndOfBuffer ctermbg=none guibg=none

highlight VertSplit cterm=None gui=None guibg=bg
highlight FoldColumn guibg=bg
highlight Folded guibg=bg
highlight SignColumn guibg=bg
highlight LineNr guibg=bg
highlight FloatermBorder guifg=Cyan

if $TERM != "dvtm-256color"
    set termguicolors      " 真彩色
endif
