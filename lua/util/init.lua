-- from:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
local Util = require "lazy.core.util"

local M = {}

M.root_patterns = { ".git", "lua", ".obsidian", ".vim", '.exercism' }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.fg(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
  local fg = hl and (hl['fg'] or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) }
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root(path)
  ---@type string?
  path = path or vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p) or ""
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require "telescope.actions.state"
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend(
              "force",
              {},
              params.opts or {},
              { cwd = false, default_text = line }
            )
          )()
        end)
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return Util.info(
      "Set " .. option .. " to " .. vim.opt_local[option]:get(),
      { title = "Option" }
    )
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info("Enabled " .. option, { title = "Option" })
    else
      Util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    Util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    Util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

function M.deprecate(old, new)
  Util.warn(
    ("`%s` is deprecated. Please use `%s` instead"):format(old, new),
    { title = "LazyVim" }
  )
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

function M.lsp_get_config(server)
  local configs = require "lspconfig.configs"
  return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.lsp_disable(server, cond)
  local util = require "lspconfig.util"
  local def = M.lsp_get_config(server)
  def.document_config.on_new_config = util.add_hook_before(
    def.document_config.on_new_config,
    function(config, root_dir)
      if cond(root_dir, config) then
        config.enabled = false
      end
    end
  )
end

-- Clearing images previewed with image.nvim
function M.clear_previewed_images(win)
  win = win or 0
  local is_ok, api = pcall(require, "image")
  if not is_ok then
    return
  end

  local images = api.get_images()
  if not next(images) then
    return
  end

  local windows_in_current_tab = vim.api.nvim_tabpage_list_wins(win)
  local windows_in_current_tab_map = {}
  for _, current_window in ipairs(windows_in_current_tab) do
    windows_in_current_tab_map[current_window] = true
  end

  for _, current_image in ipairs(images) do
    if not current_image.window or not current_image.buffer then
      goto continue
    end

    local window_ok, is_valid_window =
      pcall(vim.api.nvim_win_is_valid, current_image.window)
    if not (window_ok and is_valid_window) then
      goto continue
    end

    local buf_ok, is_valid_buffer =
      pcall(vim.api.nvim_buf_is_valid, current_image.buffer)
    if not buf_ok or not is_valid_buffer then
      goto continue
    end

    local is_window_in_current_tab = windows_in_current_tab_map[current_image.window]
    if not is_window_in_current_tab then
      goto continue
    end

    local is_buffer_in_window = vim.api.nvim_win_get_buf(
      current_image.window
    ) == current_image.buffer
    if not is_buffer_in_window then
      goto continue
    end

    current_image:clear()
  end
  ::continue::
end

local get_item_info = function(b, field, command)
  field = field or "note"
  local item_path
  if field == "note" then
    item_path = vim.fn.trim(vim.fn.system("mylib note @" .. b))
  elseif vim.tbl_contains({"pdf", "bib", "newsboat", "html", "md", "path", "title"}, field) then
    item_path = vim.fn.trim(vim.fn.system("mylib get " .. field .. " -- @" .. b))
  end
  if command then
    if vim.fn.filewritable(item_path) == 0 then return end
    vim.cmd(command .. " " .. vim.fn.fnameescape(item_path))
  else
    return item_path
  end
end

function M.bibkey_action(bibkey)
  if not bibkey then return end
  bibkey = "@" .. bibkey
  local open_app = vim.fn.has('mac') == 1 and "open " or "xdg-open "
  local command = {
    e = function() get_item_info(bibkey, "note",     "edit ")   end,
    v = function() get_item_info(bibkey, "note",     "vsplit ") end,
    t = function() get_item_info(bibkey, "note",     "tabnew ") end,
    s = function() get_item_info(bibkey, "note",     "split ")  end,
    o = function() get_item_info(bibkey, "path",     "Lf ")     end,
    n = function() get_item_info(bibkey, "newsboat", "edit ")   end,
    p = function()
      local pdf_file = get_item_info(bibkey, "pdf")
      if vim.fn.filereadable(pdf_file) == 0 then return end
      vim.fn.system( open_app .. '"' .. pdf_file .. '"')
    end,
    u = function()
      vim.fn.system( open_app .. get_item_info(bibkey, "url"))
    end,
  }

  local bib_title = get_item_info(bibkey, "title")
  local prompt = {
    bib_title .. ", Choose a action: ",
    "-------------------------------------------------------------------------------",
    "(p): open pdf file   (u): open url      (o): open dir          (n): newsboat",
    "(e): edit note       (s): split note    (v): vsplite note      (t): tabnew note",
    "-------------------------------------------------------------------------------",
    "q: Quit",
    "",
    "Please key for an action:",
  }
  vim.cmd(string.format('echon "%s"', table.concat(prompt, '\\n')))
  local choice = vim.fn.nr2char(vim.fn.getchar())
  vim.cmd('redraw!')
  if vim.tbl_contains({"p", "u", "o", "e", "s", "v", "t"}, choice) then
    command[choice]()
  end
end

function M.execute_async(command, callback_funs)
    callback_funs = callback_funs or {}
    callback_funs = vim.tbl_extend("keep", callback_funs, {
      on_stdout = function(_, data, _)
        if type(data) ~= "table" then data = {data} end
        print(vim.fn.join(data, ""))
      end,
      on_error  = function(_, data, _)
        if type(data) ~= "table" then data = {data} end
        print(vim.fn.join(data, ""))
      end,
      on_exit   = function(_, data, _)
        if type(data) ~= "table" then data = {data} end
        print(vim.fn.join(data, ""))
      end,
    })

    local job_id = vim.fn.jobstart(command, {
        on_stdout = callback_funs.on_stdout,
        on_stderr = callback_funs.on_stderr,
        on_exit   = callback_funs.on_exit,
    })

    return job_id
end

function M.in_project()
  local cwd = vim.fn.getcwd()
  local ok,project = pcall(require, "project_nvim")
  if not ok then return end
  local projects = project.get_recent_projects()
  for _, proj in ipairs(projects) do
    if cwd == proj then
      return true
    end
  end
  return false
end

function M.wk_reg(mapping, opts)
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then return end
  wk.add(mapping, opts)
end

function M.border(symbol, type, neovide, highlight)
  symbol = symbol or "═"
  type = type or "top"
  neovide = neovide or false
  highlight = "MyBorder"

  if vim.fn.exists("g:neovide") == 1 and not neovide then
    return "none"
  end

  if type == "top" then
    return { '', {symbol, highlight}, '', '', '', '', '', ''}
  elseif type == "bottom" then
    return { '', '', '', '', '', {symbol, highlight}, '', ''}
  end
end
return M
