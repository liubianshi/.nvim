local zenmode = require('zen-mode')

zenmode.setup{
    window = {
        options = {
            signcolumn     = "no",  -- disable signcolumn
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
    }
}
