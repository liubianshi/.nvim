" vim: set fdm=marker:
" Gui ==================================================================== {{{1
set mouse=nic              " 支持使用鼠标
set clipboard+=unnamedplus " 剪切板的整合
" set lazyredraw             " 只在需要时重绘，出于性能上的考虑
set hidden
 
" Ignore certain files and folders when globing ========================= {{{1
set wildignore+=*.o,*.obj,*.dylib,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
set wildignore+=*.pyc,*.pkl
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv
set wildignorecase  " ignore file and dir name cases in cmd-completion

" 语言环境配置 =========================================================== {{{1
" perl {{{2
" let g:loaded_perl_provider = 1
let g:perl_host_prog = '/sbin/perl'


" Python 相关设置 {{{2
let g:python_host_skip_check=0
let g:python3_host_skip_check=0
if(has("mac"))
    let g:python3_host_prog = '/opt/homebrew/opt/python@3.9/libexec/bin/python'
    let g:python_host_prog = '/usr/bin/python2'
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python'
endif

" R {{{2
let r_indent_align_args = 1
let r_indent_ess_compatible = 0
let r_indent_op_pattern = '\(&\||\|+\|-\|\*\|/\|=\|\~\|%\|->\)\s*$'

" 开启语法支持 =========================================================== {{{1
filetype on                " 开启文件类型侦测
filetype plugin on         " 根据侦测到的不同类型加载对应插件支持
syntax enable              " 语法高亮
syntax on                  " 允许用指定语法高亮配色方案替换默认方案
set synmaxcol=200  " Text after this column number is not highlighted
set nostartofline

" 文件同步、备份和回滚 =================================================== {{{1
set directory=~/.cache/vim/.swp//
set undodir=~/.cache/vim/.undo//
set autoread               " 在文件在外部被修改后自动加载
set swapfile
set undofile
set autowrite
set backupdir=~/.cache/vim/.backup//
set backup
set nowritebackup
set backupcopy=yes
let &backupskip=&wildignore


" 文件编码 =============================================================== {{{1
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb2312,gb18030,big5,enc-jp,enc-krlatin1

" Erorr Handle =========================================================== {{{1
set noerrorbells           " 关闭出错时的提示音
set novisualbell           " 关闭使用可视响铃代替呼叫
set t_vb=                  " 置空错误铃声的终端代码
set shortmess+=cSI

" 响应速度设置 =========================================================== {{{1
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

" 辅助信息显示 =========================================================== {{{1
set confirm
set showmatch              " 高亮显示匹配括号
set number                 " 开启行号显示
set relativenumber         " 相对行号
set noruler                " 显示光标当前位置
set cmdheight=1            " 命令行高度
set laststatus=2           " 总是显示状态栏
set cmdheight=1
set list
set listchars=tab:\ \ \|,trail:\ ,precedes:<,extends:>

set fillchars=fold:\ 
set signcolumn=yes:1
set mat=2                  " 设置匹配括号时闪缩的时间
set scrolloff=3            " 光标上下两侧最少保留的屏幕行数

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,（:）,「:」,『:』,【:】,“:”,‘:’,《:》

set pumheight=10  " Maximum number of items to show in popup menu
set pumblend=10  " pseudo transparency for completion menu
set winblend=20  " pseudo transparency for floating window

" change fillchars for folding, vertical split, end of buffer, and message separator
set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾

" 补全 =================================================================== {{{1
set wildmenu               " vim 自身命令行模式只能补全
set completeopt=noinsert,menuone,noselect
set spelllang=en,cjk  " Spell languages
set spellsuggest+=9  " show 9 spell suggestions at most
if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
            \	if &omnifunc == "" |
            \		setlocal omnifunc=syntaxcomplete#Complete |
            \	endif
endif


" 搜索相关 ============================================================== {{{1
set hlsearch               " 高亮显示搜索结果
set incsearch              " 开启实时搜索功能
set ignorecase             " 设置查找时大小不敏感
set smartcase              " 如果有一个大写字母，则切换到大小写敏感查找
set magic                  " 对正则表达式开启 magic

" 自动排版相关 ========================================================== {{{1
set expandtab              " 将制表符扩展为空格
set tabstop=4              " 设置编辑时制表符占用空格数
set shiftwidth=4           " 设置格式化时制表符占用空格数
set smarttab               " Be Smart When using tabs
set shiftround             " 运用 > < 推广缩进至 tabs 整数倍
set wrapmargin=0           " 指定拆行处与编辑窗口右边缘之间空出的字符数
set textwidth=0            " 行宽，自动排版所需
set autoindent             " 自动缩进
set cindent                " 智能缩进
set nowrap                 " 代码折行
set breakindent            " 回绕行保持视觉上的缩进
let &showbreak = ''        " 会绕行放置在开头的字符串
set nolinebreak            " 折行
" Align indent to next multiple value of shiftwidth. For its meaning,
" see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
set shiftround

" 折叠相关 ============================================================== {{{1 
set foldtext=fold#FoldText()
set foldlevel=2             " 折叠层级
set foldcolumn=1
set formatoptions=t,n1mMp,Bj,coq
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

" 字典 和 tags 相关 ===================================================== {{{1
set dictionary+=~/.config/nvim/paper.dict,~/.config/nvim/dict
set complete+=k 
set tags=./tags,tags
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = $HOME . "/.globalrc"

" nvui ================================================================== {{{1
if exists('g:nvui')
  " Configure nvui
  NvuiCmdFontFamily monospace
  NvuiCmdFontSize 14.0
  NvuiScrollAnimationDuration 0.2
endif

" Remove certain character from file name pattern matching ============== {{{1
set isfname-==
set isfname-=,

" diff options ========================================================== {{{1
set diffopt=
set diffopt+=vertical  " show diff in vertical position
set diffopt+=filler  " show filler for deleted lines
set diffopt+=closeoff  " turn off diff when one file window is closed
set diffopt+=context:3  " context for diff
set diffopt+=internal,indent-heuristic,algorithm:histogram

" External program to use for grep command ============================== {{{1
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

" Tilde (~) is an operator, thus must be followed by motions ============ {{{1
set tildeop
