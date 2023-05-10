" vim: set ft=vim fdm=marker nowrap:
if exists("b:keywords")
    finish
endif
set syntax=stata

let b:keywords       = ['des', 'codebook', 'tab', 'gdistinct', 'graph tw']
let b:cache_path     = "./.vim"
let b:varlist        = []
let b:graphlist      = []
let b:macrolist      = []
let b:cached_data    = b:cache_path . "/stata_preview.tsv"
let b:cached_varlist = b:cache_path . "/varlist.tsv"

runtime  autoload/syntaxcomplete.vim
let b:keywordlist = uniq(sort(OmniSyntaxList()))

" Load Pluguin needed ======================================================== {{{1
call utils#Load_Plug('stata-vim')
call utils#Load_Plug("vimcmdline")

"setlocal foldmarker={{{,}}}
setlocal foldexpr=fold#GetFold()
setlocal foldmethod=expr
setlocal cindent
setlocal expandtab



" Define Function and Command ================================================ {{{1
"
" Stata Preview data --------------------------------------------------------- {{{2
function! s:Stata_Preview_Data(close = "n") abort
    call utils#Preview_data(b:cached_data, "stata_preview_bufnr", "tabnew", a:close)
endfunction

function! s:Stata_Preview_Variables(close = "n") abort
    call utils#Preview_data(b:cached_varlist, "stata_preview_varlist", "50vsplit", a:close)
endfunction

