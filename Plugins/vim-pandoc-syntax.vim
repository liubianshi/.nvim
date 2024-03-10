let g:tex_conceal = "adgm"
let g:pandoc#syntax#codeblocks#embeds#langs = [
            \ "ruby",    "perl",       "r",
            \ "bash=sh", "stata",      "vim",
            \ "python",  "perl6=raku", "c"]
let g:pandoc#syntax#conceal#blacklist = []
let g:pandoc#syntax#conceal#cchar_overrides = {'titleblock': "*"}
