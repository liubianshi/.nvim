local alpha = require "alpha"
local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
}

dashboard.section.buttons.val = {
  dashboard.button("e",       "  > New file",      ":silent ene <BAR> startinsert <CR>"),
  dashboard.button("SPC f f", "󰈞  > Find file",     ":cd $HOME/Documents/Writing | Telescope find_files<CR>"),
  dashboard.button("SPC f r", "  > Recent",        ":Telescope oldfiles<CR>"),
  dashboard.button("SPC n l", "  > Obsidian Note", ":ObsidianQuickSwitch<CR>"),
  dashboard.button("q",       "󰅚  Quit NVIM",       ":qa<CR>"),
}

local handle = io.popen "fortune"
if handle then
  local fortune = handle:read "*a"
  handle:close()
  dashboard.section.footer.val = fortune
end

dashboard.config.opts.noautocmd = true

vim.cmd [[autocmd User AlphaReady echo 'ready']]

-- Send config to alpha
alpha.setup(dashboard.config)

-- Disable folding on alpha buffer
vim.cmd [[
    autocmd FileType alpha setlocal nofoldenable
]]
