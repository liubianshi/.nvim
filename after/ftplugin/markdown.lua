vim.keymap.set("n", "<c-x>m", function()
  vim.cmd.normal("EvT@")
  local text = require('util').get_visual_selection()
  require("util").bibkey_action(text)
end, { desc = "Show action related bibkey" })

vim.keymap.set({"n", "i"}, "<localleader>il", function()
  vim.fn['ref_link#add']()
end, { desc = "Add Link"})

vim.keymap.set("n", "<localleader>rf", function()
  vim.api.nvim_set_option_value("filetype", "rmd", { scope = "local" })
  local cmp = require "cmp"
  local config = require "cmp.config"
  local cmp_sources = {}
  local cmp_source_list = {}
  for _, s in pairs(cmp.core.sources) do
    if
      config.get_source_config(s.name)
      and s:is_available()
      and not cmp_source_list[s.name]
    then
      cmp_source_list[s.name] = 1
      table.insert(cmp_sources, config.get_source_config(s.name))
    end
  end
  if not cmp_source_list.nvim_lsp then
    table.insert(cmp_sources, config.get_source_config("nvim_lsp"))
  end
  vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" })
  -- cmp_sources[#cmp_sources + 1] = {
  --     name = "cmp_r",
  --     group_index = 2,
  -- }
  cmp.setup.buffer { sources = cmp.config.sources(cmp_sources) }
end, { desc = "Start R.nvim" })
