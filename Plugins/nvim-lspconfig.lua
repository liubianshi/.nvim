local lspconfig = require('lspconfig')
local util = require 'lspconfig.util'
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d',       vim.diagnostic.goto_prev,  opts)
vim.keymap.set('n', ']d',       vim.diagnostic.goto_next,  opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Preconfiguration ----------------------------------------------------------- {{{2
local on_attach_custom = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD',        vim.lsp.buf.declaration,             bufopts)
    vim.keymap.set('n', 'gd',        vim.lsp.buf.definition,              bufopts)
    vim.keymap.set('n', 'gk',        vim.lsp.buf.hover,                   bufopts)
    vim.keymap.set('n', 'gi',        vim.lsp.buf.implementation,          bufopts)
    vim.keymap.set('n', '<C-k>',     vim.lsp.buf.signature_help,          bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,    bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    -- vim.keymap.set('n', '<space>D',  vim.lsp.buf.type_definition,         bufopts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename,                  bufopts)
    -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,             bufopts)
    vim.keymap.set('n', 'gr',        vim.lsp.buf.references,              bufopts)
    -- vim.keymap.set('n', '<space>f',  function()
    --     vim.lsp.buf.format { async = true }
    -- end, bufopts)
end
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
   local capabilities = cmp_nvim_lsp.default_capabilities()
end

-- bashls (bash-language-server) ---------------------------------------- {{{2
lspconfig.bashls.setup{
    capabilities = capabilities,
    on_attach = on_attach_custom,
}

-- R (r_language_server) ------------------------------------------------ {{{2
lspconfig.r_language_server.setup({
    cmd = {
        "R", "--slave", 
        "--default-packages=" .. vim.g.R_start_libs,
        "-e", "languageserver::run()"
    },
    capabilities = capabilities,
    on_attach = on_attach_custom,
    root_dir = util.root_pattern(".git", ".vim", "NAMESPACE"),
    single_file_support = true,
    flags = {
      debounce_text_changes = 150
    },
})

-- Python (pyright) ----------------------------------------------------- {{{2
-- lspconfig.pyright.setup({ on_attach = on_attach_custom })
lspconfig.jedi_language_server.setup({
    capabilities = capabilities,
    on_attach = on_attach_custom
})

-- vim (vimls) ---------------------------------------------------------- {{{2
lspconfig.vimls.setup{
    capabilities = capabilities,
    on_attach = on_attach_custom
}

-- perl (perlls) -------------------------------------------------------- {{{2
lspconfig.perlnavigator.setup({
    cmd = {
        'node',
        "/home/liubianshi/Repositories/PerlNavigator/server/out/server.js",
        "--stdio"
    },
    capabilities = capabilities,
    on_attach = on_attach_custom,
})

-- rime-ls -------------------------------------------------------------- {{{2
local status_ok, rime_ls = pcall(require, 'rime-ls')
if status_ok then
    rime_ls.setup_rime({load = true})
end

