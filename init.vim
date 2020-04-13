" Neovim 配置文件
    call plug#begin('~/.local/share/nvim/plugged')
" 中文输入法 {{{
    if(has("mac"))
        ""Plug 'ybian/smartim'
        Plug 'CodeFalling/fcitx-vim-osx', { 'on': [] }
    else
        Plug 'lilydjwg/fcitx.vim', { 'on': [] }       " Linux 下优化中文输入法切换
    endif
"}}}

" 美化 {{{
    Plug 'morhetz/gruvbox'                          " 主题
    Plug 'rakr/vim-one'
        let g:one_allow_italics = 1 " I love italic for comments
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'ayu-theme/ayu-vim'
        "let ayucolor="light"  " for light version of theme
        let ayucolor="mirage" " for mirage version of theme
        "let ayucolor="dark"   " for dark version of theme
    "Plug 'flazz/vim-colorschemes' , { 'on': [] }    " 主题管理
    Plug 'vim-airline/vim-airline', { 'on': [] }    " 状态栏插件
    Plug 'vim-airline/vim-airline-themes', { 'on': [] }
        let g:airline_powerline_fonts = 1
        let g:airline_left_sep = ''
        let g:airline_right_sep = ''
        let g:airline#extensions#tabline#enabled = 0
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline_theme='gruvbox'
"}}}

" 文件管理
    Plug 'rbgrouleff/bclose.vim'          " lf.vim 插件依赖
    Plug 'ptzz/lf.vim'                    " 文件管理
        let g:lf_map_keys = 0
    Plug 'mileszs/ack.vim', {'on': 'Ack'}  " 在 Vim 中使用 Ack 或 Ag 检索
        let g:ackprg = 'ag --column'

" 模糊搜索加管理
    if(has("mac"))
        Plug 'junegunn/fzf.vim', { 'do': './install --bin' }
    else
        Plug '/usr/bin/fzf'               " 在 vim 中使用 fzf
    endif
    Plug 'junegunn/fzf.vim'               " 安装相关插件

