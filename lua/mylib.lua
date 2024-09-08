local fzflua = require "fzf-lua"

vim.keymap.set("n", "<leader>sq", function()
  fzflua.fzf_exec("mylib list", {
    actions = {
      ["default"] = function(selected, _)
        vim.notify(vim.inspect(selected))
      end,
    },
  })
end, { desc = "Open my library file", silent = true, noremap = true})
