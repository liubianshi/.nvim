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
"Plug 'nathom/filetype.nvim'
Plug 'lambdalisue/suda.vim' " read or write files with sudo command

" Vim Highlighter {{{2
Plug 'azabiong/vim-highlighter'

" vim-oscyank {{{2
Plug 'ojroques/vim-oscyank'

" Command line Fuzzy Search {{{2
function! UpdateRemotePlugins(...)
  " Needed to refresh runtime files
  let &rtp=&rtp
  UpdateRemotePlugins
endfunction
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

" fcitx {{{2
if(has("mac"))
    Plug 'CodeFalling/fcitx-vim-osx'
    "Plug 'rlue/vim-barbaric'
else
    Plug 'lilydjwg/fcitx.vim'    " Linux 下优化中文输入法切换
endif

" theme {{{2
Plug 'NLKNguyen/papercolor-theme'
"Plug 'flazz/vim-colorschemes' , { 'on': [] }    " 主题管理
Plug 'morhetz/gruvbox'                          " 主题
Plug 'rakr/vim-one'
Plug 'ayu-theme/ayu-vim'
Plug 'sainnhe/sonokai'
Plug 'rebelot/kanagawa.nvim'

" Airline {{{2
Plug 'akinsho/bufferline.nvim'        " buffer line (with minimal tab integration) for neovim
Plug 'hoob3rt/lualine.nvim'           " neovim statusline plugin written in pure lua

" nerdtree {{{2
Plug 'scrooloose/nerdtree',    { 'on':  'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'
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
"Plug 'lervag/wiki.vim'

" text objects {{{2
Plug 'godlygeek/tabular'            " 对齐文本插件
"Plug 'tpope/vim-surround'           " 快速给词加环绕符号
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-repeat'             " 重复插件操作
Plug 'tpope/vim-abolish'            " 高效的文本替换工具
Plug 'scrooloose/nerdcommenter'     " 注释插件
Plug 'justinmk/vim-sneak'           " The missing motion for vim
Plug 'easymotion/vim-easymotion'    " 高效移动指标插件
Plug 'liubianshi/vim-easymotion-chs' " tricks to allow easymotion recognize Chinese chars
Plug 'wellle/targets.vim'           " 扩展 vim 文本对象
Plug 'kana/vim-textobj-user'        " Create your own text objects

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
"let g:polyglot_disabled = ['ftdetect', 'markdown', 'rmd', 'rmarkdown', 'pandoc', 'Rmd']
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
"Plug 'dstein64/vim-startuptime'
Plug 'mhinz/vim-startify'

" VimTableMode: {{{2
Plug 'dhruvasagar/vim-table-mode'

" Vimspector: {{{2
Plug 'puremourning/vimspector',  { 'on': [] }

" Auto_save: {{{2 
Plug '907th/vim-auto-save'

" TrueZen.nvim: Clean and elegant distraction-free writing for NeoVim. {{{2
Plug 'Pocco81/TrueZen.nvim'
Plug 'beauwilliams/focus.nvim'

" Neovim 0.5
" Orgmode
if has('nvim-0.5.0')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-orgmode/orgmode'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'folke/trouble.nvim'
    Plug 'kevinhwang91/nvim-bqf'
endif

" plug end {{{2
call plug#end()

" plug config {{{1
call Lbs_Load_Plug_Confs(keys(g:plugs))

" Personal Global Variables {{{1 
if has('mac')
    let g:lbs_input_method_off = 1
    "let g:lbs_input_status = "xkbswitch -g"
    "let g:lbs_input_method_inactivate = "xkbswitch -s 1"
    "let g:lbs_input_method_activate = "xkbswitch -s 4"
    "let g:lbs_input_method_on = 4
    let g:lbs_input_status = "fcitx-remote"
    let g:lbs_input_method_inactivate = "fcitx-remote -c"
    let g:lbs_input_method_activate = "fcitx-remote -o"
    let g:lbs_input_method_on = 2
else
    let g:lbs_input_status = "fcitx5-remote"
    let g:lbs_input_method_inactivate = "fcitx5-remote -c"
    let g:lbs_input_method_activate = "fcitx5-remote -o"
    let g:lbs_input_method_off = 1
    let g:lbs_input_method_on = 2
endif

" source external files {{{1
source ~/.config/nvim/basic.vim
source ~/.config/nvim/KeyMap.vim
source ~/.config/nvim/autocmd.vim
source ~/.config/nvim/abbr.vim
source ~/.config/nvim/fcitx_auto_toggle.vim


" vim: set fdm=marker :
