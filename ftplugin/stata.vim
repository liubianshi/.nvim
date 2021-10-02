call Lbs_Load_Plug('stata-vim')
call Lbs_Load_Plug("vimcmdline")

let b:AutoPairs = g:AutoPairs
let b:AutoPairs['`']="'" 
setlocal foldmethod=marker
setlocal foldmarker={,}

command -nargs=+ Do :call VimCmdLineSendCmd("<args>")
nnoremap <buffer> <localleader>r<space> <C-U>:Do<Space>
nnoremap <buffer> <localleader>d :call VimCmdLineSendCmd("set trace on")<cr>
nnoremap <buffer> <localleader>D :call VimCmdLineSendCmd("set trace off")<cr>
nnoremap <buffer> <localleader>h :call VimCmdLineSendCmd("H")<cr>
nnoremap <buffer> <localleader>o :call VimCmdLineSendCmd("des")<cr>

nnoremap <buffer> <localleader>Ll :call VimCmdLineSendCmd("log using \"" . "~/.log/" . substitute(expand('%:p:~'), "/", "%", "g") . "-" . strftime("%Y%m%d%H") . ".txt\", append text name(lbs)")<cr>
nnoremap <buffer> <localleader>Lr :call VimCmdLineSendCmd("log query _all")<cr>
nnoremap <buffer> <localleader>Lp :call VimCmdLineSendCmd("log off lbs")<cr>
nnoremap <buffer> <localleader>Lo :call VimCmdLineSendCmd("log on lbs")<cr>
nnoremap <buffer> <localleader>Lc :call VimCmdLineSendCmd("log close lbs")<cr>

nnoremap <buffer> <localleader>tv :call VimCmdLineSendCmd("V")<cr>
nnoremap <buffer> <localleader>th :call VimCmdLineSendCmd("V in 1/100")<cr>
nnoremap <buffer> <localleader>te :call VimCmdLineSendCmd("V if _n >= _N - 100")<cr>
nnoremap <buffer> <localleader>tr :call VimCmdLineSendCmd("V if runiform <= 100/_N")<cr>
nnoremap <buffer> <localleader>ta :call VimCmdLineSendCmd("V")<cr>

nnoremap <buffer> <localleader>vr :call VimCmdLineSendCmd("return list")<cr>
nnoremap <buffer> <localleader>vR :call VimCmdLineSendCmd("ereturn list")<cr>
nnoremap <buffer> <localleader>ve :call VimCmdLineSendCmd("estimates dir")<cr>
nnoremap <buffer> <localleader>vm :call VimCmdLineSendCmd("macro dir")<cr>

nnoremap <buffer> <localleader>rd :call VimCmdLineSendCmd("des " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rd y:call VimCmdLineSendCmd("des " . @")<cr>
nnoremap <buffer> <localleader>ru :call VimCmdLineSendCmd("gdistinct " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>ru y:call VimCmdLineSendCmd("gdistinct " . @")<cr>
nnoremap <buffer> <localleader>rl :call VimCmdLineSendCmd("glevelsof " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rl y:call VimCmdLineSendCmd("glevelsof " . @")<cr>
nnoremap <buffer> <localleader>rp :call VimCmdLineSendCmd("codebook " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rp y:call VimCmdLineSendCmd("codebook " . @")<cr>
nnoremap <buffer> <localleader>rs :call VimCmdLineSendCmd("gstats sum " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rs y:call VimCmdLineSendCmd("gstats sum " . @")<cr>
nnoremap <buffer> <localleader>rt :call VimCmdLineSendCmd("tab " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rt y:call VimCmdLineSendCmd("tab " . @")<cr>
nnoremap <buffer> <localleader>rh :call VimCmdLineSendCmd("H " . expand('<cword>'))<cr>
vnoremap <buffer> <localleader>rh y:call VimCmdLineSendCmd("H " . @")<cr>

