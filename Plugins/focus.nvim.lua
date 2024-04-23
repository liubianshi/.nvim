require("focus").setup {
  width = 86,
  minwidth = 0,
  bufnew = false,
  autoresize = {
    width = 100,
    enable = true,
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
  "help",
  -- "terminal",
  "nofile",
  "promp",
  "popup",
}

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.w.focus_disable = true
    else
      vim.w.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for BufType",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.focus_disable = true
    else
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})
