let g:fzf_command_prefix = 'Fzf'    " 给 fzf.vim 命令加前缀

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
"imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" fzf search
nnoremap <silent> <leader>ff  :FzfFiles<CR>
nnoremap <silent> <leader>fb  :FzfBuffers<CR>
nnoremap <silent> <leader>fc  :FzfColors<CR>
nnoremap <silent> <leader>fa  :<c-u>FzfAg 
nnoremap <silent> <leader>fh  :FzfHistory<CR>
nnoremap <silent> <leader>f:  :FzfHistory:<CR>
nnoremap <silent> <leader>f/  :FzfHistory/<CR>
nnoremap <silent> <leader>fs  :FzfSnippets<CR>
nnoremap <silent> <leader>fm  :FzfCommands<CR>
nnoremap <silent> <leader>fl  :FzfBLines<CR>
nnoremap <silent> <leader>fL  :FzfLines<CR>
nnoremap <silent> <leader>ft  :FzfBTags<CR>
nnoremap <silent> <leader>fT  :FzfTags<CR>
nnoremap <silent> <leader>fw  :WikiFzfPages<CR>

" fzf-bibtex
"
"
function! Bibtex_ls()
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

" bring up fzf to insert citation to selected items.
nnoremap <silent> <tab>c :call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>
" bring up fzf to insert pretty markdown versions of selected items.
nnoremap <silent> <tab>m :call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>

function! s:bibtex_cite_sink_insert(lines)
    let r=system("bibtex-cite -prefix='​@' -postfix='​' -separator='; @'", a:lines)
    "let r=system("bibtex-cite ", a:lines)
    execute ':normal! a' . r
    call feedkeys('a', 'n')
endfunction

inoremap <silent> <tab>@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>



