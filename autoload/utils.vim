" Display an error message. ============================================== {{{1
function! utils#Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Get content between =================================================== {{{1
function! utils#GetContentBetween(left, right)
    let col = col('.')
    let line = getline('.')

    let num = col - 1
    let inpair = 0
    while num >= 0
        if line[num] == a:left
            if inpair == 0 | break | endif
            let inpair -= 1
        elseif line[num] == a:right
            let inpair += 1
        endif
        let num -= 1
    endwhile
    if num == -1 | return "" | end
    if num == col - 1
        let lcontent = ""
    else
        let lcontent = line[num+1:col-1]
    endif

    let num = col
    let inpair = 0
    while num <= col('$') - 2
        if line[num] == a:right
            if inpair == 0 | break | endif
            let inpair -= 1
        elseif line[num] == a:left
            let inpair += 1
        endif
        let num += 1
    endwhile
    if num == col('$') - 1 | return "" | end
    if num == col
        let rcontent = ""
    else
        let rcontent = line[col:num-1]
    endif
    return lcontent . rcontent
endfunction


" Extract all urls ====================================================== {{{1
function! utils#Fetch_urls(update = "")
    if has_key(b:, "fetched_urls") && a:update !=? "update"
        return b:fetched_urls
    endif

    let fn = expand('%')
    let uniq_from_perl = "perl -nle '$c{$_} //= $. } { print join q/\n/, (sort {$c{$a} <=> $c{$b}} keys %c)'"
    if fn == ""
        let urls = system("xurls | " . uniq_from_perl, getline(1, '$'))
    else
        let urls = system("xurls " . shellescape(fn) . " | " . uniq_from_perl)
    endif
    let b:fetched_urls = split(urls, '\n', 0)
    return b:fetched_urls
endfunction

