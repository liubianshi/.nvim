local zenmode = require "zen-mode"

zenmode.setup {
  window = {
    backdrop = 0.85,
    width = function()
      local ww = vim.fn.winwidth(0)
      if ww > 150 then
        return 120
      else
        return vim.fn.floor(ww * 0.8)
      end
    end,
    options = {
      signcolumn = "no", -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = "6", -- disable fold column
      list = false, -- disable whitespace characters
    },
  },
  plugins = {
    wezterm = {
        enabled = true,
        font = "+2",
    },
    kitty = {
        enabled = true,
        font = "+1",
    },
  },
  on_open = function(_)
    vim.wo.scrolloff = 9999
    -- clear previewed images
    local is_ok, _ = pcall(require, "image")
    if is_ok then
      require("util").clear_previewed_images(0)
    end
    vim.g.lbs_zen_mode = true -- Centering the cursor row
  end,
  on_close = function(_)
    local is_ok, image = pcall(require, "image")
    if is_ok then
      image.setup()
    end
    vim.g.lbs_zen_mode = false
    vim.wo.scrolloff = -1
  end,
}
