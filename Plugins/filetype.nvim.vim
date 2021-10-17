lua <<EOF
vim.g.did_load_filetypes = 1
-- In init.lua or filetype.nvim's config file
require('filetype').setup({
    overrides = {
        extensions = {
            -- Set the filetype of *.pn files to potion
            pn = 'potion',
            md = 'pandoc',
            markdown = 'pandoc'
        },
        literal = {
            -- Set the filetype of files named "MyBackupFile" to lua
            MyBackupFile = 'lua',
        },
        complex = {
            -- Set the filetype of any full filename matching the regex to gitconfig
            [".*git/config"] = "gitconfig",  -- Included in the plugin
        },
    }
})
EOF
