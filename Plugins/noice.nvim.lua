require("noice").setup {
  lsp = {
    signature = {
      enabled = true,
      auto_open = {
        trigger = false,
      }
    },
    -- overrid e markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = { enabled = false }, -- forbidden rime-ls info
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = false, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify", -- view for errors
    view_warn = "notify", -- view for warnings
    view_history = "messages", -- view for :messages
    view_search = "virtualtext",
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
  },
  cmdline = {
    opts = {
      position = {
        row = "90%", -- 将行位置设置为 100%，即底部
        col = "50%", -- 将列位置设置为 50%，即居中
      },
    },
    format = {
      search_down = {
        kind = "search",
        pattern = "^/",
        icon = " ",
        lang = "regex",
        opts = {
          -- position = {
          --   row = "100%", -- 将行位置设置为 100%，即底部
          --   col = "50%", -- 将列位置设置为 50%，即居中
          -- },
        },
      },
      search_up = {
        opts = {
          -- position = {
          --   row = "100%", -- 将行位置设置为 100%，即底部
          --   col = "50%", -- 将列位置设置为 50%，即居中
          -- },
        },
        kind = "search",
        pattern = "^%?",
        icon = " ",
        lang = "regex",
      },
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%[>?%d+/>?%d+%]$" }, -- search count
        }
      },
      opts = { skip = true }
    },
    {
      view = "vsplit",
      filter = { min_height = 20, event = "msg_show" },
    },
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
    -- {
    --   filter = {
    --     event = "msg_show",
    --     kind = {"echo", "echomsg"},
    --     any = {
    --       {find = "<Enter>"}
    --     }
    --   },
    --   view = "confirm" ,
    -- },
    {
      filter = {
        event = "lsp",
        any = {
          { find = "rime_ls", kind = {"progress"}},
          { find = "Use an initialized rime instance" },
        }
      },
      opts = {skip = true}
    },
  },
}


