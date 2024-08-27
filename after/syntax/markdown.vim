runtime syntax/pandoc.vim

syntax match MarkdownQuote /\v^\>\ze( |$)/ conceal cchar=┃
syntax match MarkdownQuoteSpecial_pre /\v^\>\ze \[![^]]+\]/ conceal cchar=┏  contained
syntax match MarkdownQuoteSpecial /\v^\> \[![^]]+\]\s.*$/hs=s+2 keepend contains=MarkdownQuoteSpecial_pre,MarkdownQuoteSpecialMarker
syntax match MarkdownQuoteSpecialMarker /\v\[![^]]+\]/ contained
syntax match MarkdownHighlightPre /\v\={2}/ conceal contained
syntax match MarkdownHighlight /\v\={2}([^=]|\n[^=])+(\={2}|\n\n)/ contains=MarkdownHighlightPre,MarkdownQuote

exec "highlight def MarkdownQuoteSpecial_pre guifg=" . g:lbs_colors['orange']
exec "highlight def MarkdownHighlight guibg=" . g:lbs_colors['yellow'] . " guifg=" . g:lbs_colors['darkblue']
exec "highlight def MarkdownQuoteSpecial gui=underline guifg=" . g:lbs_colors['yellow']
exec "highlight def MarkdownQuoteSpecialMarker gui=bold guibg=" . g:lbs_colors['yellow'] ." guifg=" . g:lbs_colors['darkblue']

syn match pandocAtxHeaderMark1 /^#\ze\s/      contained containedin=pandocAtxHeader conceal cchar=󰉫
syn match pandocAtxHeaderMark2 /^##\ze\s/     contained containedin=pandocAtxHeader conceal cchar=󰉬
syn match pandocAtxHeaderMark3 /^###\ze\s/    contained containedin=pandocAtxHeader conceal cchar=󰉭
syn match pandocAtxHeaderMark4 /^####\ze\s/   contained containedin=pandocAtxHeader conceal cchar=󰉮
syn match pandocAtxHeaderMark5 /^#####\ze\s/  contained containedin=pandocAtxHeader conceal cchar=󰉯
syn match pandocAtxHeaderMark6 /^######\ze\s/ contained containedin=pandocAtxHeader conceal cchar=󰉰

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

syntax match NonText /​/ conceal
hi pandocStrong gui=underline
