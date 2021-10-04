augroup PersonalTargets
    autocmd!
    autocmd filetype stata call targets#mappings#extend({'`': {},}) 
    autocmd filetype stata call targets#mappings#extend({'`': {'pair': [{'o':'`', 'c':"'"}]} })
augroup END


