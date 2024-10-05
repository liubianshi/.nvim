local opt = vim.opt
local cache_path = vim.fn.stdpath "cache"
local config_path = vim.fn.stdpath "config"
local opt_get = function(name, scope)
  scope = scope or "global"
  return vim.api.nvim_get_option_value(name, { scope = scope })
end

-- Resolving Errors Opening Man Files
vim.cmd [[runtime plugin/man.lua]]

-- Environment Variables ================================================ {{{1
vim.env.GTAGSLABEL = "native-pygments"
vim.env.GTAGSCONF = vim.env.HOME .. "/.globalrc"

-- Lua library ========================================================== {{{1
local luarocks_path = vim.env.XDG_CONFIG_HOME and
  (vim.env.XDG_CONFIG_HOME .. "/luarocks") or
  (vim.env.HOME  .. "/.luarocks")
package.path = package.path .. ";"
  .. (luarocks_path .. "/share/lua/5.1/?/init.lua") .. ";"
  .. (luarocks_path .. "/share/lua/5.1/?.lua")

-- Global variables ===================================================== {{{1
vim.g.mapleader = " "
vim.g.maplocalleader = ";"
vim.g.showtabline = 2
vim.g.laststatus = 3

if vim.fn.has "mac" == 1 then
  vim.g.lbs_input_method_on = 0
  vim.g.lbs_input_method_off = 1
  vim.g.lbs_input_status = "os_input_change -g"
  vim.g.lbs_input_method_inactivate = "os_input_change -s 1"
  vim.g.lbs_input_method_activate = "os_input_change -s 0"
else
  vim.g.lbs_input_status = "fcitx5-remote"
  vim.g.lbs_input_method_inactivate = "fcitx5-remote -c"
  vim.g.lbs_input_method_activate = "fcitx5-remote -o"
  vim.g.lbs_input_method_off = 1
  vim.g.lbs_input_method_on = 2
end

vim.g.plugs_lbs_conf = {} -- 用于记录插件个人配置文件的载入情况
vim.g.quickfix_is_open = 0 -- 用于记录 quickfix 的打开状态
vim.g.input_toggle = 1 -- 用于记录输入法状态
vim.g.plug_manage_tool = "lazyvim"

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Method of previewing images
vim.g.method_previewing_images = "system"

-- Options for the LazyVim statuscolumn --------------------------------- {{{2
vim.g.lazyvim_statuscolumn = {
  folds_open = true, -- show fold sign when fold is open
  folds_githl = true, -- highlight fold sign with git sign color
}

-- Man page ------------------------------------------------------------- {{{2
vim.g.ft_man_open_mode = "vert"
vim.g.ft_man_no_sect_fallback = 1
vim.g.ft_man_folding_enable = 1

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- perl ----------------------------------------------------------------- {{{2
vim.g.perl_host_prog = "/usr/bin/perl"
vim.g.Perldoc_path = vim.env.HOME .. "/.cache/perldoc/"

-- Python 相关设置 ------------------------------------------------------ {{{2
vim.g.python_host_skip_check = 0
vim.g.python3_host_skip_check = 0
if vim.fn.has "mac" == 1 then
  vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.9/libexec/bin/python"
  vim.g.python_host_prog = "/usr/bin/python2"
else
  vim.g.python_host_prog = "/usr/bin/python2"
  vim.g.python3_host_prog = "/usr/bin/python"
end

-- R -------------------------------------------------------------------- {{{2
vim.g.r_indent_align_args = 1
vim.g.r_indent_ess_compatible = 0
vim.g.r_indent_op_pattern = [[\(&\||\|+\|-\|\*\|/\|=\|\~\|%\|->\)\s*$]]
vim.g.R_start_libs = "base,stats,graphics,grDevices,utils,methods,"
  .. "rlang,data.table,readxl,haven,lbs,purrr,stringr,"
  .. "fst,future,devtools,ggplot2,fixest"

if vim.env.SSH_TTY and vim.env.TERM == "xterm-kitty" then
  opt.clipboard = ""
  vim.g.clipboard = {
    name = "Kitten clipboard",
    copy = {
        ["+"] = {'kitten', "clipboard"},
        ["*"] = {'kitten', "clipboard"},
    },
    paste = {
        ["+"] = {'kitten', "clipboard", "--get-clipboard"},
        ["*"] = {'kitten', "clipboard", "--get-clipboard", "-p"},
    },
    cache_enabled = 0,
  }
else
  opt.clipboard = "unnamedplus"
end

-- Options ============================================================== {{{1
opt.autoindent = true -- 自动缩进
opt.autoread = true
opt.autowrite = true
opt.backup = true
opt.backupcopy = "yes"
opt.backupdir = cache_path .. "/.backup//"
opt.backupskip = opt_get "wildignore"
opt.breakindent = true -- 回绕行保持视觉上的缩进
opt.cmdheight = 1
opt.completeopt = "menu,noinsert,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.dictionary:append {
  config_path .. "/paper.dict",
  config_path .. "/nvim/dict",
}
opt.directory = cache_path .. "/.swap//"
opt.encoding = "utf-8"
opt.expandtab = true -- 将制表符扩展为空格
opt.fileencodings =
  "ucs-bom,utf-8,cp936,gb2312,gb18030,big5,enc-jp,enc-krlatin1"
opt.fillchars = {
  foldopen = "·",
  foldclose = "",
  msgsep = "‾",
  vert = "│",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldcolumn = "0"
-- opt.foldexpr = "v:lua.require('util.ui').foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.formatlistpat =
  "\\v^\\s*(\\d{1,2}\\.|\\(\\d{1,2}\\)|\\[\\d{1,2}\\]|[-+*])\\s+"
opt.formatoptions = "tcn,1mp],Bj,oq"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.hlsearch = true -- 高亮显示搜索结果
opt.ignorecase = true -- 设置查找时大小不敏感
opt.inccommand = "nosplit" -- preview incremental substitute
opt.incsearch = true -- 开启实时搜索功能
opt.isfname:remove { "=", "," }
opt.jumpoptions = "view"
opt.laststatus = vim.g.laststatus
opt.linebreak = false -- 折行
opt.list = true -- show some invisible characters
opt.magic = true -- 对正则表达式开启 magic
opt.matchpairs:append {
  "<:>",
  "（:）",
  "「:」",
  "『:』",
  "【:】",
  "“:”",
  "‘:’",
  "《:》",
}
opt.matchtime = 2 -- 设置匹配括号时闪缩的时间
opt.mouse = "vh"
opt.number = true
opt.pumblend = 5 -- pseudo transparency for completion menu
opt.pumheight = 10 -- Maximum number of items to show in popup menu
opt.relativenumber = true -- 相对行号
opt.ruler = false -- 显示光标当前位置
opt.scrolloff = 3 -- 光标上下两侧最少保留的屏幕行数
-- Align indent to next multiple value of shiftwidth. For its meaning,
-- see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
opt.shiftround = true
opt.shiftwidth = 2 -- 设置格式化时制表符占用空格数
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showbreak = "" -- 会绕行放置在开头的字符串
opt.showmatch = true -- 高亮显示匹配括号
opt.showmode = true -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes:1"
opt.smartcase = true -- 如果有一个大写字母，则切换到大小写敏感查找
opt.smartindent = true -- 智能缩进
opt.smarttab = true -- Be Smart When using tabs
opt.smoothscroll = true
opt.spelllang = "en,cjk"
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.startofline = false
opt.statuscolumn = [[%!v:lua.require('util.ui').statuscolumn()]]
opt.synmaxcol = 1000
opt.swapfile = true
opt.tabstop = 2 -- 设置编辑时制表符占用空格数
opt.tags = "./tags,tags"
opt.termguicolors = true
opt.textwidth = 0 -- 行宽，自动排版所需
opt.timeoutlen = 300
opt.ttimeoutlen = 30
opt.undodir = cache_path .. "/.undo//"
opt.undofile = true
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildignore:append {
  "*.o,*.obj,*.dylib,*.bin,*.dll,*.exe",
  "*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**",
  "*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico",
  "*.pyc,*.pkl",
  "*.DS_Store",
  "*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv",
}
opt.wildmenu = true
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winblend = 5 -- pseudo transparency for floating window
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- 代码折行
opt.wrapmargin = 0 -- 指定拆行处与编辑窗口右边缘之间空出的字符数
opt.writebackup = false
