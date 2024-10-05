local dap = require "dap"
local dapui = require "dapui"

-- setting -------------------------------------------------------------- {{{1
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
dap.set_log_level "DEBUG"

-- Perl ----------------------------------------------------------------- {{{1
dap.adapters.perl = {
  type = "executable",
  command = "perl-debug-adapter",
  args = {},
}

dap.configurations.perl = {
  {
    type = "perl",
    request = "launch",
    name = "Launch Perl",
    program = "${workspaceFolder}/${relativeFile}",
  },
}

-- R -------------------------------------------------------------------- {{{1
dap.adapters.r = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a R `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'r',
      },
    })
  else
    -- work-in-progress, execute/launch mode
    error("R DAP only configured for attach-mode")
  end
end

dap.configurations.r = {
  {
    type = 'r',
    request = 'attach',
    name = 'Attach to R process',
    host = "localhost",
    port = 18721
  }
}

-- Keymap --------------------------------------------------------------- {{{1
vim.api.nvim_set_keymap(
  "n",
  "<F5>",
  '<Cmd>lua require"dap".continue()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<F10>",
  '<Cmd>lua require"dap".step_over()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<F11>",
  '<Cmd>lua require"dap".step_into()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<F12>",
  '<Cmd>lua require"dap".step_out()<CR>',
  { noremap = true, silent = true }
)
