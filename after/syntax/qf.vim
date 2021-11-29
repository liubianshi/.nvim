syn region qfPre		start="^||" end=" " conceal contained
syn match qfResult  "^|| .\+"hs=s+3 contains=qfPre
hi def link qfPre  Comment
hi def link qfLineSep Delimiter
hi def link qfVarname Label
