local lspconfig = require('lspconfig')
local util = require 'lspconfig.util'
local lspmap = function(key, desc, cmd, opts)
    opts = opts or {}
    local mode = opts.mode or 'n'
    opts.mode = nil
    opts = vim.tbl_extend("keep", opts or {}, {
        desc = "LSP: " .. desc,
        silent = true,
        noremap = true,
    })
    vim.keymap.set(mode, key, cmd, opts)
end
lspmap('[d', "Jump to previous diagnostic", vim.diagnostic.goto_prev)
lspmap(']d', "Jump to next diagnostic",     vim.diagnostic.goto_next)

-- vim.keymap.set('n', '<space>te', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '<space>tq', vim.diagnostic.setloclist, opts)

-- Preconfiguration ----------------------------------------------------------- {{{2
local on_attach_custom = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { buffer=bufnr }
    lspmap('gD', "Declaration",    vim.lsp.buf.declaration,    bufopts)
    lspmap('gd', "Definition",     vim.lsp.buf.definition,     bufopts)
    lspmap('gr', "References",     vim.lsp.buf.references,     bufopts)
    lspmap('<leader>cr', "Rename",         vim.lsp.buf.rename,         bufopts)
    lspmap('gi', "Implementation", vim.lsp.buf.implementation, bufopts)
    lspmap('gk', "Hover",          vim.lsp.buf.hover,          bufopts)
    lspmap('gK', "Signature_help", vim.lsp.buf.signature_help, bufopts)
end

local capabilities = (function()
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        return cmp_nvim_lsp.default_capabilities()
    else
        return nil
    end
end)()

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
        vim.env.HOME .. "/Repositories/PerlNavigator/server/out/server.js",
        "--stdio"
    },
    capabilities = capabilities,
    single_file_support = true,
    on_attach = on_attach_custom,
})

-- lua (lua-language-server) -------------------------------------------- {{{2
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  single_file_support = true,
  on_attach = on_attach_custom,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
-- rime-ls -------------------------------------------------------------- {{{2
local rimels_ok, rime_ls = pcall(require, 'rime-ls')
if rimels_ok then
    rime_ls.setup_rime({load = true})
end

