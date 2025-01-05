local lspconfig = require "lspconfig"
local util = require "lspconfig.util"

local opts = {
  diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
      -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
      -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
      -- prefix = "icons",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  },
  -- add any global capabilities here
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
  servers = {
    bashls = {
      cmd = { "bash-language-server", "start" },
      filetpyes = { "sh" },
      root_dir = util.root_pattern(".git", ".root", ".project"),
      single_file_support = true,
    },
    r_language_server = {
      cmd = {
        "R",
        "--slave",
        -- "--default-packages=" .. vim.g.R_start_libs,
        "-e",
        "languageserver::run()",
      },
      root_dir = util.root_pattern(
        ".git",
        "NAMESPACE",
        "R",
        ".root",
        ".project"
      ),
      single_file_support = true,
    },
    vimls = {},
    perlnavigator = {
      cmd = { "perlnavigator" },
      single_file_support = true,
      settings = {
        perlnavigator = {
          perlPath = "perl",
          enableWarnings = true,
          perltidyProfile = "",
          perlcriticProfile = "",
          perlcriticEnabled = true,
        },
      },
    },
    lua_ls = {
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
    },
    markdown_oxide = {
      cmd = {
        vim.fn.executable "markdown-oxide" == 1 and "markdown-oxide"
          or vim.env.HOME .. "/.cargo/bin/markdown-oxide",
      },
      filetype = { "markdown", "rmd", "rmarkdown", "quarto" },
      root_dir = util.root_pattern(".obsidian", ".git"),
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      },
      single_file_support = false,
      on_attach = function(client, _) -- _ bufnr
        client.handlers["textDocument/publishDiagnostics"] = function() end
      end,
    },
  },
}

vim.lsp.set_log_level(vim.log.levels.ERROR)

-- Used to block unwanted information ----------------------------------- {{{2
util.default_config =
  vim.tbl_deep_extend("force", lspconfig.util.default_config, {
    handlers = {
      ["window/showMessage"] = function(_, result, ctx)
        if
          result.type == vim.lsp.protocol.MessageType.Info
          and string.find(result.message, "rime")
        then
          return
        end

        vim.lsp.handlers["window/showMessage"](nil, result, ctx)
      end,
    },
  })

vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
for server, server_opts in pairs(opts.servers) do
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local has_blink, blink = pcall(require, "blink.cmp")
  local has_ufo, _ = pcall(require, "ufo")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    has_blink and blink.get_lsp_capabilities() or {},
    has_ufo
        and {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }
      or {}
  )
  server_opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
  }, server_opts or {})
  if server_opts.enabled == false then
    return
  end
  require("lspconfig")[server].setup(server_opts)
end

-- Global mappings ------------------------------------------------------ {{{2
local lspmap = function(key, desc, cmd, opt)
  opt = vim.tbl_extend("keep", opt or {}, {
    key,
    cmd,
    desc = "LSP:" .. desc,
    silent = true,
    noremap = true,
  })
  require("util").keymap(opt)
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
