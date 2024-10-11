local M = {};

M.detectors = {with_treesitter = {}, with_syntax = {}}
function M.detectors.with_treesitter.norg(info)
  info = info or vim.inspect_pos()
  local trees = info.treesitter
  local extmarks = info.extmarks
  local englist_env = false
  for _, ts in ipairs(trees) do
    if
      ts.capture == "neorg.markup.variable" or
      ts.capture == "neorg.markup.verbatim" or
      ts.capture == "neorg.markup.inline_math"
    then
      return true
    elseif ts.capture == "comment" then
      return false
    end
  end
  for _,ext in ipairs(extmarks) do
    if
      ext.opts and
      ext.opts.hl_group == "@neorg.tags.ranged_verbatim.code_block"
    then
      return true
    end
  end
  return englist_env
end

function M.detectors.with_treesitter.markdown(info)
  info = info or vim.inspect_pos()
  local trees = info.treesitter
  local englist_env = false
  for _, ts in ipairs(trees) do
    if
      ts.capture == "markup.math" or
      ts.capture == "markup.raw"
    then
      return true
    elseif ts.capture == "markup.raw.block" then
      englist_env = true
    elseif ts.capture == "comment" then
      return false
    end
  end
  return englist_env
end

function M.detectors.with_syntax.markdown(info)
  info = info or vim.inspect_pos()
  local syns = info.syntax
  local englist_env = false
  for _, syn in ipairs(syns) do
    local hl = syn.hl_group
    local hl_link = syn.hl_group_link
    if
      hl == "pandocLaTeXInlineMath" or
      hl == "pandocNoFormatted" or
      hl == "pandocOperator" or
      hl == "pandocLaTeXMathBlock"
    then
      return true
    elseif hl == "pandocDelimitedCodeBlock" then
      englist_env = true
    elseif hl_link == "Comment" then
      return false
    end
  end
  return englist_env
end

function M.in_english_environment()
  local detect_english_env = M.detectors
  local info = vim.inspect_pos()
  local filetype = vim.api.nvim_get_option_value("filetype", {scope = "local"})

  if not filetype or filetype == "" then
    return false
  end

  if
    detect_english_env.with_treesitter[filetype] and
    detect_english_env.with_treesitter[filetype](info)
  then
    return true
  end

  if
    detect_english_env.with_syntax[filetype] and
    detect_english_env.with_syntax[filetype](info)
  then
    return true
  end

  return false
end

return M
