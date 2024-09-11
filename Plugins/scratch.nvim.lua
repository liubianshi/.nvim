require("scratch").setup {
  scratch_file_dir = vim.fn.stdpath "cache" .. "/scratch",
  filetypes = { "lua", "js", "sh", "ts", "do", "r", "md", "rmd" },
  filetype_details = {},
  window_cmd = "rightbelow vsplit", -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
  use_telescope = true,
  localKeys = {},
}
