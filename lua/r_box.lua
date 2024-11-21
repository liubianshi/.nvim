local M = {}

local handle_choice = function(choice)
  if not choice then return end
  local text = string.format("box::use(%s)", string.gsub(choice, "%.[Rr]$", ""))
  local linenr = vim.fn.line('.')
  if vim.fn.getline('.') == "" then
    vim.fn.setline(linenr, text)
  else
    vim.fn.append(linenr, text)
    vim.cmd.normal("j")
  end

end

local insert_pkg = function()
  local box_lib = vim.env.R_BOX_LIBRARY or (vim.env.HOME .. "/Repositories/R-script/box")
  local bash_code = {
    '[[ "$PWD" = "$HOME" ]] || fd -t f -e r "." R 2>/dev/null',
    "cd '" .. box_lib .. "'",
    [[fd '[.][Rr]$']],
    [[Rscript --no-restore --no-save --no-init-file -e 'cat(installed.packages() |> rownames(), sep = "\n")']]
  }
  local cmd = table.concat(bash_code, "; ")
  local items = vim.fn.systemlist(cmd)
  if not items or #items == 0 then return end
  if #items == 1 then return items[1] end

  local fzfok, fzflua = pcall(require, "fzf-lua")
  if not fzfok then
    vim.ui.select( items, { prompt = "Select: "}, handle_choice )
    return
  end

  fzflua.fzf_exec(items, {
    preview = {
      type = "cmd",
      fn = function(selects)
        local item = selects[1]
        if item:find("%.[Rr]$") then
          local path
          if item:find("^R%/") then
            path = "./" .. item
          else
            path = vim.env.R_BOX_LIBRARY and vim.env.R_BOX_LIBRARY or
              vim.env.HOME .. "/Repositories/R-script/box/" .. item
          end
          return string.format("pistol '%s'", path)
        end
        return string.format(
          "R --no-save --no-restore --no-echo --no-init-file -e '"
          .. 'packageDescription("%s", fields = c("Title", "Description", "Version"));'
          .. 'cat("\nNamespace:\n");'
          .. 'ls(getNamespace("%s"))'
          .. "'",
          item,
          item
        )
      end,
    },
    actions = {
      ["default"] = function(selected, _)
        handle_choice(selected[1]);
      end,
    }
  })


end

local function get_box_pkg()
  local line = vim.fn.getline('.')
  if not line then return end
  local lib = nil
  local fun = nil
  if line:find("^box::use") then
    line = line:gsub("%b[]", ""):gsub(" #.*$", ""):gsub("%s", "")
    local s, e = vim.regex([[[A-Za-z.][A-Za-z0-9_.]*)]]):match_str(line)
    lib = line:sub(s + 1, e - 1)
  else
    vim.cmd.normal("t(")
    line = line:sub(1, vim.fn.col('.'))
    local s, e = vim.regex("[A-Za-z.][A-Za-z0-9_.]*\\ze\\$[A-Za-z.][A-Za-z0-9_.]*$"):match_str(line)
    lib = line:sub(s + 1, e)
    local fs, fe = vim.regex("[A-Za-z.][A-Za-z0-9_.]*\\$\\zs[A-Za-z.][A-Za-z0-9_.]*$"):match_str(line)
    fun = line:sub(fs + 1, fe)
  end
  return lib, fun
end

local reload_pkg = function()
  local lib = get_box_pkg()
  if not lib then return end
  require('r.send').cmd("box::reload(" .. lib .. ")")
end

local function get_box_script(lib_fullname)
  if not lib_fullname then return end
  if not lib_fullname:find("%/") then return end

  local filepath = lib_fullname
  if not lib_fullname:find("^R%/") then
    local box_lib = vim.env.R_BOX_LIBRARY or (vim.env.HOME .. "/Repositories/R-script/box")
    filepath = box_lib .. "/" .. lib_fullname
  end

  if vim.uv.fs_stat(filepath .. ".r") then
    filepath = filepath .. ".r"
  else
    filepath = filepath .. ".R"
  end

  return filepath
end

local function get_box_lib_fullname(line)
  line = line or vim.fn.getline('.')
  if not line:find("^box::use") then return end
  line = line:gsub("%b[]", ""):gsub(" #.*$", ""):gsub("%s", "")
  local s, e = vim.regex("^box::use(\\zs[^,)]*\\ze[,)]"):match_str(line)
  if not s then return end
  return line:sub(s + 1, e)
end

local edit_box_script = function(method, new)
  local line = vim.fn.getline('.')
  if not line then return end

  local lib_fullname = get_box_lib_fullname(line)
  local fun_name = nil
  local lib
  if not lib_fullname then
    lib, fun_name = get_box_pkg()
    if not lib then return end

    local lines = vim.api.nvim_buf_get_lines(0, 0, vim.fn.line('.') - 1, true)
    for _, l in ipairs(lines) do
      local clib = get_box_lib_fullname(l)
      if clib and clib:find(lib .. "$") then
        lib_fullname = clib
        break
      end
    end
  end
  if not lib_fullname then return end

  method = method or "edit"
  new = new or false
  local filepath = get_box_script(lib_fullname)
  if not filepath or (not new and not vim.uv.fs_stat(filepath)) then
    return
  end
  vim.cmd(method .. " " .. filepath)
  if fun_name then
    for i = 0, vim.api.nvim_buf_line_count(0) - 1 do
      local ln = vim.api.nvim_buf_get_lines(0, i, i + 1, false)
      if ln[1] and ln[1]:find("^" .. fun_name) then
        vim.api.nvim_win_set_cursor(0, {i + 1, 0})
        return
      end
    end
    vim.notify("Function " .. fun_name .. " not found", vim.log.levels.WARN)
  end
end

local keymap = function(key, fun, des, mode)
  mode = mode or "n"
  vim.keymap.set(
    mode,
    "<localleader>b" .. key,
    fun,
    { buffer = true, desc = des, noremap = true, silent = true}
  )
end

M.set_keymap = function()
  keymap("a", insert_pkg, "Box: Import package")
  keymap("r", reload_pkg, "Box: Reload package")
  keymap("e", edit_box_script, "Box: Edit package")
end

return M

