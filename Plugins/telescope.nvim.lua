local telescope = require('telescope')
local actions = require('telescope.actions')
local command_center = require("command_center")

local function flash(prompt_bufnr)
  require("flash").jump({
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  })
end

-- setup ---------------------------------------------------------------- {{{1
telescope.setup {
    defaults = {
      mappings = {
        n = { s = flash },
        i = {
          ["<c-f>"] = flash,
          ["<esc>"] = actions.close,
          [';j']    = function() vim.cmd("stopinsert") end,
        },
      },
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                            -- the default case_mode is "smart_case"
        },
        frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = {"*.git/*", "*/tmp/*"},
            disable_devicons = false,
            workspaces = {
                ["conf"]    = "~/.config",
                ["data"]    = "~/.local/share",
                ["project"] = "~/Repositories/",
                ["write"]   = "~/Documents/Writing/"
            }
        }
    }
}

-- load extensions ------------------------------------------------------ {{{1
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension("command_center")
telescope.load_extension("frecency")


-- extensions config ---------------------------------------------------- {{{1
-- command center ------------------------------------------------------- {{{2
command_center.add({
  {
    desc = "Search inside current buffer",
    cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
  },  {
    desc = "Find Files",
    cmd = "<CMD>Telescope find_files<CR>",
  }, {
    desc = "Find hidden files",
    cmd = "<CMD>Telescope find_files hidden=true<CR>",
  }, {
    desc = "Show document symbols",
    cmd = "<CMD>Telescope lsp_document_symbols<CR>",
  }, {
    desc = "Fine vim Options",
    cmd = "<cmd>Telescope vim_options<cr>",
  }
})

-- vim: set fdm=marker: ------------------------------------------------- {{{1
