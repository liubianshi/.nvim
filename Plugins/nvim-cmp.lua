-- Setup nvim-cmp.
local cmp = require "cmp"
local compare = require "cmp.config.compare"
local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
require("cmp_r").setup { filetypes = { "r", "rmd", "markdown", "rdoc" } }
vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
-- if not PlugExist('cmp-lsp-rimels') and vim.fn.has('nvim-0.10.2') ~= 1 then
--   vim.notify("Launch rimels minimal config for test", vim.log.levels.INFO)
--   require('rimels_test').setup_rime()
-- end

-- kinds icons
local icon_kinds = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Codeium = "󰘦 ",
  Color = " ",
  Control = " ",
  Collapsed = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = "󰊕 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = "󰆼 ",
  TabNine = "󰏚 ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "󰀫 ",
}

-- source config functions ---------------------------------------------- {{{2
local function construct_cmp_source(sources)
  local function not_exists(s, b)
    for _, v in ipairs(b) do
      if v.name == s.name then
        return false
      end
    end
    return true
  end

  local function gen_cmp_source(ss, base)
    if ss == nil then
      return base
    end
    base = base or {}
    for _, v in ipairs(ss) do
      if not_exists(v, base) then
        table.insert(base, v)
      end
    end
    return base
  end
  local default = gen_cmp_source {
    { name = "ultisnips" }, -- For ultisnips users.
    { name = "async_path", option = { trailing_slash = true } },
    {
      name = "nvim_lsp",
      keyword_length = 1,
      option = {
        -- r_language_server = {
        --   keyword_pattern = "[-_$:A-Za-z0-9]\\+",
        -- },
        rime_ls = {
          keyword_pattern = "[-?:<>,&{}!\\.a-z0-9]\\+",
        },
        markdown_oxide = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
        },
        marksman = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
        },
      },
    },
    { name = "buffer" },
    { name = "ctags" },
    { name = "nvim_lsp_signature_help" },
    -- { name = 'latex_symbols' },
    -- { name = 'orgmode' },
    -- { name = 'treesitter' },
    -- { name = 'vim-dadbod-completion' },
    -- { name = 'omni' },
  }
  local fallback = gen_cmp_source {
    { name = "omni" },
  }
  return (cmp.config.sources(gen_cmp_source(sources, default), fallback))
end

-- key adjust ----------------------------------------------------------- {{{2
local keymap_config = {
  ["<C-k>"] = cmp.mapping.scroll_docs(-4),
  ["<C-j>"] = cmp.mapping.scroll_docs(4),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<C-Space>"] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ["<TAB>"] = cmp.mapping {
    i = function(fallback)
      if cmp.visible() and vim.fn.getline('.'):sub(0, vim.fn.col('.') - 1):find("[^%s]") then
        cmp.select_next_item { behavior = cmp.SelectBehavior.select }
      else
        fallback()
      end
    end,
    s = function(fallback)
      if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(
            "<Plug>(ultisnips_jump_forward)",
            true,
            true,
            true
          ),
          "m",
          true
        )
      else
        fallback()
      end
    end,
  },
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if vim.fn.getline('.'):sub(0, vim.fn.col('.') - 1):find("[^%s]") then
      cmp_ultisnips_mappings.jump_backwards(fallback)
    else
      vim.cmd [[
        stopinsert
        normal <<
        startinsert
      ]]
    end
  end, { "i", "s" }),
}
-- sorting -------------------------------------------------------------- {{{2
local sorting_config = {
  priority_weight = 2,
  comparators = {
    compare.offset,
    compare.exact,
    compare.sort_text,
    compare.recently_used,
    compare.locality,
    compare.score,
    compare.length,
    compare.order,
  },
}
-- cmp_config ----------------------------------------------------------- {{{2
local border = require("util").border("▔", "bottom")
local cmp_config = {
  enabled = function()
    local disabled = false
    -- disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
    disabled = disabled or (vim.fn.reg_recording() ~= "")
    disabled = disabled or (vim.fn.reg_executing() ~= "")
    return not disabled
  end,
  menu = {},
  completion = { keyword_length = 2 },
  sorting = sorting_config,
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = {
      border = border,
      -- border = { "", "", "", "", "", "", "", "" },
      -- winhighlight = "CursorLine:PmenSel,Normal:MyPmenu,Pmenu:MyPmenu,FloatBorder:Pmenu,Search:None",
      winhighlight = "Pmenu:NormalFloat",
      col_offset = 0,
      side_padding = 0,
    },
    documentation = {
      border = border,
      -- winhighlight = "CursorLine:PmenuSel,NormalFloat:MyPmenu,Pmenu:MyPmenu,FloatBorder:Pmenu,Search:None",
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format {
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...", -- the truncated part when popup menu exceed maxwidth
      }(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (icon_kinds[strings[1]] or strings[1] .. " ")
      if strings[2] == nil then
        kind.menu = "    [" .. (strings[1] or "other") .. "] "
      elseif strings[2] == "Text" then
        kind.kind = ""
        kind.menu = ""
      else
        kind.menu = "    [" .. strings[2] .. "] "
      end
      return kind
    end,
  },
  experimental = {
    -- ghost_text = {
    --   hl_group = "CmpGhostText",
    -- },
  },
  matching = {
    disallow_fuzzy_matching = true,
    disallow_fullfuzzy_matching = true,
    disallow_symbol_nonprefix_matching = true,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = true,
    disallow_prefix_unmatching = false,
  },
  mapping = cmp.mapping.preset.insert(keymap_config),
  sources = construct_cmp_source(),
}

-- cmp setup ------------------------------------------------------------ {{{2
cmp.setup(cmp_config)

cmp.setup.filetype({ "stata" }, {
  sources = construct_cmp_source { { name = "omni" } },
})

-- cmp.setup.filetype({ "pandoc", "markdown" }, {
--   sources = construct_cmp_source {
--     { name = "dictionary", keyword_length = 2 },
--   },
-- })

cmp.setup.filetype({ "r", "rmd" }, {
  sources = construct_cmp_source {
    {
      name = "cmp_r",
      trigger_characters = {" ", ":", "(", '"', "@", "$"},
      keyword_pattern = "[`\\._@\\$:_[:digit:][:lower:][:upper:]]*",
    },
  },
})

-- cmp.setup.filetype({'perl', 'python', 'vim', 'bash'}, {
--     sources = construct_cmp_source({{name = 'nvim_lsp'}})
-- })

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = construct_cmp_source { { name = "cmp_git" } },
})

cmp.setup.filetype("lua", {
  sources = construct_cmp_source {
    { name = "lazydev", group_index = 0 },
  },
})

-- Set -- Set configuration for sql
cmp.setup.filetype("sql", {
  sources = construct_cmp_source { { name = "vim-dadbod-completion" } },
})

cmp.setup.filetype("norg", {
  sources = construct_cmp_source { { name = "neorg" } },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

cmp.setup.cmdline("@", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "nvim_lsp" },
  }, {
    { name = "cmdline" },
  }),
})

local function restart_cmp()
  local config = require "cmp.config"
  local cmp_sources = {}

  for _, s in ipairs(config.get().sources) do
    local source_config = config.get_source_config(s.name)
    if source_config then
      table.insert(cmp_sources, source_config)
    end
  end

  -- vim.notify(vim.inspect(cmp_sources))
  cmp.setup.buffer { sources = cmp.config.sources(cmp_sources) }
end
vim.api.nvim_create_user_command('CmpRestart', restart_cmp, { desc = 'Restart cmp' })


