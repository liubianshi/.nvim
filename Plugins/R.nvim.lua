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
      wk.add({
        { "<localleader>a", group = "all" },
        { "<localleader>b", group = "between marks" },
        { "<localleader>c", group = "chunks" },
        { "<localleader>f", group = "functions" },
        { "<localleader>g", group = "goto" },
        { "<localleader>k", group = "knit" },
        { "<localleader>p", group = "paragraph" },
        { "<localleader>q", group = "quarto" },
        { "<localleader>r", group = "r general" },
        { "<localleader>s", group = "split or send" },
        { "<localleader>t", group = "terminal" },
        { "<localleader>v", group = "view" },
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
      vim.keymap.set(
        "n",
        "<localleader>rA",
        "<cmd>exec 'RAdd ' . expand('<cword>')<cr>",
        {buffer = true, desc = "Add package for completion"}
      )
      vim.keymap.set(
        "v",
        "<localleader>rl",
        "<Plug>RSendSelection",
        { buffer = true, desc = "Send to R visually selected lines or part of a line"}
      )
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


