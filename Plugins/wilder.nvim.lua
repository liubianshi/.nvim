local wilder = require('wilder')

local highlighters = {
  wilder.pcre2_highlighter(),
  wilder.lua_fzy_highlighter(),
}

local highlights = {
    accent = wilder.make_hl('WilderAccent', 'Pmenu', {
        {a = 1},
        {a = 1},
        {foreground = vim.fn['utils#GetHlColor']('Identifier', 'fg#'), underline = true}
    }),
}

local popupmenu_renderer = wilder.popupmenu_renderer(
    wilder.popupmenu_border_theme{
        highlighter = highlighters,
        highlights = highlights,
        min_width = '100%',
        border = {
                '', '▔', '',
                '',  '', '',
                '', '', '',
        },
        left = {' ', wilder.popupmenu_devicons()},
        right = {' ', wilder.popupmenu_scrollbar()},
    })

local wildmenu_renderer = wilder.wildmenu_renderer({
        highlighter = highlighters,
        separator = ' · ',
        left = {' ', wilder.wildmenu_spinner(), ' '},
        right = {' ', wilder.wildmenu_index()},
})

wilder.setup({ modes = {':', '/', '?'} })

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.substitute_pipeline({
      pipeline = wilder.python_search_pipeline({
        skip_cmdtype_check = 1,
        pattern = wilder.python_fuzzy_pattern({
          start_at_boundary = 0,
        }),
      }),
    }),
    wilder.cmdline_pipeline({
      fuzzy = 2,
      fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    {
      wilder.check(function(_, x) return x == '' end),
      wilder.history(),
    },
    wilder.python_search_pipeline({
      pattern = wilder.python_fuzzy_pattern({
        start_at_boundary = 0,
      }),
    })
  )
})

wilder.set_option('renderer', wilder.renderer_mux({
    [':'] = popupmenu_renderer,
    ['/'] = wildmenu_renderer,
    ['?'] = wildmenu_renderer,
    substitute = wildmenu_renderer,
}))


