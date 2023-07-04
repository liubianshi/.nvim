require('hologram').setup{
    auto_display = false -- WIP automatic markdown image display, may be prone to breaking
}

local display_image = function(file, opts)
    if vim.fn.filereadable(file) == 0 or
       not file:match("%.png$") then
        return nil
    end
    default_opts = {
        method = "split"
    }
    opts = vim.tbl_extend("force", default_opts, opts or {})
    local cache_file = vim.fn.stdpath('cache') .. 'kitty_image_preview'
    vim.fn['utils#Preview_data'](
        cache_file,
        'kitty_image_preview_buf', opts.method, 'n', 'kittypreview'
    )

    local buf = vim.api.nvim_get_current_buf()
    vim.wo.number = false
    vim.wo.relativenumber = false
    local image = require('hologram.image'):new(file, {})

    image:display(1, 0, buf)

    vim.api.nvim_create_user_command(
        "DeleteImage",
        function()
            image:delete(0, {free = true})
            vim.fn['utils#Preview_data'](
                cache_file,
                'kitty_image_preview_buf', opts.method, 'y', 'kittypreview'
            )
        end,
        {nargs = 0, desc = "Delete Image"}
    )


    -- vim.defer_fn(function()
    --     image:delete(0, {free = true})
    -- end, 5000)
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

