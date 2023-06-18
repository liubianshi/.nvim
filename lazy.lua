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

require('lazy').setup({
    { 'lambdalisue/suda.vim'},           -- read or write files with sudo command
    { 'romainl/vim-cool'},               -- disables search highlighting automatic
    { 'ojroques/vim-oscyank'},
    { 'tpope/vim-sleuth'},               -- automaticly adjusts 'shiftwidth' and 'expandtab'
    { 'ptzz/lf.vim'},
    { 'ibhagwan/fzf-lua', branch = 'main'},

    { 'machakann/vim-highlightedyank' }, -- 高亮显示复制区域
    { 'haya14busa/incsearch.vim' },      -- 加强版实时高亮
    -- { 'mg979/vim-visual-multi' },     -- 多重选择
    { 'andymass/vim-matchup' },          -- 显示匹配符号之间的内容
    { 'tpope/vim-commentary' },          -- Comment stuff out
    { 'junegunn/vim-easy-align' },       -- 文本对齐
    { 'machakann/vim-sandwich' },        -- 操作匹配符号
    { 'tpope/vim-repeat' },              -- 重复插件操作
                                         -- 快速移动光标
    -- { 'phaazon/hop.nvim' },           -- 替代 sneak 和 easymotion
    { 'justinmk/vim-sneak' },            -- The missing motion for vim
    { 'easymotion/vim-easymotion' },     -- 高效移动指标插件
    { 'zzhirong/vim-easymotion-zh' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    { 'folke/which-key.nvim' },

    -- Chinese version of vim documents
    { 'yianwillis/vimcdoc' },             

    -- Stay: Stay at my cursor, boy!
    { 'zhimsel/vim-stay', cmd = 'set viewoptions=cursor,folds,slash,unix' }, 

    -- FastFold: Speed up Vim by updating folds only when called-for
    { 'Konfekt/FastFold' },

    -- { '907th/vim-auto-save' },
    -- 文本对象
    -- { 'wellle/targets.vim' },
    -- { 'kana/vim-textobj-user' },

    { 'vim-voom/VOoM' },

    -- Project management ==================================================== {{{1
    { 'ahmedkhalf/project.nvim' },
    { 'ludovicchabant/vim-gutentags' },
    { 'folke/trouble.nvim', ft = 'c'}
    { 'tpope/vim-fugitive' },

    -- Terminal tools ======================================================== {{{1
    { 'voldikss/vim-floaterm' },
    { 'skywind3000/asyncrun.vim' },       -- 异步执行终端程序
    { 'skywind3000/asynctasks.vim' },
    { 'liubianshi/vimcmdline' },
    { 'windwp/nvim-autopairs' },

    -- { 'skywind3000/vim-terminal-help' },
    -- { 'tpope/vim-obsession', }, { 'on': [] }            -- tmux Backup needed

    -- 个性化 UI ============================================================= {{{1
    { 'luisiacc/gruvbox-baby'}
    { 'ayu-theme/ayu-vim'}
    { 'rebelot/kanagawa.nvim'}
    { 'mhartington/oceanic-next'}
    { 'sainnhe/everforest'}
    { 'catppuccin/nvim', name = 'catppuccin'},
    -- buffer line (with minimal tab integration) for neovim
    { 'akinsho/bufferline.nvim' },
    -- neovim statusline plugin written in pure lua
    { 'nvim-lualine/lualine.nvim' },              
    { 'mhinz/vim-startify' },
    { 'kyazdani42/nvim-web-devicons' },
    -- Auto Ajust the width and height of focused window
    { 'beauwilliams/focus.nvim' },
    -- TrueZen.nvim: Clean and elegant distraction-free writing for NeoVim. {{{2
    -- { 'Pocco81/TrueZen.nvim' },
    { 'folke/zen-mode.nvim' },

    -- 补全和代码片断 ======================================================== {{{1
    -- Snippets {{{2
    { 'sirver/UltiSnips' },
    { 'honza/vim-snippets' },
    { 'jalvesaq/zotcite' },

    -- 补全框架 -------------------------------------------------------------- {{{2
    if g:complete_method ==# --coc-- 
        { 'neoclide/coc.nvim', }, { 'branch': 'release' }
    else
    --    { 'williamboman/mason.nvim' },
    --    { 'williamboman/mason-lspconfig.nvim' },
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
        -- { 'glepnir/lspsaga.nvim', }, { 'branch': 'main' }
        -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        -- { 'ray-x/lsp_signature.nvim' },
        { 'hrsh7th/cmp-omni' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-cmdline' },
        { 'FelipeLema/cmp-async-path' },
        { 'jalvesaq/cmp-nvim-r' },
        { 'ray-x/cmp-treesitter' },
        { 'onsails/lspkind.nvim' },
        { 'quangnguyen30192/cmp-nvim-ultisnips' },
        -- { 'epwalsh/obsidian.nvim' },
        { 'kdheepak/cmp-latex-symbols' },
        { 'jalvesaq/cmp-zotcite' },
        if ! has('mac')
            { 'wasden/cmp-flypy.nvim', }, { 'do': 'make flypy' }
        endif
    endif -- ------------------------------------------------------------------ }}}
    -- Command line Fuzzy Search and completation ---------------------------- {{{2
    function! UpdateRemotePlugins(...)
    -- Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
    endfunction
    { 'gelguy/wilder.nvim', }, { 'do': function('UpdateRemotePlugins') }
    -- Formatter and linter --------------------------------------------------
    { 'mhartington/formatter.nvim' }, , { 'for': [ 'lua', 'sh', 'perl', 'r',
                                    \            'html', 'xml', 'css'
                                    \          ] }

    -- Writing and knowledge management ====================================== {{{1
    { 'vim-pandoc/vim-pandoc', },        { 'on': [] }
    { 'vim-pandoc/vim-pandoc-syntax', }, { 'on': [] }
    { 'ferrine/md-img-paste.vim', },     { 'on': [] }
    { 'hotoo/pangu.vim', },              { 'on': [] }
    { 'lervag/wiki.vim' },
    { 'nvim-orgmode/orgmode', }, { 'for': [ 'org' ] }
    { 'dhruvasagar/vim-table-mode', }, { 'for': [ 'pandoc', 'rmd', 'org' ] } 

    function! NeorgSyncParsers(...)
        Neorg sync-parsers
    endfunction
    { 'nvim-neorg/neorg', }, { 'do': function('NeorgSyncParsers') }
    { 'nvim-lua/plenary.nvim' },

    -- 文件类型相关插件 ====================================================== {{{1
    -- SQL {{{2
    -- Modern database interface for Vim
    { 'tpope/vim-dadbod', }, { 'on': [] }
    -- Simple UI for vim-dadbod
    { 'kristijanhusak/vim-dadbod-ui', }, { 'on': [] }
    { 'kristijanhusak/vim-dadbod-completion', }, { 'on': [] }
    -- R {{{2
    { 'liubianshi/Nvim-R' },
    -- tex {{{2
    { 'lervag/vimtex', }, {'on': []}
    -- stata {{{2
    { 'poliquin/stata-vim', }, { 'on': [] }  -- stata 语法高亮
    -- csv / tsv {{{2
    { 'mechatroner/rainbow_csv', }, { 'for': [ 'csv', 'tsv' ]}
    -- perl {{{2 
    { 'WolfgangMehner/perl-support', }, { 'for': ['perl'] }
    -- Graphviz dot {{{2
    { 'liuchengxu/graphviz.vim', }, { 'for': [ 'dot'] }
    -- quickfile {{{2
    -- { 'kevinhwang91/nvim-bqf' },

    -- Misc ================================================================== {{{1
    -- { 'skywind3000/vim-dict', }, { 'for': ['markdown', 'pandoc', 'rmarkdown', 'rmd'] }
    -- { 'tommcdo/vim-exchange' },

})
