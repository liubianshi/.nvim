local m_header = {
  style = "padded_icon",
  line_hl = "markview_h1",
  sign = "",
  sign_hl = "rainbow1",
  icon_width = 1,
}
local m_code_block = {}
local m_inline_code = {}
local m_block_quote = {}
local m_horizontal_rule = {}
local m_hyperlink = {}
local m_image = {}
local m_table = {}
local m_list_item = {}
local m_checkbox = {}

require("markview").setup {
  header          = m_header,
  code_block      = m_code_block,
  inline_code     = m_inline_code,
  block_quote     = m_block_quote,
  horizontal_rule = m_horizontal_rule,
  hyperlink       = m_hyperlink,
  image           = m_image,
  table           = m_table,
  list_item       = m_list_item,
  checkbox        = m_checkbox,
}