" Open url ============================================================== {{{1
function! utils#OpenUrl(url, in = "", type = "")
    if type(a:url) == v:t_dict
        if len(a:url) == 0 | return | endif
        let url = a:url['url']
        let type = a:url['type']
    else
        if a:url == "" | return | endif
        let url = a:url
        let type = a:type
    endif

    if url !~ '\v^(http|(\w+\.)+)' | return | end
    let command = "linkhandler " . (type ==# "image" ? "-t image " : "")
    if a:in ==# "in"
        let image_path = system(command . "-V " . "'".url."'")
        echom image_path
        try
            DeleteImage
            catch /Not an editor command/
        endtry
        exec "PreviewImage infile " . image_path
    else
        Lazy! load asyncrun.vim
        call asyncrun#run("", {'silent': 1, 'pos': 'hide'}, command . "'".url."'" )
    endif
endfunction


" math equation preview ================================================== {{{1
function! utils#Math_Preview() range
    return
endfunction

" 在末尾添加符号 ======================================================== {{{1
function! utils#AddDash(symbol, line = "") abort
    if a:line == ""
        substitute/\s*$//g
        let lo = getline('.')
    else
        let lo = a:line
    endif

    " when the line is empty, keep the number of symbol euqal to {{{2
    " display width of previous line, and keep the indentation 
    if lo =~ '^\s*$'
        let lo_pre      = getline(line('.') - 1)
        let space_pre   = substitute(lo_pre, '\v^(\s*)(.*)$', '\1', 'g')
        let content_pre = substitute(lo_pre, '\v^(\s*)(.*)$', '\2', 'g')
        let length_pre  = strdisplaywidth(content_pre)
        call setline('.', space_pre . repeat(a:symbol, length_pre))
        return
    endif

    let w = &l:textwidth == 0 ? 78 : &l:textwidth
    if &l:foldmarker =~ '\V' . lo[-4:-2]
        let le = " " . lo[-4:-1] 
        let lo = lo[0:-5]
    elseif &l:foldmarker =~ '\V' . lo[-3:-1] 
        let le = " " . lo[-3:-1] 
        let lo = lo[0:-4]
    else
        let le = ""
    endif
    let lo = substitute(lo, '\V\(' . a:symbol . '\| \)\*\$', "", 'g')
    let conl = strdisplaywidth(lo)
    if conl >= w
        return
    endif
    let l = (w - conl) / strlen(a:symbol) - 6
    let add = repeat(a:symbol, l)
    call setline('.', lo . " " . add . le)
endfunction

" 在末尾添加 comment symbol 和 folder marker ============================ {{{1
function! utils#AddFoldMark(symbol) abort
    let comment = split(&commentstring, '%s')
    let comment_start = " " . comment[0]
    if len(comment) == 1
        let comment_end = ""
    else
        let comment_end = " " . comment[1]
    endif
    let fold_symbol = split(&foldmarker, ',')[0] . foldlevel(".")

    let line = getline('.')  . comment_start  . fold_symbol . comment_end
    call utils#AddDash(a:symbol, line)
endfunction


" 代码格式化 ============================================================= {{{1
function! utils#RFormat() range
    if g:rplugin.nvimcom_port == 0
        return
    endif
    let lns = getline(a:firstline, a:lastline)
    call writefile(lns, g:rplugin.tmpdir . "/unformatted_code")
    call AddForDeletion(g:rplugin.tmpdir . "/unformatted_code")
    let cmd = "styler::style_text(readLines(\"" . g:rplugin.tmpdir . "/unformatted_code\"), transformers = styler::tidyverse_style(strict = FALSE, indent_by = 4))"
    silent exe a:firstline . "," . a:lastline . "delete"
    silent exe ':normal k' 
    call RInsert(cmd, "here") 
endfunction

" insert org-mode roam node ============================================= {{{1
function! utils#RoamInsertNode(title, method = "")
    let external_command = 'org-mode-roam-node "' . a:title . '"'
    let @* = a:title
    let ori = @0
    let line = getline(line('.'))
    let pos = col('.') - 1
    let @0 = substitute(system(external_command), "\n$", "", "g")
    if pos != 0 && line[pos - 1:pos - 1] != " "
        let @0 = " " . @0
    end
    if line[pos:pos] != " " && line[pos:pos] != ""
        let @0 = @0 . " "
    end
    exec "normal! i\<c-r>0\<esc>2h"
    let @0 = ori
    if a:method !=? ""
        call utils#RoamOpenNode(a:method)
    endif
endfunction

" open org-roam node under cursor ======================================= {{{1
function! utils#RoamOpenNode(method = "edit")
    let ori = @0
    let line = getline(line('.'))
    let pos = col('.') - 1
    if line[pos:pos+1] == "[[" || line[pos-1:pos] == "]]"
        normal! "0yi[
    elseif line[pos-1:pos] == "[["
        normal! h"0yi[
    elseif line[pos:pos+1] == "]]"
        normal! l"0yi[
    elseif line[pos:pos+1] == "][" || line[pos-1:pos] == "]["
        normal! f]l"0yi[
    elseif line[0:pos] =~? '\[\[[^\]]\+$'
        normal! F[h"0yi[
    elseif line[pos+1:] =~? '^[^\]]\+\]\]'
        normal! f]l"0yi[
    else
        return
    endif

    let filepath = system("org-mode-roam-node -j " . shellescape(@0))
    exec a:method . " " . filepath
endfunction

" insert rmd-style picture =============================================== {{{1
function! utils#RmdClipBoardImage()
    execute "normal! i```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
    call mdip#MarkdownClipboardImage()
    execute "normal! \<esc>g_\"iyi)VCknitr::include_graphics(\"\")\<esc>F\"\"iPo```\n" 
endfunction

" RmarkdownPasteImage for md-img-paste
function! utils#RmarkdownPasteImage(relpath)
    execute "normal! i```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n" .
          \ "knitr::include_graphics(\"" . a:relpath . "\")\r" .
          \ "```\n"
endfunction

" insert org-mode style image =========================================== {{{1
function! utils#OrgModeClipBoardImage()
    call mdip#MarkdownClipboardImage()
    s/\v!\[([^]]*)]\(([^)]+)\)/[[\2][\1]]/
endfunction

" 选择光标下文字 Super useful! From an idea by Michael Naumann =========== {{{1
function! utils#VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" quickfix managing ====================================================== {{{1
function! utils#QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" shift specific line =================================================== {{{1
function! utils#ShiftLine(lnum, col)
    let line_content = substitute(getline(a:lnum), '^\s*', "" , "")
    if ! &l:expandtab
        let tab_num = a:col / shiftwidth()
        let left_space_num -= tab_num * shiftwidth() 
        let prefix_space = repeat("\t", tab_num) . repeat(" ", let_space_num)
    else
        let prefix_space = repeat(" ", a:col)
    endif
    call setline(a:lnum, prefix_space . line_content)
    call cursor(a:lnum, a:col + 1)
