" Liubianshi's Neovim

" load personal global fucntion {{{1
source ~/.config/nvim/lbs_function.vim

" Install plug.vim when necessary {{{1
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" load package {{{1
call plug#begin('~/.local/share/nvim/plugged')
Plug 'nathom/filetype.nvim'
    lua vim.g.did_load_filetypes = 1

" fcitx {{{2
if(has("mac"))
    Plug 'CodeFalling/fcitx-vim-osx'
else
    Plug 'lilydjwg/fcitx.vim'    " Linux 下优化中文输入法切换
endif

" theme {{{2
"Plug 'NLKNguyen/papercolor-theme'
"Plug 'flazz/vim-colorschemes' , { 'on': [] }    " 主题管理
"Plug 'morhetz/gruvbox'                          " 主题
"Plug 'rakr/vim-one'
"Plug 'ayu-theme/ayu-vim'
Plug 'sainnhe/sonokai'

" Airline {{{2
"Plug 'vim-airline/vim-airline',        { 'on': [] }    " 状态栏插件
"Plug 'vim-airline/vim-airline-themes', { 'on': [] }
Plug 'akinsho/bufferline.nvim'
Plug 'hoob3rt/lualine.nvim'

" nerdtree {{{2
Plug 'scrooloose/nerdtree',    { 'on':  'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }
    doau User nerdtree call Lbs_Load_Plug_Confs(['nerdtree', 'vim-devicons'])

" lf {{{2
Plug 'rbgrouleff/bclose.vim'          " lf.vim 插件依赖，关闭 buffer，但关闭 buffer 所在窗口
Plug 'ptzz/lf.vim'                    " 文件管理
    let g:lf_map_keys = 0

" vim-translator
Plug 'voldikss/vim-translator'

" fzf {{{2
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" leaderF {{{2
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

" visual_effects {{{2
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-highlightedyank'  " 高亮显示复制区域
Plug 'haya14busa/incsearch.vim'       " 加强版实时高亮
Plug 'mg979/vim-visual-multi',  {'branch': 'master'}

" vim-matchup
Plug 'andymass/vim-matchup'

" Pandoc and Rmarkdown {{{2
Plug 'vim-pandoc/vim-pandoc',        {'on': []}
Plug 'vim-pandoc/vim-pandoc-syntax', {'on': []}
Plug 'ferrine/md-img-paste.vim',     {'on': []}
Plug 'hotoo/pangu.vim',              {'on': []}

" wiki.vim {{{2
Plug 'lervag/wiki.vim'

" text objects {{{2
Plug 'godlygeek/tabular'            " 对齐文本插件
Plug 'tpope/vim-surround'           " 快速给词加环绕符号
Plug 'tpope/vim-repeat'             " 重复插件操作
Plug 'tpope/vim-abolish'            " 高效的文本替换工具
Plug 'scrooloose/nerdcommenter'     " 注释插件
Plug 'justinmk/vim-sneak'           " The missing motion for vim
Plug 'easymotion/vim-easymotion'    " 高效移动指标插件
Plug 'liubianshi/vim-easymotion-chs' " tricks to allow easymotion recognize Chinese chars
Plug 'wellle/targets.vim'           " 扩展 vim 文本对象

" Snippets {{{2
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'

" Filetype {{{2
" SQL {{{3
Plug 'tpope/vim-dadbod'             " Modern database interface for Vim
Plug 'kristijanhusak/vim-dadbod-ui' " Simple UI for vim-dadbod
Plug 'kristijanhusak/vim-dadbod-completion', { 'on': [] }
Plug 'liubianshi/Nvim-R'
Plug 'lervag/vimtex', {'on': []}
Plug 'poliquin/stata-vim', { 'on': [] }       " stata 语法高亮

" csv / tsv {{{3
Plug 'mechatroner/rainbow_csv'

" perl 
Plug 'WolfgangMehner/perl-support', { 'for': ['perl'] }

" preview {{{2
Plug 'skywind3000/vim-preview'

" Syntax checking {{{2
" let g:polyglot_disabled = ['ftdetect', 'markdown', 'rmd', 'rmarkdown', 'pandoc', 'Rmd']
"Plug 'sheerun/vim-polyglot'

Plug 'dense-analysis/ale', { 'on': [] }

" system interaction {{{2
" floaterm {{{3
Plug 'voldikss/vim-floaterm'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" asyncrun {{{3
Plug 'skywind3000/asyncrun.vim'       " 异步执行终端程序
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/vim-terminal-help'
" obsession {{{3
Plug 'tpope/vim-obsession', { 'on': [] }            " tmux Backup needed

" vimcmdline {{{3
Plug 'liubianshi/vimcmdline'

" auto-pairs {{{2
Plug 'jiangmiao/auto-pairs'

" coc {{{2
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" ncm2 complete system {{{2
"Plug 'roxma/nvim-yarp',            { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'roxma/ncm2',                 { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'liubianshi/ncm-R',           { 'for': ['r', 'rmd', 'rmarkdown'] } 
"Plug 'ncm2/ncm2-bufword',          { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'ncm2/ncm2-path',             { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'ncm2/ncm2-ultisnips',        { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'yuki-ycino/ncm2-dictionary', { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'Shougo/neco-syntax',         { 'for': ['r', 'rmd', 'rmarkdown'] }
"Plug 'ncm2/ncm2-syntax',           { 'for': ['r', 'rmd', 'rmarkdown'] }

" vim-dict {{{2
Plug 'ludovicchabant/vim-gutentags'
"Plug 'skywind3000/vim-dict', { 'for': ['markdown', 'pandoc', 'rmarkdown', 'rmd'] }

" Vim-exchange: {{{2 
Plug 'tommcdo/vim-exchange'

" Git: {{{2
Plug 'tpope/vim-fugitive', {'on': ['G', 'Gwrite', 'Gcommit', 'Gread', 'Gdiff', 'Gblame']}
    doau User vim-fugitive call Lbs_Load_Plug_Conf('vim-fugitive')

" Help: {{{2
"Plug 'liuchengxu/vim-which-key'
Plug 'folke/which-key.nvim'
Plug 'yianwillis/vimcdoc'             " Vim 中文帮助文档

" Stay: Stay at my cursor, boy! {{{2
Plug 'zhimsel/vim-stay'
    set viewoptions=cursor,folds,slash,unix

" FastFold: Speed up Vim by updating folds only when called-for {{{2
Plug 'Konfekt/FastFold'

" Rainbow Parentheses: {{{2
Plug 'kien/rainbow_parentheses.vim'
    au VimEnter * RainbowParenthesesToggle

" StarupTime: {{{2
Plug 'dstein64/vim-startuptime'
Plug 'mhinz/vim-startify'

" VimTableMode: {{{2
Plug 'dhruvasagar/vim-table-mode'

" Vimspector: {{{2
Plug 'puremourning/vimspector',  { 'on': [] }

" Auto_save: {{{2 
Plug '907th/vim-auto-save'

" better-escape {{{2
"Plug 'jdhao/better-escape.vim'

" TrueZen.nvim: Clean and elegant distraction-free writing for NeoVim. {{{2
Plug 'Pocco81/TrueZen.nvim'

" Neovim 0.5
" Orgmode
if has('nvim-0.5.0')
    Plug 'kristijanhusak/orgmode.nvim', {'for': 'org'}
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'folke/trouble.nvim'
    Plug 'kevinhwang91/nvim-bqf'
endif

" plug end {{{2
call plug#end()

" plug config {{{1
call Lbs_Load_Plug_Confs(keys(g:plugs))

" source external files {{{1
source ~/.config/nvim/basic.vim
source ~/.config/nvim/KeyMap.vim
"source ~/.config/nvim/whichkey.vim
source ~/.config/nvim/autocmd.vim
source ~/.config/nvim/abbr.vim
source ~/.config/nvim/fcitx_auto_toggle.vim

" Test lua
"command! Scratch lua require'tools'.makeScratch()
