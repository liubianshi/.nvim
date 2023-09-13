local ts = require'nvim-treesitter.configs'
ts.setup({
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "r",
        -- "perl",
        "python",
        "bash",
        "vim",
        "org",
        "lua",
        "dot",
        "javascript",
        "markdown",
        "markdown_inline",
        "c",
        "bibtex",
        "css",
        "json",
    },
    sync_install = false,
    auto_install = true,
    ignore_install = {"javascript", "css", "json"},

    highlight = {
        enable = true,
        disable = {'r', 'vim'},
        additional_vim_regex_highlighting = {'org'},
    },
    indent = {
        enable = {"r"},
    },
})
