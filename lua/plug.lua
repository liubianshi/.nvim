-- vim: set foldmethod=marker:
-- 使用 lazyvim 加载插件
package.path = package.path .. ";"
            .. vim.env.HOME .. "/.luarocks/share/lua/5.1/?/init.lua;"
            .. vim.env.HOME .. "/.luarocks/share/lua/5.1/?.lua;"

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
    local plug_name        = opts.name or string.match(plug, "/([^/]+)$")
    local config_file_name = vim.fn.stdpath("config") .. "/Plugins/" .. plug_name
    config_file_name       = vim.fn.fnameescape(config_file_name)
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
-- GUI
Plug.add('equalsraf/neovim-gui-shim')
-- UI ------------------------------------------------------------------- {{{2
-- lambdalisue/suda.vim: Read and write with sudo command --------------- {{{3
Plug.add('lambdalisue/suda.vim', { cmd = {'SudaWrite', 'SudaRead'} })
-- romainl/vim-cool: disables search highlighting automatic ------------- {{{3
Plug.add('romainl/vim-cool', { event = 'VeryLazy' })
-- ojroques/vim-oscyank: copy text through SSH with OSC52 --------------- {{{3
Plug.add('ojroques/vim-oscyank', {cmd = "OSCYank"})

-- tpope/vim-sleuth: automaticly adjusts 'shiftwidth' and 'expandtab' --- {{{3
Plug.add('tpope/vim-sleuth', {
    event = {'BufReadPost', 'BufWrite'}
})

-- is0n/fm-nvim: open terminal file manager or other terminal app ------- {{{3
Plug.add('is0n/fm-nvim', {
    cmd = {'Lf', 'Nnn', 'Neomutt', 'Lazygit'},
    keys = {
        { "<leader>fo", "<cmd>Lf '%:p:h'<cr>",  desc = "Open File with Lf"  },
        { "<leader>fn", "<cmd>Nnn '%:p:h'<cr>", desc = "Open File with nnn" },
        { "<leader>gg", "<cmd>Lazygit<cr>",   desc = "Open Lazy Git"      },
    }
})

-- nvim-neo-tree/neo-tree.nvim: browse tree like structures ------------- {{{3
Plug.add('nvim-neo-tree/neo-tree.nvim', {
    cmd = "Neotree",
    keys = {
        { "<leader>fe", desc = "Explorer NeoTree (root dir)",
            function()
                require("neo-tree.command").execute({
                    toggle = true,
                    dir = Util.get_root()
                })
            end, },
        { "<leader>fE", desc = "Explorer NeoTree (cwd)",
            function()
                require("neo-tree.command").execute({
                    toggle = true,
                    dir = vim.loop.cwd()
                })
            end, },
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

-- s1n7ax/nvim-window-picker: pick a window and returns the window id --- {{{3
Plug.add('s1n7ax/nvim-window-picker', {
    name = 'window-picker',
    lazy = true,
    version = "2.*",
})

-- ibhagwan/fzf-lua: Fzf Search ----------------------------------------- {{{3
Plug.add('ibhagwan/fzf-lua', {
    branch = 'main',
    dependencies = { 'skywind3000/asynctasks.vim' },
    cmd = {'FzfLua', 'Shelp'},
    keys = {
        '<leader>pp', '<leader>ic', '<leader>fz', '<leader>bB', '<leader>.', '<leader>ot', '<A-x>',
        { "<leader>bb", "<cmd>FzfLua buffers<cr>"             , desc = "FzfLua: Select buffer",                         },
        { "<leader>st", "<cmd>FzfLua tags<cr>"                , desc = "FzfLua: tags",                                  },
        { "<leader>sT", "<cmd>FzfLua btags<cr>"               , desc = "FzfLua: buffer tags",                           },
        { "<leader>qs", "<cmd>FzfLua quickfix<cr>"            , desc = "FzfLua: quickfix",                              },
        { "<leader>sC", "<cmd>FzfLua colorschemes<cr>"        , desc = "FzfLua: colorschemes",                          },
        { "<leader>sl", "<cmd>FzfLua lgrep_curbuf<cr>"        , desc = "FzfLua: Grep current buffer",                   },
        { "<leader>sr", "<cmd>FzfLua grep<cr>"                , desc = "FzfLua: Grep lines",                            },
        { "<leader>sR", "<cmd>FzfLua grep_project<cr>"        , desc = "FzfLua: Grep project",                          },
        { "<leader>pr", "<cmd>FzfLua grep_project<cr>"        , desc = "FzfLua: Grep project",                          },
        { "<c-b>"     , "<cmd>FzfLua grep_cword<cr>"          , desc = "FzfLua: Grep cword",          mode = {'n', 'x'} },
    }
})

-- nvim-telescope/telescope.nvim: Find, Filter, Preview, Pick ----------- {{{3
Plug.add('nvim-telescope/telescope.nvim', {
    tag = '0.1.2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'fhill2/telescope-ultisnips.nvim',
        'FeiyouG/command_center.nvim',
        "nvim-telescope/telescope-frecency.nvim"
    },
    keys = {
        { "<leader>ff", Util.telescope("files"),                                      desc = "Telescope: Find Files (root dir)" },
        { "<leader>fF", Util.telescope("files", { cwd = vim.fn.expand('%:p:h') }),    desc = "Telescope: Find Files (cwd)"      },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                desc = "Telescope: Recent"                },
        { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.fn.expand('%:p:h') }), desc = "Telescope: Recent (cwd)"          },
        { "<leader>sk", Util.telescope('keymaps'),                                    desc = "Telescope: Keymaps"               },
        { "<leader>sm", Util.telescope('man_pages'),                                  desc = "Telescope: Man Pages"             },
        { "<leader>fp", "<cmd>Telescope frecency<cr>",                                desc = "Telescope: Frecency"              },
        { "<leader>:" , "<cmd>Telescope command_center<cr>",                          desc = "Telescope: Command Center"        },
        { "<leader>sg", Util.telescope("live_grep"),                                  desc = "Grep (root dir)"                  },
        { "<leader>sG", Util.telescope("live_grep", { cwd = false }),                 desc = "Grep (cwd)"                       },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>",                               desc = "Telescope: Vim Helper"            },
        { "<leader>su", "<cmd>Telescope ultisnips<cr>",                               desc = "Telescope: Ultisnips"             },
        { "<leader>sw", Util.telescope("grep_string"),                                desc = "Word (root dir)"                  },
        { "<leader>sW", Util.telescope("grep_string", { cwd = false }),               desc = "Word (cwd)"                       },
        { "<leader>ss", Util.telescope("lsp_document_symbols", {
                symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
                },
            }), desc = "Goto Symbol", },
        { "<leader>sS", Util.telescope("lsp_dynamic_workspace_symbols", {
                symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
                },
            }), desc = "Goto Symbol (Workspace)", },
    },
    cmd = "Telescope",
})

Plug.add('nvim-telescope/telescope-fzf-native.nvim', {
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
            '&& cmake --build build --config Release ' ..
            '&& cmake --install build --prefix build',
    lazy  = true,
})
Plug.add('FeiyouG/command_center.nvim', { lazy = true, })
Plug.add("nvim-telescope/telescope-frecency.nvim", {
    dependencies = {"kkharji/sqlite.lua"},
    lazy = true,
})

-- gelguy/wilder.nvim: Command line Fuzzy Search and completation ------- {{{3
Plug.add('gelguy/wilder.nvim', {
    dependencies = {'romgrk/fzy-lua-native'},
    build = ":UpdateRemotePlugins",
    event = {'CmdwinEnter', 'CmdlineEnter'}
})

-- machakann/vim-highlightedyank: 高亮显示复制区域 ---------------------- {{{3
Plug.add('machakann/vim-highlightedyank' )

-- kevinhwang91/nvim-hlslens: Hlsearch Lens for Neovim ------------------ {{{3
Plug.add('kevinhwang91/nvim-hlslens', {
    event = { "SearchWrapped", "CursorMoved" },
})

-- mg979/vim-visual-multi: 多重选择 ------------------------------------- {{{3
Plug.add('mg979/vim-visual-multi', {
    init = function()
        if Util.has('nvim-hlslens') then
            vim.cmd([[
                aug VMlens
                    au!
                    au User visual_multi_start lua require('vmlens').start()
                    au User visual_multi_exit  lua require('vmlens').exit()
                aug END
            ]])
        end
    end,
    branch = 'master',
    keys = {
        {"<C-n>",                               desc = "Find Word", mode = {'n', 'v', 'x'}},
        {"<A-j>", '<Plug>(VM-Add-Cursor-Down)', desc = "Add Cursors Down"},
        {"<A-k>", '<Plug>(VM-Add-Cursor-Up)',   desc = "Add Cursors Up"},
    }
})
-- andymass/vim-matchup: 显示匹配符号之间的内容 ------------------------- {{{3
Plug.add('andymass/vim-matchup')

-- tpope/vim-commentary: Comment stuff out ------------------------------ {{{3
Plug.add('tpope/vim-commentary', {
    cmd = "Commentary", keys = {
        {'gc', mode ={'n', 'v', 'x'}},
        'gcc'
    }
})

-- junegunn/vim-easy-align: text alignment tool ------------------------- {{{3
Plug.add('junegunn/vim-easy-align', {
    keys = {
        {'ga', mode = {'n', 'v', 'x'}}
    },
    cmd = "EasyAlign",
})

-- beauwilliams/focus.nvim: Auto Ajust the size of focused window ------- {{{3
Plug.add('nvim-focus/focus.nvim', {
    keys = {
        { '<leader>wh', '<cmd>FocusSplitLeft<cr>',  desc = "Focus Split Left"  },
        { '<leader>wl', '<cmd>FocusSplitRight<cr>', desc = "Focus Split Right" },
        { '<leader>wj', '<cmd>FocusSplitDown<cr>',  desc = "Focus Split Down"  },
        { '<leader>wk', '<cmd>FocusSplitUp<cr>',    desc = "Focus Split Up"    },
        { '<leader>wm', '<cmd>FocusMaximise<cr>',   desc = "Focus Maximise"    },
        { '<leader>we', '<cmd>FocusEqualise<cr>',   desc = "Focus Equalise"    },
        { '<leader>ww', '<cmd>FocusSplitNicely<cr>',desc = "Focus Equalise"    },
    }
})

-- folke/zen-mode.nvim: Distraction-free coding for Neovim -------------- {{{3
Plug.add('folke/zen-mode.nvim', {
    cmd = "ZenMode",
    keys = {
        {'<leader>oZ', '<cmd>ZenMode<cr>', desc = "Toggle Zen Mode"}
    }
})

-- machakann/vim-sandwich: add/delete/replace surroundings -------------- {{{3
Plug.add('machakann/vim-sandwich', {
    init = function()
        vim.g.operator_sandwich_no_default_key_mappings = 1
    end,
    keys = {'ds', 'cs', 'ys'}
})

-- tpope/vim-repeat: 重复插件操作 --------------------------------------- {{{3
Plug.add('tpope/vim-repeat', {
    keys = {
        {'.', mode = {'n', 'v', 'x'}}
    }
})

-- nvim-pack/nvim-spectre: find with rg and replace with sed ------------ {{{3
Plug.add("nvim-pack/nvim-spectre", {
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    dependencies = {'nvim-lua/plenary.nvim'},
    keys = {
        { "<leader>R", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
})

-- rcarriga/nvim-notify: notification manager --------------------------- {{{3
Plug.add('rcarriga/nvim-notify', {
    keys = {
        { 
            "<leader>nu",
            function()
                require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Dismiss all Notifications",
        },
    },
    init = function() vim.notify = require('notify') end,
})

-- folke/flash.nvim: Navigate tools ------------------------------------- {{{3
Plug.add("folke/flash.nvim", {
  event = "VeryLazy",
  keys = {
    {
      "ss",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
})

-- easymotion/vim-easymotion: motion tools ------------------------------ {{{3
Plug.add('easymotion/vim-easymotion', {
    init = function()
        vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings
        vim.g.EasyMotion_smartcase  = 1
        vim.g.EasyMotion_use_migemo = 1
    end,
    dependencies = {'zzhirong/vim-easymotion-zh'},
    keys = {
        { '<localleader>s',  '<esc><Plug>(easymotion-sl)', mode = {'i'}, desc = 'EasyMotion: Find Char (current line)'},
        { 's.',  '<Plug>(easymotion-repeat)', desc = 'EasyMotion: Repeat last motion'},
        { 'sc',  '<Plug>(easymotion-s2)',     desc = 'EasyMotion: Search for 2 chars'},
        { 'sl',  '<Plug>(easymotion-sl)',     desc = 'EasyMotion: Find Char (current line)'},
        { 'sj',  '<plug>(easymotion-j)',      desc = 'EasyMotion: Line Downward'},
        { 'sJ',  '<plug>(easymotion-eol-j)',  desc = 'EasyMotion: Line Downword (end)'},
        { 'sk',  '<plug>(easymotion-k)',      desc = 'EasyMotion: Line Forward'},
        { 'sK',  '<plug>(easymotion-eol-k)',  desc = 'EasyMotion: Line Forward (end)'},
        { 'sn',  '<Plug>(easymotion-n)',      desc = 'EasyMotion: latest search'},
        { 'sN',  '<Plug>(easymotion-N)',      desc = 'EasyMotion: latest search (backward)'},
        { 'sw',  '<Plug>(easymotion-w)',      desc = 'EasyMotion: Beginning of word'},
        { 'sW',  '<Plug>(easymotion-W)',      desc = 'EasyMotion: Beginning of WORD'},
        { 'sb',  '<Plug>(easymotion-b)',      desc = 'EasyMotion: EasyMotion: Beginning of word (backward)'},
        { 'sB',  '<Plug>(easymotion-B)',      desc = 'EasyMotion: EasyMotion: Beginning of WORD (backward)'},
        { 'se',  '<Plug>(easymotion-e)',      desc = 'EasyMotion: End of word'},
        { 'sE',  '<Plug>(easymotion-E)',      desc = 'EasyMotion: End of WROD'},
        { 'sge', '<Plug>(easymotion-e)',      desc = 'EasyMotion: End of word (backward)'},
        { 'sgE', '<Plug>(easymotion-E)',      desc = 'EasyMotion: End of WROD (backward)'},
    }
})

-- zzhirong/vim-easymotion-zh: motion in Chinese text ------------------- {{{3
Plug.add('zzhirong/vim-easymotion-zh', {lazy = true})

-- folke/which-key.nvim: displays a popup with possible keybindings ----- {{{3
Plug.add('folke/which-key.nvim', {event = "VeryLazy"})

-- yianwillis/vimcdoc: Chinese version of vim documents ----------------- {{{3
Plug.add('yianwillis/vimcdoc', {
    keys = { '<F1>', '<leader>sh' },
    event = {'CmdwinEnter', 'CmdlineEnter'},
})

-- zhimsel/vim-stay: Make Vim persist editing state without fuss -------- {{{3
Plug.add('zhimsel/vim-stay', {
    init = function()
        vim.o.viewoptions = "cursor,folds,slash,unix"
    end
})

-- Konfekt/FastFold: updating folds only when called-for ---------------- {{{3
Plug.add('Konfekt/FastFold')

-- kevinhwang91/nvim-ufo: ultra fold in Neovim -------------------------- {{{3
Plug.add('kevinhwang91/nvim-ufo', {
    dependencies = 'kevinhwang91/promise-async',
    init = function()
        vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
})
-- vim-voom/VOoM: vim Outliner of Markups ------------------------------- {{{3
Plug.add('vim-voom/VOoM', {
    cmd = "Voom",
    keys = {
        {"<leader>v", "<cmd>Voom<cr>", desc = "VOom: Show Outliner"},
    },
})

-- akinsho/bufferline.nvim: buffer line with minimal tab integration ---- {{{3
Plug.add('akinsho/bufferline.nvim', {
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    keys = {
        { "<leader>B", "<cmd>BufferLinePick<cr>", desc = "Choose Buffer" },
    }
})

-- nvim-lualine/lualine.nvim: neovim statusline plugin ------------------ {{{3
Plug.add('nvim-lualine/lualine.nvim', { event = 'VeryLazy' })

-- mhinz/vim-startify: fancy start screen for Vim ----------------------- {{{3
Plug.add('mhinz/vim-startify' )

-- nvim-tree/nvim-web-devicons: file type icons ------------------------- {{{3
Plug.add('nvim-tree/nvim-web-devicons', { lazy = true } )

-- windwp/nvim-autopairs: autopair tools -------------------------------- {{{3
Plug.add('windwp/nvim-autopairs' )

-- stevearc/dressing.nvim: improve the default vim.ui interfaces -------- {{{3
Plug.add('stevearc/dressing.nvim', {
    opts = {
        input = {
            default_prompt = "➤ ",
            win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
        },
        select = {
            backend = { "telescope", "builtin" },
            builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
        },
    },
    config = true,
})

-- "lukas-reineke/indent-blankline.nvim"
Plug.add('lukas-reineke/indent-blankline.nvim', {
    opts = {
        buftype_exclude = {
            "nofile",
            "terminal",
        },
        filetype_exclude = {
            "help",
            "startify",
            "aerial",
            "alpha",
            "dashboard",
            "lazy",
            "neogitstatus",
            "NvimTree",
            "neo-tree",
            "Trouble",
            'norg',
            'org',
            'markdown',
            'rmarkdown',
        },
        context_patterns = {
            "class",
            "return",
            "function",
            "method",
            "^if",
            "^while",
            "jsx_element",
            "^for",
            "^object",
            "^table",
            "block",
            "arguments",
            "if_statement",
            "else_clause",
            "jsx_element",
            "jsx_self_closing_element",
            "try_statement",
            "catch_clause",
            "import_statement",
            "operation_type",
        },
        show_trailing_blankline_indent = false,
        use_treesitter = true,
        char = "▏",
        context_char = "▏",
        show_current_context = true,
        show_current_context_start = true,
    }
})

-- xiyaowong/transparent.nvim: make nvim transparent -------------------- {{{3
Plug.add('xiyaowong/transparent.nvim')

-- Tools ---------------------------------------------------------------- {{{2
-- akinsho/toggleterm.nvim: manage multiple terminal windows ------------ {{{3
Plug.add('akinsho/toggleterm.nvim', {
    version = "*",
    cmd = "ToggleTerm",
    keys = {
        {
            "<space><space>", "<cmd>ToggleTerm<cr>",
            desc = "Toogle Terminal",
            noremap = true,
            silent = true,
            mode = {'n', 't'},
            remap = true,
        },
    }
})

-- skywind3000/asyncrun.vim: run async shell command -------------------- {{{3
Plug.add('skywind3000/asyncrun.vim', {
    cmd = "AsyncRun"
})

-- skywind3000/asynctasks.vim: modern Task System ----------------------- {{{3
Plug.add('skywind3000/asynctasks.vim', {
    dependencies = {
        'skywind3000/asyncrun.vim',
    },
    cmd = {"AsyncTask", "AsyncTaskList"},
    keys = {
        {'<leader>ot',  desc = "Run AsnycTask"}
    }
})

-- liubianshi/vimcmdline: send lines to interpreter --------------------- {{{3
Plug.add('liubianshi/vimcmdline' )
-- potamides/pantran.nvim: trans without leave neovim ------------------- {{{3
Plug.add('potamides/pantran.nvim', {
    keys = {
        {'<leader>tr', mode = {'x', 'n'}, desc = "Pantran: translate"},
        {'<leader>trr', mode = {'n'}, desc = "Pantran: translate"},
        {'<leader>T', "<cmd>Pantran target=en<cr>", desc = "Pantran: to English", mode = {'n', 'v'}},
    }
})

-- edluffy/hologram.nvim: terminal image viewer for Neovim -------------- {{{3
Plug.add('vhyrro/hologram.nvim', {
    ft = {'markdown', 'pandoc', 'rmd', 'rmarkdown', 'norg', 'org'},
    cond = (vim.env.TERM == "xterm-kitty"),
    cmd = 'PreviewImage',
})

-- gbprod/yanky.nvim: Improved Yank and Put functionalities for Neovim -- {{{3
Plug.add('gbprod/yanky.nvim', {
    dependencies = {
        { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") }
    },
    keys = {
        { "<leader>sp", function()
                require("telescope").extensions.yank_history.yank_history({ })
          end, desc = "Open Yank History" },

        { "y",         "<Plug>(YankyYank)",                      desc = "Yank text",                        mode = {'n', 'x'} },
        { "p",         "<Plug>(YankyPutAfter)",                  desc = "Put yanked text after cursor",     mode = {'n', 'x'}  },
        { "P",         "<Plug>(YankyPutBefore)",                 desc = "Put yanked text before cursor",    mode = {'n', 'x'}  },
        { "gp",        "<Plug>(YankyGPutAfter)",                 desc = "Put yanked text after selection",  mode = {'n', 'x'}  },
        { "gP",        "<Plug>(YankyGPutBefore)",                desc = "Put yanked text before selection", mode = {'n', 'x'}  },
        { "[y",        "<Plug>(YankyCycleForward)",              desc = "Cycle forward through yank history" },
        { "]y",        "<Plug>(YankyCycleBackward)",             desc = "Cycle backward through yank history" },
        { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
        { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
        { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
        { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
        { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and indent right" },
        { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and indent left" },
        { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
        { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put before and indent left" },
        { "=p",        "<Plug>(YankyPutAfterFilter)",            desc = "Put after applying a filter" },
        { "=P",        "<Plug>(YankyPutBeforeFilter)",           desc = "Put before applying a filter" },
    }
})

-- Project management --------------------------------------------------- {{{2
-- ahmedkhalf/project.nvim: superior project management solution -------- {{{3
Plug.add('ahmedkhalf/project.nvim', { keys = {{'<leader>pp', mode = "n"}}})
-- ludovicchabant/vim-gutentags: tag file management -------------------- {{{3
Plug.add('ludovicchabant/vim-gutentags', {
    event = {'BufReadPost', 'BufNewFile'}
})

-- folke/trouble.nvim: diagnostics solution ----------------------------- {{{3
Plug.add('folke/trouble.nvim', {ft = 'c'})

-- tpope/vim-fugitive: Git ---------------------------------------------- {{{3
Plug.add('tpope/vim-fugitive', { cmd = 'G'})


-- Theme ---------------------------------------------------------------- {{{2
Plug.add('luisiacc/gruvbox-baby',    {lazy = false})
Plug.add('ayu-theme/ayu-vim',        {lazy = false})
Plug.add('rebelot/kanagawa.nvim',    {lazy = false})
Plug.add('mhartington/oceanic-next', {lazy = false})
Plug.add('sainnhe/everforest',       {lazy = false})
Plug.add('catppuccin/nvim',          {name = 'catppuccin', lazy = true})
Plug.add('folke/tokyonight.nvim',    {lazy = false, priority = 1000})

-- 补全和代码片断 ------------------------------------------------------- {{{2

-- sirver/UltiSnips: Ultimate snippet solution -------------------------- {{{3
Plug.add('sirver/UltiSnips', {
    dependencies = {'honza/vim-snippets'},
    cmd = {'UltiSnipsAddFiletypes'},
    event = 'InsertEnter',
})

-- jalvesaq/zotcite: Vim plugin for integration with Zotero ------------- {{{3
Plug.add('jalvesaq/zotcite',{
    ft = {"pandoc", "rmd", "rmarkdown", "markdown"},
})

-- completation framework and relative sources -------------------------- {{{3
if vim.g.complete_method == 'coc' then
    -- neoclide/coc.nvim: Nodejs extension host for vim & neovim -------- {{{4
    Plug.add('neoclide/coc.nvim', {
        branch = 'release',
        event = 'InsertEnter',
        dependencies = {
            'sirver/UltiSnips',
            'honza/vim-snippets',
        },
    })
else
    -- neovim/nvim-lspconfig: Quickstart configs for Nvim LSP ----------- {{{4
    Plug.add('neovim/nvim-lspconfig', {
        event = {'BufReadPre', 'BufNewFile', 'BufWinEnter'},
    })

    -- hrsh7th/nvim-cmp: A completion plugin for neovim ----------------- {{{4
    local cmp_dependencies = {
        'hrsh7th/cmp-nvim-lsp',                 -- neovim builtin LSP client
        'hrsh7th/cmp-omni',                     -- omnifunc
        'hrsh7th/cmp-buffer',                   -- buffer words
        'hrsh7th/cmp-cmdline',                  -- command line keywords
        'FelipeLema/cmp-async-path',            -- filesystem paths
        'jalvesaq/cmp-nvim-r',                  -- r with Nvim-R as backend
        'ray-x/cmp-treesitter',                 -- treesitter nodes
        'onsails/lspkind.nvim',                 -- adds vscode-like pictograms
        'quangnguyen30192/cmp-nvim-ultisnips',  -- ultisnips
        'kristijanhusak/vim-dadbod-completion', -- dadbod
        'kdheepak/cmp-latex-symbols',           -- latex symbol
    }
    for _,k in ipairs(cmp_dependencies) do
        Plug.add(k, {lazy = true})
    end
    Plug.add('liubianshi/cmp-zotcite', {
        dependencies = "jalvesaq/zotcite",
        ft = {'markdown', 'pandoc', 'rmarkdown', 'Rmd'},
    })
    table.insert(cmp_dependencies, 'liubianshi/cmp-zotcite')
    Plug.add('jalvesaq/cmp-nvim-r', {
        ft = {'r', 'rmd'},
        dependencies = { 'hrsh7th/nvim-cmp' }
    })
    -- 如果作为 cmp 的依赖加载，会导致 ItermKind 无法识别
    -- table.insert(cmp_dependencies, 'jalvesaq/cmp-nvim-r')
    if vim.fn.has('mac') == 0 then
        -- wasden/cmp-flypy.nvim: Chinese IM ---------------------------- {{{4
        Plug.add('wasden/cmp-flypy.nvim', {
            lazy = true,
            build = "make flypy"
        })
        table.insert(cmp_dependencies, 'wasden/cmp-flypy.nvim')
    end
    Plug.add('hrsh7th/nvim-cmp', {
        event = "InsertEnter",
        dependencies = cmp_dependencies,
    })
end

-- Formatter and linter ------------------------------------------------- {{{2

-- mhartington/formatter.nvim: autoformat tool -------------------------- {{{3
Plug.add('mhartington/formatter.nvim', {
    ft = { 'lua', 'sh', 'perl', 'r', 'html', 'xml', 'css'}
})

-- Writing and knowledge management ------------------------------------- {{{2

-- vim-pandoc/vim-pandoc: pandoc integration and utilities for vim ------ {{{3
Plug.add('vim-pandoc/vim-pandoc-syntax', {
    init = function()
        vim.g.tex_conceal = "adgm"
        vim.cmd([[
            let g:pandoc#syntax#codeblocks#embeds#langs = [
                        \ "ruby",    "perl",       "r",
                        \ "bash=sh", "stata",      "vim",
                        \ "python",  "perl6=raku", "c"]
        ]])
    end,
    ft = {'markdown', 'pandoc', 'markdown.pandoc'}
})
-- Plug.add('vim-pandoc/vim-pandoc', {
--     dependencies = {'vim-pandoc/vim-pandoc-syntax'},
--     ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc'}
-- })

-- ferrine/md-img-paste.vim: paste image to markdown -------------------- {{{3
Plug.add('ferrine/md-img-paste.vim', {
    ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc'}
})

-- hotoo/pangu.vim: 『盘古之白』中文排版自动规范化 ---------------------- {{{3
Plug.add('hotoo/pangu.vim', {
    ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc', 'norg', 'org'}
})

-- dhruvasagar/vim-table-mode: Table Mode for instant table creation ---- {{{3
Plug.add('dhruvasagar/vim-table-mode', {
    ft = {'markdown', 'pandoc', 'rmd', 'org'}
})

-- 文件类型相关插件 ----------------------------------------------------- {{{2

-- nvim-neorg/neorg: new org-mode in neovim ----------------------------- {{{3
Plug.add('nvim-neorg/neorg', {
    build = ":Neorg sync-parsers",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neorg/neorg-telescope",
    },
    ft = {'norg'},
    cmd = {'Neorg'},
    keys = {
        {'<leader>ej', '<cmd>Neorg journal today<cr>', desc = "Open today's journal"},
        {'<leader>sn', '<cmd>Telescope neorg switch_workspace<cr>', desc = "Switch Norg Workspace"},
    }
})

-- kristijanhusak/vim-dadbod-ui: simple UI for vim-dadbod --------------- {{{3
Plug.add('kristijanhusak/vim-dadbod-ui', {
    cmd = {'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer'},
    dependencies = {'tpope/vim-dadbod'},
})

-- liubianshi/Nvim-R: Vim plugin to work with R ------------------------- {{{3
Plug.add('liubianshi/Nvim-R', {
    ft = {'r', 'rmd', 'qml'},
    cmd = {'Rstart'},
})

-- lervag/vimtex: filetype plugin for LaTeX files ----------------------- {{{3
Plug.add('lervag/vimtex', { ft = 'tex' })

-- poliquin/stata-vim: Syntax highlighting and snippets for Stata files - {{{3
Plug.add('poliquin/stata-vim', { ft = 'stata' })  -- stata 语法高亮

-- mechatroner/rainbow_csv: Highlight columns and run queries ----------- {{{3
Plug.add('mechatroner/rainbow_csv', { ft = {'csv', 'tsv'}})

-- WolfgangMehner/perl-support: filetype plugin for perl files ---------- {{{3
Plug.add('WolfgangMehner/perl-support', { ft = 'perl'})

-- liuchengxu/graphviz.vim: Graphviz dot -------------------------------- {{{3
Plug.add('liuchengxu/graphviz.vim', { ft = 'dot' })

-- kevinhwang91/nvim-bqf: Better quickfix window in Neovim -------------- {{{3
Plug.add('kevinhwang91/nvim-bqf', { ft = 'qf' })

-- nvim-orgmode/orgmode: Orgmode clone written in Lua ------------------- {{{3
Plug.add('nvim-orgmode/orgmode', {
    dependencies = {'nvim-treesitter/nvim-treesitter'},
    ft = 'org',
    keys = {
        {'<leader>oa', desc = "Orgmode: agenda prompt"},
        {'<leader>oc', desc = "Orgmode: capture prompt"},
    }
})

Plug.add('akinsho/org-bullets.nvim', {
    dependencies = {'nvim-orgmode/orgmode'},
    config = true
})

-- fladson/vim-kitty: kitty config syntax highlighting for vim ---------- {{{3
Plug.add('fladson/vim-kitty', {
    ft = 'kitty'
})

-- TreeSitter ----------------------------------------------------------- {{{2
-- nvim-treesitter/nvim-treesitter: Treesitter configurations ----------- {{{3
Plug.add('nvim-treesitter/nvim-treesitter', {
    build = ':TSUpdate',
    cmd = 'TSEnable',
    event = {'BufReadPost', "BufNewFile"}
})

-- AckslD/nvim-FeMaco.lua: Fenced Markdown Code-block editing ----------- {{{3
Plug.add('AckslD/nvim-FeMaco.lua', {
    dependencies = {'nvim-treesitter/nvim-treesitter'},
    cmd = 'FeMaco',
    keys = {
        {'<localleader>o', '<cmd>FeMaco<cr>', desc = "FeMaco: Edit Code Block"}
    },
    config = true,
})

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

_G.PlugExist = function(plug)
    return(Util.has(plug))
end


