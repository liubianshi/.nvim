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
vimkey('<leader>tt', 'Tab: New', '<cmd>tabnew<cr>')
vimkey('<leader>tx', 'Tab: Close', '<cmd>tabclose<cr>')
vimkey('<leader>tn', 'Tab: Next', '<cmd>tabnext<cr>')
vimkey('<leader>tp', 'Tab: Previous', '<cmd>tabprevious<cr>')
vimkey('<leader>tP', 'Tab: First', '<cmd>tabfirst<cr>')
vimkey('<leader>tN', 'Tab: Last', '<cmd>tablast<cr>')

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
vimkey('<localleader>0',  "Special Symbol: zero-width spaces", '<C-v>u200b',                         {mode = 'i'})
vimkey('<localleader>)',  "Chinese Punctuation: （I）",        '<C-v>uFF08 <C-v>uFF09<C-o>F <c-o>x', {mode = 'i'})
vimkey('<localleader>]',  "Chinese Punctuation: 「I」",        '<C-v>u300c <C-v>u300d<C-o>F <c-o>x', {mode = 'i'})
vimkey('<localleader>}',  "Chinese Punctuation: “I”",          '<C-v>u201C <C-v>u201D<C-o>F <c-o>x', {mode = 'i'})
vimkey('<localleader>,',  "Chinese Punctuation: ，",           '<C-v>uFF0C',                         {mode = 'i'})
vimkey('<localleader>.',  "Chinese Punctuation: 。",           '<C-v>u3002',                         {mode = 'i'})
vimkey('<localleader>\\', "Chinese Punctuation: 、",           '<C-v>u3001',                         {mode = 'i'})
vimkey('<localleader>:',  "Chinese Punctuation: ：",           '<C-v>uff1a',                         {mode = 'i'})
vimkey('<localleader>_',  "Chinese Punctuation: ——",           '<C-v>u2014<c-v>u2014',               {mode = 'i'})
vimkey('<localleader>^',  "Chinese Punctuation: ……",           '<C-v>u2026<c-v>u2026',               {mode = 'i'})
vimkey('<localleader>?',  "Special Punctuation: ？",           '<C-v>uff1f',                         {mode = 'i'})
vimkey('<localleader>-',  "Special Punctuation: —",            '<C-v>u2014',                         {mode = 'i'})





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
vimkey('<leader>ev', "Neovim Plugin List",  '<cmd>edit ~/.config/nvim/lua/plug.lua<cr>')
vimkey('<leader>ek', "Neovim Keymap",       '<cmd>edit ~/.config/nvim/lua/keymap.lua<cr>')
vimkey('<leader>eo', "Neovim Options",      '<cmd>edit ~/.config/nvim/vim/option.vim<cr>')
vimkey('<leader>er', "R Profile",           '<cmd>edit ~/.Rprofile<cr>')
vimkey('<leader>es', "Stata profile",       '<cmd>edit ~/.config/stata/profile.do<cr>')
vimkey('<leader>ez', "Zshrc",               '<cmd>edit ~/.zshrc<cr>')
vimkey('<leader>eZ', "User Zshrc",          '<cmd>edit ~/useScript/usr.zshrc<cr>')
vimkey('<leader>ea', "Alias",               '<cmd>edit ~/useScript/alias<cr>')
vimkey('<leader>eu', "Snippets",            '<cmd>edit ~/.config/nvim/UltiSnips<cr>')
vimkey('<leader>ed', "Flypy Dictionary",    '<cmd>edit +$ ~/Repositories/ssnhd-rime/配置文件/flypy_top.txt<cr>')
vimkey('<leader>et', "Open Plan to Do", function()
    vim.cmd([[
        edit +$ ~/Documents/Writing/plantodo.norg
        normal zt<cr>
    ]])
end)
vimkey('<leader>eT', "Open Plan to Do", function()
    vim.cmd([[
        edit +$ ~/Documents/Writing/todo.norg
        normal zt<cr>
    ]])
end)

--- notifications ------------------------------------------------------- {{{1
vimkey('<leader>nn', "Display Notifications", '<cmd>Notifications<cr>')
vimkey('<leader>nN', "Redir Notifications",   '<cmd>Redir Notifications<cr>')
vimkey('<leader>nm', "Display messages",      '<cmd>messages<cr>')
vimkey('<leader>nM', "Redir messages",        '<cmd>Redir messages<cr>')

-- format --------------------------------------------------------------- {{{1
-- vimkey('gQ', "gq after Pangu", 'vip<cmd>Pangu<cr>gqip')
-- vimkey('gQ', "gq after Pangu", '<cmd>Pangu<cr>vgvgq', { mode = 'v'})
vim.cmd[[
    nnoremap gQ vip:Pangu<cr>gqip
    vnoremap gQ :Pangu<cr>vgvgq
]]


