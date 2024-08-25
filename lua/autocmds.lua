-- This file is automatically loaded by lazyvim.config.init.

local function augroup(name)
  return vim.api.nvim_create_augroup("LBS_" .. name, { clear = true })
end


-- Highlight for special filetype
vim.api.nvim_create_autocmd({"FileType"}, {
  group = augroup("Highlight_FileType"),
  pattern = {"norg", "org", "markdown", "rmd", "rmarkdown"},
  callback = function()
    vim.cmd([[syntax match NonText /​/ conceal]])
  end
})

-- Lsp related
vim.api.nvim_create_autocmd({"LspAttach"}, {
  group = augroup("LspAttach"),
  callback = function()
    vim.opt.formatoptions:remove('cro')
  end
})


-- Zen mode related
vim.api.nvim_create_autocmd({ "WinResized" }, {
  group = augroup "Zen",
  callback = function()
    local windows = vim.v.event.windows
    local function process_win(win)
      local winnr = vim.fn.win_id2win(win)
      if winnr == 0 then
        return
      end

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

      if zen_oriwin and type(zen_oriwin) == "table" and zen_oriwin.zenmode then
        if ww <= 84 then
          vim.wo[win].signcolumn = "yes:1"
        elseif ww <= 126 then
          vim.wo[win].signcolumn = "yes:"
            .. math.min(math.floor((ww - 81) / 4), 9)
        end
      else
        if ww <= 40 then
          vim.wo[win].signcolumn = "no"
          vim.wo[win].foldcolumn = "0"
        else
          vim.wo[win].signcolumn = "yes:1"
          vim.wo[win].foldcolumn = vim.o.foldcolumn
        end
      end
    end
    for _, win in ipairs(windows) do
      local rc = process_win(win)
      if rc == "break" then
        return
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufRead", "BufEnter" }, {
  group = augroup "Zen",
  callback = function(ev)
    local bufnr = ev.buf
    local winid = vim.fn.bufwinid(bufnr)
    if winid == -1 then
      return
    end

    local zen_oriwin = vim.b[bufnr].zen_oriwin
    local is_zen_buffer = zen_oriwin and zen_oriwin.zenmode
    local is_zen_window = vim.w[winid].zen_mode

    if not is_zen_buffer == not is_zen_window then
      return
    end

    if is_zen_buffer then
      vim.fn["utils#ZenMode_Insert"](false)
    else
      vim.fn["utils#ZenMode_Leave"](false)
    end
  end,
})

-- Keywordprg ----------------------------------------------------------- {{{1
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "Keywordprg",
  pattern = { "perl", "perldoc" },
  callback = function(ev)
    vim.bo[ev.buf].keywordprg = ":Perldoc"
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "Keywordprg",
  pattern = { "stata", "statadoc" },
  callback = function(ev)
    vim.bo[ev.buf].keywordprg = ":Shelp"
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "Keywordprg",
  pattern = { "man", "sh", "bash" },
  callback = function(ev)
    vim.bo[ev.buf].keywordprg = ":Man"
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "Keywordprg",
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
vim.api.nvim_create_autocmd({ "BufNew", "BufNewFile" }, {
  group = augroup "FASD_UPDATE",
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
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup "Cursor_Highlight",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup "Cursor_Highlight",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- Term Open ------------------------------------------------------------ {{{1
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = augroup "Term_Open",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.bufhidden = "hide"
    vim.opt_local.foldcolumn = "0"
  end,
})

-- Check if we need to reload the file when it changed ------------------ {{{1
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" and vim.fn.getcmdwintype() == "" then
      vim.cmd "checktime"
    end
  end,
})

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  group = augroup "checktime",
  callback = function()
    vim.notify(
      "File changed on disk. Buffer reloaded!",
      vim.log.levels.WARN,
      { title = "nvim-config" }
    )
  end,
})

-- Highlight on yank ---------------------------------------------------- {{{1
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- close some filetypes with <q> ----------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "close_with_q",
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
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "man_unlisted",
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Auto create dir when saving a file ----------------------------------- {{{1
-- in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.filetype.add {
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile_size
            and "bigfile"
          or nil
      end,
    },
  },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "bigfile",
  pattern = "bigfile",
  callback = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ""
    end)
  end,
})
