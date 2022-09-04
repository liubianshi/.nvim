" Vim syntax file
" Language:	Perldoc file
" Maintainer:	Peter Shangov (pshangov@yahoo.com)
" Last Change:	2009 Aug 28

if exists("b:current_syntax")
	finish
endif
let b:current_syntax = "perldoc"
let s:cpo_save = &cpo
set cpo&vim

setlocal iskeyword=@,48-57,_,.
setlocal conceallevel=2
setlocal concealcursor=nvc

syn region perldocCode matchgroup=perldocIgnore start=" >$" start="^>$" end="^[^ \t]"me=e-1 end="^<" concealends
syntax region perldocHead matchgroup=perldocIgnore start="^" end=" \~$" oneline concealends
syntax match perldocBullet "\t*  \* "
syntax match perldocItem "^\t.*"

highlight default link perldocHead String
highlight default link perldocCode Identifier 
highlight default link perldocIgnore Ignore 
highlight default link perldocItem Statement 
highlight default link perldocBullet Statement

syntax sync fromstart

" vim: ts=8 sw=2
