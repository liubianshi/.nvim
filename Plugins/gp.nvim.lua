local function gp_trans(gp, params)
  local agent = gp.get_command_agent()
  local chat_system_prompt =
    "请你担任一名将英文翻译成简体中文的翻译者。请帮我把英文翻译成简体中文。我会输入英文内容，内容可能是一个句子、或一个单字，请先理解内容后再将我提供的内容翻译成简体中文。回答内容请尽量口语化且符合语境，但仍保留意思。回答内容包含翻译后的简体中文文本，不需要额外的解释。"
  gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
end

local gpt4 = "gpt-4o"
local gpt35 = "gpt-3.5-turbo"

require("gp").setup {
  openai_api_key = { vim.env.HOME .. "/.private_info.sh", "openai" },
  hooks = {
    Translator = gp_trans,
  },
  whisper = { disable = true },
  image = { disable = true },
  agents = {
    {
      name = "ChatGPT4",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = gpt4, temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.\n\n"
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Think deeply and carefully from first principles step by step.\n"
        .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        .. "- Use Socratic method to improve your thinking and coding skills.\n"
        .. "- Don't elide any code from your output if the answer requires coding.\n"
        .. "- Take a deep breath; You've got this!\n",
    },
    {
      name = "ChatGPT3-5",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = gpt35, temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.\n\n"
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Think deeply and carefully from first principles step by step.\n"
        .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        .. "- Use Socratic method to improve your thinking and coding skills.\n"
        .. "- Don't elide any code from your output if the answer requires coding.\n"
        .. "- Take a deep breath; You've got this!\n",
    },
    {
      name = "CodeGPT4",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = gpt4, temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are an AI working as a code editor.\n\n"
        .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
        .. "START AND END YOUR ANSWER WITH:\n\n```",
    },
    {
      name = "CodeGPT3-5",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = gpt35, temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are an AI working as a code editor.\n\n"
        .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
        .. "START AND END YOUR ANSWER WITH:\n\n```",
    },
  },
}

local gp_group = vim.api.nvim_create_augroup("GpAuto", { clear = TRUE})
vim.api.nvim_create_autocmd({"FileType"}, {
  group = gp_group,
  pattern = "markdown",
  callback = function(ev)
    local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, 1, true)
    if lines and lines[1] and string.match(lines[1], "^# topic: %?$") then
      return true
    end
    vim.keymap.set("n", "<localleader><leader>", function()
      local row = vim.fn.line(".") - 2
      if row <= 1 then return end

      local chat_assistant_prefix = require('gp').config.chat_assistant_prefix[1]
      for i = row, 1, -1 do
        local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1] or ""
        if line:find("^" .. chat_assistant_prefix) then
          vim.api.nvim_win_set_cursor(0, {i + 1, 0})
          return
        end
      end
    end, {
      buffer = ev.buf,
      desc = "GPT goto previous assistant",
      noremap = true,
      silent = true,
      nowait = true,
    })
  end
})



