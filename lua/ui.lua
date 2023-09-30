-- local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local NuiLine = require("nui.line")
local NuiText = require("nui.text")
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

M.float_buffer = function(opts)
    opts = vim.tbl_extend("keep", opts or {}, {
        filetype = "org",
        commit = function() vim.cmd("quit") end,
        contents = nil,
    })

    local popup = Popup(
        {
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
                filetype = opts.filetype,
            },
            win_options = {
                winblend = 10,
                winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
        }
    )
    popup:map("n", "<localleader>s", opts.commit, { noremap = true, silent = true})
    popup:mount()
    if not opts.contents then
        local line = NuiLine()
        local contents = NuiText(opts.contents, "WarningMsg")
        line:append({contents, ""})
        line:render(popup.bufnr, -1, 1)
    end
end

return M
