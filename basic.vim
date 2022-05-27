"set background=dark        " 设置颜色模式
" colorscheme sonokai
colorscheme kanagawa
set guifont=monospace:h14
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none

" Basic Config{{{1
let mapleader = " "
let maplocalleader = ';'

set backupdir=~/.cache/vim/.backup//
set directory=~/.cache/vim/.swp//
set undodir=~/.cache/vim/.undo//

set mouse=a                " 支持使用鼠标
set clipboard+=unnamedplus " 剪切板的整合
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb2312,gb18030,big5,enc-jp,enc-krlatin1
set autoread               " 在文件在外部被修改后自动加载
set wildmenu               " vim 自身命令行模式只能补全
set scrolloff=3            " 设置 j/k 滚动的行数
set showmatch              " 高亮显示匹配括号
set mat=2                  " 设置匹配括号时闪缩的时间
set lazyredraw             " 只在需要时重绘，出于性能上的考虑
set noerrorbells           " 关闭出错时的提示音
set novisualbell           " 关闭使用可视响铃代替呼叫
set t_vb=                  " 置空错误铃声的终端代码
set sidescroll=5
set listchars+=precedes:<,extends:>
set hidden
set swapfile
set nobackup
set nowritebackup
set undofile
set completeopt=noinsert,menuone,noselect
set shortmess+=c
set foldlevel=2             " 折叠层级
if has("autocmd") && exists("+omnifunc")
autocmd Filetype *
        \	if &omnifunc == "" |
        \		setlocal omnifunc=syntaxcomplete#Complete |
        \	endif
endif
 
set updatetime=300
set timeoutlen=300
set ttimeoutlen=30
if ! has('gui_running')
    set ttimeoutlen=30
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=300
        au InsertLeave * set timeoutlen=400
    augroup END
endif

if $TERM != "dvtm-256color"
    set termguicolors      " 真彩色
endif
filetype on                " 开启文件类型侦测
filetype plugin on         " 根据侦测到的不同类型加载对应插件支持
syntax enable              " 语法高亮
syntax on                  " 允许用指定语法高亮配色方案替换默认方案
set number                 " 开启行号显示
set relativenumber         " 相对行号
set ruler                  " 显示光标当前位置
set cmdheight=1            " 命令行高度
set laststatus=2           " 总是显示状态栏
set list
set listchars=tab:..\|,trail:.
set foldcolumn=1
set fillchars=fold:\ 

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

highlight FoldColumn guibg=bg
highlight Folded guibg=bg
highlight SignColumn guibg=bg
highlight FloatermBorder guifg=Cyan

" 搜索相关{{{1
set hlsearch               " 高亮显示搜索结果
set incsearch              " 开启实时搜索功能
set ignorecase             " 设置查找时大小不敏感
set smartcase              " 如果有一个大写字母，则切换到大小写敏感查找
set magic                  " 对正则表达式开启 magic

" 自动排版相关{{{1
set expandtab              " 将制表符扩展为空格
set tabstop=4              " 设置编辑时制表符占用空格数
set shiftwidth=4           " 设置格式化时制表符占用空格数
set smarttab               " Be Smart When using tabs
set shiftround             " 运用 > < 推广缩进至 tabs 整数倍
set wrapmargin=0           " 指定拆行处与编辑窗口右边缘之间空出的字符数
set textwidth=0            " 行宽，自动排版所需
set autoindent             " 自动缩进
set smartindent            " 智能缩进
set wrap                   " 代码折行
set breakindent            " 回绕行保持视觉上的缩进
let &showbreak = ''        " 会绕行放置在开头的字符串
set nolinebreak            " 折行

" 折叠相关{{{1
function! MyFoldText()
  return " " . foldtext() . " ··· "
endfunction
set formatoptions=t,n1mp,Bj,coq
set foldmethod=marker
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldtext=MyFoldText()

" 字典 和 tags 相关 {{{1
set dictionary+=~/.config/nvim/paper.dict,~/.config/nvim/dict
set complete+=k 
set tags=./.tags;,.tags
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = $HOME . "/.globalrc"

" perl {{{1
let g:loaded_perl_provider = 1
let g:perl_host_prog = '/usr/bin/perl'


" Python 相关设置 {{{1
let g:python_host_skip_check=0
let g:python3_host_skip_check=0
if(has("mac"))
    let g:python3_host_prog = '/opt/homebrew/bin/python3'
    let g:python_host_prog = '/usr/bin/python2'
    d
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python'
endif

" R {{{1
let r_indent_align_args = 1
let r_indent_ess_compatible = 1
let r_indent_op_pattern = '\(&\||\|+\|-\|\*\|/\|=\|\~\|%\|->\)\s*$'

" nvui {{{1 
if exists('g:nvui')
  " Configure nvui
  NvuiCmdFontFamily monospace
  NvuiCmdFontSize 14.0
  NvuiScrollAnimationDuration 0.2
endif
