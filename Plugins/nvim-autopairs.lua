require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt" },
    disable_in_macro = true,  -- disable when recording or executing a macro
    disable_in_visualblock = true, -- disable when insert after visual block mode
  disable_in_replace_mode = true,
    ignored_next_char = [=[[%w%%%'%[%"%.]]=],
    enable_moveright = true,
    enable_afterquote = true,  -- add bracket pairs after quote
    enable_check_bracket_line = true,  --- check bracket in same line
    enable_bracket_in_quote = true, --
    check_ts = false,
    map_cr = true,
    map_bs = true,  -- map the <BS> key
    map_c_h = false,  -- Map the <C-h> key to delete a pair
    map_c_w = false, -- map <c-w> to delete a pair if possible
})
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
npairs.add_rules({
  Rule("`", "`", "-stata"),
  --TODO:nvim 的补全似乎有点问题，即会将光标后面的字符也纳入考虑
  Rule("[", "]", "markdown"):replace_endpair(function(opts)
    if require('util').in_obsidian_vault(opts.bufnr) then
      return ""
    else
      return "]"
    end
  end),
  Rule('"', '"', "-vim"),
  Rule("`", "'", "stata"),
  Rule("$", "$", "markdown"),
})

