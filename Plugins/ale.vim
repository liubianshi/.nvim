let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
" 显示Linter名称,出错或警告等相关信息
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" 文件内容发生变化时不进行检查
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_insert_leave = 0
"使用clang对c和c++进行语法检查，对python使用pylint进行语法检查
let g:ale_linters = {
            \   'sh': ['shellcheck'],
            \   'c': ['clang'],
            \}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'markdown': ['prettier', 'eslint'],
            \   'pandoc':   ['prettier', 'eslint'],
            \   'r': ['styler'],
            \ }
