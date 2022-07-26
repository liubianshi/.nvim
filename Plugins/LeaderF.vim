highlight Lf_hl_rgHighlight guifg=#FFFF00 guibg=NONE ctermfg=yellow ctermbg=NONE
highlight Lf_hl_match gui=bold guifg=Red cterm=bold ctermfg=21
highlight Lf_hl_matchRefine  gui=bold guifg=Magenta cterm=bold ctermfg=201

let g:Lf_ShortcutF = ""
let g:Lf_ShortcutB = ""
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 1
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:Lf_UseVersionControlTool = 1
let g:Lf_IgnoreCurrentBufferName = 1

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git', '.hg']
let g:Lf_Ctags = "ctags"
let g:Lf_CtagsFuncOpts = { 'r': '--kinds-R=-v' }
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_GtagsGutentags    = 0
let g:Lf_Gtagslabel = 'native-pygments'

let g:Lf_ShowRelativePath = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2",
                        \ 'font': "Fira Code Nerd Font Mono" }
let g:Lf_PreviewResult = {'File': 0, 'Buffer': 0, 'Mru': 0, 'BufTag': 0 }
let g:Lf_WindowPosition = 'bottom'
let g:Lf_WindowHeight = 0.30
let g:Lf_PreviewInPopup = 1

"nnoremap <silent> <leader>bb :LeaderfBuffer<cr>
"nnoremap <silent> <leader>bB :LeaderfBufferAll<cr>
"noremap <silent> <leader>sc :<C-U><C-R>=printf("Leaderf command %s", "")<CR><CR>
"noremap <silent> <leader>sC :<C-U><C-R>=printf("Leaderf colorscheme %s", "")<CR><CR>
"noremap <silent> <leader>sh :<C-U><C-R>=printf("Leaderf help %s", "")<CR><CR>
"noremap <silent> <leader>sl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
"noremap <silent> <leader>s: :<C-U><C-R>=printf("Leaderf cmdHistory %s", "")<CR><CR>
"noremap <silent> <leader>s/ :<C-U><C-R>=printf("Leaderf searchHistory %s", "")<CR><CR>
"noremap <silent> <leader>sg :<C-U><C-R>=printf("Leaderf gtags --all %s", "")<CR><CR>
"noremap <silent> <leader>sr :<C-U>Leaderf rg --current-buffer -e 
"noremap <C-B> :<C-U><C-R>=printf("Leaderf rg --current-buffer -e %s ", expand("<cword>"))<CR><CR>
noremap <silent> gf :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
noremap <silent> gF :<C-U><C-R>=printf("Leaderf function --all %s", "")<CR><CR>
noremap <silent> gn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <silent> go :<C-U><C-R>=printf("Leaderf gtags --recall %s", "")<CR><CR>
noremap <silent> gp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
