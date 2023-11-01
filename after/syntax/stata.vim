syn keyword stataCommand local_inlist
syn keyword stataProgram snappreserve snaprestore dogen my addvar
syn keyword stataProgram Snap VimSync_graphname_varlist backup_graph backup_varlist backup_macro H G V
syn keyword stataProgram backup_program file2list test missnum varattr proxy

syn keyword stataException _rc cap[ture]

syn keyword stataPackage testreg xtabond2
syn keyword stataPackage fvexpand wbopendata
syn match stataInclude "#delimit \(;\|cr\)"

syn keyword stataTodo	NOTE1 NOTE2 NOTE3 NOTE4 NOTE5 NOTE6 NOTE7 NOTE8 NOTE9 NOTE NOTE: contained
syn region stataHeader  start=/^\s*\*\s[0-9]\{1,2}\./ end=/$/ contains=stataHeader,stataTodo oneline

syn match  stataTripleSlash   "\s///" containedin=stataSlashComment
syn region stataSlashComment start="\s///"  end=/$/ contains=stataComment,stataTodo oneline

" Multi Line String
"syn region stataString  start=/^\s*(/ end=/) \/\{2,3}\s*/ oneline contains=@stataMacroGroup,stataQuote,stataString,stataEString,stataSlashComment
syn match stataString  "^\s\+\zs.\+\ze/\{2,3}\s*>.*$"      contains=@stataMacroGroup,stataQuote,stataString,stataEString,stataSlashComment
syn region stataEString matchgroup=Nothing start=/`"$/ end=/^"'/ contains=@stataMacroGroup,stataQuote,stataString,stataEString,stataSlashComment


hi def link stataHeader      Special
hi def link stataInclude     Include
hi def link stataProgram     Structure
hi def link stataPackage     Keyword
hi def link stataException   Exception
hi def link stataTripleSlash Delimiter
