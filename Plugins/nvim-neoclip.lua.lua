require("neoclip").setup {
  enable_persistent_history = true,
  keys = {
    telescope = {
      i = {
        select = "<cr>",
        paste = "<c-p>",
        paste_behind = "<c-k>",
        replay = "<c-q>", -- replay a macro
        delete = "<c-d>", -- delete an entry
        edit = "<c-e>", -- edit an entry
        custom = {},
      },
      n = {
        select = "<cr>",
        paste = "p",
        --- It is possible to map to more than one key.
        -- paste = { 'p', '<c-p>' },
        paste_behind = "P",
        replay = "q",
        delete = "d",
        edit = "e",
        custom = {},
      },
    },
    fzf = {
      select = "default",
      paste = "ctrl-p",
      paste_behind = "ctrl-k",
      custom = {},
    },
  },
}

require("telescope").load_extension("neoclip")

