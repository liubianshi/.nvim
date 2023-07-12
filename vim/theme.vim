set background=dark
set guifont=monospace:h14

" From kitty faq --------------------------------------------------------
" Mouse support
set mouse=a
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''
" -----------------------------------------------------------------------


function! s:RandomTheme() abort
    let cc = ['kanagawa',      'ayu',     'gruvbox-baby', 'OceanicNext',  'everforest', 'catppuccin', 'tokyonight']
    let cp = ['kanagawa.nvim', 'ayu-vim', 'gruvbox-baby', 'oceanic-next', 'everforest', 'catppuccin', 'tokyonight.nvim']
    let r = rand() % len(cc)
    call utils#Load_Plug(cp[r])
    exec 'colorscheme ' . cc[r]
endfunction
call <SID>RandomTheme()

" 用于实现弹出窗口背景透明
" 解决 vim 帮助文件的示例代码的不够突显的问题
hi def link helpExample Special

highlight MyBorder guifg=#ff7600

" highlight VertSplit      cterm=None gui=None guibg=bg
" highlight FoldColumn     guibg=bg
" highlight folded         gui=bold guifg=LightGreen guibg=bg
" highlight SignColumn     guibg=bg
" highlight LineNr         guibg=bg
" highlight FloatermBorder guifg=Cyan
" 
" 
" " 用于实现透明效果
" highlight Normal      ctermbg=none guibg=none
" highlight NonText     ctermbg=none guibg=none
" highlight EndOfBuffer ctermbg=none guibg=none


