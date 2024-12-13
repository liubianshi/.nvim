local function gp_trans(gp, params)
  local agent = gp.get_command_agent()
  local chat_system_prompt =
    "请你担任一名将英文翻译成简体中文的翻译者。请帮我把英文翻译成简体中文。我会输入英文内容，内容可能是一个句子、或一个单字，请先理解内容后再将我提供的内容翻译成简体中文。回答内容请尽量口语化且符合语境，但仍保留意思。回答内容包含翻译后的简体中文文本，不需要额外的解释。"
  gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
end

local function gp_polish(gp, params)
  local template =
    "Having following from {{filename}}:\n\n"
    .. "```{{filetype}}\n{{selection}}\n```\n\n"
    .. "Please act as an economics professor."
    .. " Correct any spelling mistakes and improve the expression to enhance clarity and coherence."
    .. " Additionally, optimize the text to align with the style and tone of an academic paper in the field of economics."
    .. " Please ensure that the language is the same as the original language."
    .. "\n\nRespond exclusively with the snippet that should replace the selection above."
  local agent = gp.agents['CodeGPT4o-mini']
  gp.logger.info("Implementing selection with agent: " .. agent.name)
  gp.Prompt(
    params,
    gp.Target.rewrite,
    agent,
    template,
    nil, -- command will run directly without any prompting for user input
    nil -- no predefined instructions (e.g. speech-to-text from Whisper)
  )
end

local gpt4 = "gpt-4o"
local gpt35 = "gpt-3.5-turbo"

require("gp").setup {
  openai_api_key = { vim.env.HOME .. "/.private_info.sh", "openai" },
  hooks = {
    Translator = gp_trans,
    TextOptimize = gp_polish,
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
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      name = "ChatGPT3-5",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = gpt35, temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
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
      name = "ChatGPT4o-mini",
      provider = "openai",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "openai",
      name = "CodeGPT4o-mini",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
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
local gp_group = vim.api.nvim_create_augroup("GpAuto", { clear = true})
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
