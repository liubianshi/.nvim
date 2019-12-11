" Basic Config
set clipboard+=unnamedplus " 剪切板的整合
set encoding=utf-8  " 设置编码格式
set termguicolors   " 真彩色
colorscheme gruvbox
set background=dark " 设置颜色模式
filetype on         " 开启文件类型侦测
filetype plugin on  " 根据侦测到的不同类型加载对应插件支持
set autoread        " 在文件在外部被修改后自动加载
set wildmenu     	" vim 自身命令行模式只能补全
syntax enable		" 语法高亮
syntax on		    " 允许用指定语法高亮配色方案替换默认方案
set number          " 开启行号显示
set relativenumber  " 相对行号
set laststatus=2    " 总是显示状态栏
set ruler           " 显示光标当前位置
set mouse=a         " 支持使用鼠标
set cmdheight=1     " 命令行高度
set so=7            " 设置 j/k 滚动的行数
set showmatch       " 高亮显示匹配括号
set mat=2           " 设置匹配括号时闪缩的时f
set hlsearch        " 高亮显示搜索结果
set incsearch    	" 开启实时搜索功能
set ignorecase   	" 设置查找时大小不敏感
set smartcase       " 如果有一个大写字母，则切换到大小写敏感查找
set magic           " 对正则表达式开启 magic
set lazyredraw      " 只在需要时重绘，出于性能上的考虑
set noerrorbells    " 关闭出错时的提示音
set novisualbell    " 关闭使用可视响铃代替呼叫
set t_vb=           " 置空错误铃声的终端代码
set expandtab		" 将制表符扩展为空格
set tabstop=4		" 设置编辑时制表符占用空格数
set shiftwidth=4	" 设置格式化时制表符占用空格数
set smarttab        " Be Smart When using tabs 
set shiftround      " 运用 > < 推广缩进至 tabs 整数倍
set wrapmargin=2    " 指定拆行处与编辑窗口右边缘之间空出的字符数
set laststatus=2    " 状态栏显示

set linebreak
set breakindent
set brk='/\()"':,.;<>~!@#$%^&*|+=[]{}`?-…，。、‘’“”：；'
set ai              " 自动缩进
set si              " 智能缩进
set wrap            " 代码折行
set formatoptions+=m
set formatoptions+=B

" coc.nvim 推荐设置
set hidden
set nobackup
set nowritebackup
set updatetime=300


" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
set shortmess+=c
" use <TAB> to select the popup menu:
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" UltiSnips 相关配置
imap <c-u> <Plug>(ultisnips_expand)
smap <c-u> <Plug>(ultisnips_expand)
xmap <c-u> <Plug>(ultisnips_expand)
let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsRemoveSelectModeMappings = 0

