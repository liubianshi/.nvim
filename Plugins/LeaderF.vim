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
                        \ 'font': "DejaVu Sans Mono Nerd Font" }
let g:Lf_PreviewResult = {'File': 1, 'Buffer': 1,'Mru': 1, 'BufTag': 0 }
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
