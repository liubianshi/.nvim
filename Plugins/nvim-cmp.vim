lua <<EOF
-- Setup nvim-cmp.
local cmp = require'cmp'

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
    '♛ [type]'
}

local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
cmp.setup({
    menu = {

    },
    completion = {
        keyword_length = 2,
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "    (" .. strings[2] .. ")"

            return kind
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local selected_entry = cmp.get_selected_entry()
                if selected_entry then
                    if selected_entry.source.name == "flypy" then
                        cmp.abort()
                        vim.fn.feedkeys(" ")
                    else
                        cmp.confirm()
                    end
                else
                    fallback()
                end
            else
                fallback()
            end
        end, {"i", "s"}
        ),
        ["<Space>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local selected_entry = cmp.core.view:get_selected_entry()
                if selected_entry
                    and selected_entry.source.name == "flypy"
                    and not cmp.confirm({select=true}) then
                     return fallback()
                end
            end
            fallback()
        end, {"i","s",}),
        ['<C-Space>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
        ["<Tab>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
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
        }), 
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                cmp_ultisnips_mappings.jump_backwards(fallback)
            end, {"i", "s"}
        ),
    }),
    sources = cmp.config.sources({
        { name = 'flypy' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'cmdline' },
        { name = 'latex_symbols' },
        { name = 'orgmode' },
        { name = 'treesitter' },
        { name = 'ctags' }, 
        { name = 'vim-dadbod-completion' },
    }, {
        { name = 'omni' },
        { name = 'path' },
        {name = 'buffer'}
    }),
})


-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = {
    'jedi_language_server',
    'tsserver',
    'perlpls',
    'r_language_server',
}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
      capabilities = capabilities,
  }
end

EOF
