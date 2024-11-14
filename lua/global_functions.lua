function _G.at_end_of_line()
  local mode = vim.fn.mode()
  local col = vim.fn.col('.')
  local line_end = vim.fn.col('$')
  if mode:find("^n") then
    return (col + 1 == line_end)
  elseif mode:find("^i") then
    return (col == line_end)
  else
    return false
  end
end

function _G.extract_hl_group_link(buf, row, col)
  local info = vim.inspect_pos(buf, row, col)
  local syntax = info.syntax
  local treesitter = info.treesitter
  local hl_group_links = {}

  for _, v in ipairs(syntax) do
    table.insert(hl_group_links, v.hl_group_link)
  end

  for _, v in ipairs(treesitter) do
    local hl = string.gsub(v.hl_group_link, "^@", "")
    table.insert(hl_group_links, hl)
  end

  return hl_group_links
end

function Set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", ";j", [[<C-\><C-n>]], opts)
  if vim.fn.has "mac" == 1 then
    vim.keymap.set("t", "<c-space>", [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<M-w>',     [[<C-\><C-n><C-w>]],   opts)
  else
    vim.keymap.set("t", "<A-space>", [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<A-w>',     [[<C-\><C-n><C-w>]],   opts)
  end
  vim.keymap.set('t', '<C-/>h',     [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-/>j',     [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-/>k',     [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-/>l',     [[<Cmd>wincmd l<CR>]], opts)
end

function _G.BufIsBig(bufnr)
  bufnr = bufnr or 0
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

function _G.utf8_codepoint(str, pos)
  pos = pos or 1
  local byte = string.byte
  local b1 = byte(str, pos)

  -- 检查 UTF-8 字符的第一个字节，确定字符字节数
  if b1 >= 0 and b1 <= 127 then
    -- 1 字节字符 (ASCII)
    return b1, pos + 1
  elseif b1 >= 192 and b1 <= 223 then
    -- 2 字节字符
    local b2 = byte(str, pos + 1)
    return ((b1 - 192) * 64) + (b2 - 128), pos + 2
  elseif b1 >= 224 and b1 <= 239 then
    -- 3 字节字符
    local b2, b3 = byte(str, pos + 1), byte(str, pos + 2)
    return ((b1 - 224) * 4096) + ((b2 - 128) * 64) + (b3 - 128), pos + 3
  elseif b1 >= 240 and b1 <= 247 then
    -- 4 字节字符
    local b2, b3, b4 = byte(str, pos + 1), byte(str, pos + 2), byte(str, pos + 3)
    return ((b1 - 240) * 262144) + ((b2 - 128) * 4096) + ((b3 - 128) * 64) + (b4 - 128), pos + 4
  end
end

function _G.is_cjk_character(char)
  -- 获取字符的 Unicode 码点
  local code = utf8_codepoint(char)

  -- 检查并分类 CJK 字符
  if code >= 0x4E00 and code <= 0x9FFF then
      return true, "基本汉字 (CJK Unified Ideographs)"
  elseif code >= 0x3400 and code <= 0x4DBF then
      return true, "扩展汉字 A 区 (CJK Unified Ideographs Extension A)"
  elseif code >= 0x20000 and code <= 0x2A6DF then
      return true, "扩展汉字 B 区 (CJK Unified Ideographs Extension B)"
  elseif code >= 0x2A700 and code <= 0x2B73F then
      return true, "扩展汉字 C 区 (CJK Unified Ideographs Extension C)"
  elseif code >= 0x2B740 and code <= 0x2B81F then
      return true, "扩展汉字 D 区 (CJK Unified Ideographs Extension D)"
  elseif code >= 0x2B820 and code <= 0x2CEAF then
      return true, "扩展汉字 E 区 (CJK Unified Ideographs Extension E)"
  elseif code >= 0x2CEB0 and code <= 0x2EBEF then
      return true, "扩展汉字 F 区 (CJK Unified Ideographs Extension F)"
  elseif code >= 0x30000 and code <= 0x3134F then
      return true, "扩展汉字 G 区 (CJK Unified Ideographs Extension G)"
  elseif code >= 0xF900 and code <= 0xFAFF then
      return true, "兼容汉字 (CJK Compatibility Ideographs)"
  elseif code >= 0x2F00 and code <= 0x2FDF then
      return true, "汉字部首 (Kangxi Radicals)"
  elseif code >= 0x31C0 and code <= 0x31EF then
      return true, "汉字部件补充 (CJK Strokes)"
  elseif code >= 0x3100 and code <= 0x312F then
      return true, "注音符号 (Bopomofo)"
  elseif code >= 0x3040 and code <= 0x309F then
      return true, "平假名 (Hiragana)"
  elseif code >= 0x30A0 and code <= 0x30FF then
      return true, "片假名 (Katakana)"
  else
      return false, "非 CJK 字符"
  end
end




