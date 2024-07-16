local wk = require "which-key"
wk.setup {
  preset = "modern",
  layout = {
    height = { min = 1, max = 15 },
  },
  win = {
    border = { '', {'═', "MyBorder"}, '', '', '', '', '', ''},
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
}

-- register keymap ------------------------------------------------------ {{{1
wk.add {
  { "<leader>.", desc = "Open File" },
  { "<leader>a", group = "Attach ..." },
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
  { "<leader>i", group = "Insert ..." },
  { "<leader>ic", desc = "Insert Citation" },
  { "<leader>l", group = "Session Manager ..." },
  { "<leader>ls", desc = "List Saved Session" },
  { "<leader>n", group = "Obsidian ..." },
  { "<leader>o", group = "Open Command ..." },
  { "<leader>p", group = "Project ..." },
  { "<leader>q", group = "Quickfix ..." },
  { "<leader>s", group = "Search ..." },
  { "<leader>t", group = "Tab/Translate ..." },
  { "<leader>w", group = "Window ..." },
  { "<leader>x", group = "Trouble ..." },
  { "<leader>z", group = "Fold ..." },
  { "w", group = "window ..." },
}
