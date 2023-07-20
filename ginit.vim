set mouse=a

" neovim-qt
if exists(':GuiFont')
    GuiFont! MonoSpace:h12
    GuiAdaptiveFont 1
    GuiLinespace 12
    GuiPopupmenu 1
endif

" neovide
if exists("g:neovide")
    if has('mac') 
        let &guifont =  "LXGW WenKai Mono,FiraCode Nerd Font Mono:h18"
        let &linespace = 18
    else
        let &guifont =  "LXGW WenKai Mono,FiraCode Nerd Font Mono:h12"
        let &linespace = 12
    endif
    let g:neovide_underline_automatic_scaling = v:true
" fvim
elseif exists("g:fvim_loaded")
    if has('mac')
        let &guifont = "FiraCode Nerd Font Mono:h18"
    else
        let &guifont = "FiraCode Nerd Font Mono:h20"
    end
    FVimFontNoBuiltinSymbols v:true
    FVimFontLineHeight '+10.0'
    FVimFontNormalWeight 300
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
endif
