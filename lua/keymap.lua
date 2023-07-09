local vimkey = function(key, desc, cmd, opts)
    opts = vim.tbl_extend('keep', opts or {}, {
        mode = 'n',
        desc = desc,
        silent = true,
        noremap = true,
    })

    local mode = opts.mode
    opts.mode =nil
    vim.keymap.set(mode, key, cmd, opts)
end

--- run ------------------------------------------------------------------ {{{1
vimkey('<leader>o:', 'Open Terminal', '<cmd>ToggleTerm<cr>')
vimkey('<leader>ob', 'Toggle Status Line', '<cmd>call utils#Status()<cr>')
vimkey('<leader>od', 'Source VIMRC', '<cmd>source $MYVIMRC<cr>')
vimkey('<leader>op', 'Change to Directory File Located ', function()
    vim.cmd("cd " .. vim.fn.expand('%:p:h'))
end)
vimkey('<leader>oz', 'Toggle Zen Mode (diy)', '<cmd>call utils#ToggleZenMode()<cr>')

--- buffer --------------------------------------------------------------- {{{1
vimkey('<leader>bd', 'Delete Buffer', '<cmd>Bclose<cr>')
vimkey('<leader>bp', 'Previous Buffer', '<cmd>bp<cr>')
vimkey('<leader>bn', 'Next Buffer', '<cmd>bn<cr>')
vimkey('<leader>bq', 'Quit Buffer', '<cmd>q<cr>')
vimkey('<leader>bQ', 'Quit Buffer (force)', '<cmd>q!<cr>')

--- tab ----------------------------------------------------------------- {{{1
vimkey('<tab><tab>', 'Tab: New', '<cmd>tabnew<cr>')
vimkey('<tab>x', 'Tab: Close', '<cmd>tabclose<cr>')
vimkey('<tab>n', 'Tab: Next', '<cmd>tabnext<cr>')
vimkey('<tab>p', 'Tab: Previous', '<cmd>tabprevious<cr>')
vimkey('<tab>P', 'Tab: First', '<cmd>tabfirst<cr>')
vimkey('<tab>N', 'Tab: Last', '<cmd>tablast<cr>')

--- translate ----------------------------------------------------------- {{{1
vimkey('L', 'Translate', 'utils#Trans2clip()', {
    mode = {'n', 'x'},
    expr = true,
})

--- search -------------------------------------------------------------- {{{1
vimkey('<leader>og', 'Display Highlight Group', function()
    vim.fn['utils#Extract_hl_group_link']()
end)

--- insert special symbol ----------------------------------------------- {{{1
vimkey('<localleader>)',  "Chinese Punctuation: Paired parentheses",        '<C-v>uFF08 <C-v>uFF09<C-o>F <c-o>x', {mode = 'i'})
vimkey('<localleader>]',  "Chinese Punctuation: Paired right angle quotes", '<C-v>u300c <C-v>u300d<C-o>F <c-o>x', {mode = 'i'})
vimkey('<localleader>}',  "Chinese Punctuation: Paired double quotes",      '<C-v>u201C <C-v>u201D<C-o>F <c-o>x', {mode = 'i'})
vimkey('<localleader>,',  "Chinese Punctuation: Comma",                     '<C-v>uFF0C',                         {mode = 'i'})
vimkey('<localleader>.',  "Chinese Punctuation: Period",                    '<C-v>u3002',                         {mode = 'i'})
vimkey('<localleader>\\', "Chinese Punctuation: Dun Hao",                   '<C-v>u3001',                         {mode = 'i'})
vimkey('<localleader>0',  "Special Symbol: zero-width spaces",              '<C-v>u200b',                         {mode = 'i'})

--- window manager ------------------------------------------------------ {{{1
vimkey('w0',    'Window: Suitable Width',            '<cmd>88wincmd |<cr>')
vimkey('wt',    'Move Current Window to a New Tab',  '<cmd>wincmd T<cr>')
vimkey('wo',    'Make current window the only one',  '<cmd>only<cr>')
vimkey('wv',    'Vertical Split Current Buffer',     '<c-w>v')
vimkey('ws',    'Split Current Buffer',              '<c-w>s')
vimkey('ww',    'Move cursor to window below/right', '<c-w>w')
vimkey('wW',    'Move cursor to window above/left',  '<c-w>W')
vimkey('wh',    'Move cursor to window left',        '<c-w>h')
vimkey('wj',    'Move cursor to window below',       '<c-w>j')
vimkey('wk',    'Move cursor to window above',       '<c-w>k')
vimkey('wl',    'Move cursor to window right',       '<c-w>l')
vimkey('wH',    'Move current window left',          '<c-w>H')
vimkey('wJ',    'Move current window below',         '<c-w>J')
vimkey('wK',    'Move current window above',         '<c-w>K')
vimkey('wL',    'Move current window right',         '<c-w>L')
vimkey('wx',    'Exchange window',                   '<c-w>x')
vimkey('wq',    'Quit the current window',           '<c-w>q')
vimkey('w=',    'Make Window size equally',          '<c-w>=')
vimkey('<c-j>', 'resize -2',                         '<cmd>resize -2<cr>')
vimkey('<c-k>', 'resize +2',                         '<cmd>resize +2<cr>', { remap = true})
vimkey('<c-h>', 'vertical resize -2',                '<cmd>vertical resize -2<cr>')
vimkey('<c-l>', 'vertical resize +2',                '<cmd>vertical resize +2<cr>')

--- edit special files -------------------------------------------------- {{{1
vimkey('<leader>ev', "Neovim Plugin List", '<cmd>edit ~/.config/nvim/vim/plug.vim<cr>')
vimkey('<leader>ek', "Neovim Keymap",      '<cmd>edit ~/.config/nvim/vim/keymap.vim<cr>')
vimkey('<leader>eo', "Neovim Options",     '<cmd>edit ~/.config/nvim/vim/option.vim<cr>')
vimkey('<leader>er', "R Profile",          '<cmd>edit ~/.Rprofile<cr>')
vimkey('<leader>es', "Stata profile",      '<cmd>edit ~/.config/stata/profile.do<cr>')
vimkey('<leader>ez', "Zshrc",              '<cmd>edit ~/.zshrc<cr>')
vimkey('<leader>eZ', "User Zshrc",         '<cmd>edit ~/useScript/usr.zshrc<cr>')
vimkey('<leader>ea', "Alias",              '<cmd>edit ~/useScript/alias<cr>')
vimkey('<leader>eu', "Snippets",           '<cmd>edit ~/.config/nvim/UltiSnips<cr>')
vimkey('<leader>ed', "Flypy Dictionary",   '<cmd>edit ~/Repositories/ssnhd-rime/配置文件/flypy_top.txt<cr> | exec "normal! G"')







