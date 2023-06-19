-- vim: set foldmethod=marker:
-- 使用 lazyvim 加载插件

-- 在 lazyvim 尚未安装时安装 -------------------------------------------- {{{1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 初始化 --------------------------------------------------------------- {{{1
local Plug = { plugs = {} }
Plug.add = function(plug, opts)
    opts = opts or {}
    table.insert(opts, 1, plug)
    opts.config = function()
        local plug_name = opts.name or string.match(plug, "/([^/]+)$")
        local config_file_name = vim.fn.stdpath("config") .. "/Plugins/" .. plug_name
        if vim.fn.filereadable(config_file_name .. ".lua") == 1 then
            dofile(config_file_name .. ".lua")
        elseif vim.fn.filereadable(config_file_name .. ".vim") == 1 then
            vim.cmd("source " .. vim.fn.fnameescape(config_file_name .. ".vim"))
        end
    end
    table.insert(Plug.plugs, opts)
end
Plug.get = function()
    return Plug.plugs
end

-- 配置插件 ------------------------------------------------------------- {{{1
Plug.add('lambdalisue/suda.vim')
Plug.add('romainl/vim-cool')               -- disables search highlighting automatic
Plug.add('ojroques/vim-oscyank')
Plug.add('tpope/vim-sleuth')               -- automaticly adjusts 'shiftwidth' and 'expandtab'
Plug.add('ptzz/lf.vim')
Plug.add('ibhagwan/fzf-lua', { branch = 'main' })

Plug.add('machakann/vim-highlightedyank' ) -- 高亮显示复制区域
Plug.add('haya14busa/incsearch.vim' )      -- 加强版实时高亮
-- Plug.add('mg979/vim-visual-multi' )     -- 多重选择
Plug.add('andymass/vim-matchup' )          -- 显示匹配符号之间的内容
Plug.add('tpope/vim-commentary' )          -- Comment stuff out
Plug.add('junegunn/vim-easy-align' )       -- 文本对齐
Plug.add('machakann/vim-sandwich' )        -- 操作匹配符号
Plug.add('tpope/vim-repeat' )              -- 重复插件操作
-- 快速移动光标
-- Plug.add('phaazon/hop.nvim' )           -- 替代 sneak 和 easymotion
Plug.add('justinmk/vim-sneak' )            -- The missing motion for vim
Plug.add('easymotion/vim-easymotion' )     -- 高效移动指标插件
Plug.add('zzhirong/vim-easymotion-zh' )
Plug.add('nvim-treesitter/nvim-treesitter', {build = ':TSUpdate'})
Plug.add('folke/which-key.nvim' )

-- Chinese version of vim documents
Plug.add('yianwillis/vimcdoc')             

-- Stay: Stay at my cursor, boy!
Plug.add('zhimsel/vim-stay', {
    init = function()
        vim.cmd('set viewoptions=cursor,folds,slash,unix')
    end
}) 

-- FastFold: Speed up Vim by updating folds only when called-for
Plug.add('Konfekt/FastFold')

-- Plug.add('907th/vim-auto-save' )
-- 文本对象
-- Plug.add('wellle/targets.vim' )
-- Plug.add('kana/vim-textobj-user' )

Plug.add('vim-voom/VOoM' )

-- Project management ==================================================== {{{1
Plug.add('ahmedkhalf/project.nvim' )
Plug.add('ludovicchabant/vim-gutentags' )
Plug.add('folke/trouble.nvim', {ft = 'c'})
Plug.add('tpope/vim-fugitive' )

-- Terminal tools ======================================================== {{{1
Plug.add('voldikss/vim-floaterm' )
Plug.add('skywind3000/asyncrun.vim' )       -- 异步执行终端程序
Plug.add('skywind3000/asynctasks.vim' )
Plug.add('liubianshi/vimcmdline' )
Plug.add('windwp/nvim-autopairs' )

-- Plug.add('skywind3000/vim-terminal-help' )
-- Plug.add('tpope/vim-obsession')            -- tmux Backup needed

-- 个性化 UI ============================================================= {{{1
Plug.add('luisiacc/gruvbox-baby', {lazy = true})
Plug.add('ayu-theme/ayu-vim', {lazy = true})
Plug.add('rebelot/kanagawa.nvim', {lazy = true})
Plug.add('mhartington/oceanic-next', {lazy = true})
Plug.add('sainnhe/everforest', {lazy = true})
Plug.add('catppuccin/nvim', {name = 'catppuccin', lazy = true})
-- buffer line (with minimal tab integration) for neovim
Plug.add('akinsho/bufferline.nvim', {
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
})
-- neovim statusline plugin written in pure lua
Plug.add('nvim-lualine/lualine.nvim' )              
Plug.add('mhinz/vim-startify' )
Plug.add('nvim-tree/nvim-web-devicons' )
-- Auto Ajust the width and height of focused window
Plug.add('beauwilliams/focus.nvim' )
-- TrueZen.nvim: Clean and elegant distraction-free writing for NeoVim. {{{2
-- Plug.add('Pocco81/TrueZen.nvim' )
Plug.add('folke/zen-mode.nvim' )

-- 补全和代码片断 -------------------------------------------------------- {{{1
Plug.add('sirver/UltiSnips', {
    dependencies = {'honza/vim-snippets'},
    event = 'InsertEnter',
})
Plug.add('jalvesaq/zotcite',{
    ft = {"pandoc", "rmd", "rmarkdown", "markdown"},
})
if vim.g.complete_method == 'coc' then
    Plug.add('neoclide/coc.nvim', {
        branch = 'release',
        event = 'InsertEnter',
        dependencies = {
            'sirver/UltiSnips',
            'honza/vim-snippets',
        },
    })
else
    local cmp_dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-omni',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'FelipeLema/cmp-async-path',
        'jalvesaq/cmp-nvim-r',
        'ray-x/cmp-treesitter',
        'onsails/lspkind.nvim',
        'quangnguyen30192/cmp-nvim-ultisnips',
        'kristijanhusak/vim-dadbod-completion',
        'kdheepak/cmp-latex-symbols',
        'jalvesaq/cmp-zotcite',
    }
    for _,k in ipairs(cmp_dependencies) do
        Plug.add(k, {lazy = true})
    end
    if vim.fn.has('mac') == 0 then
        Plug.add('wasden/cmp-flypy.nvim', { lazy = true, build = "make flypy"})
        table.insert(cmp_dependencies, 'wasden/cmp-flypy.nvim')
    end
    Plug.add('neovim/nvim-lspconfig')
    Plug.add('hrsh7th/nvim-cmp', {
        event = "InsertEnter",
        dependencies = cmp_dependencies,
    })
end

-- Command line Fuzzy Search and completation ---------------------------- {{{2
Plug.add('gelguy/wilder.nvim', { build = ":UpdateRemotePlugins"})

-- Formatter and linter -------------------------------------------------- {{{2
Plug.add('mhartington/formatter.nvim', {
    ft = { 'lua', 'sh', 'perl', 'r', 'html', 'xml', 'css'}
})

-- Writing and knowledge management ====================================== {{{1
Plug.add('vim-pandoc/vim-pandoc', {
    dependencies = {'vim-pandoc/vim-pandoc-syntax'},
    ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc'}
})
Plug.add('ferrine/md-img-paste.vim', {
    ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc'}
})
Plug.add('hotoo/pangu.vim', {
    ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc'}
})
Plug.add('dhruvasagar/vim-table-mode', {
    ft = {'pandoc', 'rmd', 'org'}
})
Plug.add('nvim-neorg/neorg', {
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = {'norg'},
    cmd = {'Neorg'},
})

-- 文件类型相关插件 ====================================================== {{{1
-- SQL {{{2
Plug.add('kristijanhusak/vim-dadbod-ui', {
    cmd = {'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer'},
    dependencies = {'tpope/vim-dadbod'},
})
-- R {{{2
Plug.add('liubianshi/Nvim-R', {
    ft = {'r', 'rmd', 'qml'},
    cmd = {'Rstart'},
})
-- tex {{{2
Plug.add('lervag/vimtex', { ft = 'tex' })
-- stata {{{2
Plug.add('poliquin/stata-vim', { ft = 'stata' })  -- stata 语法高亮
-- csv / tsv {{{2
Plug.add('mechatroner/rainbow_csv', { ft = {'csv', 'tsv'}})
-- perl {{{2 
Plug.add('WolfgangMehner/perl-support', { ft = 'perl'})
-- Graphviz dot {{{2
Plug.add('liuchengxu/graphviz.vim', { ft = 'dot' })
-- quickfile {{{2
-- Plug.add('kevinhwang91/nvim-bqf')

-- Misc ================================================================= {{{1
-- Plug.add('skywind3000/vim-dict', {
--      ft = {'markdown', 'pandoc', 'rmarkdown', 'rmd'}
-- }) 
-- Plug.add('tommcdo/vim-exchange' )


-- 安装并加载插件 ------------------------------------------------------- {{{1
local lazy = require("lazy")
lazy.setup(
    Plug.get(),
    dofile(vim.fn.stdpath("config") .. "/Plugins/lazy.lua")
)

-- 创建辅助函数 --------------------------------------------------------- {{{1
_G.LoadedPlugins = function()
    local plugs = require('lazy').plugins()
    local loaded_plugs = {}
    for _,plug in ipairs(plugs) do
        if not plug['_'].loaded then
            loaded_plugs[plug.name] = 1
        end
    end
    return loaded_plugs
end

