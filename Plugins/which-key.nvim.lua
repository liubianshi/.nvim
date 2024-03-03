local wk = require("which-key")
wk.setup({
    layout = {
        height = { min = 1, max = 15},
    }
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
})

-- register keymap ------------------------------------------------------ {{{1
wk.register({
    ["w"] = { name = "+window ..."},
    ["<leader>"] = { -- <leader>/<space> -------------------------------- {{{2
        ["."] = "Open File",
        ["a"] = {
            name = "Attach ...",
            ["*"] = "Attach Symbol *",
            ["-"] = "Attach Symbol -",
            ["="] = "Attach Symbol +",
            ["."] = "Attach Symbol .",
        },
        ["b"] = { name = "+buffer ...", },
        ["c"] = { name = "Code Operater ...", },
        ["d"] = { name = "diff ..." },
        ["e"] = { -- <leader>e Edit File -------------------------------- {{{3
            name = "+EditFile ...",
        },
        ["f"] = { -- <leader>f: File Handle ----------------------------- {{{3
            name = "File ...",
            ["s"] = "File Save :write",
            ["S"] = "File Save Force :write!",
            ["z"] = "FASD",
        },
        ["h"] = {
            name = "Help/Notification ...",
        },
        ["g"] = {
            name = "Git ..."
        },
        ["i"] = { -- <leader>f: Insert ---------------------------------- {{{3
            name = "Insert ...",
            ["c"] = "Insert Citation",
        },
        -- ["m"] = { name = "+MultVisual" },
        ["n"] = { name = "Obsidian ..."},
        ["o"] = { name = "Open Command ..." },
        ["p"] = { name = "Project ..." },
        ["q"] = { name = "Quickfix ..."},
        ["s"] = { name = "Search ..." },
        ["t"] = { name = "Tab/Translate ..." },
        ["w"] = { name = "Window ..." },
        ["x"] = { name = "Trouble ..." },
        ["z"] = { name = "Fold ..." },
    },
})
