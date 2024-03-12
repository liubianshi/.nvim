local dirpath = "img"

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

local obisdian_template = "![[$FILE_PATH]]$CURSOR"

require("img-clip").setup {
  default = {
    dir_path = dirpath,
    file_name = "img-%Y%m%d%H%M%S",
    prompt_for_file_name = true,
    show_dir_path_in_prompt = true,
  },
  filetypes = {
    rmd      = { template = rmd_template },
    norg     = { template = neorg_template },
    markdown = {
        template = obisdian_template,
        relative_to_current_file = true,
    },
  },
}
