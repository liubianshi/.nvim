require('github-theme').setup()

local p = require('github-theme.palette').load('github_light')
vim.g.lbs_colors = {
   bg = p.canvas.defaut,
   fg = p.fg.default,
   yellow = p.yellow.base,
   cyan = p.cyan.base,
   blue = p.blue.base,
   darkblue = p.scale.blue[-1],
   green = p.green.base,
   orange = p.orange,
   violet = p.scale.purple[-3],
   magenta = p.magenta.base,
   red = p.red.base,
   pink = p.pink.base,
}
