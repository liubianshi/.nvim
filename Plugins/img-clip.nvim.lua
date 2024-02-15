local rmd_template = [[
```{r $LABEL, echo = FALSE, out.width = '80%', fig.pos = 'h', fig.show = 'hode'}
knitr::include_graphics("$FILE_PATH")
```

$CURSOR
]]

local neorg_template = [[
.image $FILE_PATH 
$CURSOR
]]

require('img-clip').setup({
    default = {
        dir_path = ".asset",
    },
    filetypes = {
        rmd = { template = rmd_template, },
        norg = { template = neorg_template, },
    }
})
