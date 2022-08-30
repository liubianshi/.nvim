let g:fzf_command_prefix = 'Fzf'    " 给 fzf.vim 命令加前缀
let g:fzf_layout = { 'down': '40%' }
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

" 列出文献 ------------------------------------------------------------------- {{{2
function! s:Bibtex_ls()
  let bibfiles = (
      \ globpath('~/Documents', '*ref.bib', v:true, v:true) +
      \ globpath('.', '*.bib', v:true, v:true) +
      \ globpath('..', '*.bib', v:true, v:true) +
      \ globpath('*/', '*.bib', v:true, v:true)
      \ )
  let bibfiles = join(bibfiles, ' ')
  let source_cmd = 'bibtex-ls '.bibfiles
  return source_cmd
endfunction

function! s:bibtex_cite_sink(lines)
    let r=system("bibtex-cite ", a:lines)
    execute ':normal! a' . r
endfunction

function! s:bibtex_markdown_sink(lines)
    let r=system("bibtex-markdown ", a:lines)
    execute ':normal! a' . r
endfunction

function! Bibtex_cite_sink_insert(lines)
    let r=system("bibtex-cite -prefix='@' -postfix='' -separator='; @'", a:lines)
    "let r=system("bibtex-cite ", a:lines)
    execute ':normal! i' . r
    call feedkeys('a', 'n')
endfunction

function! s:bibtex_cite_sink_insert(lines)
    let r=system("bibtex-cite -prefix='@' -postfix='' -separator='; @'", a:lines)
    "let r=system("bibtex-cite ", a:lines)
    execute ':normal! i' . r
    call feedkeys('a', 'n')
endfunction

" bring up fzf to insert citation to selected items.
nnoremap <silent> <leader>ac :call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>
" bring up fzf to insert pretty markdown versions of selected items.
nnoremap <silent> <leader>am :call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>

inoremap <silent> ;@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

noremap <silent> <leader>st :<C-U><C-R>=printf("FzfBTags %s", "")<CR><CR>
noremap <silent> <leader>sT :<C-U><C-R>=printf("FzfTags %s", "")<CR><CR>
noremap <silent> <leader>sL :<C-R>=printf("FzfLocate ")<CR><space>
nmap    <silent> <leader>sm <plug>(fzf-maps-n)
xmap    <silent> <leader>sm <plug>(fzf-maps-x)
omap    <silent> <leader>sm <plug>(fzf-maps-o)
imap    <silent> ;sm <plug>(fzf-maps-i)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
