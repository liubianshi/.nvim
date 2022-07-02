lua <<EOF
require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "r",
        "perl",
        "python",
        "bash",
        "vim",
        "lua",
        "javascript",
        "markdown",
        "markdown_inline",
        "c",
        "bibtex",
        "css",
        "json",
    },
    sync_install = false,

    highlight = {
        enable = true,
        disable = { "c" },
        additional_vim_regex_highlighting = false,
    },
}
EOF
