local wilder = require('wilder')
local highlights = {
    accent = wilder.make_hl('WilderAccent', 'Pmenu', {
        {a = 1},
        {a = 1},
        {foreground = vim.fn['utils#GetHlColor']('Identifier', 'fg#'), underline = true}
    }),
},

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
        highlights = highlights,
        left = {' ', wilder.popupmenu_devicons()},
        right = {' ', wilder.popupmenu_scrollbar()},
    }),
    ['/'] = wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        highlights = highlights,
    }),
    ['?'] = wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        highlights = highlights,
    }),
}))


-- wilder.set_option('renderer', wilder.renderer_mux({
--     [':'] = wilder.popupmenu_renderer(
--         wilder.popupmenu_palette_theme({
--             border = "rounded",
--             highlighter = {
--                 wilder.lua_pcre2_highlighter(),
--                 wilder.basic_highlighter(),
--             },
--             highlights = highlights,
--             left = { ' ', wilder.popupmenu_devicons() },
--             right = { ' ', wilder.popupmenu_scrollbar() },
--             max_height = '45%',         -- max height of the palette
--             min_height = 0,             -- set to the same as 'max_height' for a fixed height window
--             prompt_position = 'bottom', -- 'top' or 'bottom' to set the location of the prompt
--             reverse = 1,                -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
--         })
--     ),

--     ['/'] = wilder.wildmenu_renderer({
--         highlighter = wilder.basic_highlighter(),
--         highlights = highlights,
--     }),

--     ['?'] = wilder.wildmenu_renderer({
--         highlighter = wilder.basic_highlighter(),
--         highlights = highlights,
--     }),
-- }))


