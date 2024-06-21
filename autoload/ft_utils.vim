" 预览文档 ============================================================== {{{1
let s:buf_nr = -1
function! ft_utils#DocView(lang, keyword = "")
  " base on fuzzyfinder windowmanager
    let cwd = getcwd()
    if (a:keyword ==# "")
        let keyword = a:lang  
    else
        let keyword = a:keyword
    endif

  let split_modifier = get(g:, 'doc_split_modifier', '')
  if !bufexists(s:buf_nr)
    exe 'leftabove ' . split_modifier . 'new'
    exe 'file `="[' . keyword . 'doc]"`'
    let s:buf_nr = bufnr('%')
  elseif bufwinnr(s:buf_nr) == -1
    exe 'leftabove ' . split_modifier . 'split'
    execute s:buf_nr . 'buffer'
    delete _
  elseif bufwinnr(s:buf_nr) != bufwinnr('%')
    execute bufwinnr(s:buf_nr) . 'wincmd w'
  endif

  " countermeasure for auto-cd script
  execute ':lcd ' . cwd
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
  setlocal nocursorline
  setlocal nocursorcolumn
  setlocal listchars=tab:\ \ ,trail:\ 
  setlocal iskeyword+=:
  setlocal iskeyword-=-

  au bufhidden <buffer> call let <sid>buf_nr = -1
endfunction
