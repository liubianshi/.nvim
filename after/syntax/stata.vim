syn keyword stataCommand testreg
syn keyword stataCommand fvexpand

syn keyword stataTodo	NOTE1 NOTE2 NOTE3 NOTE4 NOTE5 NOTE6 NOTE7 NOTE8 NOTE9 NOTE NOTE: contained
syn region stataHeader  start=/^\s*\* [0-9]\{1,2}\./ end=/$/ contains=stataHeader,stataTodo oneline

hi def link stataHeader Todo

