syntax match TableLine                 /\v^[+|].+[+|]$/                contains=SymbolC,routNormal,routFloat,routNegFloat,routNumber,routNegNum,routDate,routInteger,routConst,routTrue,routFalse,routInf,routString
syntax match TableHorizontalLine      /\v^[+|]:?[ -=+:]+[+|]$/         contains=SymbolV2,SymbolV0,SymbolV6,SymbolR,SymbolC 
syntax match TableHorizontalLineStart /\v^([^+|].*)?\n\+:?[-=][-=+:]+[+]$/ contains=SymbolV1,SymbolV8,SymbolV7,SymbolR
syntax match TableHorizontalLineEnd   /\v^\+:?[-=][-=+:]+[+]\n[+|]@!/  contains=SymbolV3,SymbolV4,SymbolV5,SymbolR

" 1 8 7
" 2 0 6
" 3 4 5
syntax match SymbolC   /[|]/    contained containedin=TableLine,TableHorizontalLine conceal cchar=│
syntax match SymbolR  /\v[-=:]/ contained containedin=TableHorizontalLine conceal cchar=─

syntax match SymbolV0 /\v\+/         contained containedin=TableHorizontalLine conceal cchar=┼
syntax match SymbolV2 /\v(^| )@<=\+/ contained containedin=TableHorizontalLine conceal cchar=├
syntax match SymbolV6 /\v\+($| )@=/  contained containedin=TableHorizontalLine conceal cchar=┤

syntax match SymbolV8 /\v\+/  contained containedin=TableHorizontalLineStart conceal cchar=┬
syntax match SymbolV1 /\v^\+/ contained containedin=TableHorizontalLineStart conceal cchar=┌
syntax match SymbolV7 /\v\+$/ contained containedin=TableHorizontalLineStart conceal cchar=┐

syntax match SymbolV4 /\v\+/  contained containedin=TableHorizontalLineEnd conceal cchar=┴
syntax match SymbolV3 /\v^\+/ contained containedin=TableHorizontalLineEnd conceal cchar=└
syntax match SymbolV5 /\v\+$/ contained containedin=TableHorizontalLineEnd conceal cchar=┘

