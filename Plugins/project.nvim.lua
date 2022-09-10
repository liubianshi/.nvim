require("project_nvim").setup( {
    detection_methods = { "pattern", "lsp" },
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", ".vim",
                 "Makefile", "package.json", "namespace" },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    silent_chdir = true,
})
