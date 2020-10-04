" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 1
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:Lf_UseVersionControlTool = 1
let g:Lf_IgnoreCurrentBufferName = 1

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git', '.hg']
let g:LF_Ctags = "ctags"
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
let g:Lf_GtagsSource = 0

let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.50
let g:Lf_ShowRelativePath = 0
let g:Lf_PreviewResult = {'File': 0, 'Buffer': 0,'Function': 1, 'BufTag': 0 }
let g:Lf_WindowPosition = 'bottom'
let g:Lf_PreviewInPopup = 1
let g:Lf_PopupShowStatusline = 1
let g:Lf_PopupPreviewPosition = 'bottom'
let g:Lf_PreviewHorizontalPosition = 'right'
let g:Lf_PopupColorscheme = 'default'
let g:Lf_AutoResize = 1
let g:Lf_PopupWidth = &columns * 3 / 4
let g:Lf_PopupHeight = 0.75



