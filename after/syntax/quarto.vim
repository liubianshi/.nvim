syntax match QuartoCrossRef /\v[^-_0-9A-Za-z]\zs\@[^ ]+[-_0-9A-Za-z]/
exec "highlight def QuartoCrossRef guifg=" . g:lbs_colors['orange']
