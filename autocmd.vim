let symbol_dict = {
            \  ',': "，",
            \  '.': "。",
            \  '\': "、",
            \  ':': "：",
            \  ';': "；",
            \  '!': "！",
            \  '?': "？",
            \  }

function! s:fasd_update() abort
  if empty(&buftype) || &filetype ==# 'dirvish'
    call jobstart(['fasd', '-A', fnameescape(expand('%:p'))])
  endif
endfunction

" 初始 ================================================================== {{{1
augroup LOAD_ENTER
autocmd!

" cmd: global setting --------------------------------------------------- {{{2
autocmd InsertLeave,WinEnter *  setlocal cursorline
autocmd InsertEnter,WinLeave *  setlocal nocursorline
autocmd TermOpen             *  setlocal nonumber norelativenumber bufhidden=hide

" Fasd ================================================================== {{{1
autocmd BufWinEnter,BufFilePost * call <SID>fasd_update()
augroup END

augroup Method_Toggle
    autocmd!
    autocmd InsertLeavePre * call input_method#En(1)
    autocmd InsertEnter * call input_method#Zh(1)
    autocmd CmdlineEnter [/\?] call input_method#Zh(1)
    autocmd CmdlineLeave [/\?] call input_method#En(1)
    autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org
        \ inoremap <silent><expr><buffer> <space> input_method#Space(symbol_dict)
    autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org
        \ inoremap <silent><expr><buffer> <bs> input_method#BS()
    autocmd FileType mail,org
        \ inoremap <silent><expr><buffer> <space> input_method#Space(symbol_dict)
    autocmd FileType mail,org
        \ inoremap <silent><expr><buffer <bs> input_method#BS()>
augroup END
