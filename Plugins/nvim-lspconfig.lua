require("neodev").setup {
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  override = function(root_dir, library)
      library.enabled = true
      library.plugins = false
  end,
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
  lspconfig = true,
  pathStrict = true,
}
local lspconfig = require "lspconfig"
local util = require "lspconfig.util"
vim.lsp.set_log_level "ERROR"

-- Preconfiguration ----------------------------------------------------------- {{{2
local capabilities = (function()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  else
    return nil
  end
end)()

-- bashls (bash-language-server) ---------------------------------------- {{{2
lspconfig.bashls.setup {
  capabilities = capabilities,
}

-- R (r_language_server) ------------------------------------------------ {{{2
lspconfig.r_language_server.setup {
  cmd = {
    "R",
    "--slave",
    "--default-packages=" .. vim.g.R_start_libs,
    "-e",
    "languageserver::run()",
  },
  capabilities = capabilities,
  root_dir = util.root_pattern(".git", ".vim", "NAMESPACE"),
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
}

-- Python (pyright) ----------------------------------------------------- {{{2
-- lspconfig.pyright.setup({ on_attach = on_attach_custom })
lspconfig.jedi_language_server.setup {
  capabilities = capabilities,
}

-- vim (vimls) ---------------------------------------------------------- {{{2
lspconfig.vimls.setup {
  capabilities = capabilities,
}

-- perl (perlls) -------------------------------------------------------- {{{2
lspconfig.perlnavigator.setup {
  cmd = {
    "node",
    vim.env.HOME .. "/Repositories/PerlNavigator/server/out/server.js",
    "--stdio",
  },
  capabilities = capabilities,
  single_file_support = true,
}

-- lua (lua-language-server) -------------------------------------------- {{{2
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  single_file_support = true,
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

-- markdown_oxide ------------------------------------------------------- {{{2
local capabilities_oxide = capabilities
capabilities_oxide.workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
}
lspconfig.markdown_oxide.setup {
  cmd = { vim.env.HOME .. "/.cargo/bin/markdown-oxide" },
  filetype = {'markdown', "rmd", "rmarkdown"},
  root_dir = util.root_pattern(".obsidian", ".git", ".vim"),
  capabilities = capabilities_oxide,
  single_file_support = false,
  on_attach = function(client, _) -- _ bufnr
    client.handlers["textDocument/publishDiagnostics"] = function() end
  end,
}

-- ltex ----------------------------------------------------------------- {{{2
-- lspconfig.ltex.setup({
--     root_dir = util.root_pattern(".obsidian", ".git", ".vim"),
--     settings = {
--         ltex = {
--             language = "zh-CN",
--         },
--     },
-- })

-- Global mappings ------------------------------------------------------ {{{2
local lspmap = function(key, desc, cmd, opts)
  opts = opts or {}
  local mode = opts.mode or "n"
  opts.mode = nil
  opts = vim.tbl_extend("keep", opts or {}, {
    desc = "LSP: " .. desc,
    silent = true,
    noremap = true,
  })
  vim.keymap.set(mode, key, cmd, opts)
end

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
lspmap("[d", "Jump to previous diagnostic", vim.diagnostic.goto_prev)
lspmap("]d", "Jump to next diagnostic", vim.diagnostic.goto_next)
lspmap("<localleader>d", "Diagnsotic open float", vim.diagnostic.open_float)
lspmap("<localleader>D", "Diagnsotic set loc list", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    lspmap("gD", "Declaration", vim.lsp.buf.declaration, { buffer = ev.buf })
    lspmap("gd", "Definition", vim.lsp.buf.definition, { buffer = ev.buf })
    lspmap("gr", "References", vim.lsp.buf.references, { buffer = ev.buf })
    lspmap("<localleader>cr", "Rename", vim.lsp.buf.rename, { buffer = ev.buf })
    -- lspmap('<localleader>ca', "Action",         vim.lsp.buf.code_action,    {buffer = ev.buf, mode = {'n', 'v'}})
    lspmap(
      "gi",
      "Implementation",
      vim.lsp.buf.implementation,
      { buffer = ev.buf }
    )
    lspmap("gk", "Hover", vim.lsp.buf.hover, { buffer = ev.buf })
    lspmap(
      "gK",
      "Signature_help",
      vim.lsp.buf.signature_help,
      { buffer = ev.buf }
    )
  end,
})

-- -- refresh codelens on TextChanged and InsertLeave as well
-- vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach' }, {
--     group = 'UserLspConfig',
--     buffer = vim.api.nvim_get_current_buf(),
--     callback = function(_)
--         if vim.lsp.codelens then
--             vim.lsp.codelens.refresh()
--         end
--     end,
-- })

-- -- trigger codelens refresh
vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
