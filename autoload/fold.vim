" 辅助数据 -------------------------------------------------------------- {{{1
let s:titlePrefix = {
            \ 'r': '#',
            \ 'stata': '*',
            \ 'vim': '"',
            \ }
let s:endInfoFunName = {
            \ 'r': 's:R_GetFoldEndInfo',
            \ 'stata': 's:Stata_GetFoldEndInfo',
            \ 'vim': 's:Vim_GetFoldEndInfo',
            \ }

" 辅助函数 ============================================================== {{{1
function! s:CheckEndCondition(content, indent, condition_list) " -------- {{{2
    for cond in a:condition_list
        if a:content =~? cond.regex && a:indent <= cond.indent
            return cond.contain_end_line ? 1 : 0
        endif
    endfor
    return -2
endfunction

function! s:IndentLevel(lnum) " ----------------------------------------- {{{2
    return indent(a:lnum) / &shiftwidth
endfunction

function! s:GetEmbededFoldLevels(lnum, p_level = 0, num = 6) abort " ---- {{{2
    let endinfo      = call(s:endInfoFunName[&l:filetype], [a:lnum])
    if empty(endinfo) | return [] | endif

    let end_condition = endinfo.end_condition
    let current_level = a:p_level + 1
    let levels        = [ current_level ]
    let current       = a:lnum + 1
    let last          = line('$')

    while current <= last
        let c_content      = getline(current)
        let c_indent_level = <sid>IndentLevel(current)

        let c_end = <sid>CheckEndCondition(c_content, c_indent_level, end_condition)
        if c_end != -2  
            if c_end == 1 | call add(levels, current_level) | endif
            let current_level -= 1
            break
        endif

        let c_manual_level = s:GetManualFoldLevel(current, s:titlePrefix[&l:filetype])
        if c_manual_level > 0
            call add(levels, ">" . (a:p_level + c_manual_level + 1))
            let current_level = a:p_level + c_manual_level + 1
            let current += 1
            continue
        endif

        let embed_fold_levels =
            \ s:GetEmbededFoldLevels(current, current_level, a:num)
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

function! s:R_GetFoldEndInfo(lnum) " ------------------------------------- {{{2
    let content          = getline(a:lnum)
    let indent_level     = <sid>IndentLevel(a:lnum)
    let end_condition    = []

    if <sid>GetMarkerFoldLevel(a:lnum) == 0
        let syntax_name = "manual"
        let end_condition = [
                    \{ 'regex': '\v^\s*$', 
                    \  'indent': indent_level,
                    \  'contain_end_line': v:false },
                    \]
    elseif content =~? '\v<switch\('
        let syntax_name = "switch"
        let end_condition = [
                    \ { 'regex': '\V\^\s\*\[)\]}]',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ },
                    \ { 'regex': '\v\S',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:false,
                    \ },
                    \]
    elseif content =~? '\v^\s*[A-z$:.]+[([]'
        let syntax_name = 'function_call'
        let end_condition = [
                    \ { 'regex': '\V\^\s\*\[)\]}]',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ },
                    \ { 'regex': '\v\S',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:false,
                    \ }
                    \]
    elseif content =~? '\v\<+\-'
        let syntax_name = 'assign'
        let end_condition = [
                    \ { 'regex': '\V\^\s\*\[)\]}]',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ },
                    \ { 'regex': '\v\S',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:false,
                    \ }
                    \]
    elseif content =~? '\v\s*<(if \(|for \(|else).*\s+\{'
        let syntax_name = 'condtion'
        let end_condition = [
                    \ { 'regex': '\V\^\s\*}(\s+\#.*)?$',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ },
                    \ { 'regex': '\v\S',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:false,
                    \ },
                    \ ]
    elseif content =~? '\v(\%[A-z<]?\>\%|\|\>|\+)(\s+\#.*)?$'
        let syntax_name = 'pipe'
        let end_condition = [
                    \ { 'regex': '\v\S',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:false,
                    \ },
                    \]
    else
        return []
    endif
    return { 'syntax_name': syntax_name, 'end_condition': end_condition}
endfunction

