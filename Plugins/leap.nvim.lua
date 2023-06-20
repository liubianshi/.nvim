   local leap = require("leap")
   leap.add_default_mappings(true)
   vim.keymap.del({ "x", "o" }, "x")
   vim.keymap.del({ "x", "o" }, "X")
   vim.keymap.del({ "x", "o", "n" }, "s")
   vim.keymap.del({ "x", "o", "n" }, "S")
   vim.keymap.set({ "n", "x", "o"}, 'ss', '<Plug>(leap-forward-to)')
   vim.keymap.set({ "n", "x", "o"}, 'sS', '<Plug>(leap-backward-to)')

