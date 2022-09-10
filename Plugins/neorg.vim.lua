require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        [ "core.export" ] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    lbs = "~/Documents/Writing",
                }
            }
        }
    }
}
