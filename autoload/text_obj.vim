" Auxiliary functions =================================================== {{{1
function! s:find_paired_line_number(start_prefix, end_prefix) abort
  let no_match = [0, 0]
  let lineno = line('.')
  normal! $

  let start_row = searchpos(a:start_prefix, 'bnW')[0]
  if start_row == 0 | return no_match | endif

  if &filetype ==# 'org'
    let key = substitute(getline(start_row), a:start_prefix . '(\S+)?.*', '\1', "")
    let start_pattern = a:start_prefix . key
    let end_pattern = a:end_prefix . key
  else
    let start_pattern = a:start_prefix
    let end_pattern = a:end_prefix
  endif 

  let nesting_level = 0
  let end_row = start_row + 1
  while end_row <= line("$")
    let line = getline(end_row)

    if match(line, start_pattern) != -1
      let nesting_level += 1
    elseif match(line, end_pattern) != -1 && nesting_level > 0
      let nesting_level -= 1
    elseif match(line, end_pattern) != -1 && nesting_level == 0
      break
    endif

    let end_row += 1
  endwhile

  if end_row < lineno
    if start_row == 1 | return no_match | endif
    exec "normal! " . (start_row - 1 ) . "G"
    return s:find_paired_line_number(a:start_prefix, a:end_prefix)
  elseif end_row > line("$")
    return no_match
  else
    return [start_row, end_row]
  endif

endfunction

" URL Objects =========================================================== {{{1
" From: https://github.com/jdhao/nvim-config/blob/master/autoload/text_obj.vim
function! text_obj#URL() abort
  if match(&runtimepath, 'vim-highlighturl') != -1
    " Note that we use https://github.com/itchyny/vim-highlighturl to get the URL pattern.
    let url_pattern = highlighturl#default_pattern()
  else
    let url_pattern = expand('<cfile>')
    " Since expand('<cfile>') also works for normal words, we need to check if
    " this is really URL using heuristics, e.g., URL length.
    if len(url_pattern) <= 10
      return
    endif
  endif

  " We need to find all possible URL on this line and their start, end index.
  " Then find where current cursor is, and decide if cursor is on one of the
  " URLs.
  let line_text = getline('.')
  let url_infos = []

  let [_url, _idx_start, _idx_end] = matchstrpos(line_text, url_pattern)
  while _url !=# ''
    let url_infos += [[_url, _idx_start+1, _idx_end]]
    let [_url, _idx_start, _idx_end] = matchstrpos(line_text, url_pattern, _idx_end)
  endwhile

  " echo url_infos
  " If no URL is found, do nothing.
  if len(url_infos) == 0
    return
  endif

  let [start_col, end_col] = [-1, -1]
  " If URL is found, find if cursor is on it.
  let [buf_num, cur_row, cur_col] = getcurpos()[0:2]
  for url_info in url_infos
    " echo url_info
    let [_url, _idx_start, _idx_end] = url_info
    if cur_col >= _idx_start && cur_col <= _idx_end
      let start_col = _idx_start
      let end_col = _idx_end
      break
    endif
  endfor

  " Cursor is not on a URL, do nothing.
  if start_col == -1
    return
  endif

  " Now set the '< and '> mark
  call setpos("'<", [buf_num, cur_row, start_col, 0])
  call setpos("'>", [buf_num, cur_row, end_col, 0])
  normal! gv
endfunction

" Markdown code block =================================================== {{{1
" From: https://github.com/jdhao/nvim-config/blob/master/autoload/text_obj.vim
function! text_obj#MdCodeBlock(type) abort
  " the parameter type specify whether it is inner text objects or around
  " text objects.

  " Move the cursor to the end of line in case that cursor is on the opening
  " of a code block. Actually, there are still issues if the cursor is on the
  " closing of a code block. In this case, the start row of code blocks would
  " be wrong. Unless we can match code blocks, it not easy to fix this.
  normal! $
  let start_row = searchpos('\s*```', 'bnW')[0]
  let end_row = searchpos('\s*```', 'nW')[0]

  let buf_num = bufnr()
  if a:type ==# 'i'
    let start_row += 1
    let end_row -= 1
  endif

  call setpos("'<", [buf_num, start_row, 1, 0])
  call setpos("'>", [buf_num, end_row, 1, 0])
  execute 'normal! gv$'
endfunction

" org-mode block ======================================================== {{{1
function! text_obj#OrgCodeBlock(type) abort
  let buf_num = bufnr()
  let pos = getpos('.')
  let [start_row, end_row] = s:find_paired_line_number('\v^.*#\+begin_', '\v^.*#\+end_')
  if start_row == 0
    call setpos(".", pos)
    return
  endif

  if a:type ==# 'i'
    let start_row += 1
    let end_row -= 1
  endif

  call setpos("'<", [buf_num, start_row, 1, 0])
  call setpos("'>", [buf_num, end_row, len(getline(end_row)), 0])
  execute 'normal! `<V`>'
endfunction


" Stata Program block =================================================== {{{1
function! text_obj#StataProgramDefine() abort
  let start_row = searchpos('\v^\s*cap(ture)? prog(ram)?', 'bnW')[0]
  let end_row = searchpos('\v^\s*end', 'nW')[0]

  let buf_num = bufnr()

  call setpos("'<", [buf_num, start_row, 1, 0])
  call setpos("'>", [buf_num, end_row, 1, 0])
  execute 'normal! `<V`>'
endfunction



" Whole Buffer ========================================================== {{{1
" From: https://github.com/jdhao/nvim-config/blob/master/autoload/text_obj.vim
function! text_obj#Buffer() abort
  let buf_num = bufnr()

  call setpos("'<", [buf_num, 1, 1, 0])
  call setpos("'>", [buf_num, line('$'), 1, 0])
  execute 'normal! `<V`>'
endfunction

