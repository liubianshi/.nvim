""" Configuration
let g:translator_target_lang = 'zh'
let g:translator_source_lang = 'auto'
let g:translator_default_engines = [ 'sdcv', 'trans', 'youdao' ]
let g:translator_proxy_url= ''
let g:translator_history_enable = v:true
let g:translator_window_type = 'popup'

" Echo translation in the cmdline
nmap <silent> <left>t <Plug>Translate
vmap <silent> <left>t <Plug>TranslateV
" Display translation in a window
nmap <silent> <left>w <Plug>TranslateW
vmap <silent> <left>w <Plug>TranslateWV
" Replace the text with translation
nmap <silent> <left>r <Plug>TranslateR
vmap <silent> <left>r <Plug>TranslateRV
" Translate the text in clipboard
nmap <silent> <left>x <Plug>TranslateX


