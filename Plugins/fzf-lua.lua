-- vim: ft=lua fdm=marker:
local fzflua = require('fzf-lua')
local mapopts = { silent = true, noremap = true }
local actions = require "fzf-lua.actions"
local fileactions = {
            ['default'] = actions.file_edit,
            ["ctrl-s"]  = actions.file_split,
            ["ctrl-v"]  = actions.file_vsplit,
            ["ctrl-t"]  = actions.file_tabedit,
            ["alt-q"]   = actions.file_sel_to_qf,
}
local fzfmap = function(key, desc, cmd, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, key, cmd, {
        desc = "FzfLua: " .. desc,
        silent = true,
        noremap = true,
    })
end

-- setup ---------------------------------------------------------------- {{{2
fzflua.setup({
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
    },
    man = {
        cmd ="echo %s | tr -d \'()\'  | xargs -r man | col -bx"
    },
  },
  fzf_opts  = {
      ['--preview'] = vim.fn.shellescape("printf {1} | perl -plE 's!\\A[^\\s\\/A-z]+\\s!!' | xargs scope"),
  },
  files = {
      previewer = "builtin",
      prompt    = 'Files❯ ',
      file_icons = true,
  },
  grep = {
      winopts = {
          -- split = "belowright new",
          height = 0.4,
          width  = 1,
          row = 1,
          col = 0,
          preview = {
              horizontal= 'right:40%',
              layout = 'horizontal',
          },
      }
  },
})

-- integration with project.nvim ---------------------------------------- {{{2
local _previous_cwd
function projects(opts)
    if not opts then opts = {} end
    local project_hist = vim.fn.stdpath("data") .. "/project_nvim/project_history"
    if not vim.loop.fs_stat(project_hist) then return end

    local project_dirs = vim.fn.readfile(project_hist)
    local iconify = function(path, color, icon)
        local ansi_codes = require'fzf-lua.utils'.ansi_codes
        local icon = ansi_codes[color](icon)
        path = require'fzf-lua.path'.relative(path, vim.fn.expand('$HOME'))
        return ("%s  %s"):format(icon, path)
    end

    local dedup = {}
    local entries = {}
    local add_entry = function(path, color, icon)
        if not path then return end
        path = vim.fn.expand(path)
        if dedup[path] ~= nil then return end
        entries[#entries+1] = iconify(path, color or "blue", icon or '')
        dedup[path] = true
    end

    coroutine.wrap(function ()
        add_entry(vim.loop.cwd(), "magenta", '')
        add_entry(_previous_cwd, "yellow")
        for _, path in ipairs(project_dirs) do
        add_entry(path)
        end
        local fzf_fn = function(cb)
        for _, entry in ipairs(entries) do
            cb(entry, function(err)
            if err then return end
            cb(nil, function() end)
            end)
        end
        end
        opts.fzf_opts = {
        ['--ansi']            = '',
        ['--no-multi']        = '',
        ['--prompt']          = 'Projects❯ ',
        ['--header-lines']    = '1',
        ['--preview']         = vim.fn.shellescape("exa --color always -T -L 2 -lh $HOME/{2..}"),
        }

        local get_cwd = function(selected)
            if not selected then return end
            _previous_cwd = vim.loop.cwd()
            local newcwd = selected[1]:match("[A-Za-z0-9_.].*$")
            print(newcwd)
            newcwd = require'fzf-lua.path'.starts_with_separator(newcwd) and newcwd
                or require'fzf-lua.path'.join({ vim.fn.expand('$HOME'), newcwd })
            return(newcwd)
        end

        opts.actions = {
            ['default'] = function(selected, opts)
                wd = get_cwd(selected)
                vim.cmd("cd " .. wd)
                require("fzf-lua").files({ cwd = wd})
            end,
        }
        require'fzf-lua'.fzf_exec(fzf_fn, opts)
    end)()
end
fzfmap('<leader>pp', "Select Project", projects)

-- 插入参考文献的引用 --------------------------------------------------- {{{2
fzfmap('<leader>ic', "Insert Citation Keys", function()
    require'fzf-lua'.fzf_exec("bibtex-ls ~/Documents/paper_ref.bib",{
        preview = "",
        actions = {
            ['default'] = function(selected, opts)
                local r = vim.fn.system("bibtex-cite -prefix='@' -postfix='' -separator='; @'", selected)
                vim.api.nvim_command('normal! i' .. r)
                vim.fn.feedkeys('a', 'n')
            end,
        }
    })
end)

-- 列出所有 buffers ----------------------------------------------------- {{{2
fzfmap('<leader>bB', "List All Buffers", function()
    fzflua.fzf_exec(function(fzf_cb)
        coroutine.wrap(function()
            local buffers = {}
            for _, b in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(b)
                -- if name == "" then name = "[No Name]" end
                if not ( name == "" or
                        string.find(name, "Wilder Float") or
                        string.find(name, "/sbin/sh")         ) then
                    buffers[b] = name 
                end
            end
            local co = coroutine.running()
            for b, name in pairs(buffers) do
                vim.schedule(function()
                    fzf_cb(b.."\t"..name, function() coroutine.resume(co) end)
                end)
            coroutine.yield()
            end
            fzf_cb()
        end)()
    end, {
        fzf_opts = { ['+m'] = '', ['--preview-window'] = "hidden"},
        actions = {
            ['default'] = function(selected, opts)
                local bufno = string.gsub(selected[1], "\t.*", '')
                vim.cmd('buffer ' .. bufno)
            end,
        }
    })
end)

-- 通过 fasd 跳转文件 {{{2
fzfmap('<leader>fz', "Jump with fasd",function()
    fzflua.fzf_exec("fasd -al",{
        actions = {
            ['default'] = actions.file_edit,
            ["ctrl-s"]      = actions.file_split,
            ["ctrl-v"]      = actions.file_vsplit,
            ["ctrl-t"]      = actions.file_tabedit,
            ["alt-q"]       = actions.file_sel_to_qf,
        }
    })
end)

-- 查看当前文件所在文件夹下的其他文件 ----------------------------------- {{{2
fzfmap('<leader>.', "List all buffers", function()
    fzflua.fzf_exec("fd -H -t f . " .. vim.fn.expand("%:p:h"), {
        actions = fileactions,
    })
end)

-- 定义查询 stata 帮助文件的命令 --{{{2
local Shelp_Action = function(vimcmd)
    return(function(selected, opts)
                local path = string.gsub(selected[1], "^.*\t", "")
                local command = string.gsub(selected[1], " *\t+.*$", "")
                local r = vim.fn.system(",sh -v -r " .. path)
                vim.cmd(vimcmd .. " " .. r)
                vim.cmd('file `="[' .. command .. ']"`' )
                vim.cmd([[
                    setlocal bufhidden=delete
                    setlocal buftype=nofile
                    setlocal noswapfile
                    setlocal nobuflisted
                    setlocal nomodifiable
                    setlocal nocursorline
                    setlocal nocursorcolumn
                ]])
           end)
end
vim.api.nvim_create_user_command('Shelp', function(opts)
    require'fzf-lua'.fzf_exec(",sh -l " .. opts.args, {
        preview = ",sh -o term -f {2..}",
        fzf_opts = {
            ['--no-multi'] = '',
        },
        actions = {
            ['default'] = Shelp_Action("edit"),
            ['ctrl-v'] = Shelp_Action("vsplit"),
            ['ctrl-s'] = Shelp_Action("split"),
            ['ctrl-t'] = Shelp_Action("tabedit"),
        }
    })
    end, { nargs = '*' })

-- asynctasks ----------------------------------------------------------- {{{2
fzfmap('<leader>ot', "Run async tasks", function()
    --local tasks = {{name = "file-run", scope = "<global>", command = "test"}}
    tasks = vim.fn['asynctasks#list']('')
    local tasktable = {}
    for i, b in ipairs(tasks) do
        tasktable[i] = b['name'] .. '  <' .. b['scope'] .. '>  : ' .. b['command']
    end
    require'fzf-lua'.fzf_exec(tasktable, {
        fzf_opts = {
            ['--no-multi'] = '',
            ['--preview-window'] = 'hidden',
        },
        winopts = {
            height           = 0.25,
            width            = 0.55,
            row              = 0.45,
            col              = 0.50,
        },
        actions = {
            ['default'] = function(selected, opts)
                local name = string.gsub(selected[1], "%s+<.*", '')
                vim.cmd('AsyncTask ' .. name)
            end,
        }
    })
end)

-- vim command fuzzy search --------------------------------------------- {{{2
fzfmap('<A-x>', "Command", function()
    require'fzf-lua'.commands({
        winopts = {
            split            = "belowright 10new",
            height = 0.35,
            width  = 1,
            row = 1,
            col = 0,
            preview = {
                horizontal= 'right:40%',
                layout = 'horizontal',
            },
        },
        fzf_opts = {
            ['--no-multi'] = '',
            ['--layout'] = 'default',
        },
        actions = {
            ['default'] = function(selected, opts)
                local command = selected[1]
                vim.cmd("stopinsert")
                local nargs = vim.api.nvim_get_commands({})[command].nargs
                if nargs:match('[0*?]') then
                    vim.cmd(command)
                else
                    vim.fn.feedkeys(string.format(":%s", command), "n")
                end
            end 
        },
    })
end)

-- keymaps -------------------------------------------------------------- {{{2
fzfmap("<leader>st", "tags",                "<cmd>FzfLua tags<cr>")
fzfmap("<leader>sT", "buffer tags",         "<cmd>FzfLua btags<cr>")
fzfmap("<leader>qs", "quickfix",            "<cmd>FzfLua quickfix<cr>")
fzfmap("<leader>sC", "colorschemes",        "<cmd>FzfLua colorschemes<cr>")
fzfmap("<leader>sh", "vim help tags",       "<cmd>FzfLua help_tags<cr>")
fzfmap("<leader>sl", "Grep current buffer", "<cmd>FzfLua lgrep_curbuf<cr>")
fzfmap("<leader>sr", "Grep lines",          "<cmd>FzfLua grep<cr>")
fzfmap("<leader>sR", "Grep project",        "<cmd>FzfLua grep_project<cr>")
fzfmap("<leader>pr", "Grep project",        "<cmd>FzfLua grep_project<cr>")
fzfmap("<c-b>",      "Grep cword",          "<cmd>FzfLua grep_cword<cr>")
fzfmap("<c-b>",      "Grep visual",         "<cmd>FzfLua grep_visual<cr>", "x")
fzfmap("<leader>sd", "Lsp document symbos", "<cmd>FzfLua lsp_document_symbols<sr>")
fzfmap("<leader>pd", "Lsp document symbos", "<cmd>FzfLua lsp_document_symbols<sr>")

