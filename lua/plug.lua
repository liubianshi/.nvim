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
local Plugins = {}
local add_plug = function(plug, opts)
  opts = opts or {}
  if type(plug) == 'table' then
    opts = vim.tbl_extend("keep", plug, opts)
    plug = plug[1]
  else
    table.insert(opts, 1, plug)
  end
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
  table.insert(Plugins, opts)
end

-- 配置插件 ------------------------------------------------------------- {{{1
-- Utils ---------------------------------------------------------------- {{{2
add_plug("nvim-lua/plenary.nvim",       { lazy = true })
add_plug("nvim-tree/nvim-web-devicons", { lazy = true })
add_plug("MunifTanjim/nui.nvim",        { lazy = true })
add_plug("s1n7ax/nvim-window-picker",   { lazy = true })
add_plug("kkharji/sqlite.lua",          { lazy = true })

-- UI ------------------------------------------------------------------- {{{2
-- lambdalisue/suda.vim: Read and write with sudo command --------------- {{{3
add_plug("lambdalisue/suda.vim", { cmd = { "SudaWrite", "SudaRead" } })

-- chentoast/marks.nvim: viewing and interacting with vim marks --------- {{{3
add_plug("chentoast/marks.nvim", {
  event = "VeryLazy",
  config = true,
})

-- ojroques/vim-oscyank: copy text through SSH with OSC52 --------------- {{{3
add_plug("ojroques/vim-oscyank", { cmd = {"OSCYankVisual"} })

-- typicode/bg.nvim: Automatically sync your terminal background -------- {{{3
add_plug( "typicode/bg.nvim", { lazy = false })

-- is0n/fm-nvim: open terminal file manager or other terminal app ------- {{{3
add_plug("is0n/fm-nvim", {
  cmd = { "Lf", "Nnn", "Neomutt", "Lazygit" },
  keys = {
    { "<leader>fo", "<cmd>Lf '%:p:h'<cr>", desc = "Open File with Lf" },
    { "<leader>fn", "<cmd>Nnn '%:p:h'<cr>", desc = "Open File with nnn" },
    -- { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Open Lazy Git" },
  },
})

-- stevearc/oil.nvim: file explorer: edit your filesystem like a buffer - {{{3
add_plug {
  'stevearc/oil.nvim',
  dependencies = {
    { "echasnovski/mini.icons", opts = {} }
  },
}

-- nvim-neo-tree/neo-tree.nvim: browse tree like structures ------------- {{{3
add_plug("nvim-neo-tree/neo-tree.nvim", {
  cmd = "Neotree",
  dependencies = {"s1n7ax/nvim-window-picker"},
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
add_plug("s1n7ax/nvim-window-picker", { name = "window-picker", lazy = true })

-- ibhagwan/fzf-lua: Fzf Search ----------------------------------------- {{{3
add_plug("ibhagwan/fzf-lua", {
  branch = "main",
  cmd = { "FzfLua", "Shelp", "Urlopen", "RoamNodeFind", "Cheat", "ProjectChange" },
  keys = {
    "<leader>pp",
    {"<leader>sq", desc =  "Open my library file"},
    "<leader>ic",
    {"<localleader>c", mode = "i"},
    "<leader>fz",
    "<leader>bB",
    {"<leader>ot", desc = "Run async tasks"},
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
      "<leader>ou",
      "<cmd>Urlopen<cr>",
      desc = "FzfLua: Open urls",
    },
    {
      "<leader>st",
      "<cmd>FzfLua tags<cr>",
      desc = "FzfLua: tags",
    },
    {
      '<leader>sk',
      "<cmd>FzfLua keymaps<cr>",
      desc = "FzfLua: keymaps table",
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
add_plug("fhill2/telescope-ultisnips.nvim", { lazy = true })
add_plug("nvim-telescope/telescope-fzf-native.nvim", { build = "make", lazy = true, })
add_plug("nvim-telescope/telescope.nvim", {
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
add_plug("danielfalk/smart-open.nvim", {
  branch = "0.2.x",
  config = function()
    require("telescope").load_extension("smart_open")
  end,
  keys = {
    {"<leader>so", function()
      require('telescope').extensions.smart_open.smart_open()
    end, desc = "telescope: smart-open"}
  }
})
add_plug("nvim-telescope/telescope-frecency.nvim", {
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
add_plug("machakann/vim-highlightedyank")

-- kevinhwang91/nvim-hlslens: Hlsearch Lens for Neovim ------------------ {{{3
add_plug("kevinhwang91/nvim-hlslens", { event = { "SearchWrapped", "CursorMoved" }, })

-- mg979/vim-visual-multi: 多重选择 ------------------------------------- {{{3
add_plug("mg979/vim-visual-multi", {
  init = function()
    if Util.has "nvim-hlslens" then
      vim.api.nvim_create_augroup("VMlens", {clear = true})
      vim.api.nvim_create_autocmd({"User"}, {
        group = "VMlens",
        pattern = "visual_multi_start",
        callback = function()
          require('vmlens').start()
        end,
      })
      vim.api.nvim_create_autocmd({"User"}, {
        group = "VMlens",
        pattern = "visual_multi_exit",
        callback = function()
          require('vmlens').exit()
        end,
      })
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
add_plug("andymass/vim-matchup")

-- numToStr/Comment.nvim: Smart and powerful comment plugin for neovim -- {{{3
add_plug('numToStr/Comment.nvim', { event = {"VeryLazy"} })

-- folke/todo-comments.nvim: Highlight, list and search todo comments --- {{{3
add_plug("folke/todo-comments.nvim", { event = {"VeryLazy"} })

-- junegunn/vim-easy-align: text alignment tool ------------------------- {{{3
add_plug("junegunn/vim-easy-align", {
  keys = {
    { "ga", mode = { "n", "v", "x" } },
  },
  cmd = "EasyAlign",
})

-- beauwilliams/focus.nvim: Auto Ajust the size of focused window ------- {{{3
add_plug("nvim-focus/focus.nvim", {
  init = function()
    local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
    local ignore_filetypes = {
      "rbrowser", "sagaoutline", "floaterm", "rdoc", "fzf",
      "voomtree", "neo-tree", "kittypreviewimage", "aerial",
    }
    local ignore_buftypes = { "terminal", "nofile", "promp", "popup" }
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      callback = function(ev)
        if vim.b[ev.buf].focus_disable then return end
        if
          vim.tbl_contains(ignore_filetypes, vim.bo[ev.buf].filetype) or
          vim.tbl_contains(ignore_buftypes, vim.bo[ev.buf].buftype)
        then
          vim.b[ev.buf].focus_disable = true
        else
          vim.b[ev.buf].focus_disable = false
        end
      end,
      desc = "Disable focus autoresize",
    })

    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("FocusResize", { clear = true }),
      callback = function()
        require('focus').resize()
      end,
    })
  end,
  keys = {
    { "<leader>wh", "<cmd>FocusSplitLeft<cr>",    desc = "Focus Split Left" },
    { "<leader>wl", "<cmd>FocusSplitRight<cr>",   desc = "Focus Split Right" },
    { "<leader>wj", "<cmd>FocusSplitDown<cr>",    desc = "Focus Split Down" },
    { "<leader>wk", "<cmd>FocusSplitUp<cr>",      desc = "Focus Split Up" },
    { "<leader>wm", "<cmd>FocusMaximise<cr>",     desc = "Focus Maximise" },
    { "<leader>we", "<cmd>FocusEqualise<cr>",     desc = "Focus Equalise" },
    { "<leader>ww", "<cmd>FocusToggle<cr>",       desc = "Focus Toggle" },
    { "ww", "<cmd>FocusToggle<cr>",       desc = "Focus Toggle" },
    { "<leader>wb", "<cmd>FocusToggleBuffer<cr>", desc = "Focus Toggle Buffer" },
  },
  cmd = { "FocusToggle", "FocusEnable" },
  event = {"WinNew"}
})

-- kylechui/nvim-surround: Surround selections, stylishly --------------- {{{3
add_plug("kylechui/nvim-surround", {
  version = "*",
  event = "VeryLazy",
  ft = {"markdown", "stata"},
  keys = {'ys', 'ds', 'cs'},
})

-- tpope/vim-repeat: repeat operation ----------------------------------- {{{3
add_plug("tpope/vim-repeat", {
  keys = {
    { ".", mode = { "n", "v", "x" } },
  },
})

-- nvim-pack/nvim-spectre: find with rg and replace with sed ------------ {{{3
add_plug("nvim-pack/nvim-spectre", {
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
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

-- MagicDuck/grug-far.nvim: Find And Replace plugin for neovim ---------- {{{3
add_plug("MagicDuck/grug-far.nvim", {
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
})

-- rcarriga/nvim-notify: notification manager --------------------------- {{{3
-- add_plug("rcarriga/nvim-notify", {
--   keys = {
--     {
--       "<leader>nu",
--       function()
--         require("notify").dismiss { silent = true, pending = true }
--       end,
--       desc = "Dismiss all Notifications",
--     },
--   },
--   init = function()
--     vim.notify = require "notify"
--   end,
--   event = {'VeryLazy'},
-- })

add_plug("folke/noice.nvim", {
  event = "VeryLazy",
  init = function()
    vim.api.nvim_set_option_value("cmdheight", 0, { scope = "global" })
  end,
  cmd = {'NoiceEnable'},
  keys = {
    {
      "<leader>hn", "<cmd>NoiceTelescope<cr>", desc = "Noice: Search Notifications",
    },
    {
      "<c-f>", function() require('noice.lsp').signature() end, mode = "i", desc = "Noice: Show lsp documents"
    },
  },
})

-- folke/flash.nvim: Navigate tools ------------------------------------- {{{3
add_plug("folke/flash.nvim", {
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
      "st",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter",
    },
  },
})

add_plug("rainzm/flash-zh.nvim", {
  event = "VeryLazy",
  keys = {
    {
      "sc",
      mode = {"n", "x", "o"},
      function()
        require("flash-zh").jump({
          chinese_only = true,
          labels = " ;,.123456789[]",
        })
      end,
      desc = "Flash between Chinese"
    },
  }
})

-- easymotion/vim-easymotion: motion tools ------------------------------ {{{3
add_plug("easymotion/vim-easymotion", {
  init = function()
    vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings
    vim.g.EasyMotion_smartcase = 1
    vim.g.EasyMotion_use_migemo = 1
  end,
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
-- add_plug("zzhirong/vim-easymotion-zh", { lazy = true })

-- folke/which-key.nvim: displays a popup with possible keybindings ----- {{{3
add_plug("folke/which-key.nvim", { event = "VeryLazy" })

-- -- yianwillis/vimcdoc: Chinese version of vim documents ----------------- {{{3
-- add_plug("yianwillis/vimcdoc", {
--   keys = { "<F1>" },
--   event = { "CmdwinEnter", "CmdlineEnter" },
-- })
--
-- zhimsel/vim-stay: Make Vim persist editing state without fuss -------- {{{3
-- add_plug("zhimsel/vim-stay", {
--   init = function()
--     vim.o.viewoptions = "cursor,folds,slash,unix"
--   end,
-- })

-- chrisgrieser/nvim-origami: Fold with relentless elegance ------------- {{{3
add_plug("chrisgrieser/nvim-origami", {
	event = "BufReadPost", -- later or on keypress would prevent saving folds
})

-- kevinhwang91/nvim-ufo: ultra fold in Neovim -------------------------- {{{3
add_plug("kevinhwang91/promise-async", { lazy = true })
add_plug("kevinhwang91/nvim-ufo", {
	event = "BufReadPost", -- later or on keypress would prevent saving folds
  init = function()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
})
-- vim-voom/VOoM: vim Outliner of Markups ------------------------------- {{{3
add_plug("vim-voom/VOoM", {
  cmd = "Voom",
  keys = {
    { "<leader>v", "<cmd>Voom<cr>", desc = "VOom: Show Outliner" },
  },
})

-- akinsho/bufferline.nvim: buffer line with minimal tab integration ---- {{{3
add_plug("akinsho/bufferline.nvim", {
  event = "VeryLazy",
})

-- Bekaboo/dropbar.nvim: IDE-like breadcrumbs, out of the box ----------- {{{3
add_plug({
  'Bekaboo/dropbar.nvim',
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  config = true,
})

-- nvim-lualine/lualine.nvim: neovim statusline plugin ------------------ {{{3
add_plug("nvim-lualine/lualine.nvim")

-- goolord/alpha-nvim: a lua powered greeter ---------------------------- {{{3
-- add_plug('goolord/alpha-nvim')

-- nvim-tree/nvim-web-devicons: file type icons ------------------------- {{{3
add_plug("nvim-tree/nvim-web-devicons", { config = true, lazy = true })
add_plug("echasnovski/mini.icons", {
  lazy = true,
  opts = {
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  config = true,
})

-- windwp/nvim-autopairs: autopair tools -------------------------------- {{{3
add_plug("windwp/nvim-autopairs")

-- stevearc/dressing.nvim: improve the default vim.ui interfaces -------- {{{3
add_plug("stevearc/dressing.nvim", {
  opts = {
    input = {
      default_prompt = "➤ ",
      win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
    },
    select = {
      backend = { "telescope", "fzf_lua", "builtin" },
      builtin = {
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
    },
  },
  config = true,
})

-- Make your nvim window separators colorful ---------------------------- {{{3
add_plug("nvim-zh/colorful-winsep.nvim", {
  event = { "WinNew" },
  config = function()
    require("colorful-winsep").setup({
      no_exec_files = {
        "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree",
        "aerial", "neo-tree"
      },
      symbols = { "─", "│", "┌", "┐", "└", "┘" },
    })
  end
})

-- "lukas-reineke/indent-blankline.nvim"
-- add_plug("lukas-reineke/indent-blankline.nvim", { main = "ibl" })
-- add_plug(  "shellRaining/hlchunk.nvim", {
--   event = { "BufReadPre", "BufNewFile" },
--   config = function()
--     require("hlchunk").setup({
--       chunk    = { enable = true },
--       indent   = { enable = false },
--       line_num = { enable = false },
--     })
--   end
-- })
-- add_plug("nvimdev/indentmini.nvim", {
--   config = function()
--     require("indentmini").setup({
--        char = "│",
--        exclude = {"markdown", "alpha", "norg", "help"}
--     })
--   end,
-- })

-- Tools ---------------------------------------------------------------- {{{2
-- liubianshi/cmp-lsp-rimels: ------------------------------------------- {{{3
if vim.fn.has('linux') == 1 and (not vim.env.SSH_TTY or vim.env.SSH_TTY == "") then
  add_plug("liubianshi/ime-toggle", {
    keys = {{"<localleader>f", mode = "i"}},
    dev = true,
    config = true,
  })
else
  add_plug("liubianshi/cmp-lsp-rimels", {
    keys = {{"<localleader>f", mode = "i"}},
    dev = true,
  })
end

-- tpope/vim-rsi: Readline style insertion ------------------------------ {{{3
add_plug("tpope/vim-rsi", {
  init = function() vim.g.rsi_no_meta = 1 end,
})

-- folke/snacks.nvim: A collection of small QoL plugins ----------------- {{{3
add_plug {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
  }
}

-- LinTaoAmons/scratch.nvim: Create temporary playground files ---------- {{{3
-- add_plug("LinTaoAmons/scratch.nvim", {
--   event = "VeryLazy",
--   cmd = "Scratch",
--   keys = {
--     {"<leader>os", "<cmd>Scratch<cr>",  desc = "Creates a new scratch file"}
--   }
-- })

-- ziontee113/icon-picker.nvim: pick Nerd Font Icons, Symbols & Emojis -- {{{3
add_plug("liubianshi/icon-picker.nvim", {
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
add_plug("brenoprata10/nvim-highlight-colors", {
  ft = { "html", "lua", "css", "vim", "cpp" },
})

-- nvimdev/lspsaga.nvim: ------------------------------------------------ {{{3
-- add_plug("nvimdev/lspsaga.nvim", { event = 'LspAttach' })
add_plug {
  'stevearc/aerial.nvim',
  config = function()
    require('aerial').setup{
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    }
  end,
  keys = {
    {"<localleader>v", "<cmd>AerialToggle!<CR>", desc = "Toggle aerial"}
  },
  cmd = {"AerialToggle"}
}


-- jackMort/ChatGPT.nvim: Effortless Natural Language Generation -------- {{{3
add_plug("jackMort/ChatGPT.nvim", {
  event = "VeryLazy",
  cmd = { "ChatGPT" },
})

add_plug("robitx/gp.nvim", {
  cmd = {
    "GpAgent",
    "GpChatNew",
    "GpChatFinder",
    "GpRewrite",
    "GpAppend",
    "GpPopup",
    "GpContext",
    "GpTextOptimize",
    "GpTranslator",
  },
  keys = {
    { "<M-o>",      "<cmd>GpTextOptimize<cr>",      desc = "Optimize Text",          nowait = true, mode = { "n"}},
    { "<M-o>",      ":<C-u>'<,'>GpTextOptimize<cr>",      desc = "Optimize Text",          nowait = true, mode = { "v" }},
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
add_plug("akinsho/toggleterm.nvim", {
  version = "*",
  cmd = "ToggleTerm",
  keys = {
    {
      "<C-CR>",
      "<cmd>ToggleTerm<cr>",
      desc = "Toogle Terminal",
      silent = true,
      mode = { "n", "t"},
      noremap = true,
    },
  },
})

-- willothy/flatten.nvim: open files in your current neovim instance ---- {{{3
add_plug("willothy/flatten.nvim", { lazy = false, priority = 1001 })

-- skywind3000/asyncrun.vim: run async shell command -------------------- {{{3
add_plug("skywind3000/asyncrun.vim", { cmd = {'AsyncRun'} })

-- skywind3000/asynctasks.vim: modern Task System ----------------------- {{{3
add_plug("skywind3000/asynctasks.vim", {
  cmd = { "AsyncTask", "AsyncTaskList" },
  keys = {
    { "<leader>ot", desc = "Run AsnycTask" },
  },
})

-- liubianshi/vimcmdline: send lines to interpreter --------------------- {{{3
add_plug("liubianshi/vimcmdline", {
  ft = {'stata', 'sh', 'bash'},
  dev = true,
})

-- -- potamides/pantran.nvim: trans without leave neovim ------------------- {{{3
-- add_plug("potamides/pantran.nvim", {
--   keys = {
--     { "<leader>tr", mode = { "x", "n" }, desc = "Pantran: translate" },
--     {
--       "<leader>T",
--       "<cmd>Pantran target=en<cr>",
--       desc = "Pantran: to English",
--       mode = { "n", "v" },
--     },
--   },
-- })

-- 3rd/image.nvim: Bringing images to Neovim.
add_plug("3rd/image.nvim", {
  cond = (vim.fn.exists("g:neovide") == 0),
  ft = { "markdown", "pandoc", "rmd", "rmarkdown", "norg", "org", "newsboat" },
})

-- gbprod/yanky.nvim: Improved Yank and Put functionalities for Neovim -- {{{3
add_plug("gbprod/yanky.nvim", {
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
-- liubianshi/anki-panky ------------------------------------------------ {{{3
add_plug('liubianshi/anki-panky', {
  dev = true,
  ft = { 'markdown' },
  cmd = {'AnkiNew', 'AnkiPush'},
  config = true,
})

-- sindrets/diffview.nvim: cycling through diffs for all modified files - {{{3
add_plug('sindrets/diffview.nvim', {
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen"},
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffviewOpen"},
  },
})

-- Project management --------------------------------------------------- {{{2
-- ahmedkhalf/project.nvim: superior project management solution -------- {{{3
add_plug("ahmedkhalf/project.nvim", { event = "VeryLazy" })

-- ludovicchabant/vim-gutentags: tag file management -------------------- {{{3
add_plug("ludovicchabant/vim-gutentags", {
  event = { "BufReadPost", "BufNewFile" },
})

-- folke/trouble.nvim: diagnostics solution ----------------------------- {{{3
add_plug("folke/trouble.nvim", {
  cmd = {'Trouble'},
  config = true,
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
})

-- rachartier/tiny-inline-diagnostic.nvim ------------------------------- {{{3
add_plug("rachartier/tiny-inline-diagnostic.nvim", {
  init = vim.diagnostic.config({ virtual_text = false }),
  event = "VeryLazy",
  config = true,
})

-- tpope/vim-fugitive: Git ---------------------------------------------- {{{3
add_plug("tpope/vim-fugitive", { cmd = "G" })


-- Theme ---------------------------------------------------------------- {{{2
add_plug("luisiacc/gruvbox-baby",            { lazy = false })
add_plug("ayu-theme/ayu-vim",                { lazy = false })
add_plug("rebelot/kanagawa.nvim",            { lazy = false, priority = 100 })
add_plug("olimorris/onedarkpro.nvim",        { priority = 100 })
add_plug("Mofiqul/vscode.nvim",              { priority = 100 })
add_plug("rmehri01/onenord.nvim",            { priority = 100 })
add_plug("nyoom-engineering/oxocarbon.nvim", {
  init = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end,
  priority = 100,
})
add_plug("Verf/deepwhite.nvim",              { lazy = false, priority = 100  })
add_plug("mhartington/oceanic-next",         { lazy = false })
add_plug("sainnhe/everforest", {
  init = function()
    vim.g.everforest_better_performance = 1
    vim.g.everforest_background = "hard"
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_transparent_background = 0
    vim.g.everforest_dim_inactive_windows = 0
  end,
  lazy = false,
})
add_plug("catppuccin/nvim", { name = "catppuccin", lazy = false })
add_plug("folke/tokyonight.nvim", { lazy = false, priority = 1000 })
add_plug("projekt0n/github-nvim-theme", { lazy = false, priority = 1000 })

-- 补全和代码片断 ------------------------------------------------------- {{{2
-- sirver/UltiSnips: Ultimate snippet solution -------------------------- {{{3
add_plug("honza/vim-snippets", { lazy = true } )
add_plug("sirver/UltiSnips", {
  cmd = { "UltiSnipsAddFiletypes" },
  init = function()
    vim.g.UltiSnipsExpandTrigger            = "<c-l>"
    vim.g.UltiSnipsJumpForwardTrigger       = "<c-j>"
    vim.g.UltiSnipsJumpBackwardTrigger      = "<c-k>"
    vim.g.UltiSnipsRemoveSelectModeMappings = 0
  end,
  dependencies = { "honza/vim-snippets" },
  event = "InsertEnter",
})

-- completation framework and relative sources -------------------------- {{{3
add_plug("folke/lazydev.nvim", {
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
add_plug("Bilal2453/luvit-meta", { lazy = true })
add_plug("neovim/nvim-lspconfig", {
  -- event = { "BufReadPre", "BufNewFile", "BufWinEnter" },
  ft = {"lua", "perl", "markdown", "bash", "r", "python", "vim", "rmd"},
})
add_plug("liubianshi/cmp-r", { dev = true, lazy = true})
-- add_plug("R-nvim/cmp-r", { lazy = true})

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
  add_plug(k, { lazy = true })
end
add_plug("hrsh7th/nvim-cmp", {
  event = {"InsertEnter", "CmdlineEnter"},
  dependencies = cmp_dependencies,
})

-- Formatter and linter ------------------------------------------------- {{{2
-- mfussenegger/nvim-dap
-- add_plug("mfussenegger/nvim-dap")
-- add_plug("rcarriga/nvim-dap-ui", {
--   dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
-- })

-- mhartington/formatter.nvim: autoformat tool -------------------------- {{{3
add_plug("mhartington/formatter.nvim", {
  ft = { "lua", "sh", "perl", "r", "html", "xml", "css", "markdown", "javascript" },
})

-- Writing and knowledge management ------------------------------------- {{{2
-- vim-pandoc/vim-pandoc: pandoc integration and utilities for vim ------ {{{3
-- add_plug("vim-pandoc/vim-pandoc-syntax", {
--   init = function()
--     vim.g.tex_conceal = "adgm"
--     vim.g['pandoc#syntax#codeblocks#embeds#langs'] = {
--       "perl", "r", "bash=sh", "stata", "vim", "python", "raku", "c"
--     }
--   end,
--   ft = { "markdown", "pandoc", "markdown.pandoc" },
-- })
--

-- folke/zen-mode.nvim: 🧘 Distraction-free coding for Neovim ----------- {{{3
add_plug {
  "folke/zen-mode.nvim",
  keys = {
    { "<leader>oZ", "<cmd>ZenMode<cr>", desc = "Zen Mode" }
  }
}

-- ellisonleao/glow.nvim: A markdown preview directly in your neovim. --- {{{3
add_plug("ellisonleao/glow.nvim", {
  cmd = {"Glow"},
  config = true
})

-- quarto-dev/quarto-nvim: Quarto mode for Neovim ----------------------- {{{3
-- add_plug {
--   "quarto-dev/quarto-nvim",
--   ft = { 'quarto' },
--   dependencies = {
--     "jmbuhr/otter.nvim",
--     "nvim-treesitter/nvim-treesitter",
--   },
-- }

-- OXY2DEV/markview.nvim ------------------------------------------------ {{{3
add_plug('OXY2DEV/markview.nvim', {
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  }
})

-- ferrine/md-img-paste.vim: paste image to markdown -------------------- {{{3
add_plug("HakonHarnes/img-clip.nvim", {
  ft = { "rmd", "markdown", "rmarkdown", "pandoc", "org", "tex", "html", "norg", "quarto" },
  keys = {
    { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
  },
})

-- hotoo/pangu.vim: 『盘古之白』中文排版自动规范化 ---------------------- {{{3
add_plug("hotoo/pangu.vim", {
  ft = { "rmd", "markdown", "rmarkdown", "pandoc", "norg", "org", "newsboat", "html" },
  init = function()
    vim.g.pangu_rule_fullwidth_punctuation = 0
    vim.g.pangu_rule_spacing_punctuation = 1
    vim.g.pangu_rule_remove_zero_width_whitespace = 0
  end,
})

-- dhruvasagar/vim-table-mode: Table Mode for instant table creation ---- {{{3
add_plug("dhruvasagar/vim-table-mode", {
  ft = { "markdown", "pandoc", "rmd", "org" },
  init = function()
    vim.g.table_mode_map_prefix = "<localleader>t"
    vim.g.table_mode_corner = '|'
  end,
})

-- epwalsh/obsidian.nvim
add_plug("epwalsh/obsidian.nvim", {
  version = "*",
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

-- 文件类型相关插件 ----------------------------------------------------- {{{2
-- nvim-neorg/neorg: new org-mode in neovim ----------------------------- {{{3
add_plug("nvim-neorg/neorg", {
  version = "*",
  ft = { "norg" },
  cmd = { "Neorg" },
  dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" }  },
  keys = {
    {
      "<leader>ej",
      "<cmd>Neorg journal today<cr>",
      desc = "Open today's journal",
    },
  },
})

-- kristijanhusak/vim-dadbod-ui: simple UI for vim-dadbod --------------- {{{3
add_plug("kristijanhusak/vim-dadbod-ui", {
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = {"tpope/vim-dadbod"}
})


add_plug("liubianshi/R.nvim", { dev = true, lazy = false })
-- add_plug("R-nvim/R.nvim", { lazy = false, branch = "fix_no_args_compl" })


-- lervag/vimtex: filetype plugin for LaTeX files ----------------------- {{{3
add_plug("lervag/vimtex", { ft = "tex" })

-- poliquin/stata-vim: Syntax highlighting and snippets for Stata files - {{{3
add_plug("poliquin/stata-vim", { ft = "stata" }) -- stata 语法高亮

-- mechatroner/rainbow_csv: Highlight columns and run queries ----------- {{{3
add_plug("mechatroner/rainbow_csv", { ft = { "csv", "tsv" } })

-- WolfgangMehner/perl-support: filetype plugin for perl files ---------- {{{3
-- add_plug("WolfgangMehner/perl-support", { ft = "perl" })

-- liuchengxu/graphviz.vim: Graphviz dot -------------------------------- {{{3
add_plug("liuchengxu/graphviz.vim", { ft = "dot" })

-- kevinhwang91/nvim-bqf: Better quickfix window in Neovim -------------- {{{3
add_plug("kevinhwang91/nvim-bqf", { ft = "qf" })

-- nvim-orgmode/orgmode: Orgmode clone written in Lua ------------------- {{{3
add_plug("nvim-orgmode/orgmode", {
  ft = "org",
  cmd = {'OrgCapture'},
  keys = {
    { "<leader>oa", desc = "Orgmode: agenda prompt" },
    { "<leader>oc", desc = "Orgmode: capture prompt" },
  },
})
add_plug("akinsho/org-bullets.nvim", { config = true, lazy = true })

-- fladson/vim-kitty: kitty config syntax highlighting for vim ---------- {{{3
add_plug("fladson/vim-kitty", { ft = "kitty" })

-- kmonad/kmonad-vim: Vim syntax highlighting for .kbd files ------------ {{{3
add_plug("kmonad/kmonad-vim", { ft = "kbd" })

-- andis-sprinkis/lf-vim: Vim syntax highlighting for the lf config ----- {{{3
add_plug("andis-sprinkis/lf-vim", { ft = "lf" })

-- TreeSitter ----------------------------------------------------------- {{{2
-- nvim-treesitter/nvim-treesitter: Treesitter configurations ----------- {{{3
add_plug("nvim-treesitter/nvim-treesitter", {
  build = ":TSUpdate",
  cmd = "TSEnable",
  event = { "BufReadPost", "BufNewFile" },
})

add_plug("nvim-treesitter/nvim-treesitter-textobjects", {
  event = { "BufReadPost", "BufNewFile" },
})

-- Wansmer/treesj: Neovim plugin for splitting/joining blocks of code --- {{{3
add_plug("Wansmer/treesj", {
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  keys = {
    { "<leader>mj", "<cmd>TSJJoin<cr>",   desc = "Join Code Block"       },
    { "<leader>ms", "<cmd>TSJSplit<cr>",  desc = "Split Code Block"      },
    { "<leader>mm", "<cmd>TSJToggle<cr>", desc = "Join/Split Code Block" },
  }
})

-- AckslD/nvim-FeMaco.lua: Fenced Markdown Code-block editing ----------- {{{3
add_plug("AckslD/nvim-FeMaco.lua", {
  cmd = "FeMaco",
  ft = {'markdown', 'rmarkdown', 'norg'},
  keys = {
    { "<localleader>o", "<cmd>FeMaco<cr>", desc = "FeMaco: Edit Code Block" },
  },
})

-- 安装并加载插件 ------------------------------------------------------- {{{1
require("lazy").setup(Plugins, require('plugins.lazy'))

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
