if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "newsboat"

setlocal conceallevel=2

syn match newsKeyword /\v^(Feed|Link|Title|Author|Date):\ze/ conceal cchar= contained
syn match newsDecodeurl /\v(\%[0-9A-Fa-f]{2}){8,}.*$/ conceal cchar=󰇘 contained
syn match newsFeed    /\v^Feed: .*$/          contains=newsKeyword
syn match newsTitle   /\v^Title: .*$/         contains=newsKeyword
syn match newsAuthor  /\v^Author: .*$/        contains=newsKeyword
syn match newsLinkType  /\v^Flags: .*$/        contains=newsKeyword
syn match newsDate    /\v^Date: .*$/          contains=newsKeyword
syn match newsLink    /\v^Link: [^ ]*$/hs=s+6 contains=newsKeyword,newsDecodeurl keepend
syn match newsInLink /\v\[[^\]\(]+\(link [^\)]+\)\]/ contains=newsLinkBracket
syn match newsLinkBracket /[\[\]]/ conceal contained
syn match newsLinkID /\v\[[0-9]+\]:?/ 
syn match newsLinkHeader /\vLinks:\ze\s*$/
syn region newsLink start="\v https://"hs=s+1 end=/\v \([^\)]+\)/he=s-1  oneline contains=newsLinkType
syn region newsInLink start='\v\[image\s' end='\v\(link #[0-9]+\)\]'  contains=newsLinkBracket keepend
syn match newsLinkType /\v\([^\)]+\)/hs=s+1,he=e-1 contained
syn match newsHighlightSymbol /\v(‹\[|\]›)/ contained conceal
syn match newsHighlightSymbol /\v(〚|〛)/ contained conceal
syn region newsHighlight start=/\V‹[/hs=s+2 end=/\V]›/he=s+1 contains=newsHighlightSymbol keepend
syn region newsHighlight start=/\V〚/hs=s+1 end=/\V〛/he=s+1 contains=newsHighlightSymbol keepend


exec "hi def newsHighlight guifg=" . g:lbs_colors['yellow'] . " guisp=" . g:lbs_colors['cyan']
hi def link newsLinkType Keyword
hi def link newsLinkHeader HighlightedYankRegion 
hi def link newsLinkID Constant
hi def link newsLink Underlined
hi def link newsInLink Underlined 
hi def link newsTitle SpecialChar
hi def link newsAuthor SpecialChar 
hi def link newsDate SpecialChar 
hi def link newsFeed NotifyWarnTitle
