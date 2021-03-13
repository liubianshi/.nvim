let g:goyo_width = 100 
let g:goyo_height = 90

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  setlocal noshowmode
  setlocal noshowcmd
  setlocal linebreak
  setlocal brk=""
  setlocal scrolloff=999
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  setlocal showmode
  setlocal showcmd
  setlocal linebreak
  highlight SignColumn guibg=#282828
  highlight FoldColumn guifg=#282828 guibg=#282828
  setlocal scrolloff=5
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
