require("focus").setup {
  width = 86,
  bufnew = false,
  autoresize = {
    enable = true,
    width = 100,
    minwidth = 20,
    minheigth = 5,
    height_quickfix = 10, -- Set the height of quickfix panel
  },
  ui = {
    colorcolumn = { enable = false, width = 100 },
    signcolumn = false,
  }
}

local ignore_filetypes = {
  "rbrowser",
  "sagaoutline",
  "floaterm",
  "rdoc",
  "fzf",
  "voomtree",
  "neo-tree",
}

local ignore_buftypes = {
  "terminal",
  "nofile",
  "promp",
  "popup",
}

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(ev)
    if vim.b[ev.buf].focus_disable then return end
    if
      vim.tbl_contains(ignore_filetypes, vim.bo[ev.buf].filetype) or
      vim.tbl_contains(ignore_buftypes, vim.bo[ev.buf].buftype)
    then
      vim.b[ev.buf].focus_disable = true
    else
      vim.b[ev.buf].focus_disable = false
    end
  end,
  desc = "Disable focus autoresize",
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("FocusResize", { clear = true }),
  callback = function()
    require('focus').resize()
  end,
})
