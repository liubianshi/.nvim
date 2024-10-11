local M = {}
local buffer_rime_status =  "buf_rime_enabled"
local detectors = require('util.code_environment_detectors')

function M.global_rime_enabled()
  local status = vim.fn.trim(vim.fn.system(vim.g.lbs_input_status))
  return ( status == vim.g.lbs_input_method_on)
end

function M.buf_rime_enabled(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local exist,status = pcall(vim.api.nvim_buf_get_var, bufnr, buffer_rime_status)
  return (exist and status)
end

function M.get_content_before_cursor(shift)
  shift = shift or 0
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col < shift then
    return nil
  end
  local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return line_content:sub(1, col - shift)
end

function M.get_chars_after_cursor(length)
  length = length or 1
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return line_content:sub(col + 1, col + length)
end

function M.get_chars_before_cursor(colnums_before, length)
  length = length or 1
  if colnums_before < length then
    return nil
  end
  local content_before = M.get_content_before_cursor(colnums_before - length)
  if not content_before then
    return nil
  end
  return content_before:sub(-length, -1)
end

function M.is_typing_english(shift)
  local content_before = M.get_content_before_cursor(shift)
  if not content_before then
    return nil
  end
  return content_before:match "%s[%w%p]+$"
end

function M.toggle_rime(force)
  force = force or ""
  if force == "on"  then
    vim.api.nvim_buf_set_var(0, buffer_rime_status, true)
    vim.system(vim.g.lbs_input_method_activate):wait()
  elseif force == "off" then
    vim.api.nvim_buf_set_var(0, buffer_rime_status, false)
    vim.system(vim.g.lbs_input_method_inactivate):wait()
  elseif M.global_rime_enabled() then
    vim.system(vim.g.lbs_input_method_inactivate):wait()
  else
    vim.system(vim.g.lbs_input_method_activate):wait()
  end
end

function M.autotoggle_backspace()
  local rc = { not_toggle = 0, toggle_off = 1, toggle_on = 2 }
  if not M.buf_rime_enabled() or detectors.in_english_environment() then
    return rc.not_toggle
  end

  -- 只有在删除空格时才启用输入法切换功能
  local word_before_1 = M.get_chars_before_cursor(1)
  if not word_before_1 or word_before_1 ~= " " then
    return rc.not_toggle
  end

  -- 删除连续空格或行首空格时不启动输入法切换功能
  local word_before_2 = M.get_chars_before_cursor(2)
  if not word_before_2 or word_before_2 == " " then
    return rc.not_toggle
  end

  -- 删除的空格前是一个空格分隔的 WORD ，或者处在英文输入环境下时，
  -- 切换成英文输入法
  -- 否则切换成中文输入法
  if M.is_typing_english(1) then
    if M.global_rime_enabled() then
      M.toggle_rime()
    end
    return rc.toggle_off
  else
    if not M.global_rime_enabled() then
      M.toggle_rime()
    end
    return rc.toggle_on
  end
end

function M.autotoggle_space()
  if not M.buf_rime_enabled() then return end
  local rc = { not_toggle = 0, toggle_off = 1, toggle_on = 2 }
  if not M.buf_rime_enabled() or detectors.in_english_environment() then
    return rc.not_toggle
  end

  -- 行首输入空格或输入连续空格时不考虑输入法切换
  local word_before = M.get_chars_before_cursor(1)
  if not word_before or word_before == " " then
    return rc.not_toggle
  end

  -- 在英文输入状态下，如果光标后为英文符号，则不切换成中文输入状态
  -- 例如：(abc|)
  local char_after = M.get_chars_after_cursor(1)
  if not M.global_rime_enabled() and char_after:match("[!-~]") then
    return rc.not_toggle
  end

  -- 最后一个字符为英文字符，数字或标点符号时，切换为中文输入法
  -- 否则切换为英文输入法
  if word_before:match "[%w%p]" then
    if not M.global_rime_enabled() then
      M.toggle_rime()
    end
    return rc.toggle_on
  else
    if M.global_rime_enabled() then
      M.toggle_rime()
    end
    return rc.toggle_off
  end
end

function M.create_inoremap_start_rime(key)
  vim.keymap.set("i", key, function()
    if not M.buf_rime_enabled() then
      M.toggle_rime("on")
    end
  end, {
    desc = "Start Chinese Input Method",
    noremap = true,
  })
end

function M.create_inoremap_stop_rime(key)
  vim.keymap.set("i", key, function()
    local cmp = require('cmp')
    if cmp.visible() then
      cmp.abort()
    end
    if M.buf_rime_enabled() then
      M.toggle_rime("off")
    end
  end, {
    desc = "Stop Chinese Input Method",
    noremap = true,
    expr = true,
  })
end

function M.leave_insert_mode()
  if M.global_rime_enabled() then
    vim.system(vim.g.lbs_input_method_inactivate, {text = true}, function(_) end)
  end
end

function M.enter_insert_mode()
  if M.buf_rime_enabled() and not M.global_rime_enabled() then
    vim.system(vim.g.lbs_input_method_activate):wait()
  elseif not M.buf_rime_enabled() and M.global_rime_enabled() then
    vim.system(vim.g.lbs_input_method_inactivate):wait()
  end
end

local cmp         = require "cmp"
local cmp_config  = require('cmp.config').get()
local cmp_keymaps = cmp_config.mapping
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode,
    false
  )
end

cmp_keymaps["<Space>"] = cmp.mapping(function(fallback)
  if not cmp.visible() then
    M.autotoggle_space()
    return fallback()
  end
  return fallback()
end, { "i", "s" })

cmp_keymaps["<BS>"] = cmp.mapping(function(fallback)
  if not cmp.visible() then
    local re = M.autotoggle_backspace()
    if re == 1 then
      cmp.abort()
      feedkey("<left>", "n")
    else
      fallback()
    end
  else
    fallback()
  end
end, { "i", "s" })

function M.setup()
  local grp = vim.api.nvim_create_augroup("LBS_InputMethod", {clear = true})
  vim.api.nvim_create_autocmd({"InsertLeavePre"}, {
    group = grp,
    callback = M.leave_insert_mode,
  })
  vim.api.nvim_create_autocmd({"InsertEnter", "BufEnter"}, {
    group = grp,
    callback = M.enter_insert_mode,
  })
  M.create_inoremap_start_rime(";f")
  M.create_inoremap_stop_rime(";;")
  cmp.setup { mapping = cmp.mapping.preset.insert(cmp_keymaps) }
end


return M;