endfunction

" move the cusror to align with the specific string of previous line ==== {{{1
function! utils#MoveCursorTo(...)
    let previous_line = getline(line('.') - 1)
    if a:0 == 0
        let symbol = input("The target string: ")
    else
        let symbol = a:1
    endif
    if symbol == ""
        let space_num = match(previous_line, '\S')
    else 
        let space_num = stridx(previous_line, symbol)
    endif
    call utils#ShiftLine(line('.'), space_num)
endfunction

" Zen {{{1 
function! s:zenmodeinsert() abort
    let ww = winwidth(0)
    let b:zen_oriwin = { 'zenmode': 1,
                       \ 'foldcolumn': &foldcolumn,
                       \ 'number': &number,
                       \ 'relativenumber': &relativenumber,
                       \ 'foldenable': &foldenable,
                       \ 'laststatus': &laststatus,
                       \ }
    setlocal nonumber
    setlocal norelativenumber
    setlocal nofoldenable
    set laststatus=0
    set noshowcmd
    if ww < 81
        setlocal foldcolumn=1
    elseif ww < 85
        setlocal foldcolumn=2
    elseif ww < 90
        setlocal foldcolumn=4
    else
        setlocal foldcolumn=8
    endif
endfunction
function! s:zenmodeleave() abort
    set noshowcmd
    if !exists('b:zen_oriwin')
        return
    endif
    for attr in keys(b:zen_oriwin)
        if attr ==# 'zenmode'
            let b:zen_oriwin[attr] = 0
        elseif attr ==# 'foldcolumn' || attr ==# 'laststatus'
            exec 'setlocal ' . attr . "=" . b:zen_oriwin[attr]
        elseif b:zen_oriwin[attr] == 1
            exec 'setlocal ' . attr
        endif
    endfor
endfunction
function! utils#ToggleZenMode() abort
    if ! exists('b:zen_oriwin') || b:zen_oriwin['zenmode'] == 0
        call <SID>zenmodeinsert()
    else
        call <SID>zenmodeleave()
    endif
endfunction

" R 语言函数定义 ========================================================= {{{1
function! utils#R_view_df(dfname, row, method, max_width)
    let fname = "/tmp/r_obj_preview_data.tsv"
    call g:SendCmdToR('fViewDFonVim("' . a:dfname . '", ' . a:row . ', "' . a:method . '", ' . a:max_width . ', "' . fname . '")')
    sleep 100m
    call utils#Preview_data(fname, "r_obj_preview_bufnr")
endfunction
function! utils#R_view_df_sample(method)
    let dfname = @"
    let row = 40
    let max_width = 30
    return utils#R_view_df(dfname, row, a:method, max_width)
endfunction
function! utils#R_view_df_full(max_width)
    let dfname = @"
    let row = 0 
    let method = 'ht'
    return utils#R_view_df(dfname, row, method, a:max_width)
endfunction
function! utils#R_view_srdm_table()
    let dfname = "srdm_tables"
    let row = 0 
    let method = 'ht'
    let max_width = 40
    return utils#R_view_df(dfname, row, method, max_width)
endfunction
function! utils#R_view_srdm_var()
    let dfname = "srdm_vars"
    let row = 0 
    let method = 'ht'
    let max_width = 40
    return utils#R_view_df(dfname, row, method, max_width)
endfunction

" Stata dolines ========================================================== {{{1
function! utils#RunDoLines()
    let selectedLines = getbufline('%', line("'<"), line("'>"))
    if col("'>") < strlen(getline(line("'>")))
        let selectedLines[-1] = strpart(selectedLines[-1], 0, col("'>"))
    endif
    if col("'<") != 1
        let selectedLines[0] = strpart(selectedLines[0], col("'<")-1)
    endif
    let temp = "/tmp/statacmd.do"
    call writefile(selectedLines, temp)

    if(has("mac"))
        silent exec "!open /tmp/statacmd.do" 
    else
        silent exec "! nohup bash ~/.config/nvim/runStata.sh >/dev/null 2>&1 &"
    endif
endfun

