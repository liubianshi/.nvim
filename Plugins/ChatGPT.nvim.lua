local chatgpt = require "chatgpt"
local home = vim.fn.expand "$HOME"

chatgpt.setup {
  api_key_cmd = home .. "/.private_info.sh openai",
  yank_register = "+",
  edit_with_instructions = {
    diff = false,
    keymaps = {
      close = "<C-c>",
      accept = "<C-y>",
      toggle_diff = "<C-d>",
      toggle_settings = "<C-o>",
      toggle_help = "<C-h>",
      cycle_windows = "<Tab>",
      use_output_as_input = "<C-i>",
    },
  },
  chat = {
    -- welcome_message = WELCOME_MESSAGE,
    loading_text = "Loading, please wait ...",
    question_sign = "", -- 🙂
    answer_sign = "ﮧ", -- 🤖
    border_left_sign = "<",
    border_right_sign = ">",
    max_line_length = 120,
    sessions_window = {
      active_sign = " 󰄲",
      inactive_sign = " 󰄱 ",
      current_line_sign = "",
      border = {
        style = { '', {'═', "MyBorder"}, '', '', '', '', '', ''},
        text = {
          top = " Sessions ",
        },
      },
      win_options = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    },
    keymaps = {
      close = "<C-c>",
      yank_last = "<C-y>",
      yank_last_code = "<C-k>",
      scroll_up = "<C-u>",
      scroll_down = "<C-d>",
      new_session = "<C-n>",
      cycle_windows = "<Tab>",
      cycle_modes = "<C-f>",
      next_message = "<C-j>",
      prev_message = "<C-k>",
      select_session = "<Space>",
      rename_session = "r",
      delete_session = "d",
      draft_message = "<C-r>",
      edit_message = "e",
      delete_message = "d",
      toggle_settings = "<C-o>",
      toggle_sessions = "<C-p>",
      toggle_help = "<C-h>",
      toggle_message_role = "<C-r>",
      toggle_system_role_open = "<C-s>",
      stop_generating = "<C-x>",
    },
  },
  popup_layout = {
    default = "center",
    center = {
      width = "80%",
      height = "80%",
    },
    right = {
      width = "30%",
      width_settings_open = "50%",
    },
  },
  popup_window = {
    border = {
      style = { '', {'═', "MyBorder"}, '', '', '', '', '', ''},
      text = {
        top = " ChatGPT ",
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = "0",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
    buf_options = {
      filetype = "markdown",
    },
  },
  system_window = {
    border = {
      style = { '', {'═', "MyBorder"}, '', '', '', '', '', ''},
      text = {
        top = " SYSTEM ",
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = "0",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  popup_input = {
    prompt = "  ",
    border = {
      style = { '', '─', '', '', '', {'═', "MyBorder"}, '', ''},
      text = {
        top_align = "center",
        top = " Prompt ",
      },
    },
    win_options = {
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
    submit = ";<Enter",
    submit_n = "<Enter>",
    max_visible_lines = 20,
  },
  settings_window = {
    setting_sign = "  ",
    border = {
      style = { '', {'═', "MyBorder"}, '', '', '', '', '', ''},
      text = {
        top = " Settings ",
      },
    },
    win_options = {
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  help_window = {
    setting_sign = "  ",
    border = {
      style = { '', {'═', "MyBorder"}, '', '', '', '', '', ''},
      text = {
        top = " Help ",
      },
    },
    win_options = {
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  openai_params = {
    model = "gpt-4o",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 3000,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = "gpt-4o",
    frequency_penalty = 0,
    presence_penalty = 0,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  use_openai_functions_for_edits = false,
  actions_paths = {},
  show_quickfixes_cmd = "Trouble quickfix",
  predefined_chat_gpt_prompts = "file:///Users/luowei/useScript/chatgpt_prompt.csv",
  highlights = {
    help_key = "@symbol",
    help_description = "@comment",
  },
}
vim.cmd [[ hi ChatGPTTotalTokens guibg=NONE]]
local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add {
    { ",", group = "ChatGPT" },
    { ",c", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
    {
      mode = { "n", "v" },
      { ",a", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
      { ",d", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
      {
        ",e",
        "<cmd>ChatGPTEditWithInstruction<CR>",
        desc = "Edit with instruction",
      },
      { ",f", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
      {
        ",g",
        "<cmd>ChatGPTRun grammar_correction<CR>",
        desc = "Grammar Correction",
      },
      { ",k", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
      {
        ",l",
        "<cmd>ChatGPTRun code_readability_analysis<CR>",
        desc = "Code Readability Analysis",
      },
      { ",o", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
      { ",r", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
      { ",s", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
      { ",t", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
      { ",x", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
    },
  }
end
