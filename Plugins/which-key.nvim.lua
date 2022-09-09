require("which-key").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
})

-- register keymap ------------------------------------------------------ {{{1
local wk = require("which-key")
wk.register({
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
        ["b"] = {
            name = "+buffer",
            ["B"] = "Fzf Serch All Buffers",
            ["b"] = "Fzf Serch Buffers",
            ["d"] = "Delete Buffer",
            ["n"] = "Next Buffer",
        },
        ["c"] = {
            name = "Code Operater",
        },
        ["d"] = { name = "diff" },
        ["e"] = { -- <leader>e Edit File -------------------------------- {{{3
            name = "+EditFile",
            ["a"] = "Alias",
            ["d"] = "Flypy Dictionary",
            ["j"] = "Wiki Journal",
            ["k"] = "Neovim Keymap",
            ["o"] = "Neovim Options",
            ["r"] = "R Profile",
            ["s"] = "Stata profile",
            ["u"] = "Snippets",
            ["v"] = "Neovim Plugin List",
            ["w"] = "Wiki Index",
            ["z"] = "Zshrc",
            ["Z"] = "User Zshrc",
        },
        ["f"] = { -- <leader>f: File Handle ----------------------------- {{{3
            name = "File ...",
            ["f"] = "Fzf Search Files(PWD)",
            ["o"] = "Open File",
            ["r"] = "Open Recent File" ,
            ["s"] = "File Save :write",
            ["S"] = "File Save Force :write!",
            ["w"] = "Fzf Search Wiki Pages",
            ["z"] = "FASD",
            ["l"] = { name = "Open Lf" },
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
        ["fl"] = { name = "+lf" },
        ["t"] = { name = "+Tab mode" },
    },
    ["s"] = { -- Search ------------------------------------------------- {{{2
        ["r"] = {
            name = "Surfraw",
            ["h"] = "Surfraw Github",
        },
    },
})
