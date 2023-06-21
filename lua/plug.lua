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
local Util = require("util")
local Plug = { plugs = {} }
Plug.add = function(plug, opts)
    opts = opts or {}
    table.insert(opts, 1, plug)
    local plug_name = opts.name or string.match(plug, "/([^/]+)$")
    local config_file_name = vim.fn.stdpath("config") .. "/Plugins/" .. plug_name
    config_file_name = vim.fn.fnameescape(config_file_name)
    if not opts.config then
        if vim.fn.filereadable(config_file_name .. ".lua") == 1 then
            opts.config = function() dofile(config_file_name .. ".lua") end
        elseif vim.fn.filereadable(config_file_name .. ".vim") == 1 then
            opts.config = function() vim.cmd("source " .. config_file_name .. ".vim") end
        end
    end
    table.insert(Plug.plugs, opts)
end
Plug.get = function()
    return Plug.plugs
end

-- 配置插件 ------------------------------------------------------------- {{{1
Plug.add('lambdalisue/suda.vim', { cmd = {'SudaWrite', 'SudaRead'} })
Plug.add('romainl/vim-cool')               -- disables search highlighting automatic
Plug.add('ojroques/vim-oscyank', {cmd = "OSCYank"})
Plug.add('tpope/vim-sleuth')               -- automaticly adjusts 'shiftwidth' and 'expandtab'
-- Plug.add('ptzz/lf.vim', {
--     dependencies = {'voldikss/vim-floaterm'},
--     keys = {'<leader>fo', '<leader>fls', '<leader>flv', '<leader>flt'},
--     cmd = 'Lf',
-- })
Plug.add('is0n/fm-nvim', {
    cmd = {'Lf', 'Nnn', 'Neomutt', 'Lazygit'},
    keys = {
        {"<leader>fo", "<cmd>Lf<cr>",  desc = "Open File with Lf",  mode = "n"},
        {"<leader>fn", "<cmd>Nnn<cr>", desc = "Open File with nnn", mode = "n"},
        {"<leader>gg", "<cmd>Lazygit<cr>", desc = "Open Lazy Git",  mode = "n"},
    }
})
Plug.add('s1n7ax/nvim-window-picker', {
    name = 'window-picker',
    event = 'VeryLazy',
    version = "2.*",
})
Plug.add('nvim-neo-tree/neo-tree.nvim', {
    cmd = "Neotree",
    keys = {
    {
        "<leader>fe",
        function()
            require("neo-tree.command").execute({ toggle = true, dir = Util.get_root() })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fE",
        function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        's1n7ax/nvim-window-picker'
    },
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
    init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
        if vim.fn.argc() == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
            require("neo-tree")
            end
        end
    end,
})
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
Plug.add('ggandor/flit.nvim', {
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
})
Plug.add('ggandor/leap.nvim', {
    keys = {
      { "ss", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "sS", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
})
Plug.add('easymotion/vim-easymotion', {
    event = {'UiEnter'}
})     -- 高效移动指标插件
Plug.add('zzhirong/vim-easymotion-zh', {event = {'UiEnter'}})
Plug.add('nvim-treesitter/nvim-treesitter', {
    build = ':TSUpdate',
    cmd = 'TSEnable',
    event = {'BufReadPost', "BufNewFile"}
})
Plug.add('folke/which-key.nvim', { event = "VeryLazy" })

-- Chinese version of vim documents
Plug.add('yianwillis/vimcdoc', {
    keys = {
        {'<F1>', mode = "n"}
    },
    event = {'CmdwinEnter', 'CmdlineEnter'},
})

-- Stay: Stay at my cursor, boy!
Plug.add('zhimsel/vim-stay', {
    init = function()
        vim.o.viewoptions = "cursor,folds,slash,unix"
    end
}) 

-- FastFold: Speed up Vim by updating folds only when called-for
Plug.add('Konfekt/FastFold')

-- Plug.add('907th/vim-auto-save' )
-- 文本对象
-- Plug.add('wellle/targets.vim' )
-- Plug.add('kana/vim-textobj-user' )

Plug.add('vim-voom/VOoM', {
    cmd = "Voom",
    keys = {
        {"<leader>v", mode = "n"},
    }, 
})

-- Project management ==================================================== {{{1
Plug.add('ahmedkhalf/project.nvim', { keys = {{'<leader>pp', mode = "n"}}})
Plug.add('ludovicchabant/vim-gutentags')
Plug.add('folke/trouble.nvim', {ft = 'c'})
Plug.add('tpope/vim-fugitive')

-- Terminal tools ======================================================== {{{1
Plug.add('voldikss/vim-floaterm', {
    keys = {
        {"<leader><leader>", "<cmd>FloatermToggle<cr>", mode = "n"}
    }
})
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
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    keys = {
        { "<leader>B", "<cmd>BufferLinePick<cr>", desc = "Choose Buffer", mode = "n"},
    }
})
-- neovim statusline plugin written in pure lua
Plug.add('nvim-lualine/lualine.nvim', { event = 'VeryLazy' })
Plug.add('mhinz/vim-startify' )
Plug.add('nvim-tree/nvim-web-devicons', { lazy = true } )
-- Auto Ajust the width and height of focused window
Plug.add('beauwilliams/focus.nvim' )
-- TrueZen.nvim: Clean and elegant distraction-free writing for NeoVim. {{{2
-- Plug.add('Pocco81/TrueZen.nvim' )
Plug.add('folke/zen-mode.nvim' )

-- 补全和代码片断 -------------------------------------------------------- {{{1
Plug.add('sirver/UltiSnips', {
    dependencies = {'honza/vim-snippets'},
    cmd = {'UltiSnipsAddFiletypes'},
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
Plug.add('gelguy/wilder.nvim', {
    build = ":UpdateRemotePlugins",
    event = {'CmdwinEnter', 'CmdlineEnter'}
})

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

