" Set local variable ==================================================== {{{1
if has('nvim')
    let s:plugfile = stdpath('data') . '/site/autoload/plug.vim'
    let s:plugdir = stdpath('data') . "/plugged"
else
    let s:plugfile = '~/.vim/autoload/plug.vim'
    let s:plugdir = "~/.vim/plugged"
endif
let s:plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" Install plug.vim when necessary ======================================= {{{1
if ! filereadable(s:plugfile)
    silent execute '!curl -fLo ' . s:plugfile . ' --create-dirs '  . s:plugurl
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:plugdir)
" Function enhancement ================================================== {{{1
"Plug 'nathom/filetype.nvim'
Plug 'lambdalisue/suda.vim'              " read or write files with sudo command
Plug 'ojroques/vim-oscyank'
Plug 'ptzz/lf.vim'
if has('nvim')
    Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
else
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
endif
" 高亮显示复制区域
Plug 'machakann/vim-highlightedyank'     
" 加强版实时高亮
Plug 'haya14busa/incsearch.vim'
" 多重选择
"Plug 'mg979/vim-visual-multi'
" 显示匹配符号之间的内容
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-commentary'              " Comment stuff out
" 文本对齐
Plug 'junegunn/vim-easy-align'
" 操作匹配符号
Plug 'machakann/vim-sandwich'
" 重复插件操作
Plug 'tpope/vim-repeat'
" 快速移动光标
if has('nvim')
    Plug 'phaazon/hop.nvim'              " 替代 sneak 和 easymotion
else
    Plug 'justinmk/vim-sneak'            " The missing motion for vim
    Plug 'easymotion/vim-easymotion'     " 高效移动指标插件
    Plug 'liubianshi/vim-easymotion-chs' 
endif
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
if has('nvim')
    Plug 'folke/which-key.nvim'
else
    Plug 'liuchengxu/vim-which-key'
endif
" Chinese version of vim documents
Plug 'yianwillis/vimcdoc'             
" Stay: Stay at my cursor, boy!
Plug 'zhimsel/vim-stay' | set viewoptions=cursor,folds,slash,unix
" FastFold: Speed up Vim by updating folds only when called-for
" Plug 'Konfekt/FastFold'
" Plug '907th/vim-auto-save'
" 文本对象
"Plug 'wellle/targets.vim'
"Plug 'kana/vim-textobj-user'
Plug 'vim-voom/VOoM'

" Project management ==================================================== {{{1
Plug 'ahmedkhalf/project.nvim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'folke/trouble.nvim', { 'for': [ 'c' ] }
Plug 'tpope/vim-fugitive'

" Terminal tools ======================================================== {{{1
Plug 'voldikss/vim-floaterm'
Plug 'skywind3000/asyncrun.vim'       " 异步执行终端程序
Plug 'skywind3000/asynctasks.vim'
Plug 'liubianshi/vimcmdline'
" 括号自动匹配
if has('nvim')
    Plug 'windwp/nvim-autopairs'
else
    Plug 'jiangmiao/auto-pairs'
endif

"Plug 'skywind3000/vim-terminal-help'
"Plug 'tpope/vim-obsession', { 'on': [] }            " tmux Backup needed

" 个性化 UI ============================================================= {{{1
Plug 'luisiacc/gruvbox-baby', { 'on': [] }
Plug 'ayu-theme/ayu-vim', { 'on': [] }        
Plug 'rebelot/kanagawa.nvim', { 'on': [] }    
Plug 'mhartington/oceanic-next', { 'on': [] } 
" buffer line (with minimal tab integration) for neovim
Plug 'akinsho/bufferline.nvim'
" neovim statusline plugin written in pure lua
Plug 'hoob3rt/lualine.nvim'              
Plug 'mhinz/vim-startify'
Plug 'kyazdani42/nvim-web-devicons'
" Auto Ajust the width and height of focused window
Plug 'beauwilliams/focus.nvim'
" TrueZen.nvim: Clean and elegant distraction-free writing for NeoVim. {{{2
" Plug 'Pocco81/TrueZen.nvim'

" 补全和代码片断 ======================================================== {{{1
" Snippets {{{2
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'
" 补全框架 -------------------------------------------------------------- {{{2
if g:complete_method ==# "coc" 
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
else
"    Plug 'williamboman/mason.nvim'
"    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
"    Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    " Plug 'ray-x/lsp_signature.nvim'
    Plug 'hrsh7th/cmp-omni'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'ray-x/cmp-treesitter'
    Plug 'onsails/lspkind.nvim'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    "Plug 'kdheepak/cmp-latex-symbols'
    if ! has('mac')
        Plug 'wasden/cmp-flypy.nvim', { 'do': 'make flypy' }
    endif
endif " ------------------------------------------------------------------ }}}
" Command line Fuzzy Search and completation ---------------------------- {{{2
function! UpdateRemotePlugins(...)
  " Needed to refresh runtime files
  let &rtp=&rtp
  UpdateRemotePlugins
endfunction
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
" Formatter and linter --------------------------------------------------
Plug 'mhartington/formatter.nvim'
" , { 'for': [ 'lua', 'sh', 'perl', 'r',
"                                  \            'html', 'xml', 'css'
"                                  \          ] }

" Writing and knowledge management ====================================== {{{1
Plug 'vim-pandoc/vim-pandoc',        { 'on': [] }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'on': [] }
Plug 'ferrine/md-img-paste.vim',     { 'on': [] }
Plug 'hotoo/pangu.vim',              { 'on': [] }
Plug 'lervag/wiki.vim'
Plug 'nvim-orgmode/orgmode', { 'for': [ 'org' ] }
Plug 'dhruvasagar/vim-table-mode', { 'for': [ 'pandoc', 'rmd', 'org' ] } 
" Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'

" 文件类型相关插件 ====================================================== {{{1
" SQL {{{2
" Modern database interface for Vim
Plug 'tpope/vim-dadbod', { 'on': [] }
" Simple UI for vim-dadbod
Plug 'kristijanhusak/vim-dadbod-ui', { 'on': [] }
Plug 'kristijanhusak/vim-dadbod-completion', { 'on': [] }
" R {{{2
Plug 'liubianshi/Nvim-R'
" tex {{{2
Plug 'lervag/vimtex', {'on': []}
" stata {{{2
Plug 'poliquin/stata-vim', { 'on': [] }  " stata 语法高亮
" csv / tsv {{{2
Plug 'mechatroner/rainbow_csv', { 'for': [ 'csv', 'tsv' ]}
" perl {{{2 
" Plug 'WolfgangMehner/perl-support', { 'for': ['perl'] }
" Graphviz dot {{{2
Plug 'liuchengxu/graphviz.vim', { 'for': [ 'dot'] }
" quickfile {{{2
" Plug 'kevinhwang91/nvim-bqf'

" Misc ================================================================== {{{1
" Plug 'skywind3000/vim-dict', { 'for': ['markdown', 'pandoc', 'rmarkdown', 'rmd'] }
" Plug 'tommcdo/vim-exchange'

" plug end ============================================================== {{{1
call plug#end()
call utils#Load_Plug_Confs(keys(g:plugs))