" Status Line ============================================================ {{{1
function! utils#Status()
    if &laststatus == 0
        "call plug#load('vim-airline', 'vim-airline-themes')
        let &laststatus = 2
    else
        let &laststatus = 0
    endif
endfunction

" Plug Load Management ================================================== {{{1
function! utils#PlugHasLoaded(plugName) abort
    " 判断插件是否已经载入
    if has_key(g:, "plug_manage_tool") && g:plug_manage_tool == "lazyvim"
        let loaded_plugs = v:lua.LoadedPlugins()
        return(has_key(loaded_plugs, a:plugName))
    endif

    if !has_key(g:plugs, a:plugName)
        return(0)
    endif
    let plugdir = g:plugs[a:plugName].dir
    let plugdir_noenddash = strpart(plugdir, 0, strlen(plugdir) - 1)
    return (
       \ has_key(g:plugs, a:plugName) &&
       \ stridx(&rtp, plugdir_noenddash) >= 0)
endfunction

function! s:PlugConfHasLoaded(plugName) abort
    " 是否已经载入插件的个人配置文件
    return(
        \ has_key(g:plugs_lbs_conf, a:plugName) &&
        \ g:plugs_lbs_conf[a:plugName] > 0
        \ )
endfunction

function! utils#Load_Plug_Conf(plugName) abort
    " 载入插件对应的配置文档
    if <SID>PlugConfHasLoaded(a:plugName) == 0
        let fname = stdpath("config") . "/Plugins/" . a:plugName
        let fname_vim = fname . ".vim"
        let fname_lua = fname . ".lua"
        if filereadable(fname_vim)
            exec "source " . fnameescape(fname_vim)
        elseif filereadable(fname_lua)
            exec "luafile " . fnameescape(fname_lua)
        endif
        let g:plugs_lbs_conf[a:plugName] = 1
    endif
endfunction

function! utils#Load_Plug(plugname)
    " 手动加载特定插件
    if utils#PlugHasLoaded(a:plugname) == 0
        if has_key(g:, "plug_manage_tool") && g:plug_manage_tool == "lazyvim"
            exec "lua require('lazy').load({plugins = '" . a:plugname . "'})"
        else
            call utils#Load_Plug_Conf(a:plugname)
            call plug#load(a:plugname)
        endif
    endif
endfunction

function! utils#Load_Plug_Confs(plugNames) abort
    " load config file for loaded plug
    for plugname in a:plugNames
        if utils#PlugHasLoaded(plugname) == 1
            call utils#Load_Plug_Conf(plugname)
        endif
    endfor
endfunction

" Input Method Toggle ==================================================== {{{1
function! utils#LToggle()
    if g:lbs_input_status == g:lbs_input_method_on
        let g:input_toggle = 1
        let l:a = system(g:lbs_input_method_inactivate)
    elseif g:lbs_input_status != g:lbs_input_method_on && g:input_toggle == 1
        let l:a = system(g:lbs_input_method_activate)
        let g:input_toggle = 0
    endif
    return("")
endfunction

" View csv lines ========================================================= {{{1
function! utils#ViewLines() range
    let selectedLines = getbufline('%', a:firstline, a:lastline)
    let selectedLines = [getline(1)] + selectedLines
    let tmpfile = tempname()
    if &filetype ==# "tsv"
        let sep = "\t"
    elseif &filetype ==# "csv_pipe"
        let sep = "|"
    elseif &filetype ==# "csv_semicolon"
        let sep = ";"
    elseif &filetype ==# "csv"
        let sep = ","
    else
        return 0
    endif
    let listcontents = system("xsv flatten -s '" . repeat("─", 30) . "' -d '" . sep . "'", selectedLines)
    let listcontents = repeat("─", 30) . "\n" . listcontents
    silent cexpr listcontents
    silent copen
    let g:quickfix_is_open = 1
    syn match qfVarname  "^|| \w\+"hs=s+3 contains=qfPre
    syn match qfLineSep  "^|| ─\+"hs=s+3 contains=qfPre
    exec "wincmd L"
    exec "vertical resize 40"
    exec "set nowrap"
    exec "wincmd h"
    "call writefile(selectedLines, tmpfile) exec "split " . tmpfile
endfunction

