local dap = require "dap"
local dapui = require "dapui"
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

dap.adapters.r = {
  type = "server",
  port = "18721",
  executable = {
    command = "R",
    args = { "--slave", "-e", "vscDebugger::.vsc.listenForDAP()" },
  },
}

dap.configurations.r = {
  -- {
  --     type = "R-Debugger",
  --     name = "Debug R-Function",
  --     request = "launch",
  --     debugMode = "function",
  --     workingDirectory = '${workspaceFolder}',
  --     file = "${file}",
  --     allowGlobalDebugging = false,
  -- },
  {
    type = "r",
    name = "Debug R-File",
    request = "attach",
    debugMode = "file",
    stopOnEntry = false,
  },
}

-- dap.set_log_level "TRACE"
dap.set_log_level "DEBUG"

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
