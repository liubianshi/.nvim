local gp_trans = function(gp, params)
  local agent = gp.get_command_agent()
  local chat_system_prompt =
    "请你担任一名将英文翻译成简体中文的翻译者。请帮我把英文翻译成简体中文。我会输入英文内容，内容可能是一个句子、或一个单字，请先理解内容后再将我提供的内容翻译成简体中文。回答内容请尽量口语化且符合语境，但仍保留意思。回答内容包含翻译后的简体中文文本，不需要额外的解释。"
  gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
end

require("gp").setup {
  openai_api_key = { vim.env.HOME .. "/.private_info.sh", "openai" },
  hooks = {
    Translator = gp_trans,
  },
}

require("which-key").register({
  ["<c-g>"] = {
    g = { name = "generate into new .." },
    w = { name = "Whisper" },
  },
}, {
  mode = { "v", "x", "i" },
})