" Vim Auto List Completion =============================================== {{{1
" From https://gist.github.com/sedm0784/dffda43bcfb4728f8e90
" Auto lists: Automatically continue/end lists by adding markers if the
" previous line is a list item, or removing them when they are empty
function! utils#AutoFormatNewline()
  if getline(".")[col("."):] =~ '\v^\s*\)+\s*$'
    exec "normal ax\<left>\<enter>\<Esc>lxh"
  else
      let l:preceding_line = getline(line("."))
      if l:preceding_line =~ '\v^\s*(\d+\.|[-+*])\s'
        let l:space_before = matchstr(l:preceding_line, '\v^\zs\s*\ze(\d+\.|[-+*])\s+')
        let l:symbol       = matchstr(l:preceding_line, '\v^\s*\zs(\d+\.|[-+*])\ze\s+')
        let l:space_after  = matchstr(l:preceding_line, '\v^\s*(\d+\.|[-+*])\zs\s+\ze')
        exec "normal a\<enter>"
        if l:preceding_line =~ '\v^\s*\d+\.\s+[^ ]'
            call setline(".", l:space_before . (l:symbol + 1) . "." . l:space_after)
        elseif l:preceding_line =~ '\v^\s*\d+\.\s+$'
            call setline(line(".") - 1, "")
        elseif l:preceding_line =~ '\v^\s*[-+*]\s+[^ ]'
            call setline(".", l:space_before . l:symbol . l:space_after)
        elseif l:preceding_line =~ '\v^\s*[-+*]\s+$'
          call setline(line(".") - 1, "")
        endif
        exec "normal $"
      else
          exec "normal \<enter>"
      endif
    endif
endfunction

