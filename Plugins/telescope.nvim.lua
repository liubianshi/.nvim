local telescope = require('telescope')
local command_center = require("command_center")

-- setup ---------------------------------------------------------------- {{{1
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

-- load extensions ------------------------------------------------------ {{{1
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension("command_center")

-- extensions config ---------------------------------------------------- {{{1
-- command center ------------------------------------------------------- {{{2
command_center.add({
  {
    desc = "Search inside current buffer",
    cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
  },  {
    desc = "Find Files",
    cmd = "<CMD>Telescope find_files<CR>",
  }, {
    desc = "Find hidden files",
    cmd = "<CMD>Telescope find_files hidden=true<CR>",
  }, {
    desc = "Show document symbols",
    cmd = "<CMD>Telescope lsp_document_symbols<CR>",
  }, {
    desc = "Fine vim Options",
    cmd = "<cmd>Telescope vim_options<cr>",
  }
})

-- keymap --------------------------------------------------------------- {{{1
local builtin = require('telescope.builtin')
local extensions = telescope.extensions
local kops = function(desc)
    return { noremap = true, silent = true, desc = "Telescope: " .. desc }
end

vim.keymap.set('n', '<leader>ff', builtin.find_files,                  kops("find files"))
vim.keymap.set('n', '<leader>fr', builtin.oldfiles,                    kops("fild recent files"))
vim.keymap.set('n', '<leader>bb', builtin.buffers,                     kops("select buffers"))
vim.keymap.set('n', '<leader>sh', builtin.help_tags,                   kops("vim help tags"))
vim.keymap.set('n', '<leader>sk', builtin.keymaps,                     kops("keymap"))
vim.keymap.set('n', '<leader>sm', builtin.man_pages,                   kops("man pages"))
vim.keymap.set('n', '<leader>s:', "<cmd>Telescope command_center<cr>", kops("command center"))

-- vim: set fdm=marker: ------------------------------------------------- {{{1
