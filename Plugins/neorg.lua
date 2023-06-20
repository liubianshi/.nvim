require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.export" ] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    lbs = "~/Documents/Writing",
                }
            }
        }
    }
}
