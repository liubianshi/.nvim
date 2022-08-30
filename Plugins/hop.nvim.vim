lua <<EOF
vim.cmd[[ hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]
vim.cmd[[ hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]
vim.cmd[[ hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]

local opts = { silent = true, noremap = true }
local kset = vim.keymap.set
local hintA = require('hop.hint').HintDirection.AFTER_CURSOR
local hintB = require('hop.hint').HintDirection.BEFORE_CURSOR
local hop = require('hop')
local hint1 = hop.hint_char1
local hint2 = hop.hint_char2
local hintl = hop.hint_lines_skip_whitespace
local hintv = hop.hint_vertical
local hintw = hop.hint_words
local hintp = hop.hint_patterns

hop.setup({
    case_insensitive = true,
    jump_on_sole_occurrence = true,
    char2_fallback_key = '<CR>',
    quit_key='<Esc>',
})

kset('n', 'f',  function() return hint1({direction = hintA, current_line_only = true}) end, opts)
kset('n', 'F',  function() return hint1({direction = hintB, current_line_only = true}) end, opts)
kset('n', 't',  function() return hint1({direction = hintA, current_line_only = true, hint_offset = -1}) end, opts)
kset('n', 'T',  function() return hint1({direction = hintB, current_line_only = true, hint_offset = 1}) end, opts)
kset('n', 'sj', function() return hintl({direction = hintA}) end, opts)
kset('n', 'sk', function() return hintl({direction = hintB}) end, opts)
kset('n', 'sJ', function() return hintv({direction = hintA}) end, opts)
kset('n', 'sK', function() return hintv({direction = hintB}) end, opts)
kset('n', 'sw', function() return hintw({current_line_only = true}) end, opts)
kset('n', 'ss', function() return hint2({direction = hintA}) end, opts)
kset('n', 'sS', function() return hint2({direction = hintB}) end, opts)
kset('n', 'sp', function() return hintp({direction = hintA}) end, opts)
kset('n', 'sP', function() return hintp({direction = hintB}) end, opts)
EOF












" vim: set nowrap:
