-- local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local M = {}

M.prompt = function(top, callback, default)
    top = top or "Input"
    default = default or ""
    callback = callback or function(value) print(value) end

    local input = Input(
        {
            position = "50%",
            size = { width = 40 },
            border = {
                style = "single",
                text = {
                    top = "[" .. top .. "]",
                    top_align = "center",
                },
            },
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
        },
        {
            prompt = "> ",
            default_value = default,
            on_close = function() print("Input Closed!") end,
            on_submit = callback,
        }
    )

    input:on(event.BufLeave, function()
        input:unmount()
    end)

    input:map("n", "<Esc>", function()
        input:unmount()
    end, { noremap = true })

    return input
end

M.mylib_tag = function()
    local input = M.prompt("Tags", function(value)
        vim.cmd("Mylib tag " .. value)
    end)
    input:mount()
end

M.popup = function(opts)
    opts = vim.tbl_extend("keep", opts or {}, {
        enter = true,
        focusable = true,
        border = {
            style = "rounded"
        },
        position = "50%",
        size = {
            width = "80%",
            height = "40%",
        },
        buf_options = {
            modifiable = true,
            readonly = false,
        },
        win_options = {
            winblend = 10,
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    })

    local popup = Popup(opts)
    return popup
end

M.mylib_popup = function(bufnr)
    local opts = {
        bufnr = bufnr,
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
        },
        win_options = {
            winblend = 2,
            winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
        },
    }

    local popup = Popup(opts)
    -- popup:on(event.BufLeave, function() popup:unmount() end)
    popup:map("n", "<leader><leader>", function() popup:unmount() end, { noremap = true })
    popup:mount()
    return popup
end

return M
