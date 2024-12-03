local wk = require "which-key"
local my_border = require('util').border('═', 'top', true)
wk.setup {
  preset = "modern",
  layout = {
    height = { min = 1, max = 15 },
  },
  win = {
    border = my_border,
  },
  triggers = {
    {"<auto>", mode = "nixsoc"},
    {"s", mode = {"n", "v"}},
    {",", mode = {"n"}},

  },
  replace = {
    key = {
      {"<Space>", "SPC"},
      {"<cr>", "RET"},
      { "<tab>", "TAB"},
      function(key)
        return require("which-key.view").format(key)
      end,
    }
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "󰮺", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  disable = {},
}

-- register keymap ------------------------------------------------------ {{{1
wk.add {
  { "<leader>.", desc = "Open File" },
  { "<leader>a", group = "Attach ...", icon = { icon = "󰹴", hl = "WhichKeyIconBlue" }},
  { "<leader>a*", desc = "Attach Symbol *" },
  { "<leader>a-", desc = "Attach Symbol -" },
  { "<leader>a.", desc = "Attach Symbol ." },
  { "<leader>a=", desc = "Attach Symbol +" },
  { "<leader>b", group = "buffer ..." },
  { "<leader>bB", desc = "List all Buffers" },
  { "<leader>c", group = "Code Operater ..." },
  { "<leader>d", group = "diff ..." },
  { "<leader>e", group = "EditFile ..." },
  { "<leader>f", group = "File ..." },
  { "<leader>fS", desc = "File Save Force :write!" },
  { "<leader>fs", desc = "File Save :write" },
  { "<leader>fz", desc = "FASD" },
  { "<leader>g", group = "Git ..." },
  { "<leader>h", group = "Help/Notification ..." },
  { "<leader>i", group = "Insert ...", icon = { icon = "↡", hl = "WhichKeyIconBlue" }},
  { "<leader>ic", desc = "Insert Citation" },
  { "<leader>l", group = "Session Manager ..." },
  { "<leader>ls", desc = "List Saved Session" },
  { "<leader>m", group = "Modify ...", icon = { icon = "", hl = "WhichKeyIconBlue" }},
  { "<leader>n", group = "Obsidian ...", icon = { icon = "", hl = "WhichKeyIconBlue" }},
  { "<leader>o", group = "Open Command ...", icon = { icon = "󱓞", hl = "WhichKeyIconBlue" }},
  { "<leader>p", group = "Project ...", icon = { icon = "󰳐", hl = "WhichKeyIconBlue" }},
  { "<leader>q", group = "Quickfix ..." },
  { "<leader>s", group = "Search ..." },
  { "<leader>t", group = "Tab/Translate ..." },
  { "<leader>w", group = "Window ..." },
  { "<leader>x", group = "Trouble ...", icon = { icon = "", hl = "WhichKeyIconBlue" }},
  { "<leader>z", group = "Fold ...", icon = { icon = "", hl = "WhichKeyIconBlue" }},
  { "<leader>u", group = "Snacks ...", icon = { icon = "󰘵", hl = "WhichKeyIconBlue" }},
  { "<leader>v", desc = "Voom Outline ...", icon = { icon = "󰠶", hl = "WhichKeyIconBlue" }},
  { "<leader><leader>", group = "Terminal ...", icon = { icon = "", hl = "WhichKeyIconBlue" }},
  { "w", group = "window ..." },
}





