lua << EOF
require("project_nvim").setup {
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", ".vim",
               "Makefile", "package.json" },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
EOF
