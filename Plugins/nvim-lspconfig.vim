lua <<EOF

local lspconfig = require('lspconfig')
local opts = { noremap=true, silent=true }

-- Preconfiguration ===========================================================
local on_attach_custom = function(client, bufnr)
  local function buf_set_option(name, value)
    vim.api.nvim_buf_set_option(bufnr, name, value)
  end

  buf_set_option('omnifunc', 'v:lua.MiniCompletion.completefunc_lsp')

  -- Mappings are created globally for simplicity

  -- Currently all formatting is handled with 'null-ls' plugin
  client.resolved_capabilities.document_formatting = false
end

-- R (r_language_server) =================================================
lspconfig.r_language_server.setup({
  on_attach = on_attach_custom,
  -- Debounce "textDocument/didChange" notifications because they are slowly
  -- processed (seen when going through completion list with `<C-N>`)
  flags = { debounce_text_changes = 150 },
})

-- Python (pyright) ======================================================
lspconfig.pyright.setup({ on_attach = on_attach_custom })


EOF
