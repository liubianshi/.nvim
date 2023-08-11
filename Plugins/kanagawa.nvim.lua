local kanagawa = require('kanagawa')
kanagawa.setup({
    transparent = false,
    undercurl = true,
    background= {
        dark = 'wave',
        light = 'lotus',
    },
    colors = {
        theme = {
            wave = {
                ui = {
                    bg = '#1E1E2E',
                }
            }
        }
    },
    overides = function(colors)
        local theme = colors.theme
        return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            FzfLuaPreviewNormal = { bg = "none" },
            FzfLuaPreviewBorder = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            -- Block-like _modern_ Telescope UI
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

            -- More uniform colors for the popup menu.
            -- add `blend = vim.o.pumblend` to enable transparency
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
        }
    end,
})

local colors = require("kanagawa.colors").setup({theme = 'wave'})
local palette = colors.palette
local ui = colors.theme.ui
vim.g.lbs_colors = {
    bg        = ui.bg,
    bg_float  = ui.float.bg,
    bg_border = ui.float.bg_border,
    bg_pmenu  = ui.pmenu.bg,
    fg        = ui.fg,
    fg_float  = ui.float.fg,
    fg_border = ui.float.fg_border,
    fg_pmenu  = ui.pmenu.fg,
    special   = ui.special,
    nontext   = ui.nontext,
    aqua      = palette.waveAqua1,
    yellow    = palette.dragonYellow,
    cyan      = palette.lotusCyan,
    blue      = palette.waveBlue1,
    darkblue  = palette.waveBlue2,
    green     = palette.dragonGreen,
    orange    = palette.surimiOrange,
    violet    = palette.dragonViolet,
    magenta   = palette.dragonPink,
    red       = palette.waveRed,
}


