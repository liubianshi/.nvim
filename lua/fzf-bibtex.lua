-- default list of bibfiles
-- can be overriden by changing vim.b.bibfiles inside buffer
local default_bibfiles = {
  "~/Documents/url_ref.bib",
  -- put your default bibfiles here
}

-- default cache directory
-- uses neovim's stdpath to set up a cache - no need to fiddle with this
local cachedir = vim.fn.stdpath "state" .. "/fzf-bibtex/"

-- actions
local pandoc = function(selected, opts)
  local result = vim.fn.system("bibtex-cite", selected)
  vim.api.nvim_put({ result }, "c", false, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local citet = function(selected, opts)
  local result = vim.fn.system(
    'bibtex-cite -prefix="\\citet{" -postfix="}" -separator=","',
    selected
  )
  vim.api.nvim_put({ result }, "c", false, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local citep = function(selected, opts)
  local result = vim.fn.system(
    'bibtex-cite -prefix="\\citep{" -postfix="}" -separator=","',
    selected
  )
  vim.api.nvim_put({ result }, "c", false, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local markdown_print = function(selected, opts)
  local result = vim.fn.system(
    "bibtex-markdown -cache="
      .. cachedir
      .. " "
      .. table.concat(vim.b.bibfiles, " "),
    selected
  )
  local result_lines = {}
  for line in result:gmatch "[^\n]+" do
    table.insert(result_lines, line)
  end
  vim.api.nvim_put(result_lines, "l", true, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local fzf_bibtex_menu = function(mode)
  return function()
    -- check cache directory hasn't mysteriously disappeared
    if vim.fn.isdirectory(cachedir) == 0 then
      vim.fn.mkdir(cachedir, "p")
    end

    require("fzf-lua").config.set_action_helpstr(pandoc, "@-pandoc")
    require("fzf-lua").config.set_action_helpstr(citet, "\\citet{}")
    require("fzf-lua").config.set_action_helpstr(citep, "\\citep{}")
    require("fzf-lua").config.set_action_helpstr(
      markdown_print,
      "markdown-pretty-print"
    )

    -- header line: the bibtex filenames
    local filenames = {}
    for i, fullpath in ipairs(vim.b.bibfiles) do
      filenames[i] = vim.fn.fnamemodify(fullpath, ":t")
    end
    local header = table.concat(filenames, "\\ ")

    -- set default action
    local default_action = nil
    if vim.bo.ft == "markdown" then
      default_action = pandoc
    elseif vim.bo.ft == "tex" then
      default_action = citet
    end

    -- run fzf
    return require("fzf-lua").fzf_exec(
      "bibtex-ls "
        .. "-cache="
        .. cachedir
        .. " "
        .. table.concat(vim.b.bibfiles, " "),
      {
        actions = {
          ["default"] = default_action,
          ["alt-a"] = pandoc,
          ["alt-t"] = citet,
          ["alt-p"] = citep,
          ["alt-m"] = markdown_print,
        },
        fzf_bibtex = { ["mode"] = mode },
        fzf_opts = { ["--prompt"] = "BibTeX> ", ["--header"] = header },
      }
    )
  end
end

-- Only enable mapping in tex or markdown
vim.api.nvim_create_autocmd("Filetype", {
  desc = "Set up keymaps for fzf-bibtex",
  group = vim.api.nvim_create_augroup("fzf-bibtex", { clear = true }),
  pattern = { "markdown", "tex" },
  callback = function()
    vim.b.bibfiles = default_bibfiles
    vim.keymap.set(
      "n",
      "<leader>c",
      fzf_bibtex_menu "n",
      { buffer = true, desc = "FZF: BibTeX [C]itations" }
    )
    vim.keymap.set(
      "i",
      "@@",
      fzf_bibtex_menu "i",
      { buffer = true, desc = "FZF: BibTeX [C]itations" }
    )
  end,
})