function! s:Stata_GetFoldEndInfo(lnum) " -------------------------------- {{{2
    let content          = getline(a:lnum)
    let indent_level     = <sid>IndentLevel(a:lnum)
    let end_condition    = []
    if <sid>GetMarkerFoldLevel(a:lnum) == 0
        let syntax_name = "manual"
        let end_condition = [
                    \{ 'regex': '\v^\s*$', 
                    \  'indent': indent_level,
                    \  'contain_end_line': v:false },
                    \]
    elseif content =~? '\v\s*preserve>'
        let syntax_name = 'preserve'
        let end_condition = [
                    \ { 'regex': '\v\s*restore>',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ }
                    \ ]
    elseif content =~? '\v\s*snappreserve>'
        let syntax_name = "snap"
        let end_condition = [
                    \ { 'regex': '\v\s*snaprestore>',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ }
                    \ ]
    elseif content =~? '\v\s*program>'
        let syntax_name = "program"
        let end_condition = [
                    \ { 'regex': '\v\s*end>',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ }
                    \ ]
    elseif content =~? '\v\s*(if|else|quietly|noisi(ly)?|foreach|forvalue)>.*\{(\s+\/\/.*)?$'
        let syntax_name = "flow"
        let end_condition = [
                    \ { 'regex': '\v\s*\}',
                    \   'indent': indent_level,
                    \   'contain_end_line': v:true,
                    \ }
                    \ ]
    else
        return {}
    endif
    return { 'syntax_name': syntax_name, 'end_condition': end_condition}
endfunction

function! s:Vim_GetFoldEndInfo(lnum) abort " ---------------------------- {{{2
    let content          = getline(a:lnum)
    let indent_level     = <sid>IndentLevel(a:lnum)
    let end    = {
               \   'regex': "",
               \   'indent': indent_level,
               \   'contain_end_line': v:true,
               \ }

    if <sid>GetMarkerFoldLevel(a:lnum) == 0
        let syntax_name           =  "manual"
        let end.regex             =  '\v^\s*$'
        let end.contain_end_line  =  v:false
    elseif content =~? '\v^\s*function'
        let syntax_name           =  "function"
        let end.regex             =  '\v^\s*endfunc'
    elseif content =~? '\v^\s*if>' && content !~? '\|\s+endif(\s+\".*)?$'
        let syntax_name           =  "if"
        let end.regex             =  '\v^\s*endif>'
    elseif content =~? '\v^\s*for>' && content !~? '\v\|\s+endfor(\s+\".*)?$'
        let syntax_name           =  "for"
        let end.regex             =  '\v^\s*endfor>'
    elseif content =~? '\v^\s*while>' && content !~? '\v\|\s+endwhile(\s+\".*)?$'
        let syntax_name           =  "while"
        let end.regex             =  '\v^\s*endwhile>'
    elseif content =~? '\v^\s*augroup\s(END)@!'
        let syntax_name           = 'augroup'
        let end.regex             = '\v^\s*augroup\s(END)@='
    elseif content =~? '\v\s*\=\s*\{'
        let syntax_name = 'assign_dict'
        let end.regex = '\v^\s*[^\\ ]'
        let contain_end_line = v:false
    elseif content =~? '\v\s*\=\s*\['
        let syntax_name = 'assign_list'
        let end.regex = '\v^\s*[^\\ ]'
        let contain_end_line = v:false
    else
        return {}
    endif

    return { 'syntax_name': syntax_name, 'end_condition': [end]}
endfunction

" 折叠表达式 ============================================================ {{{1
function! fold#GetAllLineFoldLevels(num = 6) abort " -------------------- {{{2
    let current = 1
    let lastline = line('$')
    let current_level = 0
    let levels = []

    while current <= lastline
        let manual_level = <sid>GetManualFoldLevel(current, s:titlePrefix[&l:filetype])
        if manual_level > 0
            call add(levels, ">" . manual_level)
            let current_level = manual_level
            let current += 1
            continue
        endif

        let embed_fold_levels = s:GetEmbededFoldLevels(current, current_level, a:num)
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

function! fold#GetFold() " ----------------------------------- {{{2
    if v:lnum == 1
        let b:lbs_foldlevels = fold#GetAllLineFoldLevels(6)
    endif
    let fdl = b:lbs_foldlevels[v:lnum - 1]        
    if v:lnum == line('$')
        unlet b:lbs_foldlevels
    endif
    return fdl
endfunction

