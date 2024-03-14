vim.cmd [[highlight Headline  guibg=none]]
vim.cmd [[highlight Headline1 guibg=none]]
vim.cmd [[highlight Headline2 guibg=none]]
-- vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
-- vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]

require("headlines").setup({
    markdown = {
        headline_highlights = { "Headline1", "Headline2" },
        fat_headlines = false,
    },
    rmd = {
        headline_highlights = { "Headline1", "Headline2" },
        fat_headlines = false,
    },
    org = {
        headline_highlights = { "Headline1", "Headline2" },
        fat_headlines = false,
    },
    norg = {
        headline_highlights = { "Headline1", "Headline2" },
        fat_headlines = false,
    },
})
