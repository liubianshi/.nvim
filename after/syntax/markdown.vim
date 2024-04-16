runtime syntax/pandoc.vim

syntax match MarkdownQuote /\v^\>\ze( |$)/ conceal cchar=┃
syntax match MarkdownQuoteSpecial_pre /\v^\>\ze \[![^]]+\]/ conceal cchar=┏  contained
syntax region MarkdownQuoteSpecial start='\v^\> \[![^]]+\]' end='$' keepend contains=MarkdownQuoteSpecial_pre,MarkdownQuoteSpecialMarker
syntax match MarkdownQuoteSpecialMarker /\v\[![^]]+\]/ contained

exec "highlight def MarkdownQuoteSpecial_pre guifg=" . g:lbs_colors['orange']
highlight link MarkdownQuoteSpecial @text.literal 
highlight link MarkdownQuoteSpecialMarker TSTitle

" source:
" https://github.com/vim-pandoc/vim-rmarkdown/blob/a1787cb55e45b8778eaed7b392648deb4706cd0b/syntax/rmarkdown.vim
" rmarkdown recognizes embedded R differently than regular pandoc
exe 'syn region pandocRChunk '.
            \ 'start=/\(```\s*{\s*r.*\n\)\@<=\_^/ ' .
            \ 'end=/\_$\n\(\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\_$\n\_$\)\@=/ '.
            \ 'contained containedin=pandocDelimitedCodeblock contains=@R'
syn region pandocInlineR matchgroup=Operator start=/`r\s/ end=/`/ contains=@R concealends

" rmarkdown recognizes embedded R differently than regular pandoc
exe 'syn region pandocPythonChunk '.
            \ 'start=/\(```\s*{\s*python.*\n\)\@<=\_^/ ' .
            \ 'end=/\_$\n\(\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\_$\n\_$\)\@=/ '.
            \ 'contained containedin=pandocDelimitedCodeblock contains=@python'

syn region pandocInlinePython matchgroup=Operator start=/`python\s/ end=/`/ contains=@Python concealends