" 翻译操作符 ============================================================= {{{1
function! utils#Trans2clip(type = '')
    if a:type == ''
        set opfunc=utils#Trans2clip
        return 'g@'
    endif

    let visual_marks_save = [getpos("'<"), getpos("'>")]

    try
        let commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y", v:"`<v`>y"}
        silent exe 'noautocmd normal! ' .. get(commands, a:type, '')
        let oritext = substitute(@", "\n", " ", "g")
        if oritext =~# "^ *[A-Za-z]"
            let source_to = "en:zh"
        else
            let source_to = "zh:en"
        endif
        let cmd = "trans -b --no-ansi %s \"%s\" 2>/dev/null"
        let cmd = printf(cmd, shellescape(source_to), oritext)
        let @" = system(cmd)
        cexpr @"
    finally
        call setpos("'<", visual_marks_save[0])
        call setpos("'>", visual_marks_save[1])
    endtry
endfunction

" tab, window, buffer related ============================================ {{{1
" 查找 bufnr 所在的标签序号 ---------------------------------------------- {{{2
function! s:find_buftabnr(buffernr) abort 
    let l:tabnr = -1
    for tnr in range(1, tabpagenr('$'))
        for bnr in tabpagebuflist(tnr)
            if bnr ==# a:buffernr
                let l:tabnr = tnr
                break
            endif
        endfo
        if l:tabnr != -1
            break
        endif
    endfor
    return l:tabnr
endfunction

" 查找 bufnr 的标签 ------------------------------------------------------ {{{2
function! utils#Find_bufwinnr(buffernr) abort
    let l:tabnr = <sid>find_buftabnr(a:buffernr)
    let l:winid = -1
    if l:tabnr != -1
        exe l:tabnr . "tabnext"
        let l:winid = bufwinid(a:buffernr)
    endif
    return l:winid
endfunction

" open file in spec buffer
function! utils#Preview_data(fname, globalvar, method = "tabnew", close = "n", filetype = "tsv")
    if !has_key(g:, a:globalvar)
        if a:close ==? "y" | return | endif
        let bufnr = bufadd(a:fname)
        let g:[a:globalvar] = bufnr
    else
        let bufnr = get(g:, a:globalvar)
    endif
    let l:winlist = win_findbuf(bufnr)
    if empty(l:winlist)
        if a:close ==? "y" | return | endif
        exec a:method | exec "buffer" . bufnr
        setlocal buftype=nowrite
        setlocal noswapfile
        let &l:filetype = a:filetype
        if a:filetype ==? "csv" || a:filetype ==? "tsv"
            try
                RainbowAlign
                catch /.*/
            endtry
        endif
    else
        call win_gotoid(l:winlist[0])
        exec "edit"
        if a:close ==? "y"
            Bclose
            quit
        endif
    endif
endfunction

" Stata Related ========================================================== {{{1
function! utils#StataGenHelpDocs(keywords, oft = "txt") abort
    if a:oft ==? "pdf"
        call system(",sh -o pdf " . a:keywords)
        return ""
    endif
    let l:target = system(",sh -v " . a:keywords)
    if l:target !~? '^\(\s*Cannot.*\|\s*\)$'  
        if &ft ==? "statadoc"
            exec "edit " . l:target
        else
            exec "split " . l:target
        end
        help
        q
    endif
endfunction

" Markdown Snippets Preview ============================================== {{{1
function! utils#DeleteMdPreview(zen, close_preview_buffer = v:false) abort
    try
        if a:close_preview_buffer
            DeleteImage
        else
            DeleteImage!
        endif
        catch /Not an editor command/
    endtry
    if a:zen
        ZenMode
    endif
endfun

function! utils#MdPreview(method = "FocusSplitDown") range  abort
    let bg = synIDattr(synIDtrans(hlID("StatusLine")), "bg#")
    if !(($TERM ==? "xterm-kitty" || $WEZTERM_EXECUTABLE != "") && v:lua.PlugExist('hologram.nvim'))
        let outfile = shellescape(stdpath('cache') . "/vim_markdown_preview.png")
        let command = "mdviewer --wname " . sha256(expand('.')) . 
                    \ " --outfile " . outfile . " --bg '" . bg . "'"
        Lazy! load asyncrun.vim
        call asyncrun#run("", {'silent': 1, 'pos': 'hide'}, command, 1, a:firstline, a:lastline)
        return
    endif

    let outfile = stdpath('cache') . "/kitty_markdown_preview.png"
    let command = "mdviewer --outfile " . outfile . " --quietly --bg '" . bg . "'"
    let lines = getline(a:firstline, a:lastline)
    call system(command, lines)

    let zen_mode = v:false
    nnoremap <buffer><silent> <localleader>id <Nop>
    if has_key(g:, "lbs_zen_mode") && g:lbs_zen_mode == v:true
        close " quit zen_mode before preview content
        nnoremap <buffer><silent> <localleader>id
            \ :<c-u>call utils#DeleteMdPreview(v:true, v:true)<cr>
    else
        nnoremap <buffer><silent> <localleader>id
            \ :<c-u>call utils#DeleteMdPreview(v:false, v:true)<cr>
    endif
    call utils#DeleteMdPreview(v:false)
    exec "PreviewImage " . a:method . " " . outfile
endfunction


" Check the syntax group in the current cursor position, see ============= {{{1
" https://stackoverflow.com/q/9464844/6064933 and
" https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
function! utils#SynGroup() abort
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" Get highlight group color ============================================= {{{1
function! utils#GetHlColor(hlg, element)
    return synIDattr(synIDtrans(hlID(a:hlg)), a:element)
endfun

" Redirect command output to a register for later processing. ============ {{{1
" Ref: https://stackoverflow.com/q/2573021/6064933 and https://unix.stackexchange.com/q/8101/221410 .
function! utils#CaptureCommandOutput(command) abort
  let l:tmp = @m
  redir @m
  silent! execute a:command
  redir END

  "create a scratch buffer for dumping the text, ref: https://vi.stackexchange.com/a/11311/15292.
  tabnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

  let l:lines = split(@m, '\n')
  call nvim_buf_set_lines(0, 0, 0, 0, l:lines)

  let @m = l:tmp
endfunction

" Buffer Delete ========================================================== {{{1
" From: https://github.com/rbgrouleff/bclose.vim/blob/master/plugin/bclose.vim
function! utils#Bclose(bang, buffer)
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif
    if btarget < 0
        call utils#Warn('No matching buffer for '.a:buffer)
        return
    endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call utils#Warn('No write since last change for buffer ' . 
                     \  btarget . ' (use :Bclose!)')
        return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
            buffer #
        else
            bprevious
        endif
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')),
                                \ 'buflisted(v:val) && v:val != btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else
                execute 'enew'.a:bang
            endif
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
endfunction

" 查看当前光标下的高亮组 ================================================ {{{1
function! utils#Extract_hl_group_link()
    echom v:lua.extract_hl_group_link(0, line('.') - 1, col('.') -1)
endfunction
" End =================================================================== {{{1
" vim: fdm=marker:
