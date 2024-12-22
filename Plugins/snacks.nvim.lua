
require('snacks').setup {
  bigfile = { enabled = true },
  dashboard = {
    width = 60,
    preset = {
      keys = {
        { icon = " ", key = "e", desc = "New File", action = ":silent ene | startinsert" },
        { icon = " ", key = "f", desc = "Find File", action = ":Oil" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "n", desc = "Obsidian Note", action = ":ObsidianQuickSwitch"},
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", padding = 1, gap = 0 },
      { pane = 1, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 1,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = require('util').get_git_root("") ~= nil,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
      {
        pane = 2,
        section = "terminal",
        enabled = require('util').get_git_root("") == nil,
        cmd = "fortune -s",
        -- height = 6,
        indent = 1,
        ttl = 5 * 60,
        padding = 1,
      },
      { section = "startup" },
    },
  },
  indent = {
    enabled = true,
  },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  quickfile = { enabled = true },
  terminal = { enabled = true },
  statuscolumn = {
    enabled = false,
    folds = {
      open = true,
      git_hl = true,
    }
  },
  scoll = {enabled = true},
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
    Snacks.toggle.animate():map("<leader>ua")
    Snacks.toggle.zen():map("<leader>uz")
    Snacks.toggle.dim():map("<leader>ud")
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
