-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require 'lualine'

-- Color table for highlights
local colors = vim.g.lbs_colors
local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
  encoding_not_utf8 = function() return vim.o.encoding ~= 'utf-8' end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end
}

-- conponent
local fname = {
    'filename',
    file_status = true,   -- displays file status (readonly status, modified status)
    path = 1,             -- 0 = just filename, 1 = relative path, 2 = absolute path
    shorting_target = 40, -- Shortens path to leave 40 space in the window
                        -- for other components. Terrible name any suggestions?
    symbols = {
        modified = '[+]',      -- when the file was modified
        readonly = '[-]',      -- if the file is not modifiable or readonly
        unnamed = '[No Name]', -- default display name for unnamed buffers
    },
    condition = conditions.buffer_not_empty,
    color = {fg = colors.magenta, gui = 'bold'}
}

local diagnostics = {
  'diagnostics',
  sources = {'nvim_lsp'},
  symbols = {error = ' ', warn = ' ', info = ' '},
  color_error = colors.red,
  color_warn = colors.yellow,
  color_info = colors.cyan
}

local diff = {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = {added = ' ', modified = '󰿨 ', removed = ' '},
  color_added = colors.green,
  color_modified = colors.orange,
  color_removed = colors.red,
}

local encoding = {
  function()
    if vim.o.encoding == 'utf-8' then
      return ''
    else
      return vim.o.encoding
    end
  end
}
-- rime-ls status
local rime_status = {
  function()
    if vim.b.rime_enabled and vim.g.rime_enabled then
      return 'ㄓ📍'
    elseif vim.b.rime_enabled then
      return 'ㄓ'
    else
      return ''
    end
  end,
  color = {fg = colors.orange},
}

-- Config
lualine.setup {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = "auto",
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {'mode'},
    lualine_b = {'branch', diff, diagnostics},
    lualine_c = {fname},
    lualine_x = {encoding, 'filetype', rime_status},
    lualine_y = {'progress'},
    lualine_z = {'searchcount', 'location'},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_c = {fname},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  }
}

