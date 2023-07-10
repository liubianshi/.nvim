require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
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
        ["core.itero"] = {},
        ["core.promo"] = {},
        ["core.summary"] = {},
        ["core.export" ] = {},
        ["core.export.markdown"] = {
            config = {
                extension = 'md',
                extensions = 'all',
                ['metadata'] = {
                    ['end'] = "---",
                    ['start'] = "---",
                },
            },
        },
        ["core.journal"] = {
            config = {
                journal_folder = "norg-journal",
                workspace = "journal",
            }
        },
        ["core.concealer"] = {
            config = {
                icons = {
                    heading = {
                        icons = {"", "", "", "", "", ""}
                    },
                    ordered = {
                        icons = { "1", "A", "a", "⑴", "Ⓐ", "ⓐ"},
                    },
                    list = {
                        icons = {"", "", "󰻂", "", "󱥸", ""}
                    }
                }
            }
        },
        ["core.dirman"] = {
            config = {
                workspaces = {
                    lbs = "~/Documents/Writing/Norg",
                    journal = "~/Documents/Writing/journal",
                }
            }
        },
        ['core.integrations.telescope'] = {},
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

--- neorg-telescope -----------------------------------------------------
local neorg_callbacks = require("neorg.callbacks")
neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<localleader>ll", "core.integrations.telescope.find_linkable", opts = { desc = "Find Linkable"} },
        },

        i = { -- Bind in insert mode
            { "<localleader><tab>", "core.integrations.telescope.insert_link", opts = { desc = "Insert Link"} },
        },
    }, {
            silent = true,
        noremap = true,
    })
end)

