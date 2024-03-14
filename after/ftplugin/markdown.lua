vim.keymap.set("n", '<c-x>', function()
    require("util").bibkey_action(vim.fn.expand('<cword>'))
end, { desc = "Show action related bibkey" })
