" 快捷键查询
let g:which_key_display_names = { ' ': 'SPC', '<C-H>': 'BS', '<C-I>': 'TAB', '<TAB>': 'TAB', }

call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
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

nnoremap <silent> s :<c-u>WhichKey  's'<CR>
vnoremap <silent> s :<c-u>WhichKeyVisual 's'<CR>


"nnoremap <silent> z :<c-u>WhichKey  'z'<CR>
"call which_key#register('z', "g:which_key_fold")
"let g:which_key_fold = {}
"let g:which_key_fold.a = {'za': 'Toggle one fold'}
"let g:which_key_fold.A = {'zA': 'Toggle all folds'}
"let g:which_key_fold.c = {'zc': 'Close one fold'}
"let g:which_key_fold.C = {'zC': 'Close all folds'}
"let g:which_key_fold.d = {'zd': 'Delete one fold'}
"let g:which_key_fold.D = {'zD': 'Delete folds recursively at the cursor'}
"let g:which_key_fold.f = {'zf': 'Create a folder'}
"let g:which_key_fold.F = {'zF': 'Create a folder for [count] lines'}
"let g:which_key_fold.j = {'zj': 'Move downwords to the end of the previous fold'}
"let g:which_key_fold.k = {'zk': 'Move upwords to the end of the previous fold'}
"let g:which_key_fold.r = {'zr': 'Reduce'}
"let g:which_key_fold.R = {'zR': 'Open all folds'}

"nnoremap <silent> <Tab> :<c-u>WhichKey  'TAB'<CR>
"call which_key#register('TAB', "g:which_key_tab")
"let g:which_key_tab = {}
"let g:which_key_tab.n = {'name': ':tabnew'}
"let g:which_key_tab.j = {'name': ':tabprevious'}
"let g:which_key_tab.k = {'name': ':tabnext'}
"let g:which_key_tab.x = {'name': ':tabclose'}
"let g:which_key_tab.p = {'name': '"0p'}
"let g:which_key_tab.TAB = {'name': 'V>'}
