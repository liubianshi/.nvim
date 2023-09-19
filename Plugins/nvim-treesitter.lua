local ts = require'nvim-treesitter.configs'
ts.setup({
    modules = {},
    ensure_installed = { "r", "bash", "vim", "org", "lua", "dot",
                        "markdown", "markdown_inline", "bibtex", "css", "json",
    },
    sync_install = false,
    auto_install = true,
    ignore_install = {"javascript", "css", "json"},

    highlight = {
        enable = true,
        disable = {'r', 'vim', 'tsv'},
        additional_vim_regex_highlighting = {'org'},
    },
    indent = {
        enable = false,
    },
})
