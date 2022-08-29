syn keyword stataCommand testreg xtabond2 snappreserve snaprestore dogen my
syn keyword stataCommand fvexpand
syn keyword stataCommand backup_program file2list test missnum varattr proxy
syn keyword stataCommand Snap VimSync_graphname_varlist backup_graph backup_varlist backup_macro H G V

syn keyword stataTodo	NOTE1 NOTE2 NOTE3 NOTE4 NOTE5 NOTE6 NOTE7 NOTE8 NOTE9 NOTE NOTE: contained
syn region stataHeader  start=/^\s*\* [0-9]\{1,2}\./ end=/$/ contains=stataHeader,stataTodo oneline

hi def link stataHeader  Special

