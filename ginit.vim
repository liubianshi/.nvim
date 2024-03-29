set mouse=a

if exists("g:neovide")
    " use light colorscheme during daytime
    let current_time = strftime("%H:%M")
    if current_time >= "07:00" && current_time <= "17:00"
        call setenv("NVIM_BACKGROUND", "light")
    endif
    if has('mac') 
        let &guifont =  "Maple Mono NF,LXGW WenKai Mono:h16:w-1.5"
        let &linespace = 18
        let g:neovide_padding_top = 0
        let g:neovide_padding_bottom = 0
        let g:neovide_padding_right = 0
        let g:neovide_padding_left = 0
    else
        let &linespace = 13
        let g:neovide_padding_top = 0
        let g:neovide_padding_bottom = 0
        let g:neovide_padding_right = 0
        let g:neovide_padding_left = 0
    endif
    let g:neovide_input_macos_alt_is_meta = v:true
    let g:neovide_underline_automatic_scaling = v:true
    let g:neovide_cursor_animate_in_insert_mode = v:false
    let g:neovide_floating_blur_amount_x = 0
    let g:neovide_floating_blur_amount_y = 0
    let g:neovide_transparency = 0.98
    let g:neovide_border = [['', 'NormalFloat'], ['', 'NormalFloat']]
    let g:neovide_confirm_quit = v:true
    let g:neovide_cursor_vfx_mode = "ripple"
    let g:neovide_scale_factor=1.0
    " 动态调整 Neovide 的字体大小 / Dynamically resize Neovide's fonts
    function! ChangeScaleFactor(delta)
        let g:neovide_scale_factor = g:neovide_scale_factor * a:delta
    endfunction
    nnoremap <expr><D-=> ChangeScaleFactor(1.15)
    nnoremap <expr><D--> ChangeScaleFactor(1/1.15)
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
