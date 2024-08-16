local rime_shared_data_dir = "/usr/share/rime-data"
local rime_user_dir = "~/.local/share/rime-ls"

local M = {}

function M.setup_rime()
  -- global status
  vim.g.rime_enabled = false

  local lspconfig = require('lspconfig')
  local configs = require('lspconfig.configs')
  if not configs.rime_ls then
    configs.rime_ls = {
      default_config = {
        name = "rime_ls",
        cmd = vim.lsp.rpc.connect('127.0.0.1', 9257),
        filetypes = { '*' },
        single_file_support = true,
      },
      settings = {},
      docs = {
        description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
      }
    }
  end

  local rime_on_attach = function(client, _)
    local toggle_rime = function()
      client.request('workspace/executeCommand',
        { command = "rime-ls.toggle-rime" },
        function(_, result, ctx, _)
          if ctx.client_id == client.id then
            vim.g.rime_enabled = result
          end
        end
      )
    end
    -- keymaps for executing command
    vim.keymap.set('i', ';f', function() toggle_rime() end)
    vim.keymap.set('i', '<C-x>', function() toggle_rime() end)
    vim.keymap.set('n', '<leader>rs', function() vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" }) end)
  end

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  lspconfig.rime_ls.setup {
    init_options = {
      enabled = vim.g.rime_enabled,
      shared_data_dir = rime_shared_data_dir,
      user_data_dir = rime_user_dir,
      log_dir = rime_user_dir,
      max_candidates = 9,
      trigger_characters = {},
      schema_trigger_character = "&" -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
    },
    on_attach = rime_on_attach,
    capabilities = capabilities,
  }
end

return M
