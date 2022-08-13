if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "voomtree"

setlocal conceallevel=1

syn match voomSymbol "\v\|" conceal contained
syn match voomCurrentChar "\v\=" conceal contained cchar=>
syn match voomPre "\v[ .]+\|" contains=voomSymbol
syn region voomCurrent start="\v^\= " end="\n" contains=voomPre,voomCurrentChar

hi def link voomPre Comment
hi def link voomCurrent PreProc
hi def link voomCurrentChar SpecialChar
