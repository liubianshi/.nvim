if vim.fn.has("conceal") == 1 then
    vim.b.conceallevel = 1
end

vim.keymap.set(
    "n",
    "<localleader>pi",
    '<cmd>call utils#OrgModeClipBoardImage()<cr>',
    {
        desc = "Insert Image from Clipboard",
        silent = true,
        noremap = true,
        buffer = 0,
    }
)

vim.keymap.set(
    {"v"},
    "<localleader>l",
    '"0d<cmd>call utils#RoamInsertNode(@0, "split")<cr><c-w>J<cmd>res 8<cr>',
    {
        desc = "Insert Node",
        silent = true,
        noremap = true,
        buffer = 0,
    }
)

vim.keymap.set(
    {'n', 'v'},
    "<enter>",
    '<cmd>call utils#RoamOpenNode("split")<cr><c-w>J<cmd>res 8<cr>',
    {
        desc = "Open Roam Node under Cursor",
        silent = true,
        noremap = true,
        buffer = 0,
    }
)

vim.cmd[[setlocal foldlevel=99]]