" 优化写作体验
    Plug 'junegunn/goyo.vim',       {'for': ['md', 'pandoc','rmd', 'rmarkdown']} " zen 模式:
    Plug 'hotoo/pangu.vim',         {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
    Plug 'vim-pandoc/vim-pandoc',   {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
        let g:pandoc#modules#disabled = ["spell"]
        let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
        let g:pandoc#filetypes#pandoc_markdown = 1
        let g:pandoc#biblio#bibs = ["/home/liubianshi/Documents/paper_ref.bib"]
        let g:pandoc#biblio#use_bibtool = 1
        let g:pandoc#completion#bib#mode = "citeproc"
        let g:pandoc#biblio#sources = ["bycg"]
        let g:pandoc#folding#fdc = 0
        let g:pandoc#folding#fold_yaml = 1
        let g:pandoc#folding#fold_fenced_codeblocks = 0
    Plug 'vim-pandoc/vim-pandoc-syntax', {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
        let g:tex_conceal = ""
    Plug 'vim-pandoc/vim-rmarkdown',     {'for': ['rmd', 'rmarkdown']}
    Plug 'ferrine/md-img-paste.vim',     {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
        let g:mdip_imgdir = 'assets'
        let g:mdip_imgname = 'image'
    Plug 'lervag/wiki.vim'
        autocmd BufNewFile,BufRead *.wiki set filetype=rmd
        let g:wiki_root = "~/Nutstore Files/Nutstore/Diary/Knowledge" 
        let g:wiki_cache_root = "~/.cache/wiki.vim"
        let g:wiki_link_target_type = 'md'
        let g:wiki_filetypes = ['Rmd']
        let g:wiki_mappings_use_defaults = 0
        let g:wiki_journal = {
            \ 'name': 'journal',
            \ 'frequency': 'daily',
            \ 'date_format': {
            \   'daily' : '%Y-%m-%d',
            \   'weekly' : '%Y_w%V',
            \   'monthly' : '%Y_m%m',
            \ },
            \}
        

" 文本对象操作
    Plug 'godlygeek/tabular'            " 对齐文本插件
    Plug 'tpope/vim-surround'           " 快速给词加环绕符号
    Plug 'tpope/vim-repeat'             " 重复插件操作
    Plug 'scrooloose/nerdcommenter'     " 注释插件
    Plug 'easymotion/vim-easymotion'    " 高效移动指标插件
        let g:EasyMotion_do_mapping = 0 " Disable default mappings
        let g:EasyMotion_smartcase = 1
    Plug 'wellle/targets.vim'           " 扩展 vim 文本对象

" 自动补全
    Plug 'jiangmiao/auto-pairs'      " 自动引号/括号补全
        let g:AutoPairsMapBS = 0
    Plug 'neoclide/coc.nvim', { 'branch': 'release', 'on': [] }  " coc 代码补全插件
    Plug 'roxma/nvim-yarp', { 'on': [] } " ncm2 依赖的插件
    Plug 'roxma/ncm2', { 'on': [] } 
    Plug 'gaalcaras/ncm-R', { 'on': [] }
    Plug 'ncm2/ncm2-bufword', { 'on': [] }
    Plug 'ncm2/ncm2-path', { 'on': [] }
    Plug 'ncm2/ncm2-ultisnips', { 'on': [] }
    Plug 'yuki-ycino/ncm2-dictionary', { 'on': [] }
    Plug 'Shougo/neco-syntax', { 'on': [] }
    Plug 'ncm2/ncm2-syntax', { 'on': [] }
        let g:pandoc_source = {
            \ 'name': 'pandoc',
            \ 'priority': 9,
            \ 'scope': ['pandoc', 'markdown', 'rmarkdown', 'rmd'],
            \ 'mark': 'pandoc',
            \ 'word_pattern': '\w+',
            \ 'complete_pattern': ['@'],
            \ 'on_complete': ['ncm2#on_complete#omni', 'pandoc#completion#Complete'],
            \ }
        let g:raku_source = {
            \ 'name': 'raku',
            \ 'priority': 8,
            \ 'auto_popup': 1,
            \ 'complete_length': 2,
            \ 'scope': ['raku', 'perl6'],
            \ 'mark': 'raku',
            \ 'enable': 1,
            \ 'word_pattern': "[A-za-z_]([\'\-]?[A-Za-z_]+)*",
            \ 'on_complete': 'ncm2_bufword#on_complete',
            \ }
    Plug 'sirver/UltiSnips'
        let g:UltiSnipsEditSplit = "tabdo"
        let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
        autocmd FileType rmd,rmarkdown :UltiSnipsAddFiletypes rmd.markdown
        autocmd BufNewFile,BufRead *.md UltiSnipsAddFiletypes markdown.md.pandoc
    Plug 'honza/vim-snippets', { 'on': [] }        " 配置 snippets 需要

" 模拟IDE
    Plug 'jalvesaq/Nvim-R', {'for': ['r', 'rmarkdown', 'rmd'] }
    Plug 'lervag/vimtex',       {'for': ['tex', 'plaintex']}
        let g:vimtex_compiler_progname = 'nvr'          " 调用 neovim-remote
    Plug 'poliquin/stata-vim', { 'for': 'stata' }       " stata 语法高亮
    Plug 'Raku/vim-raku', { 'for': 'raku'}
        let g:raku_unicode_abbrevs = 0
        au BufNewFile,BufRead *.raku,*.p6,*.pl6,*.p6 set filetype=raku

" 其他小工具
    Plug 'skywind3000/asyncrun.vim'       " 异步执行终端程序
        let g:asyncrun_open = 0
    Plug 'liuchengxu/vim-which-key'
    Plug 'machakann/vim-highlightedyank'  " 高亮显示复制区域
    Plug 'haya14busa/incsearch.vim'       " 加强版实时高亮
        map /  <Plug>(incsearch-forward)
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)
    Plug 'tpope/vim-fugitive', { 'on': [] }             " git 插件
    Plug 'tpope/vim-obsession', { 'on': [] }            " tmux Backup needed
    Plug 'VincentCordobes/vim-translate'                " 翻译工具
    Plug 'yianwillis/vimcdoc', { 'on': [] }             " Vim 中文帮助文档
    Plug 'mechatroner/rainbow_csv', { 
        \ 'for': ['csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'rfc_csv', 'rfc_semicolon'] 
        \ }
    "Plug 'ncm2/ncm2-tmux'
    "Plug 'ncm2/ncm2-vim'
    "Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    "Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }
    "Plug '907th/vim-auto-save'           " 自动保存
    "Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
    "Plug 'chrisbra/NrrwRgn'              " 形成小 buffer
        "let g:nrrw_rgn_vert = 0
        "let g:nrrw_rgn_wdth = 80
        "let g:nrrw_topbot_leftright = 'botright'
    "Plug 'terryma/vim-multiple-cursors'
    "Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
        "let g:clap_provider_grep_executable = 'ag'
call plug#end()

function! Status() " 开启状态栏
    call plug#load('vim-colorschemes', 'vim-airline', 'vim-airline-themes')
    set laststatus=1
endfunction
autocmd WinNew * call Status()

" 切换补全工具
function! CocCompleteEngine()
    call plug#load('coc.nvim')
    call ncm2#disable_for_buffer()
    let b:coc_suggest_disable = 0
endfunction
function! Ncm2CompleteEngine()
    call plug#load(
        \ 'nvim-yarp', 'ncm2', 'ncm-R', 'ncm2-bufword',
        \ 'ncm2-path', 'ncm2-ultisnips', 'ncm2-dictionary',
        \ 'neco-syntax', 'ncm2-syntax',
        \ )
    let b:coc_suggest_disable = 1 
    call ncm2#enable_for_buffer()
    "call ncm2#register_source(g:pandoc_source) 
    call ncm2#register_source(g:raku_source) 
endfunction
function! ChangeCompleteEngine()
    if !exists("b:coc_suggest_disable") || b:coc_suggest_disable == 0
        call Ncm2CompleteEngine() 
    else
        call CocCompleteEngine()
    endif
endfunction
autocmd BufNewFile,BufRead * call Ncm2CompleteEngine()

augroup load_enter
  autocmd!
  if(has("mac"))
      autocmd InsertEnter * call plug#load('fcitx-vim-osx')
  else
      autocmd InsertEnter * call plug#load('fcitx.vim')
  endif
  autocmd InsertEnter * call plug#load('vim-snippets')
  autocmd InsertEnter * call plug#load('vim-fugitive')
  autocmd InsertEnter * call plug#load('vim-obsession')
  autocmd InsertEnter * call plug#load('vimcdoc')
augroup END

let mapleader = " "
let maplocalleader = ';'
source ~/.config/nvim/basic.vim
source ~/.config/nvim/ChineseSymbol.vim
source ~/.config/nvim/stata.vim
source ~/.config/nvim/vimtex.vim
source ~/.config/nvim/raku.vim
source ~/.config/nvim/rfile.vim
source ~/.config/nvim/fzfConifg.vim
source ~/.config/nvim/whichkey.vim
source ~/.config/nvim/goyoConfig.vim
source ~/.config/nvim/KeyMap.vim
"source ~/.config/nvim/coc.vim
"source ~/.config/nvim/python.vim
"source ~/.config/nvim/nerdtree.vim

let g:python_host_skip_check=1
let g:python3_host_skip_check=1
if(has("mac"))
    let g:python3_host_prog = '/usr/local/bin/python3'
    let g:python_host_prog = '/usr/bin/python'
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python'
endif
