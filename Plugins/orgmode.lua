-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

local orglib = "~/Documents/Writing/"

require('orgmode').setup({
  org_agenda_files = { orglib .. '*.org'},
  org_default_notes_file = orglib .. 'refile.org',
  org_todo_keywords = {'TODO(t)', 'PROJ(p)', 'LOOP(r)', 'STRT(s)', 'WAIT(w)', 'HOLD(h)', 'IDEA(i)', '|', 'DONE(d)', 'KILL(k)'},
  org_highlight_latex_and_related = 'entities',
  org_startup_indented = true,
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

