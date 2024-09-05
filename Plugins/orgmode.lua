-- Load custom tree-sitter grammar for org filetype
local orglib = "~/Documents/Writing/"

---@diagnostic disable: missing-fields, unused-local
require('orgmode').setup({
  org_agenda_files = { orglib .. '*.org'},
  org_default_notes_file = orglib .. 'refile.org',
  org_todo_keywords = {'TODO(t)', 'PROJ(p)', 'LOOP(r)', 'STRT(s)', 'WAIT(w)', 'HOLD(h)', 'IDEA(i)', '|', 'DONE(d)', 'KILL(k)', 'CANCELLED(c)'},
  org_highlight_latex_and_related = 'entities',
  org_startup_indented = false,
  org_hide_emphasis_markers = true,
  org_hide_leading_stars = true,
  diagnostics = false,
  org_capture_templates = {
        t = {
            description = 'Todo',
            template = '\n* TODO %?\n %T',
            target = orglib .. 'todo.org',
        },
        j = {
            description = 'Short Journal',
            template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
            target = orglib .. 'journal.org'
        },
  },
})

vim.api.nvim_create_user_command("OrgCapture", function()
  require("orgmode").action("capture.prompt")
  vim.schedule(function() vim.cmd[[only!]] end)
end, { nargs = 0, desc = "Org Capture"})


-- vim: set foldlevel=99 :
