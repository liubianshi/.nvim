-- vim: set fdm=marker: -------------------------------------------------
local aucmd = vim.api.nvim_create_autocmd
local function augroup(name)
  name = "LBS_" .. name
  return vim.api.nvim_create_augroup(name, { clear = true })
end
local augroups = vim.tbl_map(
  function(name) return augroup(name) end,
  {
    "Auto_create_dir",
    "Buffer",
    "Bigfile",
    "Checktime",
    "Close_with_q",
    "Cursor",
    "FASD",
    "Fugitive",
    "Help",
    "Keywordprg",
    "LspAttach",
    "Man",
    "Term",
    "Yank",
    "Zen",
  }
)

-- Buffer --------------------------------------------------------------- {{{1
aucmd({"BufWritePre"}, {
  group = augroups.Buffer,
  command = [[%s/\v\s+$//e]],
  desc = "Delete suffix space before writing",
})

-- Lsp related ---------------------------------------------------------- {{{1
aucmd({ "LspAttach" }, {
  group = augroups.LspAttach,
  callback = function()
    vim.opt.formatoptions:remove "cro"
  end,
})

-- Zen mode related ----------------------------------------------------- {{{1
local function process_win(win)
  local winnr = vim.fn.win_id2win(win)
  if winnr == 0 then return end

  local ww = vim.api.nvim_win_get_width(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  local _, zen_oriwin = pcall(vim.api.nvim_buf_get_var, bufnr, "zen_oriwin")

  if vim.bo[bufnr].syntax == "rbrowser" then
    if ww <= 30 then
      return
    end
    vim.cmd("vertical " .. winnr .. "resize 30")
    return "break"
  end


  if vim.g.lbs_zen_mode then
    if ww <= 88 then
      vim.wo[win].signcolumn = "auto:1"
    elseif ww <= 100 then
      vim.wo[win].signcolumn = "yes:4"
    else
      vim.wo[win].signcolumn = "yes:" .. math.min(math.floor((ww - 81) / 4), 6)
    end
  elseif zen_oriwin and type(zen_oriwin) == "table" and zen_oriwin.zenmode then
    if ww <= 88 then
      vim.wo[win].signcolumn = "auto:1"
    elseif ww <= 100 then
      vim.wo[win].signcolumn = "yes:4"
    else
      vim.wo[win].signcolumn = "yes:" .. math.min(math.floor((ww - 81) / 4), 9)
    end
  else
    if ww <= 40 then
      vim.wo[win].signcolumn = "no"
      vim.wo[win].foldcolumn = "0"
    else
      vim.wo[win].signcolumn = "auto:1"
      vim.wo[win].foldcolumn = vim.o.foldcolumn
    end
  end
end

aucmd({ "WinResized" }, {
  group = augroups.Zen,
  callback = function(_)
    local windows = vim.tbl_filter(
      function(win)
        return
          vim.api.nvim_win_get_config(win).relative == ""
          or (
            vim.g.lbs_zen_mode
            and vim.api.nvim_get_option_value('buftype', { buf = vim.api.nvim_win_get_buf(win) }) == ""
          )
      end,
      vim.v.event.windows
    )
    for _, win in ipairs(windows) do
      local rc = process_win(win)
      if rc == "break" then return end
    end
  end,
})

aucmd({ "BufWinEnter", "BufRead", "BufEnter" }, {
  group = augroups.Zen,
  callback = function(ev)
    local bufnr = ev.buf
    local winid = vim.fn.bufwinid(bufnr)
    if winid == -1 then
      return
    end

    local zen_oriwin = vim.b[bufnr].zen_oriwin
    local is_zen_buffer = zen_oriwin and zen_oriwin.zenmode
    local is_zen_window = vim.w[winid].zen_mode
      local _, lualine = pcall(require, 'lualine')

    if is_zen_window and is_zen_buffer then
      vim.go.showtabline = 0
      vim.go.laststatus = 0
      ---@diagnostic disable: missing-fields
      if lualine then lualine.hide({}) end
      return
    end
    if not is_zen_buffer and not is_zen_window then
      vim.go.showtabline = vim.g.showtabline or 1
      vim.go.laststatus = vim.g.laststatus or 3
      ---@diagnostic disable: missing-fields
      if lualine then lualine.hide({ unhide = true }) end
      return
    end

    if is_zen_buffer then
      vim.fn["utils#ZenMode_Insert"](false)
    else
      vim.fn["utils#ZenMode_Leave"](false)
      vim.go.showtabline = vim.g.showtabline or 1
      vim.go.laststatus = vim.g.laststatus or 3
    end
  end,
})

-- Keywordprg ----------------------------------------------------------- {{{1
aucmd({ "FileType" }, {
  group = augroups.Keywordprg,
  pattern = { "perl", "perldoc" },
  callback = function(ev)
    vim.bo[ev.buf].keywordprg = ":Perldoc"
  end,
})
aucmd({ "FileType" }, {
  group = augroups.Keywordprg,
  pattern = { "stata", "statadoc" },
  callback = function(ev)
    vim.bo[ev.buf].keywordprg = ":Shelp"
  end,
})
aucmd({ "FileType" }, {
  group = augroups.Keywordprg,
  pattern = { "man", "sh", "bash" },
  callback = function(ev)
    vim.bo[ev.buf].keywordprg = ":Man"
  end,
})
aucmd({ "FileType" }, {
  group = augroups.Keywordprg,
  pattern = { "r", "rmd", "rdoc" },
  callback = function(ev)
    if vim.g.R_Nvim_status and vim.g.R_Nvim_status == 7 then
      vim.bo[ev.buf].keywordprg = ":RHelp"
    else
      vim.bo[ev.buf].keywordprg = ":Rdoc"
    end
  end,
})

-- Fasd Update ---------------------------------------------------------- {{{1
aucmd({ "BufNew", "BufNewFile" }, {
  group = augroups.FASD,
  callback = function(ev)
    if
      (vim.bo[ev.buf].buftype == "" or vim.bo[ev.buf].filetype == "dirvish")
      and ev.file ~= ""
    then
      vim.system { "fasd", "-A", ev.file }
    end
  end,
})

-- cursorline ----------------------------------------------------------- {{{1
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua
aucmd({ "InsertEnter", "WinLeave", "BufLeave" }, {
  group = augroups.Cursor,
  command = "if &cursorline && ! &pvw | setlocal nocursorline | endif",
})

aucmd({ "InsertLeave", "WinEnter", "BufEnter" }, {
  group = augroups.Cursor,
  command = "if ! &cursorline && ! &pvw | setlocal cursorline | endif",
})

-- Term Open ------------------------------------------------------------ {{{1
aucmd({ "TermOpen" }, {
  group = augroups.Term,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.bufhidden = "hide"
    vim.opt_local.foldcolumn = "0"
  end,
})

-- Check if we need to reload the file when it changed ------------------ {{{1
aucmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroups.Checktime,
  callback = function()
    if vim.o.buftype ~= "nofile" and vim.fn.getcmdwintype() == "" then
      vim.cmd "checktime"
    end
  end,
})

aucmd({ "FileChangedShellPost" }, {
  group = augroups.Checktime,
  callback = function()
    vim.notify(
      "File changed on disk. Buffer reloaded!",
      vim.log.levels.WARN,
      { title = "nvim-config" }
    )
  end,
})

-- Highlight on yank ---------------------------------------------------- {{{1
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua
aucmd("TextYankPost", {
  group = augroups.Yank,
  callback = function()
    vim.highlight.on_yank()
  end,
})

aucmd("InsertEnter", {
  group = augroups.Yank,
  callback = function()
    vim.schedule(function()
      vim.cmd "nohlsearch"
    end)
  end,
})

aucmd("CursorMoved", {
  group = augroups.Yank,
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function() vim.cmd.nohlsearch() end)
    end
  end,
})

-- close some filetypes with <q> ----------------------------------------
aucmd("FileType", {
  group = augroups.Close_with_q,
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- make it easier to close man-files when opened inline ----------------- {{{1
aucmd("FileType", {
  group = augroups.Man,
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Auto create dir when saving a file ----------------------------------- {{{1
-- in case some intermediate directory does not exist
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
aucmd({ "BufWritePre" }, {
  group = augroups.Auto_create_dir,
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- -- Handle Bigfile ------------------------------------------------------- {{{1
-- -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- vim.filetype.add {
--   pattern = {
--     [".*"] = {
--       function(path, buf)
--         return vim.bo[buf]
--             and vim.bo[buf].filetype ~= "bigfile"
--             and path
--             and vim.fn.getfsize(path) > vim.g.bigfile_size
--             and "bigfile"
--           or nil
--       end,
--     },
--   },
-- }
--
-- aucmd({ "FileType" }, {
--   group = augroups.Bigfile,
--   pattern = "bigfile",
--   callback = function(ev)
--     vim.b.minianimate_disable = true
--     vim.schedule(function()
--       vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ""
--     end)
--   end,
-- })

-- auto-delete fugitive buffers ----------------------------------------- {{{1
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua
aucmd("BufReadPost", {
  group = augroups.Fugitive,
  pattern = "fugitive:*",
  command = "set bufhidden=delete"
})

-- Display help|man in vertical splits and map 'q' to quit -------------- {{{1
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua
local function open_vert()
  -- do nothing for floating windows or if this is
  -- the fzf-lua minimized help window (height=1)
  local cfg = vim.api.nvim_win_get_config(0)
  if cfg and (cfg.external or cfg.relative and #cfg.relative > 0)
      or vim.api.nvim_win_get_height(0) == 1 then
    return
  end
  -- do not run if Diffview is open
  if vim.g.diffview_nvim_loaded and
      require "diffview.lib".get_current_view() then
    return
  end
  vim.cmd("wincmd L")
  -- local width = math.floor(vim.o.columns * 0.75)
  -- vim.cmd("vertical resize " .. width)
  vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = true })
end

aucmd("FileType", {
  group = augroups.Help,
  pattern = "help,man",
  callback = open_vert,
})

-- we also need this auto command or help
-- still opens in a split on subsequent opens
aucmd("BufNew", {
  group = augroups.Help,
  pattern = {"*.txt", "*.cnx", "*.md"},
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "help" then
      open_vert()
    end
  end
})

aucmd("BufHidden", {
  group = augroups.Help,
  pattern = "man://*",
  callback = function()
    if vim.bo.filetype == "man" then
      local bufnr = vim.api.nvim_get_current_buf()
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end, 0)
    end
  end
})



