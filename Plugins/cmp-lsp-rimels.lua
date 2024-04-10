local detector_for_norg = function(info)
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

require('rimels').setup({
    keys = { start = ";f", stop = ";;", esc = ";j" },
    cmd = { vim.env.HOME .. "/.local/bin/rime_ls" },
    rime_user_dir = "~/.local/share/rime-ls",
    shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport",
    detectors = {
        with_treesitter = {
            norg = detector_for_norg,
        }
    }
})


