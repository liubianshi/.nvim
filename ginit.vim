set mouse=a

if exists("g:neovide")
    if has('mac') 
        let &guifont =  "LXGW WenKai Mono,FiraCode Nerd Font Mono:h18"
        let &linespace = 18
    else
        let &guifont =  "LXGW WenKai Mono,FiraCode Nerd Font Mono:h11"
        let &linespace = 14
    endif
    let g:neovide_underline_automatic_scaling = v:true
elseif exists("g:fvim_loaded")
    if has('mac')
        let &guifont = "FiraCode Nerd Font Mono:h18"
    else
        let &guifont = "FiraCode Nerd Font Mono:h20"
    endif
    FVimFontNoBuiltinSymbols v:true
    FVimFontLineHeight '+10.0'
    FVimFontNormalWeight 300
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
else
    if has('mac')
        GuiFont! FiraCode\ Nerd\ Font\ Mono:h6
        let &guifontwide = "LXGW WenKai Mono"
        GuiLinespace 5
    else
        GuiFont! MonoSpace:h12
        GuiLinespace 10
    endif
    GuiAdaptiveFont 1
    GuiPopupmenu 0

    if has('linux')
        " linux capsloak keymap througn xmodmap
        inoremap ᅾ  <left>
        inoremap ᅾ  <right>
        inoremap ᅾ  <up>
        inoremap ᅾ  <down>
        tnoremap ᅾ  <left>
        tnoremap ᅾ  <right>
        tnoremap ᅾ  <up>
        tnoremap ᅾ  <down>
        cnoremap ᅾ  <left>
        cnoremap ᅾ  <right>
        cnoremap ᅾ  <up>
        cnoremap ᅾ  <down>
    endif
endif
