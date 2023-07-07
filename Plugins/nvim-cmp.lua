-- Setup nvim-cmp.
local cmp                    = require('cmp')
local compare                = require('cmp.config.compare')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local rimels                 = require("rime-ls")

-- helper_functions ----------------------------------------------------- {{{2
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local get_word_before = function(s, l)
    l = l or 1
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col < s or s < l then
        return nil
    end
    local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    return line_content:sub(col - s + 1, col - s + l)
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
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
        -- { name = 'omni' },
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

-- number --------------------------------------------------------------- {{{3
for numkey = 2,9 do
    numkey = tostring(numkey)
    keymap_config[numkey] = cmp.mapping(
        function(fallback)
            if not cmp.visible() or not vim.g.rime_enabled then
                return fallback()
            end
            cmp.close()
            feedkey(numkey, "n")
            cmp.complete()
            feedkey("<Space>", "m")
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
        elseif first_entry.source.name == "nvim_lsp" and
               first_entry.source.source.client.name == "rime_ls" and
               rimels.probe_all_passed() then
            -- vim.notify(vim.inspect(first_entry.source.source))
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

        if not entry then return(fallback()) end
        
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

-- <bs> ----------------------------------------------------------
keymap_config['<BS>'] = cmp.mapping(
    function(fallback)
        if not cmp.visible() then
            local re = rimels.auto_toggle_rime_ls_with_backspace()
            fallback()
            if re == 1 then
                cmp.complete()
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
