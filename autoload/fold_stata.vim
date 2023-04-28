function! fold_stata#GetStataFold()
    if v:lnum == 1
        let b:lbs_foldlevels = fold_stata#GetAllLineFoldLevels()
    endif
    let fdl = b:lbs_foldlevels[v:lnum - 1]        
    if v:lnum == line('$')
        unlet b:lbs_foldlevels
    endif
    return fdl
endfunction

function! fold_stata#GetAllLineFoldLevels(num = 6)
    let current = 1
    let lastline = line('$')
    let current_level = 0
    let levels = []

    while current <= lastline
        let manual_level = <sid>GetManualFoldLevel(current)
        if manual_level > 0
            call add(levels, ">" . manual_level)
            let current_level = manual_level
            let current += 1
            continue
        endif

        let embed_fold_levels = fold_stata#Cal_Fold_Level(
            \ current,
            \ <sid>Get_Fold_End_Info(current), current_level, a:num)
        if len(embed_fold_levels) > 0
            call extend(levels, embed_fold_levels)
            let current += len(embed_fold_levels)
            continue
        endif

        call add(levels, current_level)
        let current += 1
    endwhile
    return levels
endfunction


function! fold_stata#Cal_Fold_Level(lnum, endinfo, master_level = 0, num = 6)
    if a:endinfo.syntax_name == ""
        return []
    endif

    let current_level = a:master_level + 1
    let levels        = [current_level]
    let current       = a:lnum + 1
    let last          = line('$')
    while current <= last
        let c_content      = getline(current)
        let c_indent_level = <sid>IndentLevel(current)

        if c_content      =~? a:endinfo.regex_end    &&
        \  c_indent_level ==  a:endinfo.indent_level
            if a:endinfo.contain_end_line != 0
                call add(levels, current_level)
            endif
            let current_level -= 1
            break
        endif

        let c_manual_level = <sid>GetManualFoldLevel(current)
        if c_manual_level > 0
            call add(levels, ">" . (a:master_level + c_manual_level + 1))
            let current_level = a:master_level + c_manual_level + 1
            let current += 1
            continue
        endif

        let c_endinfo = <sid>Get_Fold_End_Info(current) 
        if c_endinfo.syntax_name != ""
            let embed_fold_levels =
                \ fold_stata#Cal_Fold_Level(current, c_endinfo, current_level)
            call extend(levels, embed_fold_levels)
            let current += len(embed_fold_levels)
            continue
        endif

        call add(levels, current_level)
        let current += 1
    endwhile

    if len(levels) < a:num
        call map(levels, {_, val -> val - 1})
    else
        let levels[0] = ">" . levels[0]
    endif
    return levels
endfunction


