function! Fcitx_status_en_p()
    let line = getline('.')
    let column = col('.')
    let cursor_char = line[column - 1]
    let cursor_before_char = line[max([0, column - 4]):(column - 2)]
    "echom cursor_before_char . "|" . cursor_char

    if " " == " "
        echo ">1"
        return(1)
    endif
    return(0)
endfunction

function! Lbs_Fcitx_Auto()
    echo Fcitx_status_en_p()
    echo "lorded"
    if Fcitx_stata_en_p() == 1
        call Fcitx2en()
        let g:LBS_fcitx_status = 0
        echo "2en"
    else
        call Fcitx2zh()
        let g:LBS_fcitx_status = 1
        echo "2cn"
    endif
    return("")
endfunction

inoremap <expr> <space><space> Lbs_Fcitx_Auto()
inoremap <expr> <space>j Fcitx_status_en_p()

"代567u11111111       11 jq1 1
" 345678910121416182022242628

