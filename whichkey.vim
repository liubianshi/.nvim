" 快捷键查询
let g:which_key_display_names = { ' ': 'SPC', '<C-H>': 'BS', '<C-I>': 'TAB', '<TAB>': 'TAB', }

call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
let g:which_key_map = {}

let g:which_key_map.t = { 'name' : '+translate' }
let g:which_key_map.b = { 'name' : '+buffer' }
let g:which_key_map.c = { 'name' : '+NerdCommander' }
let g:which_key_map.e = { 'name' : '+EditFile' }
let g:which_key_map.r = { 'name' : '+Rmarkdown' }
let g:which_key_map.l = { 'name' : '+LfList' }
let g:which_key_map.w = { 'name' : '+Wiki' }
let g:which_key_map.F = { 'name' : '+Format' }


call which_key#register(';', "g:which_key_local")
nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ';'<CR>
let g:which_key_local = {}
let g:which_key_local.a = { 'name' : '+R_File' }
let g:which_key_local.b = { 'name' : '+R_Block' }
let g:which_key_local.c = { 'name' : '+R_Chunk' }
let g:which_key_local.f = { 'name' : '+R_Function' }
let g:which_key_local.s = { 'name' : '+R_Selection_Sweave' }
let g:which_key_local.p = { 'name' : '+R_Paragraph' }
let g:which_key_local.r = { 'name' : '+R_Command' }
let g:which_key_local.v = { 'name' : '+R_View' }
let g:which_key_local.t = { 'name' : '+R_TabOutput' }
let g:which_key_local.k = { 'name' : '+R_Knit' }
let g:which_key_local.o = { 'name' : '+R_Open' }
let g:which_key_local.g = { 'name' : '+R_Goto' }
let g:which_key_local.x = { 'name' : '+R_Comment' }

call which_key#register('<tab>', "g:which_key_tab")
nnoremap <silent> <tab> :<c-u>execute "WhichKey '\<tab\>'"<CR>
vnoremap <silent> <tab> :<c-u>execute "WhichKey '\<tab\>'"<CR>
let g:which_key_tab = {}
let g:which_key_tab.f = { 'name' : '+Foloder_Makrder' }
let g:which_key_tab.w = { 'name' : '+Vim_Wiki' }

call which_key#register('<F11>', "g:which_key_vm")
nnoremap <silent> <F9> :<c-u>execute "WhichKey '\<F9\>'"<CR>
vnoremap <silent> <F9> :<c-u>execute "WhichKey '\<F9\>'"<CR>
let g:which_key_vm = {}
let g:which_key_vm.g = { 'name' : '+Visual-Mulit-Go' }

nnoremap <silent> s :<c-u>WhichKey  's'<CR>
vnoremap <silent> s :<c-u>WhichKeyVisual 's'<CR>
nnoremap <silent> ] :<c-u>WhichKey  ']'<CR>
vnoremap <silent> ] :<c-u>WhichKeyVisual ']'<CR>
nnoremap <silent> [ :<c-u>WhichKey  '['<CR>
vnoremap <silent> [ :<c-u>WhichKeyVisual '['<CR>

"nnoremap <silent> g :<c-u>WhichKey 'g'<CR>
"vnoremap <silent> g :<c-u>WhichKeyVisual 'g'<CR>

