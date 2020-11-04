" Liubianshi's Neovim

" load package {{{1
call plug#begin('~/.local/share/nvim/plugged')

" fcitx {{{2
if(has("mac"))
    ""Plug 'ybian/smartim'
    Plug 'CodeFalling/fcitx-vim-osx'
else
    Plug 'lilydjwg/fcitx.vim'   " Linux 下优化中文输入法切换
endif

" theme {{{2
"Plug 'flazz/vim-colorschemes' , { 'on': [] }    " 主题管理
Plug 'morhetz/gruvbox'                          " 主题
Plug 'rakr/vim-one'
    let g:one_allow_italics = 1 " I love italic for comments
Plug 'NLKNguyen/papercolor-theme'
Plug 'ayu-theme/ayu-vim'
    "let ayucolor="light"  " for light version of theme
    let ayucolor="mirage" " for mirage version of theme
    "let ayucolor="dark"   " for dark version of theme
    
" Airline {{{2
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

" nerdtree {{{2
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } "
    let g:NERDTreeIgnore = ['\.pyc$', '\.swp', '\.swo', '\.vscode', '__pycache__']
    let g:NERDTreeDirArrowExpandable = '▸'
    let g:NERDTreeDirArrowCollapsible = '▾'
    let g:NERDTreeShowBookmarks=1
    let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ "Ignored"   : "☒",
        \ "Unknown"   : "?"
        \ }
Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }

" lf {{{2
Plug 'rbgrouleff/bclose.vim'          " lf.vim 插件依赖，关闭 buffer，但关闭 buffer 所在窗口
Plug 'ptzz/lf.vim'                    " 文件管理
    let g:lf_map_keys = 0

" nnn {{{2
Plug 'mcchrish/nnn.vim'
    let g:nnn#set_default_mappings = 0
    let g:nnn#layout = { 'left': '~30%' } " or right, up, down
    let g:nnn#action = {
        \ '<c-t>': 'tab split',
        \ '<c-x>': 'split',
        \ '<c-v>': 'vsplit' }

" fzf {{{2
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
    let g:fzf_command_prefix = 'Fzf'    " 给 fzf.vim 命令加前缀
    let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

" leaderF {{{2
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    let g:Lf_HideHelp = 1
    let g:Lf_UseCache = 1
    let g:Lf_CacheDirectory = expand('~/.cache/')
    let g:Lf_UseVersionControlTool = 1
    let g:Lf_IgnoreCurrentBufferName = 1

    let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git', '.hg']
    let g:LF_Ctags = "ctags"
    let g:Lf_GtagsAutoGenerate = 1
    let g:Lf_Gtagslabel = 'native-pygments'
    let g:Lf_GtagsSource = 0

    let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
    let g:Lf_WorkingDirectoryMode = 'Ac'
    let g:Lf_WindowHeight = 0.50
    let g:Lf_ShowRelativePath = 0
    let g:Lf_PreviewResult = {'File': 0, 'Buffer': 0,'Function': 1, 'BufTag': 0 }
    let g:Lf_WindowPosition = 'bottom'
    let g:Lf_PreviewInPopup = 1
    let g:Lf_PopupShowStatusline = 1
    let g:Lf_PopupPreviewPosition = 'bottom'
    let g:Lf_PreviewHorizontalPosition = 'right'
    let g:Lf_PopupColorscheme = 'default'
    let g:Lf_AutoResize = 1
    let g:Lf_PopupWidth = &columns * 3 / 4
    let g:Lf_PopupHeight = 0.75

