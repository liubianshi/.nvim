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

local insert_new_node = function()
    local last_query = require('fzf-lua').config.__resume_data.last_query
    vim.cmd[[normal l]]
    vim.fn['utils#RoamInsertNode'](last_query, "split")
    vim.cmd[[wincmd J]]
    vim.cmd[[res 8]]
end

local fzf_selection_action = function(cmd)
    cmd = cmd or "cite"
    if cmd == "cite" then
        return(function(selected, _)
            if not selected[1] then
                return insert_new_node()
            end
            if not vim.fn['utils#IsPrintable_CharUnderCursor']() then vim.cmd("normal! a ") end
            local buf     = vim.fn.bufnr()
            local row_col = vim.api.nvim_win_get_cursor(0)
            local row     = row_col[1] - 1
            local col     = row_col[2] + 1
            local cite    = vim.fn.system("roam_id_title --cite  -n '" .. selected[1] .. "'")
            vim.api.nvim_buf_set_text(buf, row, col, row, col, {cite})
            vim.cmd("normal! 3f]")
        end)
    else
        return(function(selected, _)
            local file = vim.fn.system("roam_id_title  -n '" .. selected[1] .. "'  | cut -f1 | xargs -I {} roam_id_title -i {}")
            vim.cmd(cmd .. " " .. file)
        end)
    end
end

local fzflua_ok,fzf = pcall(require, "fzf-lua")
if fzflua_ok then
    vim.api.nvim_create_user_command('RoamNodeFind', function(_)
        fzf.fzf_exec(
            "roam_id_title",
            {
                preview = 'cd "' .. vim.env.HOME .. '/Documents/Writing/roam/"; scope {-1}',
                fzf_opts = { ['--no-multi'] = '' },
                actions = {
                    ['default'] = fzf_selection_action("cite"),
                    ['ctrl-l'] = function(_, _) insert_new_node() end,
                    ['ctrl-e'] = fzf_selection_action("edit"),
                }
            }
        )

    end, { nargs = 0, desc = "FzfLua: Find Org Roam Node"})
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


