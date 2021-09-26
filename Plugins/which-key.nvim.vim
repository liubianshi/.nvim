lua << EOF
require("which-key").setup {
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
}

local wk = require("which-key")
wk.register({
["<leader>:"] = {name = "+command"},
["<leader>a"] = {name = "+add_elements"},
["<leader>b"] = {name = '+buffer'},
["<leader>c"] = {name = '+NerdCommander'},
["<leader>d"] = {name = '+diff'},
["<leader>e"] = {name = '+EditFile'},
["<leader>f"] = {name = '+FileHandle'},
["<leader>m"] = {name = '+MultVisual'},
["<leader>o"] = {name = '+Open'},
["<leader>s"] = {name = '+Search'},
["<leader>t"] = {name = '+Tab'},
["<leader>w"] = {name = '+Window'},
["<leader>x"] = {name = '+Trouble'},
["<leader>z"] = {name = '+Fold'},
["<leader>T"] = {name = '+translate'},
["<leader>fl"] = {name = "+lf"},
["<leader>fr"] = {n = "Open Recent File"},
["<tab>t"] = {name = "+Tab mode"},
})

EOF
