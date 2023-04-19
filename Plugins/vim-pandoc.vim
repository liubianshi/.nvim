let g:pandoc#modules#disabled = ["spell"]
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 1
let g:pandoc#biblio#bibs = ["~/Documents/paper_ref.bib"]
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#completion#bib#mode = "citeproc"
let g:pandoc#biblio#sources = ["bycg"]
let g:pandoc#folding#fdc = 1
let g:pandoc#folding#level = 2
let g:pandoc#folding#fold_yaml = 1
let g:pandoc#folding#fastfolds = 1
let g:pandoc#folding#fold_fenced_codeblocks = 0
let g:tex_conceal = "adgm"
let g:pandoc#syntax#codeblocks#embeds#langs = ["ruby", "perl", "r", "bash=sh", "stata"]
