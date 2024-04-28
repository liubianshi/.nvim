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
    always_incomplete = false,
    detectors = {
        with_treesitter = {
            norg = detector_for_norg,
        }
    },
    cmp_keymaps = {
      disable = {
        numbers = false,
        space = false,
      }
    }
})

vim.api.nvim_create_user_command("RimeDeleteLockFile", function()
  local rime_user_dir = require('rimels').opts.rime_user_dir
  rime_user_dir = vim.fn.expand(rime_user_dir)
  vim.loop.fs_unlink(rime_user_dir .. "/rime_ice.userdb/LOCK")
end, { nargs = 0, desc = "Delete Lock file of Rime"})

