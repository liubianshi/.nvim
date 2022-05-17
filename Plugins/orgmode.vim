lua << EOF
-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  org_agenda_files = {'~/Documents/Writing/*', '~/Documents/Writing/**/*'},
  org_default_notes_file = '~/Documents/Writing/refile.org',
  org_todo_keywords = {'TODO(t)', 'PROJ(p)', 'LOOP(r)', 'STRT(s)', 'WAIT(w)', 'HOLD(h)', 'IDEA(i)', '|', 'DONE(d)', 'KILL(k)'},
  org_highlight_latex_and_related = 'entities',
  org_indent_mode = 'indent',
  diagnostics = false,
})
EOF

