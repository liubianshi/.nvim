local fm = require('fm-nvim')
local ui = {
    -- Default UI (can be "split" or "float")
    default = "float",
    float = {
        -- Floating window border (see ':h nvim_open_win')
        border    = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        -- Highlight group for floating window/border (see ':h winhl')
        float_hl  = "Normal",
        border_hl = "FloatBorder",
        -- Floating Window Transparency (see ':h winblend')
        blend     = 0,
        -- Num from 0 - 1 for measurements
        height    = 0.8,
        width     = 0.8,
        -- X and Y Axis of Window
        x         = 0.5,
        y         = 0.5
    },
    split = {
        -- Direction of split
        direction = "topleft",
        -- Size of split
        size      = 24
    }
}
local cmd = {
    lf_cmd      = "lf", -- eg: lf_cmd = "lf -command 'set hidden'"
    fm_cmd      = "fm",
    nnn_cmd     = "nnn",
    fff_cmd     = "fff",
    twf_cmd     = "twf",
    fzf_cmd     = "fzf", -- eg: fzf_cmd = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
    fzy_cmd     = "find . | fzy",
    xplr_cmd    = "xplr",
    vifm_cmd    = "vifm",
    skim_cmd    = "sk",
    broot_cmd   = "broot",
    gitui_cmd   = "gitui",
    ranger_cmd  = "ranger",
    joshuto_cmd = "joshuto",
    lazygit_cmd = "lazygit",
    neomutt_cmd = "neomutt",
    taskwarrior_cmd = "taskwarrior-tui"
}
local mappings = {
    vert_split = "<C-v>",
    horz_split = "<C-h>",
    tabedit    = "<C-t>",
    edit       = "<C-e>",
    ESC        = "<ESC>",
}

fm.setup({
    edit_cmd = "edit",
    on_close = {},
    on_open = {},
    ui = ui, 
    cmds = cmds,
    mappings = mappings,
    -- Path to broot config
    broot_conf = vim.fn.stdpath("data") .. "/site/pack/packer/start/fm-nvim/assets/broot_conf.hjson"
})
