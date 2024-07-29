-- vim: ft=lua fdm=marker:
vim.env.FZF_DEFAULT_OPTS = vim.env.FZF_DEFAULT_OPTS .. " --color=gutter:-1"
if vim.o.background == "light" then
  vim.env.FZF_DEFAULT_OPTS = "--select-1 --exit-0"
end
local external_command = {
  exa = vim.fn.systemlist("which exa")[1],
}
local my_border = require("util").border("═", "top")

local fzflua = require "fzf-lua"
local actions = require "fzf-lua.actions"
local fileactions = {
  ["default"] = actions.file_edit,
  ["ctrl-s"] = actions.file_split,
  ["ctrl-v"] = actions.file_vsplit,
  ["ctrl-t"] = actions.file_tabedit,
  ["alt-q"] = actions.file_sel_to_qf,
}

local fzfmap = function(key, desc, cmd, mode)
  mode = mode or "n"
  vim.keymap.set(mode, key, cmd, {
    desc = "FzfLua: " .. desc,
    silent = true,
    noremap = true,
  })
end

-- setup ---------------------------------------------------------------- {{{2
fzflua.setup {
  "telescope",
  winopts = {
    -- help nvim_open_win()
    --[ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]
    border = my_border,
    preview = {
      scrollchars = { "│", "" },
      winopts = {
        border = my_border,
      },
    },
  },
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
      cmd = "echo %s | tr -d '()'  | xargs -r man | col -bx",
    },
  },
  files = {
    previewer = "builtin",
    prompt = "Files❯ ",
    file_icons = true,
    fzf_opts = {
      ["--preview"] = vim.fn.shellescape "printf {1} | perl -plE 's!\\A[^\\s\\/A-z]+\\s!!' | xargs scope",
    },
  },
  grep = {
    winopts = {
      -- split = "belowright new",
      height = 0.4,
      width = 1,
      row = 1,
      col = 0,
      preview = {
        horizontal = "right:40%",
        layout = "horizontal",
      },
    },
  },
}

-- integration with project.nvim ---------------------------------------- {{{2
local _previous_cwd
local projects = function(opts)
  if not opts then
    opts = {}
  end
  local project_hist = vim.fn.stdpath "data" .. "/project_nvim/project_history"
  if not vim.loop.fs_stat(project_hist) then
    return
  end

  local project_dirs = vim.fn.readfile(project_hist)
  local iconify = function(path, color, icon)
    local ansi_codes = require("fzf-lua.utils").ansi_codes
    icon = ansi_codes[color](icon)
    path = require("fzf-lua.path").relative_to(path, vim.fn.expand "$HOME")
    return ("%s  %s"):format(icon, path)
  end

  local dedup = {}
  local entries = {}
  local add_entry = function(path, color, icon)
    if not path then
      return
    end
    path = vim.fn.expand(path)
    if dedup[path] ~= nil then
      return
    end
    entries[#entries + 1] = iconify(path, color or "blue", icon or "")
    dedup[path] = true
  end

  coroutine.wrap(function()
    add_entry(vim.loop.cwd(), "magenta", "")
    add_entry(_previous_cwd, "yellow")
    for _, path in ipairs(project_dirs) do
      add_entry(path)
    end
    local fzf_fn = function(cb)
      for _, entry in ipairs(entries) do
        cb(entry, function(err)
          if err then
            return
          end
          cb(nil, function() end)
        end)
      end
    end
    opts.fzf_opts = {
      ["--ansi"] = "",
      ["--no-multi"] = "",
      ["--prompt"] = "Projects❯ ",
      ["--header-lines"] = "1",
      ["--preview"] = external_command.exa
        .. " --color always -T -L 2 -lh $HOME/{2..}",
    }

    local get_cwd = function(selected)
      if not selected then
        return
      end
      _previous_cwd = vim.loop.cwd()
      local newcwd = selected[1]:match "[A-Za-z0-9_.].*$"
      print(newcwd)
      newcwd = require("fzf-lua.path").is_absolute(newcwd) and newcwd
        or require("fzf-lua.path").join { vim.fn.expand "$HOME", newcwd }
      return newcwd
    end

    opts.actions = {
      ["default"] = function(selected, _)
        local wd = get_cwd(selected)
        vim.cmd("cd " .. wd)
        require("fzf-lua").files { cwd = wd }
      end,
    }
    require("fzf-lua").fzf_exec(fzf_fn, opts)
  end)()
end
fzfmap("<leader>pp", "Select Project", projects)

-- 插入参考文献的引用 --------------------------------------------------- {{{2
fzfmap("<leader>ic", "Insert Citation Keys", function()
  require("fzf-lua").fzf_exec("bibtex-ls ~/Documents/url_ref.bib", {
    preview = "",
    actions = {
      ["default"] = function(selected, _)
        local r = vim.fn.system(
          "bibtex-cite -prefix='@' -postfix='' -separator='; @'",
          selected
        )
        vim.api.nvim_command("normal! i" .. r)
        vim.fn.feedkeys("a", "n")
      end,
    },
  })
end)

-- 列出所有 buffers ----------------------------------------------------- {{{2
fzfmap("<leader>bB", "List All Buffers", function()
  fzflua.fzf_exec(function(fzf_cb)
    coroutine.wrap(function()
      local buffers = {}
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(b)
        -- if name == "" then name = "[No Name]" end
        if
          not (
            name == ""
            or string.find(name, "Wilder Float")
            or string.find(name, "/sbin/sh")
          )
        then
          buffers[b] = name
        end
      end
      local co = coroutine.running()
      for b, name in pairs(buffers) do
        vim.schedule(function()
          fzf_cb(b .. "\t" .. name, function()
            coroutine.resume(co)
          end)
        end)
        coroutine.yield()
      end
      fzf_cb()
    end)()
  end, {
    fzf_opts = { ["+m"] = "", ["--preview-window"] = "hidden" },
    actions = {
      ["default"] = function(selected, _)
        local bufno = string.gsub(selected[1], "\t.*", "")
        vim.cmd("buffer " .. bufno)
      end,
    },
  })
end)

-- 通过 fasd 跳转文件 {{{2
fzfmap("<leader>fz", "Jump with fasd", function()
  fzflua.fzf_exec("fasd -al", {
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["alt-q"] = actions.file_sel_to_qf,
    },
  })
end)

-- 查看当前文件所在文件夹下的其他文件 ----------------------------------- {{{2
fzfmap("<leader>.", "List all buffers", function()
  fzflua.fzf_exec("fd -H -t f . " .. vim.fn.expand "%:p:h", {
    actions = fileactions,
  })
end)

-- 定义查询 stata 帮助文件的命令 --{{{2
local Shelp_Action = function(vimcmd)
  return function(selected, _)
    local path = string.gsub(selected[1], "^.*\t", "")
    local command = string.gsub(selected[1], " *\t+.*$", "")
    local r = vim.fn.system(",sh -v -r " .. path)
    vim.cmd(vimcmd .. " " .. r)
    vim.cmd('file `="[' .. command .. ']"`')
    vim.cmd [[
                    setlocal bufhidden=delete
                    setlocal buftype=nofile
                    setlocal noswapfile
                    setlocal nobuflisted
                    setlocal nomodifiable
                    setlocal nocursorline
                    setlocal nocursorcolumn
                ]]
  end
end
vim.api.nvim_create_user_command("Shelp", function(opts)
  require("fzf-lua").fzf_exec(",sh -l " .. opts.args, {
    preview = "scope {2..}",
    fzf_opts = {
      ["--no-multi"] = "",
    },
    actions = {
      ["default"] = Shelp_Action "edit",
      ["ctrl-v"] = Shelp_Action "vsplit",
      ["ctrl-s"] = Shelp_Action "split",
      ["ctrl-t"] = Shelp_Action "tabedit",
    },
  })
end, { nargs = "*" })

vim.api.nvim_create_user_command("Urlopen", function(opts)
  require("fzf-lua").fzf_exec(vim.fn["utils#Fetch_urls"](opts.args), {
    preview = nil,
    actions = {
      ["default"] = function(selected, _)
        local command = "linkhandler '" .. selected[1] .. "'"
        vim.cmd [[Lazy! load asyncrun.vim]]
        vim.fn["asyncrun#run"]("", { silent = 1, pos = "hide" }, command)
      end,
    },
  })
end, { nargs = 0, desc = "FzfLua: Open urls" })

-- asynctasks ----------------------------------------------------------- {{{2
-- From:
-- https://github.com/skywind3000/asynctasks.vim/wiki/UI-Integration
fzfmap("<leader>ot", "Run async tasks", function()
  local rows = vim.fn["asynctasks#source"](vim.go.columns * 48 / 100)
  if #rows == 0 then
    local LOG_LEVEL_WARN = 3
    vim.notify(
      "No task attated to the buffer",
      LOG_LEVEL_WARN,
      { title = "AsyncTasks" }
    )
    return
  end
  fzflua.fzf_exec(function(cb)
    for _, e in ipairs(rows) do
      local color = fzflua.utils.ansi_codes
      local line = color.green(e[1])
        .. " "
        .. color.cyan(e[2])
        .. ": "
        .. color.yellow(e[3])
      cb(line)
    end
    cb()
  end, {
    actions = {
      ["default"] = function(selected)
        local str = fzflua.utils.strsplit(selected[1], " ")
        local command = "AsyncTask " .. vim.fn.fnameescape(str[1])
        vim.api.nvim_exec2(command, { output = false })
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--preview-window"] = "hidden",
      ["--nth"] = "1",
    },
    winopts = {
      height = 0.6,
      width = 0.6,
    },
  })
end)

-- vim command fuzzy search --------------------------------------------- {{{2
fzfmap("<A-x>", "Command", function()
  require("fzf-lua").commands {
    winopts = {
      -- split            = "belowright 10new",
      height = 0.4,
      width = 1,
      row = 1,
      col = 0.5,
      preview = {
        horizontal = "right:40%",
        layout = "horizontal",
      },
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--layout"] = "default",
    },
    actions = {
      ["default"] = function(selected, _)
        local command = selected[1]
        vim.cmd "stopinsert"
        local nargs = vim.api.nvim_get_commands({})[command].nargs
        if nargs:match "[0*?]" then
          vim.cmd(command)
        else
          vim.fn.feedkeys(string.format(":%s", command), "n")
        end
      end,
    },
  }
end)

-- Find Roam Node
local insert_new_node = function()
  local last_query = require("fzf-lua").config.__resume_data.last_query
  vim.cmd [[normal l]]
  vim.fn["utils#RoamInsertNode"](last_query, "split")
  vim.cmd [[wincmd J]]
  vim.cmd [[res 8]]
end

local fzf_selection_action = function(cmd)
  cmd = cmd or "cite"
  if cmd == "cite" then
    return function(selected, _)
      if not selected[1] then
        return insert_new_node()
      end
      if not vim.fn["utils#IsPrintable_CharUnderCursor"]() then
        vim.cmd "normal! a "
      end
      local buf = vim.fn.bufnr()
      local row_col = vim.api.nvim_win_get_cursor(0)
      local row = row_col[1] - 1
      local col = row_col[2] + 1
      local cite =
        vim.fn.system("roam_id_title --cite  -n '" .. selected[1] .. "'")
      vim.api.nvim_buf_set_text(buf, row, col, row, col, { cite })
      vim.cmd "normal! 3f]"
    end
  else
    return function(selected, _)
      local file = vim.fn.system(
        "roam_id_title  -n '"
          .. selected[1]
          .. "'  | cut -f1 | xargs -I {} roam_id_title -i {}"
      )
      vim.cmd(cmd .. " " .. file)
    end
  end
end

vim.api.nvim_create_user_command("RoamNodeFind", function(_)
  fzflua.fzf_exec("roam_id_title", {
    preview = 'cd "' .. vim.env.home .. '/documents/writing/roam/"; scope {-1}',
    fzf_opts = { ["--no-multi"] = "" },
    actions = {
      ["default"] = fzf_selection_action "edit",
      ["ctrl-l"] = function(_, _)
        insert_new_node()
      end,
      ["ctrl-e"] = fzf_selection_action "cite",
    },
  })
end, { nargs = 0, desc = "fzflua: find org roam node" })

local Cheat_Action = function(vimcmd)
  return function(selected, opts)
    local item = next(selected) and selected[1]
      or opts.last_query:gsub("^'", "")
    if not item then
      return
    end
    local dir = vim.env.HOME .. "/.config/cheat/cheatsheets/personal/"
    local target_file = vim.fn.system("help -p '" .. item .. "' 2>/dev/null")
    if string.match(target_file, "\n") then
      return
    end

    if vimcmd == "rename" then
      local newname = vim.fn.input "Enter newname: "
      vim.fn.system("help -r " .. newname .. " " .. item)
    elseif vimcmd == "Glow" then
      local tmp = vim.fn.tempname() .. ".md"
      vim.fn.system("ln -sf " .. vim.fn.fnameescape(target_file) .. " " .. tmp)
      vim.cmd("Glow " .. tmp)
    else
      vim.cmd(vimcmd .. " " .. vim.fn.fnameescape(target_file))
      vim.cmd("cd " .. dir)
    end
  end
end
vim.api.nvim_create_user_command("Cheat", function(_)
  local command = vim.env.HOME .. "/useScript/bin/help"
  fzflua.fzf_exec(command .. " -l", {
    preview = command .. " {}",
    fzf_opts = {
      ["--no-multi"] = "",
    },
    actions = {
      ["default"] = Cheat_Action "Glow",
      ["ctrl-e"] = Cheat_Action "edit",
      ["ctrl-v"] = Cheat_Action "vsplit",
      ["ctrl-x"] = Cheat_Action "split",
      ["ctrl-t"] = Cheat_Action "tabedit",
      ["ctrl-r"] = Cheat_Action "rename",
    },
  })
end, { nargs = "*", desc = "FzfLua: Cheat" })

