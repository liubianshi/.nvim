local in_blog = function(_)
  local parent_dir = vim.fn.expand('%:h')
  if parent_dir == "content/posts" or parent_dir:match('^content/posts/') then
    return true
  else
    return false
  end
end

local get_img_dirpath = function()
  local filename = vim.fn.expand('%:t:r')
  return string.format('static/assets/%s_files/figure-html', filename)
end

local rmd_template = function(context)
  local file_path = context.file_path
  if in_blog() then
    local _, j = file_path:find('static/assets/')
    file_path = "/assets/" .. file_path:sub(j + 1)
  end

  return string.format(
    '```{r %s, echo=F, out.width="80%%", fig.pos="h", fig.show="hold"}\n knitr::include_graphics("%s")\n```\n\n%s',
    context.label,
    file_path,
    context.cursor
  )
end

local markdown_template = function(context)
  local file_path = context.file_path
  if in_blog() then
    local _, j = file_path:find('static/assets/')
    file_path = file_path:sub(j + 1)
  end
  return string.format('![](%s)%s', file_path, context.cursor)
end

local neorg_template = [[
.image $FILE_PATH
$CURSOR
]]

require("img-clip").setup {
  default = {
    dir_path = "img",
    file_name = "img-%Y%m%d%H%M%S",
    prompt_for_file_name = true,
    show_dir_path_in_prompt = true,
    copy_images = true,
  },
  filetypes = {
    rmd      = { template = rmd_template },
    norg     = { template = neorg_template },
    markdown = {
        template = markdown_template,
        relative_to_current_file = true,
    },
  },
  custom = {
    {
      trigger = require('util').in_obsidian_vault,
      template = "![[$FILE_PATH]]$CURSOR",
    },
    {
      trigger = in_blog,
      dir_path = get_img_dirpath,
      show_dir_path_in_prompt = false,
      relative_to_current_file = false,
    },
  }
}
