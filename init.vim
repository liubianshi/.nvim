" Neovim 配置文件
call plug#begin('~/.local/share/nvim/plugged')
    if(has("mac"))
        "Plug 'ybian/smartim'
        Plug 'CodeFalling/fcitx-vim-osx'
    else
        Plug 'lilydjwg/fcitx.vim'       " Linux 下优化中文输入法切换
    endif
    Plug 'hotoo/pangu.vim'
    Plug 'vim-airline/vim-airline'  " 状态栏插件
    Plug 'vim-airline/vim-airline-themes'
        let g:airline_powerline_fonts = 1
        "let g:airline#extensions#tabline#enabled = 1
        "let g:airline#extensions#tabline#left_sep = ' '
        "let g:airline#extensions#tabline#left_alt_sep = '|'
        "let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline_theme='deus'
    Plug 'liuchengxu/vim-which-key'  
    Plug 'jalvesaq/Nvim-R', {'for': ['r', 'rmd', 'rmarkdown']}
    Plug 'sirver/UltiSnips'         
        let g:UltiSnipsEditSplit = "tabdo"
        let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
    Plug 'honza/vim-snippets'      " 配置 snippets 需要


   "Plug 'neoclide/coc.nvim', {'branch': 'release'}             " coc 代码补全插件
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }
    "Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on':  'NERDTreeToggle' }
    "Plug 'jistr/vim-nerdtree-tabs', { 'on':  'NERDTreeToggle' }
    Plug 'scrooloose/nerdcommenter'       " 注释插件
    Plug 'rbgrouleff/bclose.vim'          " lf.vim 插件依赖
    Plug 'ptzz/lf.vim'                    " 文件管理
        let g:lf_map_keys = 0

    "Plug 'machakann/vim-highlightedyank'  " 高亮显示复制区域
    Plug '/usr/bin/fzf'                   " 在 vim 中使用 fzf
    Plug 'junegunn/fzf.vim'               " 安装相关插件
    "Plug 'vim-scripts/mru.vim'            " 最近打开文档
    Plug 'junegunn/goyo.vim'              " zen 模式:
    Plug 'chrisbra/NrrwRgn'               " 形成小 buffer
        let g:nrrw_rgn_vert = 0
        let g:nrrw_rgn_wdth = 80
        let g:nrrw_topbot_leftright = 'botright'
    Plug 'yianwillis/vimcdoc'             " Vim 中文帮助文档
    
    Plug 'vim-pandoc/vim-pandoc'
        let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
        let g:pandoc#filetypes#pandoc_markdown = 1
        let g:pandoc#biblio#bibs = ["/home/liubianshi/Documents/paper_ref.bib"]
        let g:pandoc#biblio#use_bibtool = 1 
        let g:pandoc#completion#bib#mode = "citeproc"  
        let g:pandoc#biblio#sources = ["byc"]
    Plug 'vim-pandoc/vim-pandoc-syntax'
        let g:pandoc#modules#disabled = ["spell"]
        let g:tex_conceal = ""
    Plug 'vim-pandoc/vim-rmarkdown', {'for': ['rmd', 'rmarkdown']}

    Plug '907th/vim-auto-save'     " 自动保存
    Plug 'flazz/vim-colorschemes'  " 主题管理
    Plug 'morhetz/gruvbox'         " 主题
    Plug 'jacoborus/tender.vim'    " 主题

    "Plug 'mileszs/ack.vim'         " 在 Vim 中使用 Ack 或 Ag 检索
    Plug 'godlygeek/tabular'       " 对齐文本插件
    Plug 'tpope/vim-surround'      " 快速给词加环绕符号
    Plug 'tpope/vim-repeat'        " 重复插件操作
    Plug 'jiangmiao/auto-pairs'    " 自动引号/括号补全
        let g:AutoPairsMapBS = 0
    Plug 'VincentCordobes/vim-translate'
    Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' } 
    Plug 'lervag/vimtex' 
        let g:vimtex_compiler_progname = 'nvr'          " 调用 neovim-remote

    Plug 'roxma/nvim-yarp'         " ncm2 依赖的插件
    Plug 'ncm2/ncm2'              " 自动补全方案
    Plug 'ncm2/ncm2-bufword'      " 基于 Buffer 中的内容补全
    Plug 'ncm2/ncm2-path'         " 基于路径自动补全
    Plug 'ncm2/ncm2-tmux'
    Plug 'ncm2/ncm2-vim'
    Plug 'gaalcaras/ncm-R'        " R 语言自动补全
    Plug 'ncm2/ncm2-ultisnips'    " ncm ultisnips 插件
    Plug 'tpope/vim-fugitive'     " git 插件

    Plug 'poliquin/stata-vim'     " stata 语法高亮
