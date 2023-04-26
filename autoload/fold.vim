function! fold#GetRFold()
    if v:lnum == 1
        let b:lbs_foldlevels = fold#CalBufFoldLevel()
    endif

    let level = b:lbs_foldlevels[v:lnum - 1]
    if getline(v:lnum) =~? '\v\s*$' && b:lbs_foldlevels[v:lnum] < level
        let level = b:lbs_foldlevels[v:lnum] 
    endif

    if v:lnum == line('$')
        unlet b:lbs_foldlevels
    endif

    return level
endfunction

function! fold#CalBufFoldLevel()
    let right_bracket_regex = '\v^\s*[\}\]\)\"]'
    let levels              = []
    let current             = 0
    let last                = line('$')

    while current <= last
        let current += 1
        if <sid>Is_Fold_Start(current)
            let endline_num = <sid>ContainedLineNumber(current, right_bracket_regex)
            if endline_num >= 7
                call add(levels, <sid>IndentLevel(current) + 1)
                continue
            endif
        endif
        call add(levels, <sid>Cal_fold_level(current, levels, right_bracket_regex))
    endwhile

    return levels
endfunction

function! s:Is_Fold_Start(lnum)
    let content = getline(a:lnum)
    let foldstart = 0
    if content =~? '\v\<+\-'
        let foldstart = 1
    elseif content =~? '\v<switch\('
        let foldstart = 1
    elseif content =~? '\v(^|\<\-)\s*if\s*\('
        let foldstart = 1
    elseif content =~? '\v^\s*\w+[\(\[]'
        let foldstart = 1
    endif
    return foldstart
endfunction
    
function! s:Cal_fold_level(lnum, pre_line_levels, right_bracket_regex)
    let indent_level     = <sid>IndentLevel(a:lnum)
    let content          = getline(a:lnum)
    let is_right_bracket = (content =~? a:right_bracket_regex)
    let bline            = a:lnum - 1
    let bfoldlevel       = 0

    while bline >= 1
        let bfoldlevel = a:pre_line_levels[bline - 1]
        if bfoldlevel == 0
            return 0
        elseif content =~? '\v^\s*$'
            return bfoldlevel
        elseif content =~? '\v^\s*\{\s*$'
            return bfoldlevel
        elseif  bfoldlevel != 0  &&
                \ bfoldlevel != -1 &&
                \ bfoldlevel <= (indent_level + is_right_bracket)
            return bfoldlevel
        else
            let bline -= 1
        endif
    endwhile

    return 0
endfunction

function! s:IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! s:NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! s:ContainedLineNumber(lnum, regex)
    let numlines      = line('$')
    let current       = a:lnum + 1
    let contained_num = 0
    let indent_level  = <sid>IndentLevel(a:lnum)

    while current <= numlines
        let current_indent_level = <sid>IndentLevel(current)
        let content = getline(current)
        if  (current_indent_level > indent_level) ||
          \ (current_indent_level == indent_level && content =~? a:regex) ||
          \ (content =~? '\v^\s*$') ||
          \ (content =~? '\v^\s*\{\s*$')
            let contained_num += 1
            let current += 1
        else
            return contained_num 
        endif
    endwhile
        
    return contained_num
endfunction
