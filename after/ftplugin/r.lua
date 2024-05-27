local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local r_popup = function(debug)
    local opts = {
        enter = true,
        focusable = true,
        border = {
            style = "rounded"
        },
        position = {
            row = "75%",
            col = "50%",
        },
        size = {
            width = "80%",
            height = "50%",
        },
        buf_options = {
            modifiable = true,
            readonly = false,
            filetype = "r",
        },
        win_options = {
            foldcolumn = '2',
            winblend = 2,
            winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
        },
    }

    local popup = Popup(opts)
    popup:on(
        event.BufWinEnter,
        function()
            if not debug then
                vim.cmd("RSend local(browser())")
            end
        end
    )
    popup:on(
        event.BufWinLeave,
        function()
            vim.cmd("RSend f")
            popup:unmount()
        end
    )
    popup:map(
        "n",
        "<leader><leader>",
        function() popup:unmount() end,
        { noremap = true }
    )
    popup:mount()
    return popup
end



local wk = require "which-key"
local vimkey = function(key, desc, cmd, opts)
    opts = vim.tbl_extend('keep', opts or {}, {
        mode = 'n',
        desc = desc,
        silent = true,
        noremap = true,
        buffer = true,
    })

    local mode = opts.mode
    opts.mode =nil
    vim.keymap.set(mode, key, cmd, opts)
end
vimkey("<localleader><leader>", "Open a Scratch", function() r_popup() end)
vimkey("<localleader>de", "Edit test file",            "<cmd>call r#EditTestFile()<cr>")
vimkey("<localleader>df", "Test current file",         "<cmd>call r#TestCurrentFile()<cr>")
vimkey("<localleader>dt", "Test whole parogram",       "<cmd>call r#TestWholeProgram()<cr>")
vimkey("<localleader>dl", "devtools: load package",    "<cmd>RSend devtools::load_all()<cr>")
vimkey("<localleader>dd", "devtools: update document", "<cmd>RSend devtools::document()<cr>")
vimkey("<localleader>dB", "devtools: trace back",      "<cmd>RSend rlang::trace_back()<cr>")
vimkey("<localleader>db", "Debug", string.format('<cmd>RSend debug(%s)<cr>', vim.fn.expand('<cword>')))
vimkey("<localleader>du", "Debug", string.format('<cmd>RSend undebug(%s)<cr>', vim.fn.expand('<cword>')))

vimkey("<localleader>tv", "view data: head+tail",   "yiw<cmd>call utils#R_view_df_sample('ht')<cr>")
vimkey("<localleader>tr", "view data: random",      "yiw<cmd>call utils#R_view_df_sample('r')<cr>")
vimkey("<localleader>th", "view data: head",        "yiw<cmd>call utils#R_view_df_sample('h')<cr>")
vimkey("<localleader>tt", "view data: tail",        "yiw<cmd>call utils#R_view_df_sample('t')<cr>")
vimkey("<localleader>tV", "view data: all",         "yiw<cmd>call utils#R_view_df_full(30)<cr>")

vimkey("<localleader>tv", "view data: head+tail",   "y<cmd>call   utils#R_view_df_sample('ht')<cr>", {mode = "v"})
vimkey("<localleader>tr", "view data: random",      "y<cmd>call   utils#R_view_df_sample('r')<cr>",  {mode = "v"})
vimkey("<localleader>th", "view data: head",        "y<cmd>call   utils#R_view_df_sample('h')<cr>",  {mode = "v"})
vimkey("<localleader>tt", "view data: tail",        "y<cmd>call   utils#R_view_df_sample('t')<cr>",  {mode = "v"})
vimkey("<localleader>tV", "view data: all",         "y<cmd>call   utils#R_view_df_full(30)<cr>",     {mode = "v"})

vimkey("<localleader>t1", "DataLib: table list",    "<cmd>call    utils#R_view_srdm_table()<cr>")
vimkey("<localleader>t2", "DataLib: variable list", "<cmd>call    utils#R_view_srdm_var()<cr>")


wk.register({
    ['a'] = { name = "Send file / ALE" },
    ['b'] = { name = "Send block / debug" },
    ['d'] = { name = "devtools/testthat" },
    ['f'] = { name = "Send function" },
    ['k'] = { name = "Rmarkdown / Knitr" },
    ['p'] = { name = "Send paragraphs" },
    ['r'] = { name = "R command" },
    ['s'] = { name = "Send Selection" },
    ['t'] = { name = "View Data Frame" },
    ['u'] = { name = "Undebug" },
    ['v'] = { name = "View Object" },
    ['x'] = { name = "R comment" },
}, { buffer = 0, prefix = '<localleader>' })




