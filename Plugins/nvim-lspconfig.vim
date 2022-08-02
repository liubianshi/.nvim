lua <<EOF

local lspconfig = require('lspconfig')
local opts = { noremap = true, silent = true }

-- Preconfiguration ===========================================================
local on_attach_custom = function(client, bufnr)
  local function buf_set_option(name, value)
    vim.api.nvim_buf_set_option(bufnr, name, value)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings are created globally for simplicity
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  -- Currently all formatting is handled with 'null-ls' plugin
  client.resolved_capabilities.document_formatting = false
end

-- bashls (bash-language-server) ========================================
lspconfig.bashls.setup{
    on_attach = on_attach_custom,
}

-- R (r_language_server) =================================================
lspconfig.r_language_server.setup({
    on_attach = on_attach_custom,
    -- Debounce "textDocument/didChange" notifications because they are slowly
    -- processed (seen when going through completion list with `<C-N>`)
    flags = {
      debounce_text_changes = 150

    },
})

-- Python (pyright) ======================================================
-- lspconfig.pyright.setup({ on_attach = on_attach_custom })
lspconfig.jedi_language_server.setup({ on_attach = on_attach_custom })

-- vim (vimls) ===========================================================
lspconfig.vimls.setup{ on_attach = on_attach_custom }

-- perl (perlls) =========================================================
lspconfig.perlls.setup({
    on_attach = on_attach_custom,
    single_file_support = true,
})

EOF
