vim.keymap.set("n", '<c-x>', function()
    require("util").bibkey_action(vim.fn.expand('<cword>'))
end, { desc = "Show action related bibkey" })

vim.keymap.set("n", '<localleader>rf', function()
    vim.api.nvim_buf_set_option(0, "filetype", "rmd")
    local cmp = require('cmp')
    local config = require('cmp.config')
    local cmp_sources = {}
    for _, s in pairs(cmp.core.sources) do
        if config.get_source_config(s.name) and s:is_available() then
            table.insert(cmp_sources, config.get_source_config(s.name))
        end
    end
    vim.api.nvim_buf_set_option(0, "filetype", "markdown")
    cmp_sources[#cmp_sources + 1] = {
        name = "cmp_r",
        group_index = 2,
    }
    cmp.setup.buffer( { sources = cmp.config.sources(cmp_sources) })
end, { desc = "Start R.nvim"})
