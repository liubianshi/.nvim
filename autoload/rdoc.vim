function! s:RdocWord(word)
    if s:DocExist(a:word)
        " call s:ShowCmd("0read!Rscript --no-init-file -e 'help(" . a:word . ", try.all.packages = T)'", a:word)
        call s:ShowCmd("0read!,rhelp " . a:word, a:word)
    else
        echo 'No documentation found for "' . a:word . '".'
  end
endfunction

function! s:DocExist(word)
    let result = system("Rscript --no-init-file -e 'cat(length(unclass(help(" . a:word . ", try.all.packages = T))))'")
    if result == 0
        return 0
    else
        return 1
    endif
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
  let word = join(a:000, ' ')
  if !strlen(word)
    let word = expand('<cword>')
  endif
  call s:RdocWord(word)
endfunction

