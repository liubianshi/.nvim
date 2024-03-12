local image = require("image")
local backend = "ueberzug"
if (vim.env.TERM == "xterm-kitty" or vim.env.WEZTERM_EXECUTABLE ~= "") then
   backend = "kitty"
end

image.setup({
   backend = backend,
   integrations = {
      markdown = {
         enabled = true,
         clear_in_insert_mode = false,
         download_remote_images = true,
         only_render_image_at_cursor = false,
         filetypes = { "markdown", "vimwiki", "rmd" }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
         enabled = true,
         clear_in_insert_mode = false,
         download_remote_images = true,
         only_render_image_at_cursor = false,
         filetypes = { "norg" },
      },
   },
   max_width = nil,
   max_height = nil,
   max_width_window_percentage = nil,
   max_height_window_percentage = 50,
   window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
   window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
   editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
   tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
   hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
})


-- Define Global Command
local display_image = function(file, opts)
    file = vim.fn.fnamemodify(file, ":p")
    if vim.fn.filereadable(file) == 0 or not (file:match("%.png$") or file:match("%.jpe?g$")) then
        return nil
    end
    local default_opts = { method = "infile" }
    opts = vim.tbl_extend("force", default_opts, opts or {})

    local cache_file = vim.fn.stdpath('cache') .. 'kitty_image_preview'
    if opts.method ~= "infile" then
        vim.fn['utils#Preview_data'](cache_file, 'kitty_image_preview_buf', opts.method, 'n', 'kittypreview')
        vim.wo.number = false
        vim.wo.relativenumber = false
    end

    -- local window_shift   = vim.fn.wincol()
    local line           = opts.line or vim.fn['utils#GetNearestEmptyLine']()
    local window_id      = vim.fn.win_getid()
    local window         = require('image.utils.window').get_window(window_id)
    -- local display_row    = (line - window.scroll_y)
    local display_row    = line
    if window.scroll_y > 3 then display_row = display_row - 1 end
    local display_column = vim.fn.getline(line):match("^%s*"):len()

    local preview_image = require("image").from_file(file, {
        window = window_id,
        buffer = window.buffer,
        with_virtual_padding = true,
    })
    preview_image:render()
    preview_image:move(display_column, display_row)

    vim.api.nvim_create_user_command(
        "DeleteImage",
        function(o)
            preview_image:clear()
            if not o.bang and opts.method ~= "infile" then
                vim.fn['utils#Preview_data'](
                    cache_file, 'kitty_image_preview_buf', opts.method, 'y', 'kittypreview'
                )
            end
        end,
        {bang = true, nargs = 0, desc = "Delete Image"}
    )

    return preview_image
end

vim.api.nvim_create_user_command(
    'PreviewImage',
    function(args)
        local args_number = #args.fargs
        local file = args.fargs[args_number]
        local method = "infile"
        if args_number > 1 then method = args.fargs[1] end
        display_image(file, {method = method})
        -- vim.cmd([[wincmd w]])
    end,
    { nargs = '+', desc = "Preview image"}
)


