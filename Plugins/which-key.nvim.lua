local wk = require "which-key"
wk.setup {
  layout = {
    height = { min = 1, max = 15 },
  },
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "󰮺", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
}

-- register keymap ------------------------------------------------------ {{{1
wk.register {
  ["w"] = { name = "+window ..." },
  ["<leader>"] = { -- <leader>/<space> -------------------------------- {{{2
    ["."] = "Open File",
    ["a"] = {
      name = "Attach ...",
      ["*"] = "Attach Symbol *",
      ["-"] = "Attach Symbol -",
      ["="] = "Attach Symbol +",
      ["."] = "Attach Symbol .",
    },
    ["b"] = {
      name = "+buffer ...",
      B = "List all Buffers",
    },
    ["c"] = { name = "Code Operater ..." },
    ["d"] = { name = "diff ..." },
    ["e"] = { -- <leader>e Edit File -------------------------------- {{{3
      name = "+EditFile ...",
    },
    ["f"] = { -- <leader>f: File Handle ----------------------------- {{{3
      name = "File ...",
      ["s"] = "File Save :write",
      ["S"] = "File Save Force :write!",
      ["z"] = "FASD",
    },
    ["h"] = {
      name = "Help/Notification ...",
    },
    ["g"] = {
      name = "Git ...",
    },
    ["i"] = { -- <leader>f: Insert ---------------------------------- {{{3
      name = "Insert ...",
      ["c"] = "Insert Citation",
    },
    ['l'] = {
      name = "Session Manager ...",
      ["s"] = "List Saved Session",
    },
    -- ["m"] = { name = "+MultVisual" },
    ["n"] = { name = "Obsidian ..." },
    ["o"] = { name = "Open Command ..." },
    ["p"] = { name = "Project ..." },
    ["q"] = { name = "Quickfix ..." },
    ["s"] = { name = "Search ..." },
    ["t"] = { name = "Tab/Translate ..." },
    ["w"] = { name = "Window ..." },
    ["x"] = { name = "Trouble ..." },
    ["z"] = { name = "Fold ..." },
  },
}
