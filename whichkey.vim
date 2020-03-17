" 快捷键查询
call which_key#register('<Space>', "g:which_key_map")
call which_key#register(';', "g:which_key_local")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ';'<CR>
nnoremap <silent> s :<c-u>WhichKey  's'<CR>
vnoremap <silent> s :<c-u>WhichKeyVisual 's'<CR>

let g:which_key_map = {}
let g:which_key_map.f = {
      \ 'name' : '+FzfCommand',
      \ 'f' : 'Files'    ,
      \ 'b' : 'Open buffers',
      \ 'c' : 'Color schemes',
      \ 'a' : 'ag search result',
      \ 'h' : 'v:oldfiles and open buffers',
      \ ':' : 'Command history',
      \ '/' : 'Search history',
      \ 's' : 'Snippets(UltiSnips)',
      \ 'm' : 'Commands',
      \ 'l' : 'Lines in the current buffer',
      \ 'L' : 'Lines in loaded buffers',
      \ 't' : 'Tags in the current buffer',
      \ 'T' : 'Tags in the project',
      \ }
let g:which_key_map.t = { 'name' : '+tabHandle' }
let g:which_key_map.b = { 'name' : '+buffer' }
let g:which_key_map.c = { 'name' : '+NerdCommander' }
let g:which_key_map.e = { 'name' : '+EditFile' }
let g:which_key_map.r = { 'name' : '+Rmarkdown' }
let g:which_key_map.l = { 'name' : '+LfList' }

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

