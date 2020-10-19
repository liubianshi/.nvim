" Neovim 配置文件
" 安装插件 {{{1
    call plug#begin('~/.local/share/nvim/plugged')
" 中文输入法 {{{2
    if(has("mac"))
        ""Plug 'ybian/smartim'
        Plug 'CodeFalling/fcitx-vim-osx', { 'on': [] }
    else
        Plug 'lilydjwg/fcitx.vim'   " Linux 下优化中文输入法切换
    endif
" 美化 {{{2
    "Plug 'flazz/vim-colorschemes' , { 'on': [] }    " 主题管理
    Plug 'morhetz/gruvbox'                          " 主题
    Plug 'rakr/vim-one'
        let g:one_allow_italics = 1 " I love italic for comments
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'ayu-theme/ayu-vim'
        "let ayucolor="light"  " for light version of theme
        let ayucolor="mirage" " for mirage version of theme
        "let ayucolor="dark"   " for dark version of theme
" Airline {{{3
    Plug 'vim-airline/vim-airline', { 'on': [] }    " 状态栏插件
    Plug 'vim-airline/vim-airline-themes', { 'on': [] }
        let g:airline_powerline_fonts = 1
        let g:airline_left_sep = ''
        let g:airline_right_sep = ''
        let g:airline#extensions#tabline#enabled = 0
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline_theme='ayu'
" 文件管理{{{2
    Plug 'rbgrouleff/bclose.vim'          " lf.vim 插件依赖，关闭 buffer，但关闭 buffer 所在窗口
    Plug 'ptzz/lf.vim'                    " 文件管理
        let g:lf_map_keys = 0
    Plug 'mileszs/ack.vim', {'on': 'Ack'}  " 在 Vim 中使用 Ack 或 Ag 检索
        let g:ackprg = 'ag --column'
    Plug 'mcchrish/nnn.vim'
        let g:nnn#set_default_mappings = 0
        let g:nnn#layout = { 'left': '~30%' } " or right, up, down
        let g:nnn#action = {
            \ '<c-t>': 'tab split',
            \ '<c-x>': 'split',
            \ '<c-v>': 'vsplit' }

