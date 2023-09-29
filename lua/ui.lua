-- local Popup = require("nui.popup")
-- local Layout = require("nui.layout")
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

return M
