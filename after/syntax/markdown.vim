runtime syntax/pandoc.vim

syntax match MarkdownQuote /\v^\>\ze( |$)/ conceal cchar=┃
syntax match MarkdownQuoteSpecial_pre /\v^\>\ze \[[^]]+\]/ conceal cchar=┏  contained
syntax region MarkdownQuoteSpecial start='\v^\> \[[^]]+\]' end='$' keepend contains=MarkdownQuoteSpecial_pre,MarkdownQuoteSpecialMarker
syntax match MarkdownQuoteSpecialMarker /\v\[[^]]+\]/ contained

exec "highlight def MarkdownQuoteSpecial_pre guifg=" . g:lbs_colors['orange']
highlight link MarkdownQuoteSpecial @text.literal 
highlight link MarkdownQuoteSpecialMarker TSTitle

