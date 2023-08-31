-- Setup nvim-cmp.
local cmp                    = require('cmp')
local compare                = require('cmp.config.compare')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local rimels                 = require("rime-ls")


-- helper_functions ----------------------------------------------------- {{{2
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(t(key), mode, true)
end

local input_method_take_effect = function(entry, method, ignore_probes)
    if not entry then return(false) end

    method = method or "rime-ls"
    if method == "rime-ls" then
        if entry.source.name == "nvim_lsp" and
           entry.source.source.client.name == "rime_ls" and
           rimels.probe_all_passed(ignore_probes) then
            return true
        else
            return false
        end
    end
end

local rimels_auto_upload = function(entries)
    if #entries == 1 then
        if input_method_take_effect(entries[1]) then
            cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
        end
    end
end

-- source config functions ---------------------------------------------- {{{2
local function constuct_cmp_source(sources)
    local function not_exists(s, b)
        for _,v in ipairs(b) do
            if v.name == s.name then return(false) end
        end
        return(true)
    end

    local function gen_cmp_source(ss, base)
        if ss == nil then return base end
        base = base or {}
        for _,v in ipairs(ss) do
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
        {
            name = 'nvim_lsp',
            keyword_length = 1,
            keyword_pattern = '[-/,.?!$<>A-Za-z0-9]\\+',
        },
        -- { name = 'latex_symbols' },
        -- { name = 'orgmode' },
        -- { name = 'treesitter' },
        -- { name = 'ctags' }, 
        -- { name = 'vim-dadbod-completion' },
        -- { name = 'omni' },
    })
    local fallback = gen_cmp_source({
        { name = 'omni' },
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

-- number --------------------------------------------------------------- {{{3
keymap_config['0'] = cmp.mapping(
    function(fallback)
        if not cmp.visible() or not vim.b.rime_enabled then
            return fallback()
        end
        local first_entry  = cmp.core.view:get_first_entry()
        if not input_method_take_effect(first_entry) then
            return fallback()
        end
        if rimels_auto_upload(cmp.core.view:get_entries()) then
            cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
        end
    end, {'i'}
)
for numkey = 1,9 do
    local numkey_str = tostring(numkey)
    keymap_config[numkey_str] = cmp.mapping(
        function(fallback)
            if not cmp.visible() or not vim.b.rime_enabled then
                return fallback()
            else
                local first_entry  = cmp.core.view:get_first_entry()
                if not input_method_take_effect(
                    first_entry,
                    'rime-ls',
                    {"probe_punctuation_after_half_symbol"}) then
                    return fallback()
                end
            end
            cmp.mapping.close()
            feedkey(numkey_str, "n")
            cmp.complete()
            feedkey("0", "m")
        end,
        {"i"}
    )
end

-- <Space> -------------------------------------------------------------- {{{3
keymap_config["<Space>"] = cmp.mapping(
    function(fallback)
        if not cmp.visible() then
            rimels.auto_toggle_rime_ls_with_space()
            return fallback()
        end
        local select_entry = cmp.get_selected_entry()
        local first_entry  = cmp.core.view:get_first_entry()
        local lsp_kinds = require('cmp.types').lsp.CompletionItemKind

        if select_entry then
            if select_entry:get_kind() and
               lsp_kinds[select_entry:get_kind()] ~= 'Text' then
                cmp.confirm({behavior = cmp.ConfirmBehavior.Insert, select = false})
                vim.fn.feedkeys(' ')
            else
                cmp.confirm({behavior = cmp.ConfirmBehavior.Insert, select = false})
            end
        elseif input_method_take_effect(first_entry) then
            cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
        elseif first_entry.source.name == "flypy" then
            cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
        else
            rimels.auto_toggle_rime_ls_with_space()
            return fallback()
        end
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

        local select_entry = cmp.get_selected_entry()
        local first_entry  = cmp.core.view:get_first_entry()
        local entry = select_entry or first_entry

        if not entry then
            return(fallback())
        end

        if (entry.source.name == "nvim_lsp" and
            entry.source.source.client.name == "rime_ls") or
           entry.source.name == "flypy" then
            cmp.abort()
            vim.fn.feedkeys(" ")
        elseif select_entry then
            cmp.confirm()
        else
            fallback()
        end
    end,
    {"i", "s"}
)

-- <bs> ---------------------------------------------------------- {{{3
keymap_config['<BS>'] = cmp.mapping(
    function(fallback)
        if not cmp.visible() then
            local re = rimels.auto_toggle_rime_ls_with_backspace()
            if re == 1 then
                cmp.abort()
                local bs = vim.api.nvim_replace_termcodes("<left>", true, true, true)
                vim.api.nvim_feedkeys(bs, 'n', false)
            else
                fallback()
            end
        else
            fallback()
        end
    end,
    {'i', 's'}
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
    view = 'native',
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
            -- [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]
            border = { '', '', '',  '', '', '', '', {'│', "MyBorder"} },
            winhighlight = "CursorLine:PmenuSel,Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = 0,
            side_padding = 0,
        },
        documentation = {
            border = { '', '', '',  '', '', '', '', {'│', "MyBorder"} },
            winhighlight = "CursorLine:PmenuSel,Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = 0,
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
                kind.menu = "    [other]"
            elseif strings[2] == "Text" then
                kind.kind = ""
                kind.menu = ""
            else
                kind.menu = "    [" .. strings[2] .. "]"
            end
            return kind
        end,
    },
    mapping = cmp.mapping.preset.insert(keymap_config),
    sources = constuct_cmp_source(),
}

-- cmp setup ------------------------------------------------------------ {{{2
cmp.setup(cmp_config)
cmp.setup.filetype({'stata'}, {
    sources = constuct_cmp_source({{name = 'omni'}})
})

cmp.setup.filetype({'pandoc', 'markdown', 'rmd', 'rmarkdown'}, {
    sources = constuct_cmp_source({{name = 'cmp_zotcite'}})
})

-- cmp.setup.filetype({'r'}, {
--     sources = constuct_cmp_source({{name = 'cmp_nvim_r'}})
-- })

-- cmp.setup.filetype({'rmd'}, {
--     sources = constuct_cmp_source({{name = 'cmp_nvim_r'}})
-- })


-- cmp.setup.filetype({'perl', 'python', 'vim', 'bash'}, {
--     sources = constuct_cmp_source({{name = 'nvim_lsp'}})
-- })

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = constuct_cmp_source({{name = 'cmp_git'}})
})

-- Set -- Set configuration for sql
cmp.setup.filetype('sql', {
    sources = constuct_cmp_source({{name = 'vim-dadbod-completion'}})
})

cmp.setup.filetype('norg', {
    sources = constuct_cmp_source({{name = 'neorg'}})
})

-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })


-- vim: set fdm=marker: ------------------------------------------------- {{{1

