local add_namespace = function(packages)
  if not packages then return end
  local r_script
  if type(packages) ~= 'table' then
    r_script = string.format('nvimcom_update_libs("%s")', packages)
  elseif #packages == 1 then
    r_script = string.format('nvimcom_update_libs("%s")', packages[1])
  else
    packages = vim.fn.join(packages, ",")
    r_script = string.format(
      'nvimcom_update_libs(strsplit("%s", ",")[[1]])',
      packages
    )
  end

  require('r.send').cmd(r_script)
end

local opts = {
  R_args = { "--quiet", "--no-save" },
  hook = {
    on_filetype = function()
      -- This function will be called at the FileType event
      -- of files supported by R.nvim. This is an
      -- opportunity to create mappings local to buffers.
      vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
      vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })

      -- Increase the width of which-key to handle the longer r-nvim descriptions
      local wk = require("which-key")
      -- Workaround from https://github.com/folke/which-key.nvim/issues/514#issuecomment-1987286901
      wk.register({
        ["<localleader>"] = {
          a = { name = "+(a)ll", ["🚫"] = "which_key_ignore" },
          b = { name = "+(b)etween marks", ["🚫"] = "which_key_ignore" },
          c = { name = "+(c)hunks", ["🚫"] = "which_key_ignore" },
          f = { name = "+(f)unctions", ["🚫"] = "which_key_ignore" },
          g = { name = "+(g)oto", ["🚫"] = "which_key_ignore" },
          k = { name = "+(k)nit", ["🚫"] = "which_key_ignore" },
          p = { name = "+(p)aragraph", ["🚫"] = "which_key_ignore" },
          q = { name = "+(q)uarto", ["🚫"] = "which_key_ignore" },
          r = { name = "+(r) general", ["🚫"] = "which_key_ignore" },
          s = { name = "+(s)plit or (s)end", ["🚫"] = "which_key_ignore" },
          t = { name = "+(t)erminal", ["🚫"] = "which_key_ignore" },
          v = { name = "+(v)iew", ["🚫"] = "which_key_ignore" },
        },
      })
    end,
    after_config = function()
      -- This function will be called at the FileType event
      -- of files supported by R.nvim. This is an
      -- opportunity to create mappings local to buffers.
      if vim.o.syntax ~= "rbrowser" then
        vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
        vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
      else
        vim.api.nvim_set_option_value("filetype", "rbrowser", {scope = "local"})
      end
    end,
    after_R_start = function()
      require('r.term').highlight_term()

      require('r.send').cmd(
        'options(nvimcom_libs_info = "' .. vim.g.R_start_libs .. '")'
      )

      require('r.send').cmd('nvimcom_update_libs()')

      vim.api.nvim_create_user_command(
        "RAdd",
        function(tbl) add_namespace(tbl.fargs) end,
        { nargs = "+" }
      )

      require('util').wk_reg({
        A = {
          ":exec 'RAdd ' . expand('<cword>')<cr>",
          "Add package for completion"
        },
      }, {buffer = 0, prefix = "<localleader>r", mode = "n"})

      require('util').wk_reg({
        l = {
          "<Plug>RSendSelection", "Send to R visually selected lines or part of a line"
        },
      }, {buffer = 0, prefix = "<localleader>", mode = "v"})
    end
  },
  hl_term = true,
  Rout_more_colors = true,
  min_editor_width = 72,
  rconsole_width = 78,
  csv_app = "terminal:vd",
  objbr_openlist = true,
  objbr_place = 'console,left',
  objbr_opendf = true,
  -- bracketed_paste = vim.fn.has('mac') and false or true,
  setwd = 'nvim',
  open_pdf = "no",
  open_html = "no",
  pdfviewer = vim.fn.has('mac') == 0 and "zathura" or "open",
  synctex = false,
  listmethods = true,
  start_libs = vim.g.R_start_libs,
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


