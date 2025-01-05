local blink = require('blink.cmp')

local keymaps = {
  preset = 'none',
  ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  ['<Tab>'] = {'select_next', 'fallback'},
  ['<S-Tab>'] = {'select_prev', 'fallback'},
  ['<C-p>'] = { 'scroll_documentation_up', 'fallback' },
  ['<C-n>'] = { 'scroll_documentation_down', 'fallback' },
  ['<C-e>'] = { 'hide', 'fallback' },
  ['<CR>'] = { 'fallback' },
}

local ime_ok, ime = pcall(require, "ime-toggle.blink-setting")
local rimels_ok, rimels = pcall(require, "rimels")
if ime_ok then
  keymaps = vim.tbl_extend("force", keymaps, ime.mapping)
end
if rimels_ok then
  keymaps = vim.tbl_extend("force", keymaps, rimels.get_keymaps())
end

local border = require("util").border("▔", "bottom")
local opts = {
  keymap = keymaps,
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
    kind_icons = {
      Text = ""
    }
  },

  completion = {
    accept = {
      auto_brackets = { enabled = false },
    },
    documentation = {
      window = { border = border },
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    keyword = {
      range = 'prefix',
      regex = '[-_,.:\\?!]\\|[A-Za-z0-9]'
    },
    trigger = {
      prefetch_on_insert = true,
      show_on_keyword = true,
      show_on_trigger_character = true,
      show_on_insert_on_trigger_character = true,
      show_on_accept_on_trigger_character = true,
    },
    list = { selection = function(ctx) return ctx.mode == "cmdline" and 'auto_insert' or 'preselect' end },
    menu = {
      border = border,
      auto_show = true,
      draw = {
        treesitter = { "lsp" },
      },
    },
  },

  signature = { enabled = true },

  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'cmp_r' },
    providers = {
      lsp = {
        enabled = true,
        transform_items = function(_, items)
          -- the default transformer will do this
          for _, item in ipairs(items) do
            if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
              item.score_offset = item.score_offset - 3
            end
            if
              item.kind == require('blink.cmp.types').CompletionItemKind.Text
              and item.source_id == "lsp"
              and vim.lsp.get_client_by_id(item.client_id).name == "rime_ls"
            then
              item.score_offset = 99
            end
          end
          -- you can define your own filter for rime item
          return items

        end
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
      cmp_r = {
        name = "cmp_r",
        module = 'blink.compat.source',
        enabled = function()
          return vim.tbl_contains({ "r", "rmd", "quarto", "rdoc" }, vim.bo.filetype)
        end,
        opts = {
          trigger_characters = {" ", ":", "(", '"', "@", "$"},
          keyword_pattern = "[-`\\._@\\$:_[:digit:][:lower:][:upper:]]*",
        }
      }
    },
  },
}

blink.setup(opts)

