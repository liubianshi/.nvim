require'cmp_zotcite'.setup({
    filetypes = {"pandoc", "markdown", "rmd", "quarto"}
})

vim.api.nvim_create_user_command(
    'ToggleCmpZotCite',
    function()
        if vim.b.cmp_zotcite_enable then
            vim.b.cmp_zotcite_enable = false
        else
            vim.b.cmp_zotcite_enable = true 
        end
    end, { nargs = 0}
)
