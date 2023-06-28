require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
            config = {
                hook = function(keybinds)
                    keybinds.map(
                        'norg', "n", '<localleader>o',
                        '<cmd>Neorg keybind all core.looking-glass.magnify-code-block<cr>'
                    )
                    keybinds.map(
                        'norg', 'n', '<localleader>s',
                        '<cmd>Neorg generate-workspace-summary<cr>'
                    )
                    keybinds.map(
                        'norg', 'n', '<localleader>j', 
                        '<cmd>Neorg journal today<cr>'
                    )
                end,
            }
        },
        ["core.esupports.indent"] = {},
        ["core.summary"] = {},
        ["core.export" ] = {},
        ["core.journal"] = {
            config = {
                journal_folder = "norg-journal",
                workspace = "journal",
            }
        },
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    lbs = "~/Documents/Writing/Norg",
                    journal = "~/Documents/Writing/journal",
                }
            }
        }
    }
}

local status_ok,wk = pcall(require, 'which-key')
if status_ok then
    wk.register({
        ['<localleader>'] = {
            ['i'] = {name = '+Insert'},
            ['l'] = {name = '+List'},
            ['m'] = {name = '+Move'},
            ['n'] = {name = '+Note'},
            ['t'] = {name = '+Task'},
            ['o'] = "Edit Code Chunk",
            ['s'] = "Summary",
            ['j'] = "Open today's journal",
        }
    })
end
