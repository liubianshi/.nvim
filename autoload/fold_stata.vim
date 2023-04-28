" 辅助函数 ============================================================== {{{1
function! s:IndentLevel(lnum) " ----------------------------------------- {{{2
    return indent(a:lnum) / &shiftwidth
endfunction

function! s:GetManualFoldLevel(lnum, title_prefix) " -------------------- {{{2
    let marker_level = <sid>GetMarkerFoldLevel(a:lnum)
    if marker_level > 0
        return marker_level
    endif

    let title_level = <sid>GetTitleLevel(a:lnum, a:title_prefix)
    if title_level > 0
        return title_level
    endif

    return -2
endfunction

function! s:GetTitleLevel(lnum, prefix = '*') " ------------------------- {{{2
    let content = getline(a:lnum)
    let prefix_length = strlen(a:prefix)
    let regex_title = '\V\^\s\*\zs'
            \ . '\('.a:prefix.'\)\+' . '\s\+'
            \ . '\(\d\+.\)\+\d\*' . '\ze\s\+'

    let prefix_number = matchstr(content, regex_title)
    if prefix_number == ""
        return -2
    endif

    let prefix_symbol = matchstr(prefix_number, '\V\(' . a:prefix . '\)\+')
    let prefix_num    = strlen(prefix_symbol) / prefix_length

    let title_number  = matchstr(prefix_number, '\v(\d+\.)+\d*')
    let title_level   = len(split(title_number, '\.'))

    return (title_level + prefix_num - 1)
endfunction

function! s:GetMarkerFoldLevel(lnum) " ---------------------------------- {{{2
    let content         = getline(a:lnum)
    let marker          = split(&l:foldmarker, ",")[0]
    let search_regex    = '\V' . marker . '\zs\d\*'
    let marker_position = match(content, search_regex)
    if marker_position == -1
        return -2
    endif  

    let marker_on_comment = match(
        \ v:lua.extract_hl_group_link(0, a:lnum - 1, marker_position - 1),
        \ '\vComment|Special'
        \ )
    if marker_on_comment == -1 
        return -2
    endif
    
    let marker_level = matchstr(content, search_regex)
    if strlen(marker_level) == ""
        let marker_level = 0
    endif

    return marker_level
endfunction

" Stata Fold ============================================================ {{{1
function! s:Stata_GetFoldEndInfo(lnum) " -------------------------------- {{{2
    let content          = getline(a:lnum)
    let indent_level     = <sid>IndentLevel(a:lnum)
    let contain_end_line = 1
    let regex_end        = -2
    let syntax_name      = ""

    if <sid>GetMarkerFoldLevel(a:lnum) == 0
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

function! s:Stata_GetEmbedFoldLevels(lnum, p_level = 0, num = 6) " ------- {{{2
    let endinfo = <sid>Stata_GetFoldEndInfo(a:lnum)
    if  endinfo.syntax_name == ""
        return []
    endif

    let current_level = a:p_level + 1
    let levels        = [ current_level ]
    let current       = a:lnum + 1
    let last          = line('$')
    let title_prefix  = '*'

    while current <= last
        let c_content      = getline(current)
        let c_indent_level = <sid>IndentLevel(current)

        if c_content      =~? endinfo.regex_end    &&
        \  c_indent_level ==  endinfo.indent_level
            if endinfo.contain_end_line != 0
                call add(levels, current_level)
            endif
            let current_level -= 1
            break
        endif

        let c_manual_level = <sid>GetManualFoldLevel(current, title_prefix)
        if c_manual_level > 0
            call add(levels, ">" . (a:p_level + c_manual_level + 1))
            let current_level = a:p_level + c_manual_level + 1
            let current += 1
            continue
        endif

        let embed_fold_levels =
            \ <sid>Stata_GetEmbedFoldLevels(current, current_level, a:num)
        if len(embed_fold_levels) > 0
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

function! s:GetAllLineFoldLevels(num = 6) " -------------------- {{{2
    let current = 1
    let lastline = line('$')
    let current_level = 0
    let levels = []
    let title_prefix = '*'

    while current <= lastline
        let manual_level = <sid>GetManualFoldLevel(current, title_prefix)
        if manual_level > 0
            call add(levels, ">" . manual_level)
            let current_level = manual_level
            let current += 1
            continue
        endif

        let embed_fold_levels = <sid>Stata_GetEmbedFoldLevels(
            \ current, current_level, a:num
            \ )
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

function! fold_stata#GetStataFold() " ----------------------------------- {{{2
    if v:lnum == 1
        let b:lbs_foldlevels = <sid>GetAllLineFoldLevels(6)
    endif
    let fdl = b:lbs_foldlevels[v:lnum - 1]        
    if v:lnum == line('$')
        unlet b:lbs_foldlevels
    endif
    return fdl
endfunction




