if $TERM != "dvtm-256color"
    set termguicolors      " 真彩色
endif
set background=dark        " 设置颜色模式
set guifont=monospace:h14

function! s:RandomTheme() abort
    let cc = ['kanagawa', 'ayu', 'gruvbox-baby', 'OceanicNext']
    let cp = ['kanagawa.nvim', 'ayu-vim', 'gruvbox-baby', 'oceanic-next']
    let r = rand() % len(cc)
    call utils#Load_Plug(cp[r])
    exec 'colorscheme ' . cc[r]
endfunction
call <SID>RandomTheme()

highlight VertSplit cterm=None gui=None guibg=bg
highlight FoldColumn guibg=bg
highlight Folded guibg=bg
highlight SignColumn guibg=bg
highlight LineNr guibg=bg
highlight FloatermBorder guifg=Cyan


" 用于实现透明效果
highlight Normal      ctermbg=none guibg=none
highlight NonText     ctermbg=none guibg=none
highlight EndOfBuffer ctermbg=none guibg=none


