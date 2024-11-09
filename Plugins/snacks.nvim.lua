require('snacks').setup {
  bigfile = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  quickfile = { enabled = true },
  terminal = { enabled = true },
  statuscolumn = {
    enabled = true,
    folds = {
      open = true,
      git_hl = true,
    }
  },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true } -- Wrap notifications
    }
  }
}

--- @diagnostic disable: undefined-field
local Snacks = _G.Snacks

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command

    -- Create some toggle mappings
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end,
})

local map = vim.keymap.set
map("n", "<leader>un", function() Snacks.notifier.hide()           end, { desc = "Dismiss All Notifications"    })
map("n", "<leader>bd", function() Snacks.bufdelete()               end, { desc = "Delete Buffer"                })
map("n", "<leader>gg", function() Snacks.lazygit()                 end, { desc = "Lazygit"                      })
map("n", "<leader>gb", function() Snacks.git.blame_line()          end, { desc = "Git Blame Line"               })
map("n", "<leader>gB", function() Snacks.gitbrowse()               end, { desc = "Git Browse"                   })
map("n", "<leader>gf", function() Snacks.lazygit.log_file()        end, { desc = "Lazygit Current File History" })
map("n", "<leader>gl", function() Snacks.lazygit.log()             end, { desc = "Lazygit Log (cwd)"            })
map("n", "<leader>cR", function() Snacks.rename()                  end, { desc = "Rename File"                  })
map("n", "<c-/>",      function() Snacks.terminal()                end, { desc = "Toggle Terminal"              })
map("n", "<c-_>",      function() Snacks.terminal()                end, { desc = "which_key_ignore"             })
map("n", "]]",         function() Snacks.words.jump(vim.v.count1)  end, { desc = "Next Reference"               })
map("n", "[[",         function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference"               })
