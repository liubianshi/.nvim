local zenmode = require('zen-mode')

zenmode.setup{
    window = {
        width = function()
            if vim.fn.winwidth(0) > 125 then
                return 100
            else
                return 0.8
            end
        end,
        options = {
            number         = false, -- disable number column
            relativenumber = false, -- disable relative numbers
            cursorline     = true, -- disable cursorline
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
    on_open = function(win)
        vim.g.lbs_zen_mode = true
    end,
    on_close = function()
        vim.g.lbs_zen_mode = false
    end,
}
