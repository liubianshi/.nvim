require("noice").setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  messages = {
    enabled = false,
    view = "notify",
    view_warn = "mini",
  },
  popupmenu = {
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
          position = {
            row = "100%", -- 将行位置设置为 100%，即底部
            col = "50%", -- 将列位置设置为 50%，即居中
          },
        },
      },
      search_up = {
        opts = {
          position = {
            row = "100%", -- 将行位置设置为 100%，即底部
            col = "50%", -- 将列位置设置为 50%，即居中
          },
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
      view = "vsplit",
      filter = { min_height = 20 },
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
  },
}