" 定义 Stata Motion 函数 ----------------------------------------------------- {{{2
function! s:StataCommandFactory(command = '', type = '') abort
    let cmd = a:command
    let reg_save = @"
    let visual_marks_save = [getpos("'<"), getpos("'>")]
    try
        set clipboard= selection=inclusive
        let commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y", v: "`<v`>y"}
        silent exe 'noautocmd keepjumps normal! ' .. get(commands, a:type, '')
        if cmd == "H"
            call Lbs_StataGenHelpDocs(@")
        else
            call cmdline#SendCmd(cmd .. " " .. @")
        endif
    finally
        call setreg('"', reg_save)
        call setpos("'<", visual_marks_save[0])
        call setpos("'>", visual_marks_save[1])
     endtry
endfunction
function! s:Stata_des(type = '')
    call <SID>StataCommandFactory("des", a:type)
endfunction
function! s:Stata_view(type = '')
    call <SID>StataCommandFactory("V", a:type)
endfunction
function! s:Stata_help(type = '')
    call <SID>StataCommandFactory("H", a:type)
endfunction
function! s:Stata_levelsof(type = '')
    call <SID>StataCommandFactory("glevelsof", a:type)
endfunction
function! s:Stata_distinct(type = '')
    call <SID>StataCommandFactory("gdistinct", a:type)
endfunction
function! s:Stata_sum(type = '')
    call <SID>StataCommandFactory("gstats sum", a:type)
endfunction
 
" 将最新的变量名和标签写入 ./.varlist.tsv, 同时设置 buffer 变量 b:varlist -------- {{{2
function! s:StataSyncVarlistGraphlist() abort
    call cmdline#SendCmd("VimSync_graphname_varlist")
    let b:varlist   = split(system("cut -f1 ./.vim/varlist.tsv"), "\n")
    let b:graphlist = split(system("cut -f1 ./.vim/graphlist.txt"), "\n")
    let b:macrolist = split(system("cut -f1 ./.vim/macrolist.txt"), "\n")
endfunction

let s:prepended = ''
function! StataComplete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        let lastword = -1
        while start > 0
            if line[start - 1] =~ '\k'
                let start -= 1
                let lastword = a:findstart
            else
                break
            endif
        endwhile
        if lastword == -1
            let s:prepended = ''
            return start
        endif
        let s:prepended = strpart(line, start, (col('.') - 1) - start)
        return start
    endif 

    let base = substitute(s:prepended, "'", "''", 'g')
    let compl_list = b:macrolist + b:varlist + b:graphlist + b:keywordlist

    if base != ''
        let expr = 'v:val =~#' . " '^" . escape(base, '\\/.*$^~[]') . ".*'"
        let compl = filter(deepcopy(compl_list), expr)
    endif
    return compl
endfunction
setlocal omnifunc=StataComplete

" 生成向 Stata 发送代码的 vim 命令，并且配置常用方法和变量补全 --------------- {{{2
function! s:StataCommandComplete(A, L, P)
    let commandlist = b:macrolist + b:varlist + b:graphlist + b:keywordlist
    call filter(commandlist, 'v:val =~# "^' . a:A . '"')
    return commandlist
endfunction

" 生成 Stata vim-style doc 文件，并在 Vim 中打开 ----------------------------- {{{2
command! -nargs=+ -complete=customlist,<SID>StataCommandComplete
        \ STATADO call cmdline#SendCmd(<q-args>)
command! -nargs=0 STATAPREVIEW call <sid>Stata_Preview_Data()

" Mapping ==================================================================== {{{1
xnoremap <silent><buffer> if :<C-U>call text_obj#StataProgramDefine()<CR>
onoremap <silent><buffer> if :<C-U>call text_obj#StataProgramDefine()<CR>

inoremap <buffer> <M-j>  <space>///<cr><esc>:call utils#MoveCursorTo("")<cr>i

" Send Comamand -------------------------------------------------------------- {{{2
nnoremap <buffer> <localleader>: :call <SID>StataSyncVarlistGraphlist()<cr>:STATADO<Space>
nnoremap <buffer> <localleader><space> :call <SID>StataSyncVarlistGraphlist()<cr>
nnoremap <buffer> <localleader>G :STATADO G<cr>
nnoremap <buffer> <localleader>V :STATAPREVIEW<cr>
nnoremap <buffer> <localleader>H :Shelp<cr>
nnoremap <buffer> <localleader>S :STATADO VimSync_graphname_varlist<cr>

" Set options ---------------------------------------------------------------- {{{2
nnoremap <buffer> <localleader>,d :STATADO set trace on<cr>
nnoremap <buffer> <localleader>,D :STATADO set trace off<cr>

" Log ------------------------------------------------------------------------ {{{2
nnoremap <buffer> <localleader>Ll :call cmdline#SendCmd("log using \"" . "~/.log/" . substitute(expand('%:p:~'), "/", "%", "g") . "-" . strftime("%Y%m%d%H") . ".txt\", append text name(lbs)")<cr>
nnoremap <buffer> <localleader>Lr :STATADO log query _all<cr>
nnoremap <buffer> <localleader>Lp :STATADO log off lbs<cr>
nnoremap <buffer> <localleader>Lo :STATADO log on lbs<cr>
nnoremap <buffer> <localleader>Lc :STATADO log close lbs<cr>

" Description ---------------------------------------------------------------- {{{2
vnoremap <silent><buffer> <localleader>d  :<c-u>call <SID>Stata_des(visualmode())<cr>
nnoremap <silent><buffer> <localleader>dm :set opfunc=<SID>Stata_des<cr>g@
nnoremap <buffer> <localleader>rd :call cmdline#SendCmd("des " . expand('<cword>'))<cr>
nnoremap <buffer> <localleader>de :STATADO des<cr>
nnoremap <buffer> <localleader>ds :STATADO ds<cr>
nnoremap <buffer> <localleader>dc :STATADO count<cr>

" view Data ----------------------------------------------------------------- {{{2
vnoremap <silent><buffer> <localleader>v  :<c-u>call <SID>Stata_view(visualmode())<cr>
nnoremap <silent><buffer> <localleader>vm :set opfunc=<SID>Stata_view<cr>g@
nnoremap <buffer> <localleader>rv :call cmdline#SendCmd("codebook " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rv y:call cmdline#SendCmd("codebook " . @")<cr>
nnoremap <buffer> <localleader>vr :STATADO V if runiform() <= 100/_N<cr>:STATAPREVIEW<cr>
nnoremap <buffer> <localleader>vh :STATADO V in 1/100<cr>:STATAPREVIEW<cr>
nnoremap <buffer> <localleader>vt :STATADO V if _n >= _N - 100<cr>:STATAPREVIEW<cr>
nnoremap <buffer> <localleader>va :STATADO V<cr>:STATAPREVIEW<cr>
nnoremap <buffer> <localleader>vv :STATADO backup_varlist<cr>:r! xsv table -d '\t' ./.vim/varlist.tsv \| perl -pe '$_ = "*│ " . $_'<cr>
nnoremap <buffer> <localleader>vo :STATADO backup_varlist<cr>:call <sid>Stata_Preview_Variables()<cr>
nnoremap <buffer> <localleader>vO :STATADO backup_varlist<cr>:call <sid>Stata_Preview_Variables("y")<cr>
nnoremap <buffer> <localleader>ve :STATADO estimates dir<cr>
nnoremap <buffer> <localleader>vl :STATADO macro dir<cr>
nnoremap <buffer> <localleader>vx :STATADO return list<cr>
nnoremap <buffer> <localleader>vX :STATADO ereturn list<cr>

" help ----------------------------------------------------------------------- {{{2
nnoremap <buffer> <localleader>rh :<C-U><C-R>=printf("Shelp %s", expand("<cword>"))<CR><CR>
vnoremap <silent><buffer> <localleader>rh  :<c-u>call <SID>Stata_help(visualmode())<cr><cr>
nnoremap <silent><buffer> <localleader>hm :set opfunc=<SID>Stata_help<cr>g@
nnoremap <buffer> <localleader>hp :StataHelpPDF<cr>

" factor variable ------------------------------------------------------------ {{{2
vnoremap <silent><buffer> <localleader>f  :<c-u>call <SID>Stata_distinct(visualmode())<cr>
nnoremap <silent><buffer> <localleader>fm :set opfunc=<SID>Stata_distinct<cr>g@
nnoremap <buffer>         <localleader>rf :call cmdline#SendCmd("gdistinct " . expand('<cword>'))<cr>
vnoremap <buffer>         <localleader>rf y:call cmdline#SendCmd("gdistinct " . @")<cr>
nnoremap <buffer>         <localleader>fl :call cmdline#SendCmd("glevelsof " . expand('<cword>'))<cr>
vnoremap <buffer>         <localleader>fl y:call cmdline#SendCmd("glevelsof " . @")<cr>
nnoremap <buffer>         <localleader>ft :call cmdline#SendCmd("tab " . expand('<cword>'))<cr>
vnoremap <buffer>         <localleader>ft y:call cmdline#SendCmd("tab " . @")<cr>

" Continuous Variable Statisitcs --------------------------------------------- {{{2
vnoremap <silent><buffer> <localleader>n  :<c-u>call <SID>Stata_sum(visualmode())<cr>
nnoremap <silent><buffer> <localleader>nm :set opfunc=<SID>Stata_sum<cr>g@
nnoremap <buffer>         <localleader>rn :call cmdline#SendCmd("gstats sum " . expand('<cword>'))<cr>
vnoremap <buffer>         <localleader>rn y:call cmdline#SendCmd("gstats sum " . @")<cr>

" preserve data -------------------------------------------------------------- {{{2
nnoremap <silent><buffer> <localleader>sp :STATADO preserve<cr>
nnoremap <silent><buffer> <localleader>sP :STATADO restore<cr>
nnoremap <silent><buffer> <localleader>ss :STATADO Snap<cr>
nnoremap <silent><buffer> <localleader>sS :STATADO Snap, r<cr>
nnoremap <silent><buffer> <localleader>sl :STATADO snapshot list _all<cr>

" quick insert
inoremap ;<enter> <ESC>A<space>///<cr>
inoremap ;/ " ///<cr><tab>+ "<esc>

" which key desc ============================================================= {{{1
lua <<EOF
local wk = require("which-key")
wk.register({
["<localleader><space>"] = { "Sync Element" },
["<localleader>:"]       = { "Send Command"},
["<localleader>H"]       = {"Help Document"},
["<localleader>G"]       = {"Preview Graph"},
["<localleader>b"]       = {name = "Block"},
["<localleader>d"]       = {name = "describe"},
["<localleader>f"]       = {name = "factor variable operator"},
["<localleader>h"]       = {name = "stata help"},
["<localleader>L"]       = {name = "log operator"},
["<localleader>n"]       = {name = "numeric variable operator"},
["<localleader>p"]       = {name = "Paragraph"},
["<localleader>r"]       = {name = "run stata commmand"},
["<localleader>s"]       = {name = "perserve or snapshot current data"},
["<localleader>v"]       = {name = "view data, local, estimates et.al"},
["<localleader>,"]       = {name = "+options set"},
}, {buffer = 0} )
EOF

