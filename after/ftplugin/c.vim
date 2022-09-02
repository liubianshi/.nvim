nnoremap <buffer><silent> <localleader>D :<c-u>AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"<cr>
nnoremap <buffer><silent> <localleader>L :<c-u>AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"<cr>
