vim.cmd[[
    if has("conceal")
        setlocal conceallevel=2
        setlocal concealcursor=nc
    endif
    setlocal foldlevel=99
]]

local delete_empty_roam_file = function()
    local path = vim.fn.expand('%:p')
    vim.cmd[[
        Bclose
        quit
    ]]
    vim.fn.system("org-mode-roam-node -d " .. path)
    if vim.api.nvim_get_vvar("shell_error") == 0 then
        vim.notify(path .. " deleted")
    end
end


-- Keymap =============================================================== {{{1
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
    '<cmd>call utils#RoamOpenNode("split")<cr>',
    {
        desc = "Open Roam Node under Cursor",
        silent = true,
        noremap = true,
        buffer = 0,
    }
)

vim.keymap.set(
    "n", "<localleader>D", delete_empty_roam_file, {
        silent = true, noremap = true, buffer = 0,
        desc = "Delete Empty Roam Node",
    }
)

vim.keymap.set(
    "n", "<localleader>f", "<cmd>RoamNodeFind<cr>", {
        desc = "Find Org Roam Node",
        silent = true,
        noremap = true,
        buffer = 0,
    }
)

vim.cmd[[
xnoremap <silent><buffer> ib :<C-U>call text_obj#OrgCodeBlock("i")<CR>
onoremap <silent><buffer> ib :<C-U>call text_obj#OrgCodeBlock("i")<CR>
xnoremap <silent><buffer> ab :<C-U>call text_obj#OrgCodeBlock("a")<CR>
onoremap <silent><buffer> ab :<C-U>call text_obj#OrgCodeBlock("a")<CR>
]]


