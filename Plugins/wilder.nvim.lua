local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.cmdline_pipeline({
      language = 'python',
      fuzzy = 1,
      set_prce2_pattern = 1,
    }),
    wilder.python_search_pipeline({
      pattern = wilder.python_fuzzy_pattern(),
      sorter = wilder.python_difflib_sorter(),
      engine = 're',
    })
  ),
})

wilder.set_option('renderer', wilder.renderer_mux({
    [':'] = wilder.popupmenu_renderer({
        highlighter = {
            wilder.lua_pcre2_highlighter(),
            wilder.basic_highlighter(),
        },
        highlights = {
            accent = wilder.make_hl('WilderAccent', 'Pmenu', {
                {a = 1}, {a = 1}, {foreground = '#f4468f'}
            }),
        },
        left = {' ', wilder.popupmenu_devicons()},
        right = {' ', wilder.popupmenu_scrollbar()},
    }),
    ['/'] = wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
    }),
}))




