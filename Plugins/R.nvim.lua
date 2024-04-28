local opts = {
  R_args = { "--quiet", "--no-save" },
  hook = {
    after_config = function()
      -- This function will be called at the FileType event
      -- of files supported by R.nvim. This is an
      -- opportunity to create mappings local to buffers.
      if vim.o.syntax ~= "rbrowser" then
        vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
        vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
      end
    end,
    after_R_start = function()
      require('r.term').highlight_term()
    end
  },
  hl_term = true,
  Rout_more_colors = true,
  min_editor_width = 72,
  rconsole_width = 78,
  csv_app = "terminal:vd",
  objbr_openlist = true,
  objbr_place = 'console,right',
  objbr_opendf = false,
  -- bracketed_paste = vim.fn.has('mac') and false or true,
  setwd = 'nvim',
  open_pdf = "no",
  open_html = "no",
  pdfviewer = vim.fn.has('mac') == 0 and "zathura" or "open",
  synctex = false,
  listmethods = true,
  start_libs = vim.g.R_start_libs,
  assign = false,
  rmdchunk = 1,
  disable_cmds = {},
}
-- Check if the environment variable "R_AUTO_START" exists.
-- If using fish shell, you could put in your config.fish:
-- alias r "R_AUTO_START=true nvim"
if vim.env.R_AUTO_START == "true" then
  opts.auto_start = 1
  opts.objbr_auto_start = true
end
require("r").setup(opts)
