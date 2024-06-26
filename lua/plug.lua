-- vim: set foldmethod=marker:
-- 使用 lazyvim 加载插件
package.path = package.path
  .. ";"
  .. vim.fn.expand "$HOME"
  .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path
  .. ";"
  .. vim.fn.expand "$HOME"
  .. "/.luarocks/share/lua/5.1/?.lua;"

-- 在 lazyvim 尚未安装时安装 -------------------------------------------- {{{1
local lazypath = vim.fn.stdpath("data")  .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
  if type(plug) == 'table' then
    opts = vim.tbl_extend("keep", plug, opts)
  else
    table.insert(opts, 1, plug)
  end
  local plug_name = opts.name or string.match(plug, "/([^/]+)$")
  local config_file_name = vim.fn.stdpath("config") .. "/Plugins/" .. plug_name
  config_file_name = vim.fn.fnameescape(config_file_name)
  if not opts.config then
    if vim.fn.filereadable(config_file_name .. ".lua") == 1 then
      opts.config = function()
        dofile(config_file_name .. ".lua")
      end
    elseif vim.fn.filereadable(config_file_name .. ".vim") == 1 then
      opts.config = function()
        vim.cmd("source " .. config_file_name .. ".vim")
      end
    end
  end
  table.insert(Plug.plugs, opts)
end
Plug.get = function()
  return Plug.plugs
end

-- 配置插件 ------------------------------------------------------------- {{{1
-- Plug.add("vhyrro/luarocks.nvim", { priority = 1000, config = true })
-- GUI
-- Plug.add("equalsraf/neovim-gui-shim")
-- UI ------------------------------------------------------------------- {{{2
-- lambdalisue/suda.vim: Read and write with sudo command --------------- {{{3
Plug.add("lambdalisue/suda.vim", { cmd = { "SudaWrite", "SudaRead" } })
-- romainl/vim-cool: disables search highlighting automatic ------------- {{{3
Plug.add("romainl/vim-cool", { event = "VeryLazy" })
-- ojroques/vim-oscyank: copy text through SSH with OSC52 --------------- {{{3
Plug.add("ojroques/vim-oscyank", { cmd = "OSCYank" })

-- typicode/bg.nvim: Automatically sync your terminal background -------- {{{3
Plug.add( "typicode/bg.nvim", { lazy = false })

-- is0n/fm-nvim: open terminal file manager or other terminal app ------- {{{3
Plug.add("is0n/fm-nvim", {
  cmd = { "Lf", "Nnn", "Neomutt", "Lazygit" },
  keys = {
    { "<leader>fo", "<cmd>Lf '%:p:h'<cr>", desc = "Open File with Lf" },
    { "<leader>fn", "<cmd>Nnn '%:p:h'<cr>", desc = "Open File with nnn" },
    { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Open Lazy Git" },
  },
})

-- nvim-neo-tree/neo-tree.nvim: browse tree like structures ------------- {{{3
Plug.add("s1n7ax/nvim-window-picker", { lazy = true, config = true})
Plug.add("nvim-neo-tree/neo-tree.nvim", {
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      desc = "Explorer NeoTree (root dir)",
      function()
        require("neo-tree.command").execute {
          toggle = true,
          dir = Util.get_root(),
        }
      end,
    },
    {
      "<leader>fE",
      desc = "Explorer NeoTree (cwd)",
      function()
        require("neo-tree.command").execute {
          toggle = true,
          dir = vim.loop.cwd(),
        }
      end,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.fn.isdirectory(vim.fn.argv(0))
      if stat and stat == 1 then
        require "neo-tree"
      end
    end
  end,
})

-- s1n7ax/nvim-window-picker: pick a window and returns the window id --- {{{3
Plug.add("s1n7ax/nvim-window-picker", { name = "window-picker", lazy = true })

-- ibhagwan/fzf-lua: Fzf Search ----------------------------------------- {{{3
Plug.add("ibhagwan/fzf-lua", {
  branch = "main",
  dependencies = { "skywind3000/asynctasks.vim" },
  cmd = { "FzfLua", "Shelp", "Urlopen", "RoamNodeFind", "Cheat" },
  keys = {
    "<leader>pp",
    "<leader>ic",
    "<leader>fz",
    "<leader>bB",
    "<leader>.",
    "<leader>ot",
    "<A-x>",
    {
      "<leader>:",
      "<cmd>FzfLua command_history<cr>",
      desc = "FzfLua: Command History",
    },
    {"<leader>hc", "<cmd>Cheat<cr>", desc = "FzfLua: Cheatsheet"},
    {
      "<leader>bb",
      "<cmd>FzfLua buffers<cr>",
      desc = "FzfLua: Select buffer",
    },
    {
      "<leader>u",
      "<cmd>Urlopen<cr>",
      desc = "FzfLua: Open urls",
    },
    {
      "<leader>st",
      "<cmd>FzfLua tags<cr>",
      desc = "FzfLua: tags",
    },
    {
      "<leader>sT",
      "<cmd>FzfLua btags<cr>",
      desc = "FzfLua: buffer tags",
    },
    {
      "<leader>qs",
      "<cmd>FzfLua quickfix<cr>",
      desc = "FzfLua: quickfix",
    },
    {
      "<leader>sC",
      "<cmd>FzfLua colorschemes<cr>",
      desc = "FzfLua: colorschemes",
    },
    {
      "<leader>sr",
      "<cmd>FzfLua grep<cr>",
      desc = "FzfLua: Grep lines",
    },
    {
      "<leader>sR",
      "<cmd>FzfLua grep_project<cr>",
      desc = "FzfLua: Grep project",
    },
    {
      "<leader>pr",
      "<cmd>FzfLua grep_project<cr>",
      desc = "FzfLua: Grep project",
    },
    {
      "<c-b>",
      "<cmd>FzfLua grep_cword<cr>",
      desc = "FzfLua: Grep cword",
      mode = { "n", "x" },
    },
  },
})

-- nvim-telescope/telescope.nvim: Find, Filter, Preview, Pick ----------- {{{3
Plug.add("nvim-telescope/telescope.nvim", {
  dependencies = {
    "nvim-lua/plenary.nvim",
    "fhill2/telescope-ultisnips.nvim",
    "FeiyouG/command_center.nvim",
  },
  keys = {
    {
      "<leader>ff",
      Util.telescope "files",
      desc = "Telescope: Find Files (root dir)",
    },
    {
      "<leader>sH",
      Util.telescope "highlights",
      desc = "Telescope: highlights",
    },
    {
      "<leader>fF",
      Util.telescope("files", { cwd = vim.fn.expand "%:p:h" }),
      desc = "Telescope: Find Files (cwd)",
    },
    {
      "<leader>fr",
      "<cmd>Telescope oldfiles<cr>",
      desc = "Telescope: Recent",
    },
    {
      "<leader>fR",
      Util.telescope("oldfiles", { cwd = vim.fn.expand "%:p:h" }),
      desc = "Telescope: Recent (cwd)",
    },
    {
      "<leader>sk",
      Util.telescope "keymaps",
      desc = "Telescope: Keymaps",
    },
    {
      "<leader>sj",
      Util.telescope("jumplist"),
      desc = "Telescope: Jumplist"
    },
    {
      "<leader>sl",
      Util.telescope("current_buffer_fuzzy_find"),
      desc = "Telescope: Search Current Buffer"
    },
    {
      "<leader>sm",
      Util.telescope "man_pages",
      desc = "Telescope: Man Pages",
    },
    {
      "<leader>sn",
      function()
        require('telescope.builtin').live_grep({
          prompt_title = "Search in Personal Library ...",
          cwd = (vim.env.WRITING_LIB or vim.env.HOME .. "/Documents/writing")
        })
      end,
      desc = "Telescope: Search Personal Notes",
    },
    {
      "<leader>sg",
      Util.telescope "live_grep",
      desc = "Grep (root dir)",
    },
    {
      "<leader>sG",
      Util.telescope("live_grep", { cwd = false }),
      desc = "Grep (cwd)",
    },
    {
      "<leader>sh",
      "<cmd>Telescope help_tags<cr>",
      desc = "Telescope: Vim Helper",
    },
    {
      "<leader>hh",
      "<cmd>Telescope help_tags<cr>",
      desc = "Telescope: Vim Helper",
    },
    {
      "<leader>su",
      "<cmd>Telescope ultisnips<cr>",
      desc = "Telescope: Ultisnips",
    },
    {
      "<leader>sw",
      Util.telescope "grep_string",
      desc = "Word (root dir)",
    },
    {
      "<leader>sW",
      Util.telescope("grep_string", { cwd = false }),
      desc = "Word (cwd)",
    },
    {
      "<leader>ss",
      Util.telescope("lsp_document_symbols", {
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
      }),
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      Util.telescope("lsp_dynamic_workspace_symbols", {
        symbols = {
          "File",
          "Key",
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
      }),
      desc = "Goto Symbol (Workspace)",
    },
  },
  cmd = "Telescope",
})

Plug.add("nvim-telescope/telescope-fzf-native.nvim", {
  build = "make", lazy = true,
})
Plug.add("FeiyouG/command_center.nvim", { lazy = true })
Plug.add("danielfalk/smart-open.nvim", {
  branch = "0.2.x",
  dependencies = {
    "kkharji/sqlite.lua",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").load_extension("smart_open")
  end,
  keys = {
    {"<leader>so", function()
      require('telescope').extensions.smart_open.smart_open()
    end, desc = "telescope: smart-open"}
  }
})
Plug.add("nvim-telescope/telescope-frecency.nvim", {
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>fp",
      function()
        require("telescope").extensions.frecency.frecency()
      end,
      desc = "Telescope: Frecency",
    },
  },
  lazy = true,
})

-- machakann/vim-highlightedyank: 高亮显示复制区域 ---------------------- {{{3
Plug.add("machakann/vim-highlightedyank")

-- kevinhwang91/nvim-hlslens: Hlsearch Lens for Neovim ------------------ {{{3
Plug.add("kevinhwang91/nvim-hlslens", {
  event = { "SearchWrapped", "CursorMoved" },
})

-- mg979/vim-visual-multi: 多重选择 ------------------------------------- {{{3
Plug.add("mg979/vim-visual-multi", {
  init = function()
    if Util.has "nvim-hlslens" then
      vim.cmd [[
                aug VMlens
                    au!
                    au User visual_multi_start lua require('vmlens').start()
                    au User visual_multi_exit  lua require('vmlens').exit()
                aug END
            ]]
    end
  end,
  branch = "master",
  keys = {
    {
      "<C-n>",
      desc = "Find Word",
      mode = { "n", "v", "x" },
    },
    { "<A-j>", "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursors Down" },
    { "<A-k>", "<Plug>(VM-Add-Cursor-Up)", desc = "Add Cursors Up" },
  },
})
-- andymass/vim-matchup: 显示匹配符号之间的内容 ------------------------- {{{3
Plug.add("andymass/vim-matchup", { event = {"VeryLazy"} })

-- numToStr/Comment.nvim: Smart and powerful comment plugin for neovim -- {{{3
Plug.add('numToStr/Comment.nvim', {  event = {"VeryLazy"}  })

-- folke/todo-comments.nvim: Highlight, list and search todo comments --- {{{3
Plug.add("folke/todo-comments.nvim", {
  dependencies = { "nvim-lua/plenary.nvim" },
  event = {"VeryLazy"},
})

-- junegunn/vim-easy-align: text alignment tool ------------------------- {{{3
Plug.add("junegunn/vim-easy-align", {
  keys = {
    { "ga", mode = { "n", "v", "x" } },
  },
  cmd = "EasyAlign",
})

-- beauwilliams/focus.nvim: Auto Ajust the size of focused window ------- {{{3
Plug.add("nvim-focus/focus.nvim", {
  keys = {
    { "<leader>wh", "<cmd>FocusSplitLeft<cr>", desc = "Focus Split Left" },
    { "<leader>wl", "<cmd>FocusSplitRight<cr>", desc = "Focus Split Right" },
    { "<leader>wj", "<cmd>FocusSplitDown<cr>", desc = "Focus Split Down" },
    { "<leader>wk", "<cmd>FocusSplitUp<cr>", desc = "Focus Split Up" },
    { "<leader>wm", "<cmd>FocusMaximise<cr>", desc = "Focus Maximise" },
    { "<leader>we", "<cmd>FocusEqualise<cr>", desc = "Focus Equalise" },
    { "<leader>ww", "<cmd>FocusSplitNicely<cr>", desc = "Focus Equalise" },
  },
  cmd = { "FocusToggle", "FocusEnable" },
})

-- -- folke/zen-mode.nvim: Distraction-free coding for Neovim -------------- {{{3
-- Plug.add("folke/zen-mode.nvim", {
--   cmd = "ZenMode",
--   keys = {
--     { "<leader>oZ", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
--   },
-- })

-- machakann/vim-sandwich: add/delete/replace surroundings -------------- {{{3
Plug.add("machakann/vim-sandwich", {
  init = function()
    vim.g.operator_sandwich_no_default_key_mappings = 1
  end,
  keys = { "ds", "cs", "ys", {"S", mode = {"v", "x"} } },
})

-- tpope/vim-repeat: 重复插件操作 --------------------------------------- {{{3
Plug.add("tpope/vim-repeat", {
  keys = {
    { ".", mode = { "n", "v", "x" } },
  },
})

-- nvim-pack/nvim-spectre: find with rg and replace with sed ------------ {{{3
Plug.add("nvim-pack/nvim-spectre", {
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>R",
      function()
        require("spectre").open()
      end,
      desc = "Replace in files (Spectre)",
    },
  },
})

-- rcarriga/nvim-notify: notification manager --------------------------- {{{3
Plug.add("rcarriga/nvim-notify", {
  keys = {
    {
      "<leader>nu",
      function()
        require("notify").dismiss { silent = true, pending = true }
      end,
      desc = "Dismiss all Notifications",
    },
  },
  init = function()
    vim.notify = require "notify"
  end,
})

-- 
Plug.add("folke/noice.nvim", {
  event = "VeryLazy",
  init = function()
    vim.api.nvim_set_option_value("cmdheight", 0, { scope = "global" })
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  keys = {
    {
      "<leader>hn", "<cmd>NoiceTelescope<cr>", desc = "Noice: Search Notifications",
    },
  },
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
    {
      "S",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter",
    },
  },
})

-- easymotion/vim-easymotion: motion tools ------------------------------ {{{3
Plug.add("easymotion/vim-easymotion", {
  init = function()
    vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings
    vim.g.EasyMotion_smartcase = 1
    vim.g.EasyMotion_use_migemo = 1
  end,
  dependencies = { "zzhirong/vim-easymotion-zh" },
  keys = {
    {
      "<localleader>s",
      "<esc><Plug>(easymotion-sl)",
      mode = { "i" },
      desc = "EasyMotion: Find Char (current line)",
    },
    {
      "s.",
      "<Plug>(easymotion-repeat)",
      desc = "EasyMotion: Repeat last motion",
    },
    {
      "sc",
      "<Plug>(easymotion-s2)",
      desc = "EasyMotion: Search for 2 chars",
    },
    {
      "sl",
      "<Plug>(easymotion-sl)",
      mode = { "n", "v" },
      desc = "EasyMotion: Find Char (current line)",
    },
    { "sj", "<plug>(easymotion-j)", desc = "EasyMotion: Line Downward" },
    {
      "sJ",
      "<plug>(easymotion-eol-j)",
      desc = "EasyMotion: Line Downword (end)",
    },
    { "sk", "<plug>(easymotion-k)", desc = "EasyMotion: Line Forward" },
    {
      "sK",
      "<plug>(easymotion-eol-k)",
      desc = "EasyMotion: Line Forward (end)",
    },
    { "sn", "<Plug>(easymotion-n)", desc = "EasyMotion: latest search" },
    {
      "sN",
      "<Plug>(easymotion-N)",
      desc = "EasyMotion: latest search (backward)",
    },
    {
      "sw",
      "<Plug>(easymotion-w)",
      desc = "EasyMotion: Beginning of word",
    },
    {
      "sW",
      "<Plug>(easymotion-W)",
      desc = "EasyMotion: Beginning of WORD",
    },
    {
      "sb",
      "<Plug>(easymotion-b)",
      desc = "EasyMotion: EasyMotion: Beginning of word (backward)",
    },
    {
      "sB",
      "<Plug>(easymotion-B)",
      desc = "EasyMotion: EasyMotion: Beginning of WORD (backward)",
    },
    { "se", "<Plug>(easymotion-e)", desc = "EasyMotion: End of word" },
    { "sE", "<Plug>(easymotion-E)", desc = "EasyMotion: End of WROD" },
    {
      "sge",
      "<Plug>(easymotion-e)",
      desc = "EasyMotion: End of word (backward)",
    },
    {
      "sgE",
      "<Plug>(easymotion-E)",
      desc = "EasyMotion: End of WROD (backward)",
    },
  },
})

-- zzhirong/vim-easymotion-zh: motion in Chinese text ------------------- {{{3
Plug.add("zzhirong/vim-easymotion-zh", { lazy = true })

-- folke/which-key.nvim: displays a popup with possible keybindings ----- {{{3
Plug.add("folke/which-key.nvim", { event = "VeryLazy" })

-- yianwillis/vimcdoc: Chinese version of vim documents ----------------- {{{3
Plug.add("yianwillis/vimcdoc", {
  keys = { "<F1>" },
  event = { "CmdwinEnter", "CmdlineEnter" },
})

-- zhimsel/vim-stay: Make Vim persist editing state without fuss -------- {{{3
-- Plug.add("zhimsel/vim-stay", {
--   init = function()
--     vim.o.viewoptions = "cursor,folds,slash,unix"
--   end,
-- })

-- Konfekt/FastFold: updating folds only when called-for ---------------- {{{3
-- Plug.add("Konfekt/FastFold")
-- chrisgrieser/nvim-origami: Fold with relentless elegance ------------- {{{3
Plug.add("chrisgrieser/nvim-origami", {
	event = "BufReadPost", -- later or on keypress would prevent saving folds
})

-- kevinhwang91/nvim-ufo: ultra fold in Neovim -------------------------- {{{3
Plug.add("kevinhwang91/nvim-ufo", {
  dependencies = "kevinhwang91/promise-async",
	event = "BufReadPost", -- later or on keypress would prevent saving folds
  init = function()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
})
-- vim-voom/VOoM: vim Outliner of Markups ------------------------------- {{{3
Plug.add("vim-voom/VOoM", {
  cmd = "Voom",
  keys = {
    { "<leader>v", "<cmd>Voom<cr>", desc = "VOom: Show Outliner" },
  },
})

-- akinsho/bufferline.nvim: buffer line with minimal tab integration ---- {{{3
Plug.add("akinsho/bufferline.nvim", {
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  keys = {
    { "<leader>B", "<cmd>BufferLinePick<cr>", desc = "Choose Buffer" },
  },
})

-- nvim-lualine/lualine.nvim: neovim statusline plugin ------------------ {{{3
Plug.add("nvim-lualine/lualine.nvim")

-- goolord/alpha-nvim: a lua powered greeter ---------------------------- {{{3
-- Plug.add('goolord/alpha-nvim')

-- nvim-tree/nvim-web-devicons: file type icons ------------------------- {{{3
Plug.add("nvim-tree/nvim-web-devicons", { config = true })

-- windwp/nvim-autopairs: autopair tools -------------------------------- {{{3
Plug.add("windwp/nvim-autopairs")
-- Plug.add('altermo/ultimate-autopair.nvim', {
--   event = {'InsertEnter', 'CmdlineEnter'},
--   branch = 'v0.6',
--   config = function()
--     require('ultimate-autopair').setup({
--       {'$', '$', suround=true, ft={'markdown'}},
--       {"`", "'", suround=true, ft={'stata'}},
--       config_internal_pairs = {
--         {'`', '`', ft = {'markdown'}},
--       }
--     })
--   end,
-- })

-- stevearc/dressing.nvim: improve the default vim.ui interfaces -------- {{{3
Plug.add("stevearc/dressing.nvim", {
  opts = {
    input = {
      default_prompt = "➤ ",
      win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
    },
    select = {
      backend = { "telescope", "builtin" },
      builtin = {
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
    },
  },
  config = true,
})

-- Make your nvim window separators colorful ---------------------------- {{{3
Plug.add("nvim-zh/colorful-winsep.nvim", {
  event = { "WinNew" },
})

-- "lukas-reineke/indent-blankline.nvim"
-- Plug.add("lukas-reineke/indent-blankline.nvim", { main = "ibl" })
Plug.add("nvimdev/indentmini.nvim", {
  config = function()
    require("indentmini").setup({
       char = "│",
       exclude = {"markdown", "alpha", "norg", "help"}
    })
  end,
})
-- Tools ---------------------------------------------------------------- {{{2
-- liubianshi/cmp-lsp-rimels: ------------------------------------------- {{{3
Plug.add("liubianshi/cmp-lsp-rimels", {
  event = {"InsertEnter"},
  ft = {'md', "rmd"},
  keys = {{"<localleader>f", mode = "i"}},
  dev = true,
})

-- LinTaoAmons/scratch.nvim: Create temporary playground files ---------- {{{3
Plug.add("LinTaoAmons/scratch.nvim", {
  event = "VeryLazy",
  cmd = "Scratch",
  keys = {
    {"<leader>os", "<cmd>Scratch<cr>",  desc = "Creates a new scratch file"}
  }
})

-- ziontee113/icon-picker.nvim: pick Nerd Font Icons, Symbols & Emojis -- {{{3
Plug.add("liubianshi/icon-picker.nvim", {
  dev = true,
  config = function()
    require("icon-picker").setup({ disable_legacy_commands = true })
  end,
  cmd = { "IconPickerNormal", "IconPickerYank"},
  keys = {
    {
      '<localleader>i',
      '<cmd>IconPickerInsert history nerd_font_v3 alt_font symbols emoji<cr>',
      desc = ' Pick Icon and insert it to the buffer',
      mode = "i",
      silent = true,
      noremap = true,
    },
    {
      '<leader>si',
      '<cmd>IconPickerYank history nerd_font_v3 alt_font symbols emoji<cr>',
      desc = 'Pick Icon and yank it to register',
      mode = "n",
      silent = true,
      noremap = true,
    }
  }
})

-- brenoprata10/nvim-highlight-colors: Highlight colors for neovim ------ {{{3
Plug.add("brenoprata10/nvim-highlight-colors", {
  ft = { "html", "lua", "css", "vim", "cpp" },
})

-- nvimdev/lspsaga.nvim: ------------------------------------------------ {{{3
Plug.add("nvimdev/lspsaga.nvim", {
  event = 'LspAttach',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  }
})

-- jackMort/ChatGPT.nvim: Effortless Natural Language Generation -------- {{{3
Plug.add("jackMort/ChatGPT.nvim", {
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
})

-- 
Plug.add("robitx/gp.nvim", {
  cmd = {
    "GpAgent",
    "GpChatNew",
    "GpChatFinder",
    "GpRewrite",
    "GpAppend",
    "GpPopup",
    "GpContext",
  },
  keys = {
    { "<C-g>c",     "<cmd>GpChatNew vsplit<cr>",    desc = "GPT prompt New Chat",    nowait = true },
    { "<C-g>t",     "<cmd>GpChatToggle vsplit<cr>", desc = "GPT prompt Toggle Chat", nowait = true },
    { "<C-g>f",     "<cmd>GpChatFinder<cr>",        desc = "GPT prompt Chat Finder", nowait = true },
    { "<leader>sc", "<cmd>GpChatFinder<cr>",        desc = "GPT prompt Chat Finder", nowait = true },

    { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>",    desc = "GPT prompt Visual Chat New",    nowait = true, mode = "v" },
    { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>",  desc = "GPT prompt Visual Chat Paste",  nowait = true, mode = "v" },
    { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "GPT prompt Visual Toggle Chat", nowait = true, mode = "v" },

    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",  desc = "GPT prompt New Chat split",  nowait = true },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "GPT prompt New Chat vsplit", nowait = true },
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "GPT prompt New Chat tabnew", nowait = true },

    { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>",  desc = "GPT prompt Visual Chat New split",  nowait = true, mode = "v" },
    { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "GPT prompt Visual Chat New vsplit", nowait = true, mode = "v" },
    { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "GPT prompt Visual Chat New tabnew", nowait = true, mode = "v" },

    -- Prompt commands
    { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "GPT prompt Inline Rewrite",   nowait = true },
    { "<C-g>a", "<cmd>GpAppend<cr>",  desc = "GPT prompt Append (after)",   nowait = true },
    { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "GPT prompt Prepend (before)", nowait = true },

    { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>",   desc = "GPT prompt Visual Rewrite",          nowait = true, mode = "v" },
    { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>",    desc = "GPT prompt Visual Append (after)",   nowait = true, mode = "v" },
    { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>",   desc = "GPT prompt Visual Prepend (before)", nowait = true, mode = "v" },
    { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "GPT prompt Implement selection",     nowait = true, mode = "v" },

    { "<C-g>gp", "<cmd>GpPopup<cr>",  desc = "GPT prompt Popup",    nowait = true },
    { "<C-g>ge", "<cmd>GpEnew<cr>",   desc = "GPT prompt GpEnew",   nowait = true },
    { "<C-g>gn", "<cmd>GpNew<cr>",    desc = "GPT prompt GpNew",    nowait = true },
    { "<C-g>gv", "<cmd>GpVnew<cr>",   desc = "GPT prompt GpVnew",   nowait = true },
    { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GPT prompt GpTabnew", nowait = true },

    { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>",  desc = "GPT prompt Visual Popup",    nowait = true, mode = "v" },
    { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>",   desc = "GPT prompt Visual GpEnew",   nowait = true, mode = "v" },
    { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>",    desc = "GPT prompt Visual GpNew",    nowait = true, mode = "v" },
    { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>",   desc = "GPT prompt Visual GpVnew",   nowait = true, mode = "v" },
    { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "GPT prompt Visual GpTabnew", nowait = true, mode = "v" },

    { "<C-g>x", "<cmd>GpContext<cr>",       desc = "GPT prompt Toggle Context",        nowait = true },
    { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "GPT prompt Visual Toggle Context", nowait = true, mode = "v" },

    { "<C-g>s", "<cmd>GpStop<cr>",      desc = "GPT prompt Stop",       nowait = true, mode = {"n", "v", "x"} },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "GPT prompt Next Agent", nowait = true, mode = {"n", "v", "x"} },

  }
})


-- akinsho/toggleterm.nvim: manage multiple terminal windows ------------ {{{3
Plug.add("akinsho/toggleterm.nvim", {
  version = "*",
  cmd = "ToggleTerm",
  keys = {
    {
      "<space><space>",
      "<cmd>ToggleTerm<cr>",
      desc = "Toogle Terminal",
      silent = true,
      mode = { "n", "t" },
      noremap = true,
    },
  },
})

-- willothy/flatten.nvim: open files in your current neovim instance ---- {{{3
Plug.add("willothy/flatten.nvim", { lazy = false, priority = 1001 })
-- skywind3000/asyncrun.vim: run async shell command -------------------- {{{3
Plug.add("skywind3000/asyncrun.vim")

-- skywind3000/asynctasks.vim: modern Task System ----------------------- {{{3
Plug.add("skywind3000/asynctasks.vim", {
  dependencies = {
    "skywind3000/asyncrun.vim",
  },
  cmd = { "AsyncTask", "AsyncTaskList" },
  keys = {
    { "<leader>ot", desc = "Run AsnycTask" },
  },
})

-- liubianshi/vimcmdline: send lines to interpreter --------------------- {{{3
Plug.add("liubianshi/vimcmdline", {
  ft = {'stata', 'sh', 'bash'},
  dev = true,
})
Plug.add("voldikss/vim-translator", {
  cmd = {"Translate"},
  keys = {
    {"<leader>k", desc = "Translate", mode = {"n", "v"}},
  }
})

-- potamides/pantran.nvim: trans without leave neovim ------------------- {{{3
Plug.add("potamides/pantran.nvim", {
  keys = {
    { "<leader>tr", mode = { "x", "n" }, desc = "Pantran: translate" },
    { "<leader>trr", mode = { "n" }, desc = "Pantran: translate" },
    {
      "<leader>T",
      "<cmd>Pantran target=en<cr>",
      desc = "Pantran: to English",
      mode = { "n", "v" },
    },
  },
})

-- 3rd/image.nvim: 🖼️ Bringing images to Neovim.
Plug.add("3rd/image.nvim", {
  cond = (vim.fn.exists("g:neovide") == 0),
  ft = { "markdown", "pandoc", "rmd", "rmarkdown", "norg", "org", "newsboat" },
})

-- OXY2DEV/markview.nvim: Experimental markdown preview for neovim 
-- Plug.add("OXY2DEV/markview.nvim", {
--   dependencies = {
--     "nvim-tree/nvim-web-devicons",
--   },
--   ft = { "markdown", "pandoc", "rmd", "rmarkdown"}
-- })

-- gbprod/yanky.nvim: Improved Yank and Put functionalities for Neovim -- {{{3
Plug.add("gbprod/yanky.nvim", {
  dependencies = {"kkharji/sqlite.lua"},
  keys = {
    {
      "<leader>sp", function()
        require("telescope").extensions.yank_history.yank_history({ initial_mode = "normal"})
      end, desc = "Open Yank History"
    },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
    { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
    { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
  }
})

Plug.add('liubianshi/anki-panky', {
  dev = true,
  -- ft = { 'markdown' },
  cmd = {'AnkiNew', 'AnkiPush'},
  keys = {'<localleader>aa', '<localleader>af'},
  config = true,
})

-- sindrets/diffview.nvim: cycling through diffs for all modified files - {{{3
Plug.add('sindrets/diffview.nvim', {
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen"},
    { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffviewOpen"},
  },
})

-- ThePrimeagen/harpoon:
-- Plug.add("ThePrimeagen/harpoon", {
--   branch = "harpoon2",
--   dependencies = { "nvim-lua/plenary.nvim" },
-- })

-- Project management --------------------------------------------------- {{{2
-- ahmedkhalf/project.nvim: superior project management solution -------- {{{3
Plug.add("ahmedkhalf/project.nvim")
-- Plug.add("olimorris/persisted.nvim", {
--   dependencies = { "nvim-telescope/telescope.nvim"},
--   cmd = {"SessionLoad", "SessionLoadLast"},
--   keys = {
--     {
--       "<leader>ls", function()
--         require("telescope").extensions.persisted.persisted()
--       end,
--       desc = "Select Sessions",
--     }
--   },
--   config = true
-- })

-- ludovicchabant/vim-gutentags: tag file management -------------------- {{{3
Plug.add("ludovicchabant/vim-gutentags", {
  event = { "BufReadPost", "BufNewFile" },
})

-- folke/trouble.nvim: diagnostics solution ----------------------------- {{{3
Plug.add("folke/trouble.nvim", { ft = {"c", "lua", "perl", "sh", "r"} })

-- tpope/vim-fugitive: Git ---------------------------------------------- {{{3
Plug.add("tpope/vim-fugitive", { cmd = "G" })


-- Theme ---------------------------------------------------------------- {{{2
Plug.add("luisiacc/gruvbox-baby",            { lazy = false })
Plug.add("ayu-theme/ayu-vim",                { lazy = false })
Plug.add("rebelot/kanagawa.nvim",            { lazy = false, priority = 100 })
Plug.add("olimorris/onedarkpro.nvim",        { priority = 100 })
Plug.add("Mofiqul/vscode.nvim",              { priority = 100 })
Plug.add("rmehri01/onenord.nvim",            { priority = 100 })
Plug.add("nyoom-engineering/oxocarbon.nvim", { priority = 100 })
Plug.add("Verf/deepwhite.nvim",              { lazy = false, priority = 100  })

Plug.add("mhartington/oceanic-next",         { lazy = false })
Plug.add("sainnhe/everforest", {
  init = function()
    vim.g.everforest_better_performance = 1
    vim.g.everforest_background = "hard"
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_transparent_background = 1
    vim.g.everforest_dim_inactive_windows = 0
  end,
  lazy = false,
})
Plug.add("catppuccin/nvim", { name = "catppuccin", lazy = false })
Plug.add("folke/tokyonight.nvim", { lazy = false, priority = 1000 })
Plug.add("projekt0n/github-nvim-theme", { lazy = false, priority = 1000 })

-- 补全和代码片断 ------------------------------------------------------- {{{2
-- sirver/UltiSnips: Ultimate snippet solution -------------------------- {{{3
Plug.add("sirver/UltiSnips", {
  dependencies = { "honza/vim-snippets" },
  cmd = { "UltiSnipsAddFiletypes" },
  event = "InsertEnter",
})

-- completation framework and relative sources -------------------------- {{{3
Plug.add("folke/lazydev.nvim", {
  ft = "lua",
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
    enabled = function(root_dir)
      if vim.uv.fs_stat(root_dir .. "/luarc.json") then
        return false
      end
      return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
    end
  }
})
Plug.add("Bilal2453/luvit-meta", { lazy = true })
Plug.add("neovim/nvim-lspconfig", {
  -- event = { "BufReadPre", "BufNewFile", "BufWinEnter" },
  ft = {"lua", "perl", "markdown", "bash", "r", "python", "vim"},
})
Plug.add("liubianshi/cmp-r", { dev = true, lazy = true})

-- hrsh7th/nvim-cmp: A completion plugin for neovim ----------------- {{{4
local cmp_dependencies = {
  "hrsh7th/cmp-nvim-lsp", -- neovim builtin LSP client
  "hrsh7th/cmp-nvim-lsp-signature-help", -- displaying function signatures
  "hrsh7th/cmp-omni", -- omnifunc
  "hrsh7th/cmp-buffer", -- buffer words
  "hrsh7th/cmp-cmdline", -- command line keywords
  "uga-rosa/cmp-dictionary", -- A dictionary completation source for nvim-cmp
  "FelipeLema/cmp-async-path", -- filesystem paths
  "ray-x/cmp-treesitter", -- treesitter nodes
  "onsails/lspkind.nvim", -- adds vscode-like pictograms
  "quangnguyen30192/cmp-nvim-ultisnips", -- ultisnips
  "kristijanhusak/vim-dadbod-completion", -- dadbod
  "kdheepak/cmp-latex-symbols", -- latex symbol
}
for _, k in ipairs(cmp_dependencies) do
  Plug.add(k, { lazy = true })
end
Plug.add("hrsh7th/nvim-cmp", {
  event = "InsertEnter",
  dependencies = cmp_dependencies,
})


-- Formatter and linter ------------------------------------------------- {{{2
-- mfussenegger/nvim-dap
-- Plug.add("mfussenegger/nvim-dap")
-- Plug.add("rcarriga/nvim-dap-ui", {
--   dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
--   config = true,
-- })

-- mhartington/formatter.nvim: autoformat tool -------------------------- {{{3
Plug.add("mhartington/formatter.nvim", {
  ft = { "lua", "sh", "perl", "r", "html", "xml", "css", "markdown", "javascript" },
})

-- Writing and knowledge management ------------------------------------- {{{2

-- vim-pandoc/vim-pandoc: pandoc integration and utilities for vim ------ {{{3
Plug.add("vim-pandoc/vim-pandoc-syntax", {
  init = function()
    vim.g.tex_conceal = "adgm"
    vim.cmd [[
            let g:pandoc#syntax#codeblocks#embeds#langs = [
                        \ "ruby",    "perl",       "r",
                        \ "bash=sh", "stata",      "vim",
                        \ "python",  "perl6=raku", "c"]
        ]]
  end,
  ft = { "markdown", "pandoc", "markdown.pandoc" },
})
Plug.add("ellisonleao/glow.nvim", {
  cmd = {"Glow"},
  config = function()
    require('glow').setup { style = "dark", width = 86}
  end
})

-- Plug.add( "denstiny/styledoc.nvim", {
--   dependencies = {
--     "nvim-treesitter/nvim-treesitter",
--     "vhyrro/luarocks.nvim",
--     "3rd/image.nvim",
--   },
--   opts = true,
--   ft = "markdown",
-- })



-- Plug.add('vim-pandoc/vim-pandoc', {
--     dependencies = {'vim-pandoc/vim-pandoc-syntax'},
--     ft = {'rmd', 'markdown', 'rmarkdown', 'pandoc'}
-- })

-- ferrine/md-img-paste.vim: paste image to markdown -------------------- {{{3
Plug.add("img-paste-devs/img-paste.vim", {
  ft = { "rmd", "markdown", "rmarkdown", "pandoc", "org" },
})

Plug.add("HakonHarnes/img-clip.nvim", {
  ft = {
    "rmd",
    "markdown",
    "rmarkdown",
    "pandoc",
    "org",
    "tex",
    "html",
    "norg",
  },
  keys = {
    { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
  },
})

-- hotoo/pangu.vim: 『盘古之白』中文排版自动规范化 ---------------------- {{{3
Plug.add("hotoo/pangu.vim", {
  ft = {
    "rmd",
    "markdown",
    "rmarkdown",
    "pandoc",
    "norg",
    "org",
    "newsboat",
    "html",
  },
  init = function()
    vim.g.pangu_rule_fullwidth_punctuation = 0
    vim.g.pangu_rule_spacing_punctuation = 1
    vim.g.pangu_rule_remove_zero_width_whitespace = 0
  end,
})

-- dhruvasagar/vim-table-mode: Table Mode for instant table creation ---- {{{3
Plug.add("dhruvasagar/vim-table-mode", {
  ft = { "markdown", "pandoc", "rmd", "org" },
  init = function()
    vim.g.table_mode_map_prefix = "<localleader>t"
    vim.g.table_mode_corner = '|'
  end,
})

-- epwalsh/obsidian.nvim
Plug.add("epwalsh/obsidian.nvim", {
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = {"markdown"},
  cmd = {"ObsidianQuickSwitch", "ObsidianNew", "ObsidianSearch"},
  keys = {
    { "<leader>nl", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Switch Note"                             },
    { "<leader>nn", "<cmd>ObsidianNew<cr>",         desc = "Obsidian: Create new note"                         },
    { "<leader>no", "<cmd>ObsidianOpen<cr>",        desc = "Obsidian: open a note in the Obsidian app"         },
    { "<leader>nj", "<cmd>ObsidianToday<cr>",       desc = "Obsidian: open/create a new daily note"            },
    { "<leader>nf", "<cmd>ObsidianSearch<cr>",      desc = "Obsidian: search for (or create) notes"            },
  },
})

-- lukas-reineke/headlines.nvim  adds horizontal highlights ------------- {{{3
-- Plug.add("lukas-reineke/headlines.nvim", {
--   ft = {"markdown", "org", "rmd", "rmarkdown", "norg"},
--   dependencies = "nvim-treesitter/nvim-treesitter",
-- })
-- 文件类型相关插件 ----------------------------------------------------- {{{2
-- nvim-neorg/neorg: new org-mode in neovim ----------------------------- {{{3
Plug.add("nvim-neorg/neorg", {
  version = "*",
  ft = { "norg" },
  cmd = { "Neorg" },
  keys = {
    {
      "<leader>ej",
      "<cmd>Neorg journal today<cr>",
      desc = "Open today's journal",
    },
  },
})

-- kristijanhusak/vim-dadbod-ui: simple UI for vim-dadbod --------------- {{{3
Plug.add("kristijanhusak/vim-dadbod-ui", {
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = { "tpope/vim-dadbod" },
})

-- -- liubianshi/Nvim-R: Vim plugin to work with R ------------------------- {{{3
-- Plug.add("liubianshi/Nvim-R", {
--   ft = { "r", "rmd", "qml" },
--   cmd = { "RStart" },
-- })

Plug.add("liubianshi/R.nvim", { dev = true, lazy = false })


-- lervag/vimtex: filetype plugin for LaTeX files ----------------------- {{{3
Plug.add("lervag/vimtex", { ft = "tex" })

-- poliquin/stata-vim: Syntax highlighting and snippets for Stata files - {{{3
Plug.add("poliquin/stata-vim", { ft = "stata" }) -- stata 语法高亮

-- mechatroner/rainbow_csv: Highlight columns and run queries ----------- {{{3
Plug.add("mechatroner/rainbow_csv", { ft = { "csv", "tsv" } })

-- WolfgangMehner/perl-support: filetype plugin for perl files ---------- {{{3
Plug.add("WolfgangMehner/perl-support", { ft = "perl" })

-- liuchengxu/graphviz.vim: Graphviz dot -------------------------------- {{{3
Plug.add("liuchengxu/graphviz.vim", { ft = "dot" })

-- kevinhwang91/nvim-bqf: Better quickfix window in Neovim -------------- {{{3
Plug.add("kevinhwang91/nvim-bqf", { ft = "qf" })

-- nvim-orgmode/orgmode: Orgmode clone written in Lua ------------------- {{{3
Plug.add("nvim-orgmode/orgmode", {
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    {"akinsho/org-bullets.nvim", config = true}
  },
  ft = "org",
  keys = {
    { "<leader>oa", desc = "Orgmode: agenda prompt" },
    { "<leader>oc", desc = "Orgmode: capture prompt" },
  },
})

-- fladson/vim-kitty: kitty config syntax highlighting for vim ---------- {{{3
Plug.add("fladson/vim-kitty", { ft = "kitty" })

-- kmonad/kmonad-vim: Vim syntax highlighting for .kbd files ------------ {{{3
Plug.add("kmonad/kmonad-vim", { ft = "kbd" })

-- TreeSitter ----------------------------------------------------------- {{{2
-- nvim-treesitter/nvim-treesitter: Treesitter configurations ----------- {{{3
Plug.add("nvim-treesitter/nvim-treesitter", {
  build = ":TSUpdate",
  cmd = "TSEnable",
  event = { "BufReadPost", "BufNewFile" },
})

Plug.add("nvim-treesitter/nvim-treesitter-textobjects", {
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },
})

-- Wansmer/treesj: Neovim plugin for splitting/joining blocks of code --- {{{3
Plug.add("Wansmer/treesj", {
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  keys = {
    { "<leader>cj", "<cmd>TSJJoin<cr>",   desc = "Join Code Block"       },
    { "<leader>cs", "<cmd>TSJSplit<cr>",  desc = "Split Code Block"      },
    { "<leader>cm", "<cmd>TSJToggle<cr>", desc = "Join/Split Code Block" },
  }
})

-- AckslD/nvim-FeMaco.lua: Fenced Markdown Code-block editing ----------- {{{3
Plug.add("AckslD/nvim-FeMaco.lua", {
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = "FeMaco",
  keys = {
    { "<localleader>o", "<cmd>FeMaco<cr>", desc = "FeMaco: Edit Code Block" },
  },
})

-- 安装并加载插件 ------------------------------------------------------- {{{1
local lazy = require("lazy")
lazy.setup(Plug.get(), dofile(vim.fn.stdpath "config" .. "/Plugins/lazy.lua"))

-- 创建辅助函数 --------------------------------------------------------- {{{1
_G.LoadedPlugins = function()
  local plugs = require("lazy").plugins()
  local loaded_plugs = {}
  for _, plug in ipairs(plugs) do
    if not plug["_"].loaded then
      loaded_plugs[plug.name] = 1
    end
  end
  return loaded_plugs
end

_G.PlugExist = function(plug)
  return (Util.has(plug))
end

