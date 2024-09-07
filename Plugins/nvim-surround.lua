local surround = require('nvim-surround')
local config = require('nvim-surround.config')
local gen_surround = function(left, right) 
  if not left or not right then return end
  return {
    add = {left, right},
    find = function()
      return config.get_selection({ pattern = vim.pesc(left) .. ".-" .. vim.pesc(right) })
    end,
    delete = "^(" .. vim.pesc(left) .. " ?)().-( ?" .. vim.pesc(right) .. ")()$",
  }
end

local global_opts = {
  keymaps = {
    insert = ";s",
    insert_line = ";S",
  },
}

local filetype_opts = {
  markdown = {
    surrounds = {
      ['w'] = gen_surround("[[", "]]"),
      ['h'] = gen_surround("==", "=="),
    },
  },
  stata = {
    surrounds = {
      ["'"] = gen_surround([[`"]], [["']]),
    },
  },
}


surround.setup(global_opts) 
local group_surround = vim.api.nvim_create_augroup("Surround_buffer", { clear = true })
for type, opt in pairs(filetype_opts) do
  vim.api.nvim_create_autocmd({"FileType"}, {
    group = group_surround,
    pattern = { type },
    callback = function()
      surround.buffer_setup(opt)
    end
  })
end
