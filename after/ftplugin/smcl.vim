call Lbs_Load_Plug('stata-vim')

let b:AutoPairs = g:AutoPairs
let b:AutoPairs['`']="'" 
setlocal foldmethod=marker
setlocal foldmarker={,}
