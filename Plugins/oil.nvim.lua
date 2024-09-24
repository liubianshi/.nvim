require("oil").setup {
  columns = {
    {"icon", highlight = "Special"},
    {"mtime", format = "%Y-%m-%d %H:%M", highlight = "Number"},
    {"size", highlight = "String" },
  }
}
