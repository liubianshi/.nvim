if vim.env.PWD == vim.env.HOME then
  vim.cmd.cd(vim.env.WRITING_LIB or vim.env.HOME .. "/Documents/Writing")
end
require('options')
require('global_functions')
require("plug")
require('commands')
require('autocmds')
require('util.input-method').setup()
require('keymap')
require("theme")
-- require("after_init")



