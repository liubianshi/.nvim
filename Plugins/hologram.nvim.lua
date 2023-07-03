local display_image = function(file, opts)
    if vim.fn.filereadable(file) == 0 or
       not file:match("%.png$") then
        return nil
    end
    default_opts = {
        method = "split"
    }
    opts = vim.tbl_extend("force", default_opts, opts or {})
    vim.fn['utils#Preview_data'](
        vim.fn.stdpath('cache') .. 'kitty_image_preview',
        'kitty_image_preview_buf', opts.method, 'n', 'kittypreview'
    )

    local buf = vim.api.nvim_get_current_buf()
    local image = require('hologram.image'):new(file, {})

    image:display(1, 0, buf, {})

    vim.defer_fn(function()
        image:delete(0, {free = true})
    end, 5000)
end

require('hologram').setup{
    auto_display = false -- WIP automatic markdown image display, may be prone to breaking
}

