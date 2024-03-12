local zenmode = require('zen-mode')

zenmode.setup{
    window = {
        width = function()
            local ww = vim.fn.winwidth(0)
            if ww > 125 then
                return 100
            else
                return vim.fn.floor(ww * 0.8)
            end
        end,
        options = {
            number         = false, -- disable number column
            relativenumber = false, -- disable relative numbers
            cursorline     = false, -- disable cursorline
            cursorcolumn   = false, -- disable cursor column
            foldcolumn     = "8",   -- disable fold column
            list           = false, -- disable whitespace characters
        }
    },
    wezterm = {
        enabled = true,
        font = "+4",
    },
    kitty = {
        enabled = true,
        font = "+4",
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

