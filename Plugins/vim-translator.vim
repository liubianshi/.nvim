""" Configuration
let g:translator_target_lang = 'zh'
let g:tranlator_window_max_height = 13
let g:translator_source_lang = 'auto'
let g:translator_default_engines = [ 'sdcv' ]
let g:translator_proxy_url = ''
let g:translator_history_enable = v:true
let g:translator_window_type = 'popup'
let g:translator_history_enable = v:true

hi def link Translator                  Normal
hi def link TranslatorBorder            TelescopeBorder


nmap  <silent> <leader>k <Plug>TranslateW
nmap  <silent> X <Plug>TranslateW
vmap  <silent> <leader>k <Plug>TranslateWV

