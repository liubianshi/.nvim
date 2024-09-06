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
  dashboard.button("e", "  New file",      ":silent ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find file",     ":lua require('telescope').extensions.smart_open.smart_open()<CR>"),
  dashboard.button("n", "  Obsidian Note", ":ObsidianQuickSwitch<CR>"),
  dashboard.button("p", "  Open Project",  ":ProjectChange<CR>"),
  dashboard.button("r", "  Recent",        ":lua vim.cmd.normal(vim.g.mapleader .. 'fz')<cr>"),
  dashboard.button("q", "  Quit",          ":qa<CR>"),
}

local handle = io.popen "fortune"
if handle then
  local fortune = handle:read "*a"
  handle:close()
  dashboard.section.footer.val = fortune
end

dashboard.config.opts.noautocmd = true

local alpha_group = vim.api.nvim_create_augroup("Alpha_Autocmd", { clear = true })
-- vim.cmd [[autocmd User AlphaReady echo 'ready']]
vim.api.nvim_create_autocmd({'User'}, {
  group = alpha_group,
  pattern = "AlphaReady",
  command = "echo 'ready'"
})

-- Send config to alpha
alpha.setup(dashboard.config)

-- Disable folding on alpha buffer
vim.api.nvim_create_autocmd({'FileType'}, {
  group = alpha_group,
  pattern = "*.alpha",
  command = "setlocal nofoldenable nocursorline"
})


