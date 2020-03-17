" Basic Config
set clipboard+=unnamedplus " 剪切板的整合
set encoding=utf-8         " 设置编码格式
set termguicolors          " 真彩色
colorscheme gruvbox
set background=dark        " 设置颜色模式
filetype on                " 开启文件类型侦测
filetype plugin on         " 根据侦测到的不同类型加载对应插件支持
syntax enable              " 语法高亮
syntax on                  " 允许用指定语法高亮配色方案替换默认方案
set autoread               " 在文件在外部被修改后自动加载
set wildmenu               " vim 自身命令行模式只能补全
set nonumber               " 开启行号显示
set norelativenumber       " 相对行号
set ruler                  " 显示光标当前位置
set mouse=a                " 支持使用鼠标
set cmdheight=1            " 命令行高度
set so=7                   " 设置 j/k 滚动的行数
set showmatch              " 高亮显示匹配括号
set mat=2                  " 设置匹配括号时闪缩的时f
set hlsearch               " 高亮显示搜索结果
set incsearch              " 开启实时搜索功能
set ignorecase             " 设置查找时大小不敏感
set smartcase              " 如果有一个大写字母，则切换到大小写敏感查找
set magic                  " 对正则表达式开启 magic
set lazyredraw             " 只在需要时重绘，出于性能上的考虑
set noerrorbells           " 关闭出错时的提示音
set novisualbell           " 关闭使用可视响铃代替呼叫
set t_vb=                  " 置空错误铃声的终端代码
set expandtab              " 将制表符扩展为空格
set tabstop=4              " 设置编辑时制表符占用空格数
set shiftwidth=4           " 设置格式化时制表符占用空格数
set smarttab               " Be Smart When using tabs
set shiftround             " 运用 > < 推广缩进至 tabs 整数倍

" 折行相关设置
set wrap                   " 代码折行
set sidescroll=5
set listchars+=precedes:<,extends:>
set formatoptions=tqcnmB1jo
set wrapmargin=0           " 指定拆行处与编辑窗口右边缘之间空出的字符数
set textwidth=0
set ai              " 自动缩进
set si              " 智能缩进
set linebreak
set breakindent
"let &brk = " ^I!@*-+;:,./?"
let &showbreak = ''


" coc.nvim 推荐设置
set hidden
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set completeopt=noinsert,menuone,noselect
set shortmess+=c

" trim 尾部空格
autocmd BufWritePre *.{md,pl,p6,rmd,r,do} :%s/\s\+$//e

" 模拟 goyo 模式
set foldcolumn=1
highlight FoldColumn guibg=#282828 guifg=#282828
highlight SignColumn guibg=#282828
set signcolumn=yes
autocmd VimEnter * set laststatus=0
set laststatus=0           " 总是显示状态栏
set fdl=0
set fdls=0

" 高亮当前行
"autocmd InsertLeave,WinEnter * set cursorline
"autocmd InsertEnter,WinLeave * set nocursorline