function! fold_stata#Stata_CalBufFoldLevel()
    let last = line('$')
    let linenum = 7
    let marker_levels = map(
        \ range(1, last),
        \ {_, val -> fold_stata#FoldMarkerLevel(val)}
        \ )
    let title_levels = map(range(1, last),  {_, val -> fold_stata#TitleLevel(getline(val), '*')}  )
    let indent_levels = map(
        \ range(1, last),
        \ {_, val -> <sid>IndentLevel(val)}
        \ )
    let syntax_pair = {
        \ 'preserve': ['\v^\s*preserve', '\v^\s*restore', -2],
        \ 'program':  ['\v^\s*program', '\v^\s*end', -2],
        \ 'braket':   ['\v^\s*(if|else|else if|forvalue|foreach).*\{(\s+\/\/.*)?$', '\v^\s*\}', -2]
        \ }
    let levels = []
    let current = 1
    let current_level = 0
    let markfold_start = -2 

    for current in range(1, last)
        let manual_level = -1 
        if marker_levels[current-1] != -1
            let manual_level = marker_levels[current-1]
        elseif title_levels[current-1] != -1
            let manual_level = title_levels[current-1] 
        endif

        if manual_level > -1
            call add(levels, ">" . manual_level)
            let current_level = manual_level
            continue
        endif

        if manual_level == 0
            call add(levels, ">" . (current_level + 1))
            let markfold_start = 1
            let current_level += 1
            continue
        endif
        if getline(current) =~? '\v^\s*$'
            call add(levels, -1)
            if markfold_start == 1
                let markfold_start = -2
                let current_level -= 1
            endif
            continue
        endif
        
        let content = getline(current)
        let indent_level = <sid>IndentLevel(current)
        let special_line = -2
        for pair_name in keys(syntax_pair)
            let regex_s = syntax_pair[pair_name][0]
            let regex_e = syntax_pair[pair_name][1]
            let status  = syntax_pair[pair_name][2]
            if fold_stata#Is_Fold_Start(current, regex_s, regex_e)
                call add(levels, ">" . (current_level + 1))
                let current_level += 1
                let syntax_pair[pair_name][2] = indent_level
                let special_line = 1
                break
            elseif content =~? regex_e
                let special_line = 1
                call add(levels, current_level)
                if indent_level == status
                    let current_level -= 1
                    let syntax_pair[pair_name][2] = -12
                endif
                let special_line = 1
                break
            endif
        endfor
        if special_line == -2
            call add(levels, current_level)
        endif
    endfor

    return levels
endfunction

function! s:GetManualFoldLevel(lnum)
    let c_marker_level = fold_stata#FoldMarkerLevel(a:lnum)
    if c_marker_level > 0
        return c_marker_level
    endif
    let c_title_level = fold_stata#TitleLevel(getline(a:lnum), '*')
    if c_title_level > 0
        return c_title_level
    endif
    return -2
endfunction

function! s:Get_Fold_End_Info(lnum)
    let content = getline(a:lnum)
    let indent_level = <sid>IndentLevel(a:lnum)
    let contain_end_line = 1
    let regex_end = -2
    let syntax_name = ""
    if fold_stata#FoldMarkerLevel(a:lnum) == 0
        let syntax_name = "manual"
        let regex_end = '\v\s*$'
        let contain_end_line = 0
    elseif content =~? '\v\s*preserve>'
        let syntax_name = "preserve"
        let regex_end = '\v\s*restore>'
    elseif content =~? '\v\s*snappreserve>'
        let syntax_name = "snap"
        let regex_end = '\v\s*snaprestore>'
    elseif content =~? '\v\s*program>'
        let syntax_name = "program"
        let regex_end =  '\v\s*end>'
    elseif content =~? '\v\s*(if|else|quietly|noisi(ly)?|foreach|forvalue)>.*\{(\s+\/\/.*)?$'
        let syntax_name = "flow"
        let regex_end = '\v\s*\}'
    endif
    return { 
         \   'syntax_name':      syntax_name,
         \   'regex_end':        regex_end,
         \   'indent_level':     indent_level,
         \   'contain_end_line': contain_end_line,
         \ }
endfunction

function! fold_stata#TitleLevel(str, prefix = '*')
    let str_regex = '\V\^\s\*\zs'
            \ . '\('.a:prefix.'\+\)'. '\s\+'
            \ . '\(\%(\d\+.\)\+\d\*\)' . '\ze\s\+'
    let str = matchstr(a:str, str_regex)
    if str == ""
        return -1
    endif
    let prefix_num = strlen(matchstr(str, '\V' . a:prefix . '\+'))
    let number_num = len(split(matchstr(str, '\v(\d+\.)+\d*'), '\.'))
    return number_num + prefix_num - 1
endfunction

function! fold_stata#FoldMarkerLevel(lnum)
    let str = getline(a:lnum)
    let marker = split(&l:foldmarker, ",")[0]
    let search_regex = '\V' . marker . '\zs\d\*'
    let marker_position = match(str, search_regex)
    if marker_position == -1
        return -1
    endif  

    let marker_on_comment = match(
        \ v:lua.extract_hl_group_link(0, a:lnum - 1, marker_position - 1),
        \ '\vComment|Special'
        \ )
    if marker_on_comment == -1 
        return -1
    endif
    
    let marker_level = matchstr(str, search_regex)
    if strlen(marker_level) == ""
        let marker_level = 0
    endif

    return marker_level
endfunction

function! s:IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! fold_stata#ContainedLineNumber(lnum, regex)
    let numlines      = line('$')
    let current       = a:lnum + 1
    let contained_num = 0
    let indent_level  = <sid>IndentLevel(a:lnum)

    while current <= numlines
        let contained_num += 1
        let current_indent_level = <sid>IndentLevel(current)
        let content = getline(current)

        if content =~? a:regex && indent_level == current_indent_level
            break
        endif

        let current += 1
    endwhile

    return contained_num
endfunction

function! fold_stata#Is_Fold_Start(lnum, start_regex, end_regex, num = 7)
    if getline(a:lnum) =~? a:start_regex &&
    \  fold_stata#ContainedLineNumber(a:lnum, a:end_regex) >= a:num
        return 1
    else
        return 0
    endif
endfunction

