" function! s:set_header_cchar(level, char)
"     let re = '\v\*{' . a:level . '}\ze '
"     exec "syntax match Entity '" . re . "' conceal cchar=" . a:char
" endfunction
" let s:header_icon = split("🌀 ◉ ○ ✺ ▶ ⤷")
" let s:header_max_level = len(s:header_icon)
" for ll in range(1, s:header_max_level) 
"     call s:set_header_cchar(ll, s:header_icon[ll - 1])
" endfor

" syn match orgQuoteMarker /^\s*#\+(begin|end)_quote$/ conceal
" syn match orgQuoteMarker /quote/ containedin=@OrgTSBlock
" syn region orgQuote start=/^\s*\#\+begin_quote$/ 
"
exec "hi OrgTSBlock guifg=" . g:lbs_colors['blue']
exec "hi OrgTSDirective cterm=bold guifg=" . g:lbs_colors['orange']
syntax match NonText /​/ conceal
" hi def link orgQuoteMarker Underlined



