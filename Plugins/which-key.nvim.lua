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
    ["w"] = { name = "+window"},
    ["<leader>"] = { -- <leader>/<space> -------------------------------- {{{2
        ["."] = "Open File",
        ["<leader>:"] = {
            name = "Command",
        },
        ["a"] = {
            name = "Attach",
            ["*"] = "Attach Symbol *",
            ["-"] = "Attach Symbol -",
            ["="] = "Attach Symbol +",
            ["."] = "Attach Symbol .",
        },
        ["b"] = { name = "+buffer", },
        ["c"] = {
            name = "Code Operater",
        },
        ["d"] = { name = "diff" },
        ["e"] = { -- <leader>e Edit File -------------------------------- {{{3
            name = "+EditFile",
        },
        ["f"] = { -- <leader>f: File Handle ----------------------------- {{{3
            name = "File ...",
            ["s"] = "File Save :write",
            ["S"] = "File Save Force :write!",
            ["z"] = "FASD",
        },
        ["i"] = { -- <leader>f: Insert ---------------------------------- {{{3
            name = "Insert",
            ["c"] = "Insert Citation",
        },
        -- ["m"] = { name = "+MultVisual" },
        ["o"] = {
            name = "Open Command"
        },
        ["p"] = {
            name = "Project",
            ["d"] = "LSP Document Symbols in Project",
            ["p"] = "Change Project",
            ["r"] = "Grep Project",
            ["t"] = "Tags in Project",
        },
        ["q"] = { name = "Quickfix"},
        ["s"] = { name = "Search" },
        ["t"] = { name = "Tab" },
        ["T"] = { name = "Translate" },
        ["w"] = { name = "Wndow" },
        ["x"] = { name = "+Trouble" },
        ["z"] = { name = "+Fold" },
    },
})
