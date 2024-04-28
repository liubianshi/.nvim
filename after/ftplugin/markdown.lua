vim.keymap.set("n", '<c-x>', function()
    require("util").bibkey_action(vim.fn.expand('<cword>'))
end, { desc = "Show action related bibkey" })

vim.keymap.set("n", '<localleader>rf', function()
    vim.api.nvim_buf_set_option(0, "filetype", "rmd")
    vim.fn.timer_start(700, function() -- wait rnvimserver start
        require('r.run').start_R('R')
    end)
    local cmp = require('cmp')
    local config = require('cmp.config')
    local cmp_sources = {}
    for _, s in pairs(cmp.core.sources) do
        if config.get_source_config(s.name) and s:is_available() then
            table.insert(cmp_sources, config.get_source_config(s.name))
        end
    end
    cmp_sources[#cmp_sources + 1] = {
        name = "cmp_r",
        group_index = 1,
        option = {filetypes = {'r', 'rmd', 'markdown'}},
    }
    vim.notify(vim.inspect(cmp.config.sources(cmp_sources) ))
    cmp.setup.buffer( { sources = cmp.config.sources(cmp_sources) })
    vim.api.nvim_buf_set_option(0, "filetype", "markdown")
end, { desc = "Start R.nvim"})
