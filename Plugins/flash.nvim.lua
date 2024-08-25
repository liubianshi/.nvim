local flash = require "flash"
flash.setup {
  style = "right_align",
  modes = {
    char = {
      enabled = true,
      keys = { "f", "F", "t", "T", [";"] = "|", "," },
      multi_line = false,
      jump_labels = true,
    },
    search = {
      enabled = false,
    },
  },
  jump = {
    autojump = true,
  }
}

-- to use this, make sure to set `opts.modes.char.enabled = false`
-- local Config = require "flash.config"
-- local Char = require "flash.plugins.char"
-- for _, motion in ipairs { "f", "t", "F", "T" } do
--   vim.keymap.set({ "n", "x", "o" }, motion, function()
--     require("flash").jump(Config.get({
--       mode = "char",
--       search = {
--         mode = Char.mode(motion),
--         max_length = 1,
--       },
--     }, Char.motions[motion]))
--   end)
-- end