call plug#end()


source ~/.config/nvim/goyoConfig.vim
source ~/.config/nvim/ChineseSymbol.vim
source ~/.config/nvim/nerdtree.vim
source ~/.config/nvim/stata.vim
source ~/.config/nvim/vimtex.vim
source ~/.config/nvim/ncm2.vim
source ~/.config/nvim/rfile.vim
source ~/.config/nvim/basic.vim
source ~/.config/nvim/KeyMap.vim
source ~/.config/nvim/fzfConifg.vim

let g:python_host_skip_check=1
let g:python3_host_skip_check=1
if(has("mac"))
    let g:python3_host_prog = '/usr/local/bin/python3'
    let g:python_host_prog = '/usr/bin/python'
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python'
endif
let g:auto_save = 1                         " 总 Vim 启动时即开启自动保存
let g:auto_save_envets = ["BufLeave", "FocusLost", "WinLeave"]

" previm 配置
" open with Google Chrome
" let g:previm_open_cmd = 'xdg-open'
" .vimrc
" Instead of using the default CSS and apply only your own CSS
"let g:previm_disable_default_css = 1
let g:previm_custom_css_path = '/home/liubianshi/Dropbox/Backup/markdown CSS/vue.css'


" 快捷键查询
call which_key#register('<Space>', "g:which_key_map")
call which_key#register(';', "g:which_key_local")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>

let g:which_key_map = {}
let g:which_key_map.f = {
      \ 'name' : '+FzfCommand',
      \ 'f' : 'Files'    ,
      \ 'b' : 'Open buffers',
      \ 'c' : 'Color schemes',
      \ 'a' : 'ag search result',
      \ 'h' : 'v:oldfiles and open buffers',
      \ ':' : 'Command history',
      \ '/' : 'Search history',
      \ 's' : 'Snippets (UltiSnips)',
      \ 'm' : 'Commands',
      \ 'l' : 'Lines in the current buffer',
      \ 'L' : 'Lines in loaded buffers',
      \ 't' : 'Tags in the current buffer',
      \ 'T' : 'Tags in the project',
      \ }
let g:which_key_map.t = { 'name' : '+tabHandle' }
let g:which_key_map.b = { 'name' : '+buffer' }
let g:which_key_map.c = { 'name' : '+NerdCommander' }
let g:which_key_map.e = { 'name' : '+EditFile' }
let g:which_key_map.r = { 'name' : '+Ranger' }
let g:which_key_map.l = { 'name' : '+CocList' }

let g:which_key_local = {}
let g:which_key_local.a = { 'name' : '+R_File' }
let g:which_key_local.b = { 'name' : '+R_Block' }
let g:which_key_local.c = { 'name' : '+R_Chunk' }
let g:which_key_local.f = { 'name' : '+R_Function' }
let g:which_key_local.s = { 'name' : '+R_Selection_Sweave' }
let g:which_key_local.p = { 'name' : '+R_Paragraph' }
let g:which_key_local.r = { 'name' : '+R_Command' }
let g:which_key_local.v = { 'name' : '+R_View' }
let g:which_key_local.t = { 'name' : '+R_TabOutput' }
let g:which_key_local.k = { 'name' : '+R_Knit' }
let g:which_key_local.o = { 'name' : '+R_Open' }
let g:which_key_local.g = { 'name' : '+R_Goto' }
let g:which_key_local.x = { 'name' : '+R_Comment' }


