local zenmode = require "zen-mode"

zenmode.setup {
  window = {
    backdrop = 0.95,
    width = function()
      local ww = vim.api.nvim_get_option_value("columns", { scope = "global" })
      if ww > 150 then
        return 120
      elseif ww > 120 then
        return vim.fn.floor(ww * 0.8)
      else
        return ww
      end
    end,
    height = vim.api.nvim_get_option_value("lines", { scope = "global" }) ,
    options = {
      signcolumn = "yes:6",
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = "0", -- disable fold column
      list = false, -- disable whitespace characters
    },
  },
  plugins = {
    wezterm = {
        enabled = false,
        font = "+2",
    },
    kitty = {
        enabled = false,
        font = "+1",
    },
    options = {
      enabled = true,
      ruler = false,
      showcmd = false,
      -- laststatus = 0,
    },
    neovide = {
      enabled = false,
      -- Will multiply the current scale factor by this number
      scale = 1.2,
      -- disable the Neovide animations while in Zen mode
      disable_animations = {
        neovide_animation_length = 0,
        neovide_cursor_animate_command_line = false,
        neovide_scroll_animation_length = 0,
        neovide_position_animation_length = 0,
        neovide_cursor_animation_length = 0,
        neovide_cursor_vfx_mode = "",
      }
    },
  },
  on_open = function(_)
    vim.wo.scrolloff = 9999
    -- clear previewed images
    local is_ok, _ = pcall(require, "image")
    if is_ok then
      require("util").clear_previewed_images(0)
    end
    vim.o.showtabline = 0
    vim.o.laststatus = 0
    --- @diagnostic disable: missing-parameter
    require('lualine').hide()
    vim.g.lbs_zen_mode = true -- Centering the cursor row
  end,
  on_close = function(_)
    local is_ok, image = pcall(require, "image")
    if is_ok then
      image.setup()
    end
    vim.o.laststatus = 0
    vim.o.showtabline = vim.g.showtabline or 1
    require('lualine').hide({ place = { 'statusline', 'tabline', 'winbar' }, unhide = true })
    vim.g.lbs_zen_mode = false
    vim.wo.scrolloff = -1
  end,
}
