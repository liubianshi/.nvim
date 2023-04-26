function format#Markdown() 
  let firstline = v:lnum
  let lastline  = v:lnum + v:count - 1
  silent! execute firstline . "," . lastline . "Pangu"
  let contents = getline(firstline, lastline)
  let format_cmd = "prettier --tab-width " . shiftwidth() . " --parser markdown"
  let contents_new = systemlist(format_cmd, contents)
  silent! execute firstline . "," . lastline . "d"
  call append(firstline - 1, contents_new)
  return 0
endfunction
