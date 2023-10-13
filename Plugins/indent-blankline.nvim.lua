local ibl = require("ibl")
ibl.setup({
   indent = {
      char = "│",
      tab_char = "│",
      smart_indent_cap = true,
   },
   scope  = {
      show_start = true,
   },
   exclude = {
      buftypes = {
         "nofile",
         "terminal",
      },
      filetypes = {
         "help",
         "startify",
         "aerial",
         "alpha",
         "dashboard",
         "lazy",
         "neogitstatus",
         "NvimTree",
         "neo-tree",
         "Trouble",
         'norg',
         'org',
         'markdown',
         'rmarkdown',
      },
   },
})
