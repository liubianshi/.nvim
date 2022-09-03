local vkey = vim.api.nvim_set_keymap
local vimcmd = ":lua require('focus')"
local mapopts = { silent = true}

require("focus").setup({
    width = 86,
    minwidth = 15,
    bufnew = false,
    autoresize = false,
    excluded_buftypes = {"help", "terminal", "nofile", "promp", "popup"},
    excluded_filetypes = {"rbrowser", "floaterm", "rdoc", "fzf", "voomtree"},
    compatible_filetrees = {"nerdtree"},
    colorcolumn = {enable = TRUE, width = 100},
    signcolumn = false,
})

-- keymap --------------------------------------------------------------- {{{1
vkey("n", "<Leader>wh", vimcmd .. ".split_command('h')<cr>", mapopts)
vkey("n", "<Leader>wl", vimcmd .. ".split_command('l')<cr>", mapopts)
vkey("n", "<Leader>wk", vimcmd .. ".split_command('k')<cr>", mapopts)
vkey("n", "<Leader>wj", vimcmd .. ".split_command('j')<cr>", mapopts)
vkey("n", "<leader>we", vimcmd .. ".focus_enable()<cr>",     mapopts)
vkey("n", "<leader>wd", vimcmd .. ".focus_disable()<cr>",    mapopts)
vkey("n", "<leader>wf", vimcmd .. ".focus_toggle()<cr>",     mapopts)
vkey("n", "<leader>wm", vimcmd .. ".focus_maximise()<cr>",   mapopts)
vkey("n", "<leader>we", vimcmd .. ".focus_equalise()<cr>",   mapopts)
vkey("n", "<leader>ws", vimcmd .. ".resize()<cr>",           mapopts)
vkey("n", "<leader>ww", ":FocusSplitNicely<cr>",             mapopts)
