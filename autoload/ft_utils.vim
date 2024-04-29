    wincmd H
    let s:buf_nr = bufnr('%')
  elseif bufwinnr(s:buf_nr) == -1
