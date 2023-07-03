require('hologram').setup{
    auto_display = true -- WIP automatic markdown image display, may be prone to breaking
}

local display_image = function(file, opts)
    if vim.fn.filereadable(file) == 0 or
       not file:match("%.png$") then
        return nil
    end
    opts = opts or {}
    

end
