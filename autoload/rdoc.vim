function! s:RdocWord(word)
    if s:DocExist(a:word)
        " call s:ShowCmd("0read!Rscript --no-init-file -e 'help(" . a:word . ", try.all.packages = T)'", a:word)
        call s:ShowCmd("0read!,rhelp " . a:word, a:word)
    else
        echo 'No documentation found for "' . a:word . '".'
    endif
endfunction

function! s:DocExist(word)
    let result = system("Rscript --no-init-file -e 'cat(length(unclass(help(" . a:word . ", try.all.packages = T))))'")
    return result == 0 ? 0 : 1
endfunction

function! s:ShowCmd(cmd, word)
  silent call ft_utils#DocView("r", a:word)
  setlocal modifiable
  normal ggdG
  silent execute a:cmd
  normal gg
  setlocal filetype=rdoc
  setlocal nomodifiable
endfunction

function! rdoc#Rdoc(...)
  let word = (empty(a:000) ? expand('<cword>') : join(a:000, ' '))
  call s:RdocWord(word)
endfunction

