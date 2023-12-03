-- vim: foldlevel=99
local toggleterm = require("toggleterm")
local colors = require("toggleterm.colors")
local constants = require("toggleterm.constants")

local uniform_background_color = function(conf)
    conf.shading_factor = conf.shading_factor or constants.shading_amount
    conf.shade_terminals = conf.shade_terminals or true

    local is_bright = colors.is_bright_background()
    local degree = is_bright and -3 or 1
    local amount = conf.shading_factor * degree
    local normal_bg = colors.get_hex("Normal", "bg")
    local shade_color = conf.shade_terminals and colors.shade_color(normal_bg, amount) or normal_bg

    conf.highlights.FoldColumn = { guibg = shade_color }
    return conf
end

toggleterm.setup(uniform_background_color({
    open_mapping    = nil,
    size            = 7,
    shade_filetypes = {"none"},
    shade_terminals = true,
    start_in_insert = true,
    persist_size    = true,
    direction       = "horizontal",
    highlights = {
        NormalFloat = {
            link = "Normal",
        },
    },
    on_open = function() end,
}))

vim.wo.signcolumn = "no"
