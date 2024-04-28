vim.keymap.set("n", '<c-x>', function()
    require("util").bibkey_action(vim.fn.expand('<cword>'))
end, { desc = "Show action related bibkey" })

vim.keymap.set("n", '<localleader>rf', function()
    vim.api.nvim_buf_set_option(0, "filetype", "rmd")
    vim.fn.timer_start(700, function() -- wait rnvimserver start
        require('r.run').start_R('R')
    end)
    local cmp = require('cmp')
    local cmp_sources = cmp.core.sources
    cmp_sources[#cmp_sources + 1] = { name = "cmp_r", group_index = 2 }
    cmp.setup.buffer { sources = cmp_sources }
    vim.api.nvim_buf_set_option(0, "filetype", "markdown")
end, { desc = "Start R.nvim"})
