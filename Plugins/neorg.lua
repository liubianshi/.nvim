-- register keybinds ---------------------------------------------------- {{{1
local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add {
    { "<localleader>i", group = "Insert" },
    { "<localleader>l", group = "List" },
    { "<localleader>m", group = "Move" },
    { "<localleader>n", group = "Note" },
    { "<localleader>s", group = "search node" },
    { "<localleader>t", group = "Task" },
  }
end

local image_render_exist = function()
  PlugExist "image.nvim"
end

local get_modules = function()
  local modules = {
    ["core.defaults"] = {},
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
      },
    },
    ["core.summary"] = {},
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.export"] = {},
    ["core.export.markdown"] = {
      config = {
        extension = "md",
        extensions = "all",
        ["metadata"] = {
          ["end"] = "---",
          ["start"] = "---",
        },
      },
    },
    ["core.journal"] = {
      config = {
        journal_folder = "norg-journal",
        workspace = "journal",
      },
    },
    ["core.concealer"] = {
      config = {
        icons = {
          heading = {
            icons = { "󰉫", "󰉬", "󰉭", "󰉮", "󰉯", "󰉰" },
          },
          ordered = {
            icons = { "1", "A", "a", "⑴", "Ⓐ", "ⓐ" },
          },
          list = {
            -- icons = { "", "", "󰻂", "", "󱥸", "" },
            icons = { "󰻂", "󰻂", "󰻂", "󰻂", "󰻂", "󰻂" },
          },
        },
      },
    },
    ["core.dirman"] = {
      config = {
        workspaces = {
          lbs = "~/Documents/Writing/Norg",
          journal = "~/Documents/Writing/journal",
          meeting = "~/Documents/Writing/meeting",
        },
      },
    },
    ["core.integrations.telescope"] = {},
  }

  if image_render_exist() then
    modules["core.latex.renderer"] = {
      renderer = "core.integrations.image",
      render_on_enter = true,
      dpi = 600,
      scale = 0.5,
    }
  end
  return modules
end

-- setup ---------------------------------------------------------------- {{{1
require("neorg").setup {
  load = get_modules(),
}

--- keybinds ------------------------------------------------------------ {{{1
local kmap = function(key, cmd, opts)
  opts = vim.tbl_extend('keep', opts or {}, {
    silent = true,
    noremap = true,
    buffer = true,
  })
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.set(mode, key, cmd, opts)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("LBS_Neorg_Keymaps", {clear = true}),
  pattern = "norg",
  callback = function()
    kmap(
      "<localleader>sH",
      "<cmd>Neorg toc qflist<cr>",
      { desc = "Search Headings through qflist" }
    )
    kmap(
      "<localleader>o",
      "<cmd>Neorg keybind all core.looking-glass.magnify-code-block<cr>",
      { desc = "Edit Code Chunk" }
    )
    kmap(
      "<localleader>S",
      "<cmd>Neorg generate-workspace-summary<cr>",
      { desc = "Display Summary" }
    )
    kmap(
      "<localleader>nj",
      "<cmd>Neorg journal today<cr>",
      { desc = "Open today's journal" }
    )
    kmap(
      "<localleader>ni",
      "<cmd>Neorg index<cr>",
      { desc = "Return to Index Page" }
    )
    kmap(
      "<localleader><tab>",
      "<Plug>((neorg.telescope.switch_workspace))",
      { desc = "Switch Workspace" }
    )
    kmap("<localleader>sl",
      "<Plug>((neorg.telescope.find_linkable))",
      { desc = "Find Linkable" }
    )
    kmap("<localleader>sf",
      "<Plug>((neorg.telescope.find_norg_files))",
      { desc = "Find Norg Files" }
    )
    kmap("<localleader>sh",
      "<Plug>((neorg.telescope.search_headings))",
      { desc = "Search Headings" }
    )
    kmap("<localleader>st",
      "<Plug>((neorg.telescope.find_context_tasks))",
      { desc = "Find Context Tasks" }
    )
    kmap("<localleader>sT",
      "<Plug>(neorg.telescope.find_project_tasks)",
      { desc = "Find Project Tasks" }
    )
    kmap("<localleader>sa",
      "<Plug>(neorg.telescope.find_aof_tasks)",
      { desc = "Find AOF Tasks" }
    )
    kmap("<localleader>sA",
      "<Plug>(neorg.telescope.find_aof_project_tasks)",
      { desc = "Find AOF Project Tasks" }
    )
    kmap("<localleader>ll",
      "<Plug>(neorg.telescope.insert_link)",
      { mode = "i", desc = "Insert Link" }
    )
    kmap("<localleader>lf",
      "<Plug>(neorg.telescope.insert_file_link)",
      { mode = "i", desc = "Insert File Link" }
    )
  end,
})





-- vim: set fdm=marker: ------------------------------------------------- {{{1
