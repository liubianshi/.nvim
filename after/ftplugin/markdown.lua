vim.keymap.set("n", '<c-x>', function()
    require("util").bibkey_action(vim.fn.expand('<cword>'))
end, { desc = "Show action related bibkey" })

vim.keymap.set("n", '<localleader>rf', function()
    vim.api.nvim_buf_set_option(0, "filetype", "rmd")
    vim.fn.timer_start(700, function() -- wait rnvimserver start
        require('r.run').start_R('R')
    end)
    vim.api.nvim_buf_set_option(0, "filetype", "markdown")
end, { desc = "Start R.nvim"})
