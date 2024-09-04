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
    "cd '" .. box_lib .. "'",
    [[fd '[.][Rr]$']],
    [[Rscript --no-restore --no-save --no-init-file -e 'cat(installed.packages() |> rownames(), sep = "\n")']]
  }
  local cmd = table.concat(bash_code, "; ")
  local items = vim.fn.systemlist(cmd)
  if not items or #items == 0 then return end
  if #items == 1 then return items[1] end

  vim.ui.select( items, { prompt = "Select: "}, handle_choice )
end

local reload_pkg = function()
  local line = vim.fn.getline('.')
  if not line then return end
  line = line:gsub("%b[]", ""):gsub(" #.*$", ""):gsub("%s", "")
  local s, e = vim.regex([[[A-Za-z.][A-Za-z0-9_.]*)]]):match_str(line)
  local lib = line:sub(s + 1, e - 1)
  require('r.send').cmd("box::reload(" .. lib .. ")")
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
end

return M

