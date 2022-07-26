lua << EOF
local ops = { silent = true, noremap = false }
local actions = require "fzf-lua.actions"
local fileactions = {
            ['default'] = actions.file_edit,
            ["ctrl-s"]  = actions.file_split,
            ["ctrl-v"]  = actions.file_vsplit,
            ["ctrl-t"]  = actions.file_tabedit,
            ["alt-q"]   = actions.file_sel_to_qf,
}
require('fzf-lua').setup({
  previewers = {
    builtin = {
      extensions = {
        -- neovim terminal only supports `viu` block output
        ["png"] = { "ueberzug" },
        ["jpg"] = { "ueberzug" },
        ["xlsx"] = { "scope" },
        ["xls"] = { "scope" },
        ["csv"] = { "scope" },
        ["dta"] = { "scope" },
        ["Rds"] = { "scope" },
        ["pdf"] = { "scope" },
      },
      -- When using 'ueberzug' we can also control the way images
      -- fill the preview area with ueberzug's image scaler, set to:
      --   false (no scaling), "crop", "distort", "fit_contain",
      --   "contain", "forced_cover", "cover"
      -- For more details see:
      -- https://github.com/seebye/ueberzug
      ueberzug_scaler = "cover",
    }
  },
  fzf_opts  = {
      ['--preview'] = vim.fn.shellescape("printf {1} | sed -E 's/^[^\\s]+\\s//' | xargs scope"),
  }, 
  files = {
      previewer = "builtin",
      prompt    = 'Files❯ ',
      file_icons = true,
  }
})

-- 列出常规 buffer
vim.keymap.set('n', '<leader>i', function()
    require'fzf-lua'.fzf_exec("bibtex-ls ~/Documents/paper_ref.bib",{
        actions = {
            ['default'] = function(selected, opts)
                local r = vim.fn.system("bibtex-cite -prefix='@' -postfix='' -separator='; @'", selected)
                vim.api.nvim_command('normal! i' .. r) 
                vim.fn.feedkeys('a', 'n')
            end,
        }
    })
end, ops)

-- 列出所有 buffers
vim.keymap.set('n', '<leader>bB', function()
    require'fzf-lua'.fzf_exec(function(fzf_cb)
    coroutine.wrap(function()
        local co = coroutine.running()
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
            vim.schedule(function()
                local name = vim.api.nvim_buf_get_name(b)
                name = #name>0 and name or "[No Name]"
                fzf_cb(b..":"..name, function() coroutine.resume(co) end)
        end)
        coroutine.yield()
        end
        fzf_cb()
    end)()
    end)
end, opts)

-- 通过 fasd 跳转文件
vim.keymap.set('n', '<leader>fz', function()
    require'fzf-lua'.fzf_exec("fasd -al",{
        actions = {
            ['default'] = actions.file_edit,
            ["ctrl-s"]      = actions.file_split,
            ["ctrl-v"]      = actions.file_vsplit,
            ["ctrl-t"]      = actions.file_tabedit,
            ["alt-q"]       = actions.file_sel_to_qf,
        }
    })
end, ops)

-- 查看当前文件所在文件夹下的其他文件
vim.keymap.set('n', '<leader>.', function()
    require'fzf-lua'.fzf_exec("fd -H -t f . " .. vim.fn.expand("%:p:h"), {
        actions = fileactions,
    })
end, ops)
EOF

nnoremap <silent> <leader>ff :<C-U>FzfLua files<CR>
nnoremap <silent> <leader>fr :<C-U>FzfLua oldfiles<CR>
nnoremap <silent> <leader>bb :<c-u>FzfLua buffers<cr>

nnoremap <silent> <leader>ts :<c-u>FzfLua tags<cr>

nnoremap <silent> <leader>qs :<c-u>FzfLua quickfix<cr>

nnoremap <silent> <leader>gs :<c-u>FzfLua git_status<cr>
nnoremap <silent> <leader>gc :<c-u>FzfLua git_commits<cr>
nnoremap <silent> <leader>gb :<c-u>FzfLua git_braches<cr>


nnoremap <silent> <leader>ss :<C-U>FzfLua resume<CR>
nnoremap <silent> <leader>sc :<C-U>FzfLua commands<CR>
nnoremap <silent> <leader>s: :<C-U>FzfLua command_history<CR>
nnoremap <silent> <leader>s/ :<C-U>FzfLua search_history<CR>
nnoremap <silent> <leader>sC :<C-U>FzfLua colorschemes<CR>
nnoremap <silent> <leader>sh :<C-U>FzfLua help_tags<CR>
nnoremap <silent> <leader>sl :<C-U>FzfLua lgrep_curbuf<CR>
nnoremap <silent> <leader>sr :<C-U>FzfLua grep<cr>
nnoremap <silent> <leader>sR :<C-U>FzfLua grep_project<cr>
nnoremap <silent> <C-B>      :<C-U>FzfLua grep_cword<CR>
vnoremap <silent> <C-B>      :<C-U>FzfLua grep_visual<CR>


noremap <silent> <leader>st :<C-U>FzfLua btags<CR>
noremap <silent> <leader>sT :<C-U>FzfLua tags<CR>
noremap <silent> <leader>sd :<C-U>FzfLua lsp_document_symbols<CR>
noremap <silent> <leader>sD :<C-U>FzfLua lsp_live_workspace_symbols<CR>