" 模糊搜索加管理{{{2
    if(has("mac"))
        Plug 'junegunn/fzf.vim', { 'do': './install --bin' }
    else
        Plug '/usr/bin/fzf'               " 在 vim 中使用 fzf
    endif
    Plug 'junegunn/fzf.vim'               " 安装相关插件
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" 优化写作体验{{{2
    Plug 'junegunn/goyo.vim',       {'for': ['md', 'pandoc','rmd', 'rmarkdown']} " zen 模式:
    Plug 'hotoo/pangu.vim',         {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
    Plug 'mg979/vim-visual-multi',  {'branch': 'master'}
" Pandoc 和 Rmarkdown {{{3
    Plug 'vim-pandoc/vim-pandoc',   {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
        let g:pandoc#modules#disabled = ["spell"]
        let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
        let g:pandoc#filetypes#pandoc_markdown = 1
        let g:pandoc#biblio#bibs = ["/home/liubianshi/Documents/paper_ref.bib"]
        let g:pandoc#biblio#use_bibtool = 1
        let g:pandoc#completion#bib#mode = "citeproc"
        let g:pandoc#biblio#sources = ["bycg"]
        let g:pandoc#folding#fdc = 1
        let g:pandoc#folding#fold_yaml = 1
        let g:pandoc#folding#fastfolds = 1
        let g:pandoc#folding#fold_fenced_codeblocks = 0
    Plug 'vim-pandoc/vim-pandoc-syntax', {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
        let g:tex_conceal = ""
    Plug 'vim-pandoc/vim-rmarkdown',     {'for': ['rmd', 'rmarkdown']}
"}}}
    Plug 'ferrine/md-img-paste.vim',     {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
        let g:mdip_imgdir = 'assets'
        let g:mdip_imgname = 'image'
" wiki.vim {{{3
    Plug 'lervag/wiki.vim'
        "autocmd BufNewFile,BufRead *.wiki set filetype=rmd
        let g:wiki_root = '/home/liubianshi/Documents/WikiHome'
        let g:wiki_cache_root = '~/.cache/wiki.vim'
        let g:wiki_link_target_type = 'md'
        let g:wiki_filetypes = ['md', 'Rmd']
        let g:wiki_mappings_use_defaults = 'none' 
        let g:wiki_journal = {
            \ 'name': 'journal',
            \ 'frequency': 'daily',
            \ 'date_format': {
            \   'daily' : '%Y-%m-%d',
            \   'weekly' : '%Y_w%V',
            \   'monthly' : '%Y_m%m',
            \ },
            \}
"}}}
" 文本对象操作{{{2
    Plug 'godlygeek/tabular'            " 对齐文本插件
    Plug 'tpope/vim-surround'           " 快速给词加环绕符号
    Plug 'tpope/vim-repeat'             " 重复插件操作
    Plug 'tpope/vim-abolish'            " 高效的文本替换工具
    Plug 'scrooloose/nerdcommenter'     " 注释插件
    Plug 'easymotion/vim-easymotion'    " 高效移动指标插件
        let g:EasyMotion_do_mapping = 0 " Disable default mappings
        let g:EasyMotion_smartcase = 1
    Plug 'wellle/targets.vim'           " 扩展 vim 文本对象
" Snippets 相关 {{{3
    Plug 'sirver/UltiSnips'
        let g:UltiSnipsEditSplit = "tabdo"
        let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
        autocmd FileType rmd,rmarkdown :UltiSnipsAddFiletypes rmd.markdown
        autocmd BufNewFile,BufRead *.md UltiSnipsAddFiletypes markdown.md.pandoc
    Plug 'honza/vim-snippets', { 'on': [] }        " 配置 snippets 需要
"}}}
" 模拟IDE{{{2
    " SQL{{{3
    Plug 'tpope/vim-dadbod'   " Modern database interface for Vim
    Plug 'kristijanhusak/vim-dadbod-ui'  " Simple UI for vim-dadbod
        let g:dbs = { 
        \  'dataRepo': 'sqlite:/home/liubianshi/Documents/SRDM/srdm_dataRepo.sqlite',
        \ }
        let g:db_ui_save_location = "~/.config/diySync/db_ui_queries"
    Plug 'kristijanhusak/vim-dadbod-completion', { 'for': 'sql' }
        " Source is automatically added, you just need to include it in the chain complete list
        let g:completion_chain_complete_list = {
            \   'sql': [ {'complete_items': ['vim-dadbod-completion']} ]
            \ }
        " Make sure `substring` is part of this list. Other items are optional for this completion source
        let g:completion_matching_strategy_list = ['exact', 'substring']
        " Useful if there's a lot of camel case items
        let g:completion_matching_ignore_case = 1
    "}}}
    Plug 'jalvesaq/Nvim-R', {'for': ['r', 'rmarkdown', 'rmd'] }
    Plug 'lervag/vimtex',       {'for': ['tex', 'plaintex']}
        let g:vimtex_compiler_progname = 'nvr'          " 调用 neovim-remote
    Plug 'poliquin/stata-vim', { 'for': 'stata' }       " stata 语法高亮
    Plug 'Raku/vim-raku', { 'for': 'raku'}
        let g:raku_unicode_abbrevs = 0
        au BufNewFile,BufRead *.raku,*.p6,*.pl6,*.p6 set filetype=raku
    Plug 'kovetskiy/sxhkd-vim', { 'for': 'sxhkd' }
        au BufNewFile,BufRead sxhkdrc set filetype=sxhkd
    " tags and preview {{{3
    Plug 'ludovicchabant/vim-gutentags'
        let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
        let s:vim_tags = expand('~/.cache/tags')
        let g:gutentags_cache_dir = s:vim_tags
        " 配置 ctags 的参数
        let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
        " 检测 ~/.cache/tags 不存在就新建
        if !isdirectory(s:vim_tags)
            silent! call mkdir(s:vim_tags, 'p')
        endif
    Plug 'skywind3000/vim-preview'
    " Syntax checking {{{3
    Plug 'dense-analysis/ale'                      
        let g:ale_sign_column_always = 1
        let g:ale_set_highlights = 0
        let g:ale_sign_error = '✗'
        let g:ale_sign_warning = '⚡'
        " 显示Linter名称,出错或警告等相关信息
        let g:ale_echo_msg_error_str = 'E'
        let g:ale_echo_msg_warning_str = 'W'
        let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
        " 文件内容发生变化时不进行检查
        let g:ale_lint_on_text_changed = 'never'
        " 打开文件时不进行检查
        let g:ale_lint_on_enter = 0
        "使用clang对c和c++进行语法检查，对python使用pylint进行语法检查
        let g:ale_linters = {
                    \   'sh': ['shellcheck'],
                    \   'c': ['clang'],
                    \   'r': ['styler'],
                    \   'perl': ['perl -c'],
                    \   'raku': ['raku -c'],
                    \}
        let g:ale_fixers = {
                    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
                    \ }
" 其他小工具{{{2
    Plug 'chrisbra/NrrwRgn'              " 形成小 buffer
        let g:nrrw_rgn_vert = 0
        let g:nrrw_rgn_wdth = 80
        let g:nrrw_topbot_leftright = 'botright'
    Plug 'skywind3000/asyncrun.vim'       " 异步执行终端程序
        let g:asyncrun_open = 6
    Plug 'liuchengxu/vim-which-key'
    Plug 'machakann/vim-highlightedyank'  " 高亮显示复制区域
    Plug 'haya14busa/incsearch.vim'       " 加强版实时高亮
        map /  <Plug>(incsearch-forward)
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)
    Plug 'tpope/vim-fugitive', { 'on': [] }             " git 插件
    Plug 'tpope/vim-obsession', { 'on': [] }            " tmux Backup needed
    Plug 'yianwillis/vimcdoc', { 'on': [] }             " Vim 中文帮助文档
    Plug 'mechatroner/rainbow_csv', {                   
        \ 'for': ['csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'rfc_csv', 'rfc_semicolon'] 
        \ }
" vimcmdline {{{3
    Plug 'jalvesaq/vimcmdline'                               " vim/neovim 终端函数
        " vimcmdline mappings
        let cmdline_map_start          = '<LocalLeader>s'
        let cmdline_map_send           = '<LocalLeader>l'
        let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
        let cmdline_map_source_fun     = '<LocalLeader>f'
        let cmdline_map_send_paragraph = '<LocalLeader>p'
        let cmdline_map_send_block     = '<LocalLeader>b'
        let cmdline_map_quit           = '<LocalLeader>qq'

        " vimcmdline options
        let cmdline_vsplit      = 1      " Split the window vertically
        let cmdline_esc_term    = 1      " Remap <Esc> to :stopinsert in Neovim's terminal
        let cmdline_in_buffer   = 1      " Start the interpreter in a Neovim's terminal
        let cmdline_term_height = 15     " Initial height of interpreter window or pane
        let cmdline_term_width  = 90    " Initial width of interpreter window or pane
        let cmdline_tmp_dir     = '/tmp' " Temporary directory to save files
        let cmdline_outhl       = 1      " Syntax highlight the output
        let cmdline_auto_scroll = 1      " Keep the cursor at the end of terminal (nvim)
        
        let cmdline_app           = {}
        let cmdline_app['ruby']   = 'pry'
        let cmdline_app['sh']     = 'bash'
        let cmdline_app['stata']  = 'stata-mp'

        " Color
        let cmdline_follow_colorscheme = 1   
"}}}
" 自动补全{{{2
    Plug 'jiangmiao/auto-pairs'         " 自动引号/括号补全
        let g:AutoPairsMapBS = 0
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile', 'on': []}
" ncm2 及相关插件 {{{3
    Plug 'roxma/nvim-yarp'              " ncm2 依赖的插件
    Plug 'roxma/ncm2'
    Plug 'liubianshi/ncm-R', { 'for': ['r', 'rmarkdown', 'rmd']  }
    Plug 'ncm2/ncm2-bufword', { 'on': [] }
    Plug 'ncm2/ncm2-path', { 'on': [] }
    Plug 'ncm2/ncm2-ultisnips', { 'on': [] }
    Plug 'yuki-ycino/ncm2-dictionary', { 'on': [] }
    Plug 'Shougo/neco-syntax', { 'on': [] }
    Plug 'ncm2/ncm2-syntax', { 'on': [] }
        let g:ncm2_pandoc_source = {
            \ 'name': 'pandoc',
            \ 'priority': 9,
            \ 'scope': ['pandoc', 'markdown', 'rmarkdown', 'rmd'],
            \ 'mark': 'pandoc',
            \ 'word_pattern': '\w+',
            \ 'complete_pattern': ['@'],
            \ 'on_complete': ['ncm2#on_complete#omni', 'pandoc#completion#Complete'],
            \ }
        let g:ncm2_raku_source = {
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
        let g:ncm2_r_source = {
            \ 'name': 'r',
            \ 'priority': 9,
            \ 'auto_popup': 1,
            \ 'complete_length': 2,
            \ 'scope': ['r', 'R','Rmd', 'rmd', 'rmarkdown'],
            \ 'mark': 'r',
            \ 'word_pattern': '[\w.]+',
            \ 'on_complete': ['ncm2_bufword#on_complete'],
            \ }
"}}}
" 以前用过暂时不用将来可能用到的工具{{{2
    "Plug 'ncm2/ncm2-tmux'
    "Plug 'ncm2/ncm2-vim'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }
    "Plug '907th/vim-auto-save'           " 自动保存
    "Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
    "Plug 'chrisbra/NrrwRgn'              " 形成小 buffer
        "let g:nrrw_rgn_vert = 0
        "let g:nrrw_rgn_wdth = 80
        "let g:nrrw_topbot_leftright = 'botright'
    "Plug 'terryma/vim-multiple-cursors'
    "Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
        "let g:clap_provider_grep_executable = 'ag'
    "Plug 'VincentCordobes/vim-translate'                " 翻译工具
    "Plug 'neoclide/coc.nvim', {'branch': 'release'}     " coc 代码补全插件
"}}}
call plug#end()

" 初始设置相关 {{{1
" 状态栏{{{2
function! Status() 
    call plug#load('vim-airline', 'vim-airline-themes')
    set laststatus=1
endfunction

" 切换补全工具{{{2
function! CocCompleteEngine()
    call plug#load('coc.nvim')
    if exists("*ncm2#disable_for_buffer")
        call ncm2#disable_for_buffer()
    endif
    let b:coc_suggest_disable = 0
endfunction
function! Ncm2CompleteEngine()
    call plug#load(
         \ 'ncm2', 'ncm-R', 'ncm2-bufword',
         \ 'ncm2-path', 'ncm2-ultisnips', 'ncm2-dictionary',
         \ 'neco-syntax', 'ncm2-syntax',
         \ )
    let b:coc_suggest_disable = 1 
    call ncm2#enable_for_buffer()
    call ncm2#register_source(g:ncm2_pandoc_source) 
    call ncm2#register_source(g:ncm2_r_source) 
    call ncm2#register_source(g:ncm2_raku_source) 
endfunction
function! ChangeCompleteEngine()
    if !exists("b:coc_suggest_disable") || b:coc_suggest_disable == 0
        call Ncm2CompleteEngine() 
    else
        call CocCompleteEngine()
    endif
endfunction

" 进入插入模式启动的插件{{{2
augroup LOAD_ENTER
    autocmd!
    if(has("mac"))
        autocmd BufNewFile,BufRead * call plug#load('fcitx-vim-osx')
    else
        autocmd BufNewFile,BufRead * call plug#load('fcitx.vim')
    endif
    autocmd BufNewFile,BufRead * call plug#load('vim-snippets')
    autocmd BufNewFile,BufRead * call plug#load('vim-fugitive')
    autocmd BufNewFile,BufRead * call plug#load('vim-obsession')
    autocmd BufNewFile,BufRead * call plug#load('vimcdoc')
    autocmd BufNewFile,BufRead * call CocCompleteEngine()

    autocmd WinNew * call Status()
    autocmd BufNewFile,BufRead *.[Rr]md,*.[Rr] call Ncm2CompleteEngine()

    autocmd BufWritePre *.{md,pl,p6,raku,Rmd,rmd,r,do,ado} :%s/\s\+$//e
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex let &brk = ''
    autocmd filetype mail set tw=0 wrap
    autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
"}}}
augroup END

" 导入外部文件{{{1
source ~/.config/nvim/basic.vim
source ~/.config/nvim/lbs_function.vim  
source ~/.config/nvim/ChineseSymbol.vim
source ~/.config/nvim/vimtex.vim
source ~/.config/nvim/raku.vim
source ~/.config/nvim/rfile.vim
source ~/.config/nvim/fzfConifg.vim
source ~/.config/nvim/LeaderfConifg.vim
source ~/.config/nvim/whichkey.vim
source ~/.config/nvim/goyoConfig.vim
source ~/.config/nvim/KeyMap.vim
source ~/.config/nvim/nerdtree.vim
source ~/.config/nvim/stata.vim
"source ~/.config/nvim/coc.vim
"source ~/.config/nvim/python.vim
"}}}

