local util = require('formatter.util')
local fmt = require('formatter')

fmt.setup({
    logging = false,
    filetype = {
        lua = { require("formatter.filetypes.lua").stylua },
        sh = { require("formatter.filetypes.sh").shfmt },
        html = { require("formatter.filetypes.html").prettier },
        css = { require("formatter.filetypes.css").prettier },
        xml = {
            function()
                return {
                    exe = 'xmllint',
                    args = {},
                    stdin = true,
                }
            end
        },
        perl = {
            function()
                return {
                    exe = 'perltidy',
                    args = {"-xci", "-cti=1", "-nsfs", "-st"},
                    stdin = true,
                }
            end
        },
        r = {
            function()
                local shiftwidth = vim.opt.shiftwidth:get()
                local expandtab = vim.opt.expandtab:get()

                if not expandtab then
                    shiftwidth = 0
                end

                return {
                    exe = "r-format",
                    args = { "-i", shiftwidth}, 
                    stdin =true,
                }
            end
        },

        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace
        }
    }
})

local keymap = vim.keymap.set
local keyopts = { silent = true, noremap = true }
keymap("n", "<leader>cf", "<cmd>Format<CR>", keyopts)
keymap("x", "<leader>cf", "<cmd>Format<CR>", keyopts)
