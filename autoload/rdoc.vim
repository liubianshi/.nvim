
function! s:RdocWord(word)
    call s:ShowCmd("0read!,rhelp " . a:word, a:word)
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

function! rdoc#RLisObjs(ArgLead, CmdLine, CursorPos)
    return luaeval('require("r.server").list_objs(_A)', a:ArgLead)
endfunction


function! rdoc#Rdoc(...)
  let word = (empty(a:000) ? expand('<cword>') : join(a:000, ' '))
  call s:RdocWord(word)
endfunction