" visual_effects {{{2
Plug 'junegunn/goyo.vim',       {'for': ['md', 'pandoc','rmd', 'rmarkdown']} " zen 模式:
Plug 'hotoo/pangu.vim',         {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
Plug 'machakann/vim-highlightedyank'  " 高亮显示复制区域
Plug 'haya14busa/incsearch.vim'       " 加强版实时高亮
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

" visual multi {{{2
Plug 'mg979/vim-visual-multi',  {'branch': 'master'}
    let g:VM_leader = "<F9>" 
" Pandoc and Rmarkdown {{{2
Plug 'vim-pandoc/vim-pandoc',   {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
    let g:pandoc#modules#disabled = ["spell"]
    let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
    let g:pandoc#filetypes#pandoc_markdown = 1
    let g:pandoc#biblio#bibs = ["/home/liubianshi/Documents/paper_ref.bib"]
    let g:pandoc#biblio#use_bibtool = 1
    let g:pandoc#completion#bib#mode = "citeproc"
    let g:pandoc#biblio#sources = ["bycg"]
    let g:pandoc#folding#fdc = 1
    let g:pandoc#folding#level = 1
    let g:pandoc#folding#fold_yaml = 1
    let g:pandoc#folding#fastfolds = 1
    let g:pandoc#folding#fold_fenced_codeblocks = 0
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
    let g:tex_conceal = ""
Plug 'vim-pandoc/vim-rmarkdown',     {'for': ['rmd', 'rmarkdown']}
Plug 'ferrine/md-img-paste.vim',     {'for': ['md', 'pandoc','rmd', 'rmarkdown']}
    let g:mdip_imgdir = 'assets'
    let g:mdip_imgname = 'image'

" wiki.vim {{{2
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
" text objects {{{2
Plug 'godlygeek/tabular'            " 对齐文本插件
Plug 'tpope/vim-surround'           " 快速给词加环绕符号
Plug 'tpope/vim-repeat'             " 重复插件操作
Plug 'tpope/vim-abolish'            " 高效的文本替换工具
Plug 'scrooloose/nerdcommenter'     " 注释插件
Plug 'easymotion/vim-easymotion'    " 高效移动指标插件
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    let g:EasyMotion_smartcase = 1
Plug 'wellle/targets.vim'           " 扩展 vim 文本对象

" Snippets {{{2
Plug 'sirver/UltiSnips'
    let g:UltiSnipsEditSplit = "tabdo"
    let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
Plug 'honza/vim-snippets', { 'on': [] }

" Filetype {{{2
" SQL {{{3
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

" R {{{3
Plug 'jalvesaq/Nvim-R', {'for': ['r', 'rmarkdown', 'rmd'] }
    let r_syntax_folding = 1
    let R_cmd = "R"
    let R_app = "radian"
    let R_hl_term = 1
    let R_openpdf = 1
    let R_bracketed_paste = 0
    let R_rcomment_string = '#> '
    let R_nvimpager = "vertical"
    let Rout_more_colors = 1
    let R_hi_fun_globenv = 1
    let R_hi_fun_paren = 1
    let R_assign = 0
    let R_rmdchunk = 0
    let R_in_buffer = 1
    let R_external_term = 'st -n R -e'
    let R_csv_app = "terminal:/home/liubianshi/useScript/viewdata"
    let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,rlang,data.table,fread,readxl,tidyverse,haven,lbs'
    command! RStart let oldft=&ft
        \ | set ft=r
        \ | exe 'set ft='.oldft
        \ | let b:IsInRCode = function("DefaultIsInRCode")
        \ | normal <LocalLeader>rf

" latex {{{3
Plug 'lervag/vimtex',       {'for': ['tex', 'plaintex']}
    let g:vimtex_compiler_progname = 'nvr'          " 调用 neovim-remote
    let g:vimtex_compiler_latexmk = {
        \ 'background' : 1,
        \ 'build_dir' : 'tex_tmp',
        \ 'callback' : 1,
        \ 'continuous' : 0,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}
    let g:vimtex_compiler_latexmk_engines = {
        \ '_'                : '-xelatex',
        \ 'pdflatex'         : '-pdf',
        \ 'dvipdfex'         : '-pdfdvi',
        \ 'lualatex'         : '-lualatex',
        \ 'xelatex'          : '-xelatex',
        \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
        \ 'context (luatex)' : '-pdf -pdflatex=context',
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
        \}
" stat {{{3
Plug 'poliquin/stata-vim', { 'for': 'stata' }       " stata 语法高亮

" raku {{{3 
Plug 'Raku/vim-raku', { 'for': 'raku'}
    let g:raku_unicode_abbrevs = 0
" sxhkd {{{3
Plug 'kovetskiy/sxhkd-vim', { 'for': 'sxhkd' }

" csv / tsv {{{3
Plug 'mechatroner/rainbow_csv', {                   
    \ 'for': ['csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'rfc_csv', 'rfc_semicolon'] 
    \ }

" tags {{{2
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

" preview {{{2
Plug 'skywind3000/vim-preview'

" Syntax checking {{{2
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
" system interaction {{{2
" floaterm {{{3
Plug 'voldikss/vim-floaterm'
    let g:floaterm_rootmarkers = ['.project', '.git', '.hg', '.svn', '.root', '.gitignore']
    let g:floaterm_position = 'topright'
" asyncrun {{{3
Plug 'skywind3000/asyncrun.vim'       " 异步执行终端程序
    let g:asyncrun_open = 6
" obsession {{{3
Plug 'tpope/vim-obsession', { 'on': [] }            " tmux Backup needed
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

" auto-pairs {{{2
Plug 'jiangmiao/auto-pairs'         
    let g:AutoPairsMapBS = 0

" coc {{{2
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile', 'on': []}

" ncm2 complete system {{{2
Plug 'roxma/nvim-yarp'              " ncm2 依赖的插件
Plug 'roxma/ncm2'
Plug 'liubianshi/ncm-R', { 'on': []  }
Plug 'ncm2/ncm2-bufword', { 'on': [] }
Plug 'ncm2/ncm2-path', { 'on': [] }
Plug 'ncm2/ncm2-ultisnips', { 'on': [] }
Plug 'yuki-ycino/ncm2-dictionary', { 'on': [] }
Plug 'Shougo/neco-syntax', { 'on': [] }
Plug 'ncm2/ncm2-syntax', { 'on': [] }
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
" Git {{{2
Plug 'tpope/vim-fugitive', { 'on': [] }             " git 插件

" help {{{2
Plug 'liuchengxu/vim-which-key'
Plug 'yianwillis/vimcdoc', { 'on': [] }             " Vim 中文帮助文档

" used plugs {{{2
    "Plug 'ncm2/ncm2-tmux'
    "Plug 'ncm2/ncm2-vim'
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

" plug end {{{2
call plug#end()

" source external files {{{1
source ~/.config/nvim/basic.vim
source ~/.config/nvim/lbs_function.vim  
source ~/.config/nvim/KeyMap.vim
source ~/.config/nvim/whichkey.vim
source ~/.config/nvim/goyoConfig.vim
source ~/.config/nvim/autocmd.vim


