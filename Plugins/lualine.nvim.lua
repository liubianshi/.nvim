-- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
       return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require "lualine"

-- Color table for highlights
local colors = vim.g.lbs_colors

-- window
local function window()
  return vim.api.nvim_win_get_number(0)
end

-- conponent
--- @diagnostic disable: unused-local
local buffers = {
  "buffers",
  buffers_color = {
    active = { bg = colors.yellow, fg = colors.black, gui = "bold" },
    inactive = { bg = colors.grey, fg = colors.cream, gui = "italic" },
  },
  symbols = {
    modified = " ●",
    alternate_file = " ",
    directory = "",
  },
  mode = 2,
}
local fname = {
  "filename",
  file_status = true, -- displays file status (readonly status, modified status)
  path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
  shorting_target = 40, -- Shortens path to leave 40 space in the window
  -- for other components. Terrible name any suggestions?
  symbols = {
    modified = "[+]", -- when the file was modified
    readonly = "[-]", -- if the file is not modifiable or readonly
    unnamed = "[No Name]", -- default display name for unnamed buffers
  },
  color = { fg = colors.black, gui = "bold" },
  separator = { left = "", right = "" },
}
local diagnostics = {
  "diagnostics",
  sources = { "nvim_lsp" },
  symbols = { error = " ", warn = " ", info = " " },
  color_error = colors.red,
  color_warn = colors.yellow,
  color_info = colors.cyan,
}
local diff = {
  "diff",
  -- Is it me or the symbol for modified us really weird
  symbols = { added = " ", modified = "󰿨 ", removed = " " },
  colored = true,
  color_added = colors.green,
  color_modified = colors.orange,
  color_removed = colors.red,
}
local encoding = {
  function()
    if vim.bo.fileencoding == "utf-8" then
      return ""
    else
      return vim.o.encoding
    end
  end,
}
local rime_status = {
  function()
    local ime_ok, ime = pcall(require, "ime-toggle.input-method")
    if not ime_ok then return "" end
    if ime.buf_rime_enabled() then
      if ime.global_rime_enabled() then
        return "· ㄓ"
      else
        return "· ㄨ"
      end
    else
      return ""
    end
  end,
  padding = { left = 0, right = 1 },
  color = { fg = colors.orange },
}
local foldmethod = {
  function()
    local fdm = vim.wo.foldmethod
    local symbols = {
      manual = "U",
      marker = "M",
      indent = "I",
      expr = "E",
      syntax = "S",
      diff = "D",
    }
    return "· ｢" .. symbols[fdm] .. "-" .. vim.wo.foldlevel .. "｣"
  end,
  padding = { left = 0, right = 1 },
}

-- R.nvim
local rstt = {
  { "-", "#aaaaaa" }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
  { "S", "#757755" }, -- 2: nclientserver started, but not ready yet.
  { "S", "#117711" }, -- 3: nclientserver is ready.
  { "S", "#ff8833" }, -- 4: nclientserver started the TCP server
  { "S", "#3388ff" }, -- 5: TCP server is ready
  { "R", "#ff8833" }, -- 6: R started, but nvimcom was not loaded yet.
  { "R", "#3388ff" }, -- 7: nvimcom is loaded.
}

local rstatus = function()
  if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
    -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
    return ""
  end
  return "· " .. rstt[vim.g.R_Nvim_status][1]
end

local rsttcolor = function()
  if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
    -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
    return { fg = "#000000" }
  end
  return { fg = rstt[vim.g.R_Nvim_status][2] }
end

local current_time = {
  function()
    return os.date "%H:%M"
  end,
  padding = { left = 1, right = 1 },
  colors = { bg = colors.fg, fg = colors.bg },
}

-- Config
lualine.setup {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    globalstatus = true,
    theme = "auto",
    disabled_filetypes = {
      statusline = { "alpha" },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {
      {
        "mode",
        fmt = trunc(80, 4, 0, true),
        separator = { left = "", right = "" },
      },
    },
    lualine_b = {},
    lualine_c = {
      diff,
      diagnostics,
    },
    lualine_x = {
      fname,
      {
        "progress",
        padding = { left = 1, right = 0 },
        color = { fg = colors.yellow },
      },
      "location",
    },
    lualine_y = {
      "filetype",
      encoding,
      { rstatus, color = rsttcolor },
      foldmethod,
      rime_status,
    },
    lualine_z = { "selectioncount", "searchcount", current_time },
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_c = { fname },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
}



