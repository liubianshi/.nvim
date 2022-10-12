" Vim syntax file
" Language:	Stata documentation
" Maintainer:	LUO Wei <liu.bian.shi@gmail.com>
" Last Change:	2021-10-11
" Based on Vim help file

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "statadoc"

setlocal iskeyword=@,48-57,_,.
setlocal conceallevel=2
setlocal concealcursor=nvc

syn match helpSpecial		"^\s*\[[A-Z]\{1,2}\] \w\+"
syn match helpInclude		"\[[A-Z]\{1,2}\]"
syn match helpHeader		"^.\{-}\ze\s\=\~$" nextgroup=helpIgnore
syn match helpHeader		"\s\+\zs.\{-}\ze\s\=\~\n" nextgroup=helpIgnore
syn match helpHyperTextJump	"\\\@<!│\([^│]\|\n\)\+│" contains=helpBar,helpUnderlined,helpItalic
syn match helpHyperTextEntry	"\*[#-)!+-~]\+\*\s"he=e-1 contains=helpStar
syn match helpHyperTextEntry	"\*[#-)!+-~]\+\*$" contains=helpStar
if has("conceal")
  syn match helpBar		contained "│" conceal
  syn match helpBacktick	contained "`" conceal
  syn match helpStar		contained "\*" conceal
else
  syn match helpBar		contained "│"
  syn match helpBacktick	contained "`"
  syn match helpStar		contained "\*"
endif
syn match helpCommand		"`[^` \t]\+`"hs=s+1,he=e-1 contains=helpBacktick
syn match helpCommand		"\(^\|[^a-z"[]\)\zs`[^`]\+`\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1 contains=helpBacktick
syn match helpComment		"^ vim:.*$"

" Highlight group items in their own color.
syn match helpURL `\v<(((https?|ftp|gopher)://|(mailto|file|news):)[^' 	<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' 	<>"]+)[a-zA-Z0-9/]`
if has("conceal")
  syn region helpExample	matchgroup=helpIgnore start="｢" end="｣" concealends contains=helpHyperTextJump,helpComment
  "syn region helpExample	matchgroup=helpIgnore start="<" end=">" concealends
  syn region helpNote		matchgroup=helpIgnore start="⁽" end="⁾" concealends contains=helpHyperTextJump,helpNote,helpUnderlined,helpItalic
  syn region helpUnderlined	matchgroup=helpIgnore start="_(" end=")_" concealends contains=helpBar 
  syn region helpSpecial	matchgroup=helpIgnore start="+(" end=")+" contains=helpBar concealends
  syn region helpItalic		matchgroup=helpIgnore start="«" end="»" concealends contains=helpHyperTextJump,helpNote
  syn region helpExample	matchgroup=helpIgnore start=" >>>$" start="^>>>$" end="^[^ \t]"me=e-1 end="^<<<" concealends
else
  syn region helpExample	matchgroup=helpIgnore start="｢" end="｣" contains=helpHyperTextJump,helpComment
  syn region helpExample	matchgroup=helpIgnore start="｢" end="｣"
  "syn region helpExample	matchgroup=helpIgnore start="<" end=">"
  syn region helpNote		matchgroup=helpIgnore start="⁽" end="⁾"
  syn region helpItalic		matchgroup=helpIgnore start="«" end="»" contains=helpHyperTextJump,helpNote
  syn region helpExample	matchgroup=helpIgnore start=" >>>$" start="^>>>$" end="^[^ \t]"me=e-1 end="^<<<"
endif


"syn match helpNormal		"|.*====*|"
"syn match helpNormal		"|||"
"syn match helpNormal		":|vim:|"	" for :help modeline
"syn match helpVim		"\<Vim version [0-9][0-9.a-z]*"
"syn match helpVim		"VIM REFERENCE.*"
"syn match helpVim		"NVIM REFERENCE.*"
"syn match helpOption		"'[a-z]\{2,\}'"
"syn match helpOption		"'t_..'"
"syn match helpCommand		"`[^` \t]\+`"hs=s+1,he=e-1 contains=helpBacktick
"syn match helpCommand		"\(^\|[^a-z"[]\)\zs`[^`]\+`\ze\([^a-z\t."']\|$\)"hs=s+1,he=e-1 contains=helpBacktick
"syn match helpHeader		"\s*\zs.\{-}\ze\s\=\~$" nextgroup=helpIgnore
"syn match helpGraphic		".* \ze`$" nextgroup=helpIgnore
"syn keyword helpNote		note Note NOTE note: Note: NOTE: Notes Notes:
"syn keyword helpWarning		WARNING WARNING: Warning:
"syn keyword helpDeprecated	DEPRECATED DEPRECATED: Deprecated:
"syn match helpSpecial		"\<N\>"
"syn match helpSpecial		"\<N\.$"me=e-1
"syn match helpSpecial		"\<N\.\s"me=e-2
"syn match helpSpecial		"(N\>"ms=s+1


if has("conceal")
  syn match helpIgnore		"." contained conceal
else
  syn match helpIgnore		"." contained
endif


syn sync minlines=40
" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link helpIgnore		Ignore
hi def link helpHyperTextJump	Identifier
hi def link helpBar		Ignore
hi def link helpBacktick	Ignore
hi def link helpStar		Ignore
hi def link helpHyperTextEntry	String
hi def link helpHeadline	Statement
hi def link helpHeader		PreProc
hi def link helpSectionDelim	PreProc
hi def link helpVim		Identifier
hi def link helpCommand		Comment
hi def link helpExample		Special
hi def link helpOption		Type
hi def link helpSpecial		Special
hi def link helpNote		SpecialChar
hi def link helpWarning		Todo
hi def link helpDeprecated	Todo

hi def link helpComment		Comment
hi def link helpConstant	Constant
hi def link helpString		String
hi def link helpCharacter	Character
hi def link helpNumber		Number
hi def link helpBoolean		Boolean
hi def link helpFloat		Float
hi def link helpIdentifier	Identifier
hi def link helpFunction	Function
hi def link helpStatement	Statement
hi def link helpConditional	Conditional
hi def link helpRepeat		Repeat
hi def link helpLabel		Label
hi def link helpOperator	Operator
hi def link helpKeyword		Keyword
hi def link helpException	Exception
hi def link helpPreProc		PreProc
hi def link helpInclude		Include
hi def link helpDefine		Define
hi def link helpMacro		Macro
hi def link helpPreCondit	PreCondit
hi def link helpType		Type
hi def link helpStorageClass	StorageClass
hi def link helpStructure	Structure
hi def link helpTypedef		Typedef
hi def link helpSpecialChar	SpecialChar
hi def link helpTag		Tag
hi def link helpDelimiter	Delimiter
hi def link helpSpecialComment	SpecialComment
hi def link helpDebug		Debug
hi def link helpUnderlined	Underlined
hi def link helpError		Error
hi def link helpTodo		Todo
hi def link helpURL		String
hi def link helpItalic		Statement

" vim: ts=8 sw=2 noet
