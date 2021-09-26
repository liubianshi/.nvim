lua << EOF
require('orgmode').setup({
  org_agenda_files = {"~/Documents/Writing/*", "~/Documents/Writing/**/*"},
  org_default_notes_file = '~/Documents/Writing/refile.org',
})
EOF
