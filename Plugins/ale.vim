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

" 文件类型别名
let g:ale_linter_aliases = {
            \   'pandoc': ['markdown'],
            \   'rmd': ['markdown', 'r'],
            \}
"使用clang对c和c++进行语法检查，对python使用pylint进行语法检查
let g:ale_linters = {
            \   'sh': ['shellcheck'],
            \   'c': ['clang'],
            \   'r': ['lintr'],
            \   'markdown': ['languagetool'],
            \   'perl': [ 'perltidy' ],
            \}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'markdown': ['languagetool'],
            \   'r': ['styler'],
            \   'perl': [ 'perltidy' ],
            \ }
let g:ale_r_lintr_options = "with_defaults(". join([
            \   "line_length_linter = line_length_linter(120)",
            \   "object_name_linter = NULL",
            \   "single_quotes_linter = NULL",
            \   "trailing_blank_lines_lintr = NULL",
            \   "object_name_linter = NULL",
            \   "camel_case_linter = NULL"
            \   ], ", ") . ")"
let g:ale_r_styler_options = "styler::tidyverse_style(strict = FALSE, indent_by = 4)"
let g:ale_languagetool_options = "--autoDetect --languagemodel ~/Downloads"

nnoremap <silent><buffer> <localleader>ae :<c-u>ALEEnableBuffer<cr>
nnoremap <silent><buffer> <localleader>ad :<c-u>ALEDisableBuffer<cr>
nnoremap <silent><buffer> <localleader>at :<c-u>ALEToggleBuffer<cr>
nnoremap <silent><buffer> <localleader>al :<c-u>ALELint<cr>
nnoremap <silent><buffer> <localleader>as :<c-u>ALELintStop<cr>
nnoremap <silent><buffer> [a         :<c-u>ALEPrevious<cr>
nnoremap <silent><buffer> ]a         :<c-u>ALENext<cr>

