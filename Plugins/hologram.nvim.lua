require('hologram').setup{
    auto_display = false -- WIP automatic markdown image display, may be prone to breaking
}

local display_image = function(file, opts)
    if vim.fn.filereadable(file) == 0 or not file:match("%.png$") then
        return nil
    end
    local default_opts = { method = "split" }
    opts = vim.tbl_extend("force", default_opts, opts or {})
    local display_row = 1
    local display_column = 0
    local cache_file = vim.fn.stdpath('cache') .. 'kitty_image_preview'
    if opts.method == "infile" then
        vim.cmd[[normal! zt]]
        display_row = vim.fn.line('.')
    else
        vim.fn['utils#Preview_data'](
            cache_file,
            'kitty_image_preview_buf', opts.method, 'n', 'kittypreview'
        )
        vim.wo.number = false
        vim.wo.relativenumber = false
    end
    local buf = vim.api.nvim_get_current_buf()
    local image = require('hologram.image'):new(file, {})
    image:display(display_row, display_column, buf)

    vim.api.nvim_create_user_command(
        "DeleteImage",
        function(o)
            image:delete(0, {free = true})
            if not o.bang and opts.method ~= "infile" then
                vim.fn['utils#Preview_data'](
                    cache_file, 'kitty_image_preview_buf', opts.method, 'y', 'kittypreview'
                )
            end
        end,
        {bang = true, nargs = 0, desc = "Delete Image"}
    )
end

vim.api.nvim_create_user_command(
    'PreviewImage',
    function(args)
        local args_number = #args.fargs
        local file = args.fargs[args_number]
        local method = "split"
        if args_number > 1 then method = args.fargs[1] end
        display_image(file, {method = method})
        vim.cmd([[wincmd w]])
    end,
    { nargs = '+', desc = "Display image with hologram"}
)
