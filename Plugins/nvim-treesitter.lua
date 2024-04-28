local ts = require'nvim-treesitter.configs'
vim.treesitter.language.register("markdown", "rmd")
ts.setup({
    modules = {},
    ensure_installed = { "r",       "bash",            "vim",    "org",   "lua",  "dot", 'perl',
                        "markdown", "markdown_inline", "bibtex", "css",   "json",
                        "vim",      "vimdoc",          "query",  "latex", "jq", 'rnoweb'
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {"javascript", "css", "json"},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = {"markdown"},
        disable = function(lang, buf)
            local disable_lang_list = {'tsv', 'perl', 'markdown'}
            for _, v in ipairs(disable_lang_list) do
                if v == lang then return true end
            end
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
    indent = {
        enable = true,
    },
})
