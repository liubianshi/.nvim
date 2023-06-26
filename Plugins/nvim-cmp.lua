-- Setup nvim-cmp.
local cmp                    = require('cmp')
local compare                = require('cmp.config.compare')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

-- helper_functions
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- source config functions ---------------------------------------------- {{{2
local function constuct_cmp_source(sources)
    local function not_exists(s, b)
        for _,v in ipairs(b) do
            if v.name == s.name then return(false) end
        end
        return(true)
    end

    local function gen_cmp_source(sources, base) 
        if sources == nil then return base end
        base = base or {}
        for _,v in ipairs(sources) do
            if not_exists(v, base) then table.insert(base, v) end
        end
        return(base)
    end
    local default = gen_cmp_source({
        -- { name = 'flypy' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'async_path', option = { trailing_slash = true }},
        --{ name = 'nvim_lsp_signature_help' },
        --{ name = 'cmdline' },
        { name = 'nvim_lsp' },
        -- { name = 'latex_symbols' },
        { name = 'orgmode' },
        -- { name = 'treesitter' },
        -- { name = 'ctags' }, 
        -- { name = 'vim-dadbod-completion' },
        { name = 'omni' },
    })
    local fallback = gen_cmp_source({
        { name = "buffer"}
    })
    return(cmp.config.sources(gen_cmp_source(sources, default), fallback))
end

-- Item Kind ------------------------------------------------------------ {{{2
vim.lsp.protocol.CompletionItemKind = {
    ' [text]',
    ' [method]',
    ' [function]',
    ' [constructor]',
    'ﰠ [field]',
    ' [variable]',
    ' [class]',
    ' [interface]',
    ' [module]',
    ' [property]',
    ' [unit]',
    ' [value]',
    ' [enum]',
    ' [key]',
    '﬌ [snippet]',
    ' [color]',
    ' [file]',
    ' [reference]',
    ' [folder]',
    ' [enum member]',
    ' [constant]',
    ' [struct]',
    '⌘ [event]',
    ' [operator]',
    '« [type]'
}

-- key adjust ----------------------------------------------------------- {{{2
local keymap_config = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-Space>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
    }),
    ["<S-Tab>"] = cmp.mapping(
        function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
        end, {"i", "s"}
    ),
}

-- <Space> -------------------------------------------------------------- {{{3
keymap_config["<Space>"] = cmp.mapping(
    function(fallback)
        if not cmp.visible() then
            return fallback()
        end
        local entry = cmp.get_selected_entry()
        if entry == nil then
            entry = cmp.core.view:get_first_entry()
        end
        if entry and entry.source.name == "nvim_lsp"
                 and entry.source.source.client.name == "rime_ls" then
            cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            })
        elseif entry.source.name == "flypy" then
            cmp.confirm({select=true})
        end
        fallback()
    end,
    {"i","s"}
)

-- <Tab> ---------------------------------------------------------------- {{{3
keymap_config["<Tab>"] = cmp.mapping({
    i = function(fallback)
        if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.select })
        else
            fallback()
        end
    end,
    s = function(fallback)
        if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
        else
            fallback()
        end
    end,
}) 

-- <CR> ----------------------------------------------------------------- {{{3
keymap_config['<CR>'] = cmp.mapping(
    function(fallback)
        if not cmp.visible() then return(fallback()) end

        local entry = cmp.get_selected_entry()
        if not entry then return(fallback()) end
        
        if entry.source.name == "nvim_lsp" and
           entry.source.source.client.name == "rime_ls" then
            cmp.abort()
            vim.fn.feedkeys(" ")
        elseif entry.source.name == "flypy" then
            cmp.abort()
            vim.fn.feedkeys(" ")
        else
            cmp.confirm()
        end
    end,
    {"i", "s"}
)

-- sorting -------------------------------------------------------------- {{{2
local sorting_config = {
    comparators = {
        compare.sort_text,
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        compare.kind,
        compare.length,
        compare.order,
    }
}
-- cmp_config ----------------------------------------------------------- {{{2
local cmp_config = {
    menu = {},
    completion = { keyword_length = 1 },
    sorting = sorting_config,
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        completion = {
            winhighlight = "CursorLine:PmenuSel,Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = '...', -- the truncated part when popup menu exceed maxwidth
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            if strings[2] == nil then
                kind.menu = "    (other)"
            else
                kind.menu = "    (" .. strings[2] .. ")"
            end
            return kind
        end,
    },
    mapping = cmp.mapping.preset.insert(keymap_config),
    sources = constuct_cmp_source(),
}

-- cmp setup ------------------------------------------------------------ {{{2
cmp.setup(cmp_config)
-- cmp.setup.filetype({'pandoc', 'markdown', 'rmd', 'rmarkdown'}, {
--     sources = constuct_cmp_source({{name = 'cmp_zotcite'}})
-- })

cmp.setup.filetype({'r'}, {
    sources = constuct_cmp_source({{name = 'cmp_nvim_r'}})
})

cmp.setup.filetype({'rmd'}, {
    sources = constuct_cmp_source({{name = 'cmp_nvim_r'}, {name = 'cmp_zotcite'}})
})


cmp.setup.filetype({'perl', 'python', 'vim', 'bash'}, {
    sources = constuct_cmp_source({{name = 'nvim_lsp'}})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = constuct_cmp_source({{name = 'cmp_git'}})
})

-- Set -- Set configuration for sql
cmp.setup.filetype('sql', {
    sources = constuct_cmp_source({{name = 'vim-dadbod-completion'}})
})

-- autopairs ------------------------------------------------------------ {{{2
local status_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if status_ok then
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    local handlers = require('nvim-autopairs.completion.handlers')
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done({
            filetypes = {
            -- "*" is a alias to all filetypes
            ["*"] = {
                ["("] = {
                kind = {
                    cmp.lsp.CompletionItemKind.Function,
                    cmp.lsp.CompletionItemKind.Method,
                },
                handler = handlers["*"]
                }
            },
            lua = {
                ["("] = {
                kind = {
                    cmp.lsp.CompletionItemKind.Function,
                    cmp.lsp.CompletionItemKind.Method
                },
                ---@param char string
                ---@param item item completion
                ---@param bufnr buffer number
                handler = function(char, item, bufnr)
                    -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr})
                end
                }
            },
            -- Disable for tex
            tex = false
            }
        })
    )
end
