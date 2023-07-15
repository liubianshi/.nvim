require("transparent").setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  },
  -- table: additional groups that should be cleared
  extra_groups = {'FzfLuaPreviewBorder', 'FzfLuaPreviewNormal'},
  exclude_groups = {}, -- table: groups you don't want to clear
})

