local disable_treesitter = function(lang, buf)
  local disable_lang_list = { "tsv", "perl", "markdown", "markdown_inline" }
  for _, v in ipairs(disable_lang_list) do
    if v == lang then
      return true
    end
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, true)
  if string.match(lines[1], "^# topic: %?$") then
    return true
  end

  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end
local ts = require "nvim-treesitter.configs"
vim.treesitter.language.register("markdown", "rmd")
ts.setup {
  modules = {},
  ensure_installed = {
    "r",
    "bash",
    "vim",
    "org",
    "lua",
    "dot",
    "perl",
    "markdown",
    "markdown_inline",
    "bibtex",
    "css",
    "json",
    "regex",
    "vim",
    "vimdoc",
    "query",
    "latex",
    "jq",
    "rnoweb",
  },
  sync_install = false,
  auto_install = false,
  ignore_install = { "javascript", "css", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
    disable = disable_treesitter,
  },
  indent = {
    enable = true,
    disable = disable_treesitter,
  },
  matchup = {
    enable = false,
  },
  incremental_selection = {
    enable = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = {
          query = "@class.inner",
          desc = "Select inner part of a class region",
        },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = {
          query = "@scope",
          query_group = "locals",
          desc = "Select language scope",
        },
      },
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },
}
