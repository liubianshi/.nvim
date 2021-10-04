" vim: set ft=vim fdm=marker nowrap:
setlocal foldmethod=marker
setlocal foldmarker={,}
let b:AutoPairs = g:AutoPairs
let b:AutoPairs['`']="'" 
let b:keywords = ['des', 'codebook', 'tab', 'gdistinct', 'graph tw']
let b:varlist = []

" Load Pluguin needed ======================================================== {{{1
call Lbs_Load_Plug('stata-vim')
call Lbs_Load_Plug("vimcmdline")

" Define Function and Command ================================================ {{{1
" 定义 Stata Motion 函数 ----------------------------------------------------- {{{2
function! s:StataCommandFactory(command = '', type = '') abort
    let cmd = a:command
    let reg_save = @"
    let visual_marks_save = [getpos("'<"), getpos("'>")]
    try
        set clipboard= selection=inclusive
        let commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y", v: "`<v`>y"}
        silent exe 'noautocmd keepjumps normal! ' .. get(commands, a:type, '')
        call VimCmdLineSendCmd(cmd .. " " .. @")
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
 
" 将最新的变量名和标签写入 ./.varlist, 同时设置 buffer 变量 b:varlist -------- {{{2
function! s:StataSyncVarlist() abort
    call VimCmdLineSendCmd("backup_varlist")
    let l:varlist = split(system("cut -f1 ./.varlist"), "\n")
    let b:varlist = l:varlist
    return varlist
endfunction

" 生成向 Stata 发送代码的 vim 命令，并且配置常用方法和变量补全 --------------- {{{2
command -nargs=+ -complete=customlist,<SID>StataCommandComplete
            \ STATADO call VimCmdLineSendCmd("<args>")
function! s:StataCommandComplete(A, L, P)
    let commandlist = b:keywords + b:varlist
    call filter(commandlist, 'v:val =~# "^' . a:A . '"')
    return commandlist
endfunction


" Mapping ==================================================================== {{{1

" Send Comamand -------------------------------------------------------------- {{{2
nnoremap <buffer> <localleader><space> :<C-U>call <SID>StataSyncVarlist()<cr>:STATADO<Space>

" Set options ---------------------------------------------------------------- {{{2
nnoremap <buffer> <localleader>,d :call VimCmdLineSendCmd("set trace on")<cr>
nnoremap <buffer> <localleader>,D :call VimCmdLineSendCmd("set trace off")<cr>
nnoremap <buffer> <localleader>,b :call VimCmdLineSendCmd("backup_varlist")<cr>

" Log ------------------------------------------------------------------------ {{{2
nnoremap <buffer> <localleader>Ll :call VimCmdLineSendCmd("log using \"" . "~/.log/" . substitute(expand('%:p:~'), "/", "%", "g") . "-" . strftime("%Y%m%d%H") . ".txt\", append text name(lbs)")<cr>
nnoremap <buffer> <localleader>Lr :call VimCmdLineSendCmd("log query _all")<cr>
nnoremap <buffer> <localleader>Lp :call VimCmdLineSendCmd("log off lbs")<cr>
nnoremap <buffer> <localleader>Lo :call VimCmdLineSendCmd("log on lbs")<cr>
nnoremap <buffer> <localleader>Lc :call VimCmdLineSendCmd("log close lbs")<cr>

" Description ---------------------------------------------------------------- {{{2
vnoremap <silent><buffer> <localleader>d  :<c-u>call <SID>Stata_des(visualmode())<cr>
nnoremap <silent><buffer> <localleader>dm :set opfunc=<SID>Stata_des<cr>g@
nnoremap <buffer> <localleader>rd :call VimCmdLineSendCmd("des " . expand('<cword>'))<cr>
nnoremap <buffer> <localleader>de         :call VimCmdLineSendCmd("des")<cr>

" view Data ----------------------------------------------------------------- {{{2
vnoremap <silent><buffer> <localleader>v  :<c-u>call <SID>Stata_view(visualmode())<cr>
nnoremap <silent><buffer> <localleader>vm :set opfunc=<SID>Stata_view<cr>g@
nnoremap <buffer> <localleader>rv :call VimCmdLineSendCmd("codebook " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rv y:call VimCmdLineSendCmd("codebook " . @")<cr>
nnoremap <buffer> <localleader>vr :call VimCmdLineSendCmd("V if runiform <= 100/_N")<cr>
nnoremap <buffer> <localleader>vh :call VimCmdLineSendCmd("V in 1/100")<cr>
nnoremap <buffer> <localleader>vt :call VimCmdLineSendCmd("V if _n >= _N - 100")<cr>
nnoremap <buffer> <localleader>va :call VimCmdLineSendCmd("V")<cr>
nnoremap <buffer> <localleader>vv :call VimCmdLineSendCmd("backup_varlist")<cr>:r! xsv table ./.varlist \| perl -pe 's/^"\|"$//g; $_ = "*│ " . $_'<cr>
nnoremap <buffer> <localleader>vt :call VimCmdLineSendCmd("backup_varlist")<cr>:tabnew ./.varlist<cr>
nnoremap <buffer> <localleader>vo :call VimCmdLineSendCmd("backup_varlist")<cr>:vsplit ./.varlist<cr>
nnoremap <buffer> <localleader>ve :call VimCmdLineSendCmd("estimates dir")<cr>
nnoremap <buffer> <localleader>vl :call VimCmdLineSendCmd("macro dir")<cr>
nnoremap <buffer> <localleader>vx :call VimCmdLineSendCmd("return list")<cr>
nnoremap <buffer> <localleader>vX :call VimCmdLineSendCmd("ereturn list")<cr>

" help ----------------------------------------------------------------------- {{{2
nnoremap <buffer> <localleader>rh :call VimCmdLineSendCmd("H " . expand('<cword>'))<cr>
vnoremap <silent><buffer> <localleader>rh  :<c-u>call <SID>Stata_help(visualmode())<cr>
nnoremap <silent><buffer> <localleader>hm :set opfunc=<SID>Stata_help<cr>g@
nnoremap <buffer> <localleader>H :call VimCmdLineSendCmd("H")<cr>

" factor variable ------------------------------------------------------------ {{{2
vnoremap <silent><buffer> <localleader>f  :<c-u>call <SID>Stata_distinct(visualmode())<cr>
nnoremap <silent><buffer> <localleader>fm :set opfunc=<SID>Stata_distinct<cr>g@
nnoremap <buffer> <localleader>rf :call VimCmdLineSendCmd("gdistinct " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rf y:call VimCmdLineSendCmd("gdistinct " . @")<cr>
nnoremap <buffer> <localleader>fl :call VimCmdLineSendCmd("glevelsof " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>fl y:call VimCmdLineSendCmd("glevelsof " . @")<cr>
nnoremap <buffer> <localleader>ft :call VimCmdLineSendCmd("tab " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>ft y:call VimCmdLineSendCmd("tab " . @")<cr>

" Continuous Variable Statisitcs --------------------------------------------- {{{2
vnoremap <silent><buffer> <localleader>n  :<c-u>call <SID>Stata_sum(visualmode())<cr>
nnoremap <silent><buffer> <localleader>nm :set opfunc=<SID>Stata_sum<cr>g@
nnoremap <buffer> <localleader>rn :call VimCmdLineSendCmd("gstats sum " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rn y:call VimCmdLineSendCmd("gstats sum " . @")<cr>

" preserve data -------------------------------------------------------------- {{{2
nnoremap <silent><buffer> <localleader>sp :STATADO preserve<cr>
nnoremap <silent><buffer> <localleader>sP :STATADO restore<cr>
nnoremap <silent><buffer> <localleader>ss :STATADO Snap<cr>
nnoremap <silent><buffer> <localleader>sS :STATADO Snap, r<cr>
nnoremap <silent><buffer> <localleader>sl :STATADO snapshot list _all<cr>

" which key desc ============================================================= {{{1
lua <<EOF
local wk = require("which-key")
wk.register({
["<localleader><space>"] = {name = "Send Command"},
["<localleader>b"] = {name = "Block"},
["<localleader>d"] = {name = "describe"},
["<localleader>f"] = {name = "factor variable operator"},
["<localleader>h"] = {name = "stata help"},
["<localleader>H"] = {name = "fzf_help"},
["<localleader>L"] = {name = "log operator"},
["<localleader>n"] = {name = "numeric variable operator"},
["<localleader>p"] = {name = "Paragraph"},
["<localleader>r"] = {name = "run stata commmand"},
["<localleader>s"] = {name = "perserve or snapshot current data"},
["<localleader>v"] = {name = "view data, local, estimates et.al"},
["<localleader>,"] = {name = "+options set"},
}, {buffer = 0} )

EOF
