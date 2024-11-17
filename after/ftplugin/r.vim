"call utils#Load_Plug("Nvim-R")

" Function =================================================================== {{{1
let b:cached_data = "/tmp/r_obj_preview.tsv"
" setlocal foldexpr=fold#GetFold()
" setlocal foldmethod=expr
" setlocal formatprg=r-format
setlocal tags+=~/.cache/Nvim-R/Rtags,~/.cache/Nvim-R/RsrcTags

" Keymap ===================================================================== {{{1
inoremap <buffer> <A-\>          %>%
inoremap <buffer> <A-\|>         %<>%
inoremap <buffer> <A-=>          <-<Space>
" imap     <buffer> <A-1>          <Esc><Plug>RSendLine
" nmap     <buffer> <A-1>          <Plug>RSendLine
if has("mac")
    inoremap <buffer> «          %>%
    inoremap <buffer> »          %<>%
    inoremap <buffer> ≠          <-<Space>
    " imap     <buffer> ¡          <Esc><Plug>RDSendLine
    " nmap     <buffer> ¡          <Plug>RDSendLine
endif

" nmap     <buffer> <localleader>l              <Plug>RSendLine
" vmap     <buffer> <localleader>l              <Plug>REDSendSelection
" nmap     <buffer> <LocalLeader>: :RSend

