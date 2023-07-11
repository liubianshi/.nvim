-- register keybinds ---------------------------------------------------- {{{1
local status_ok,wk = pcall(require, 'which-key')
if status_ok then
    wk.register({
        ['<localleader>'] = {
            ['i'] = {name = '+Insert'},
            ['l'] = {name = '+List'},
            ['m'] = {name = '+Move'},
            ['n'] = {name = '+Note'},
            ['t'] = {name = '+Task'},
            ['s'] = {name = '+search node'},
        }
    })
end

-- setup ---------------------------------------------------------------- {{{1
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                hook = function(keybinds)
                    keybinds.map(
                        'norg', 'n', "<localleader>sH", "<cmd>Neorg toc qflist<cr>", {desc = "Search Headings through qflist"}
                    )
                    keybinds.map(
                        'norg', "n", '<localleader>o', '<cmd>Neorg keybind all core.looking-glass.magnify-code-block<cr>', {desc = "Edit Code Chunk"}
                    )
                    keybinds.map(
                        'norg', 'n', '<localleader>S', '<cmd>Neorg generate-workspace-summary<cr>', { desc = "Display Summary"}
                    )
                    keybinds.map(
                        'norg', 'n', '<localleader>nj', '<cmd>Neorg journal today<cr>', {desc =  "Open today's journal"}
                    )
                    keybinds.map(
                        'norg', 'n', '<localleader>ni', '<cmd>Neorg index<cr>', {desc = "Return to Index Page"}
                    )
                end,
            }
        },
        ["core.summary"] = {},
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            }
        },
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
                        icons = {"󰉫", "󰉬", "󰉭", "󰉮", "󰉯", "󰉰"}
                    },
                    ordered = {
                        icons = { "1", "A", "a", "⑴", "Ⓐ", "ⓐ"},
                    },
                    list = {
                        icons = {"", "", "󰻂", "", "󱥸", ""}
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
        -- ['core.ui.calendar'] = {}, -- at least Neovim 0.10.0 is required to run
        ['core.integrations.telescope'] = {},
    }
}

--- keybinds ------------------------------------------------------------ {{{1
local neorg_callbacks = require("neorg.callbacks")
neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<localleader><tab>", "core.integrations.telescope.switch_workspace",       opts = { desc = "Switch Workspace"} },
            { "<localleader>sl",    "core.integrations.telescope.find_linkable",          opts = { desc = "Find Linkable"} },
            { "<localleader>sf",    "core.integrations.telescope.find_norg_files",        opts = { desc = "Find Norg Files"} },
            { "<localleader>sh",    "core.integrations.telescope.search_headings",        opts = { desc = "Search Headings"} },
            { "<localleader>st",    "core.integrations.telescope.find_context_tasks",     opts = { desc = "Find Context Tasks"} },
            { "<localleader>sT",    "core.integrations.telescope.find_project_tasks",     opts = { desc = "Find Project Tasks"} },
            { "<localleader>sa",    "core.integrations.telescope.find_aof_tasks",         opts = { desc = "Find AOF Tasks"} },
            { "<localleader>sA",    "core.integrations.telescope.find_aof_project_tasks", opts = { desc = "Find AOF Project Tasks"} },
        },
        i = { -- Bind in insert mode
            { "<localleader>ll",    "core.integrations.telescope.insert_link",            opts = { desc = "Insert Link"} },
            { "<localleader>lf",    "core.integrations.telescope.insert_file_link",       opts = { desc = "Insert File Link"} },
        },
    }, { silent = true, noremap = true })
end)

-- vim: set fdm=marker: ------------------------------------------------- {{{1
