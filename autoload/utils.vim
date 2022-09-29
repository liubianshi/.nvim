" Display an error message. ============================================== {{{1
function! utils#Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" math equation preview ================================================== {{{1
function! utils#Math_Preview() range
    return
endfunction

" 在末尾添加符号 ======================================================== {{{1
function! utils#AddDash(symbol) abort
    let w = &l:textwidth == 0 ? 78 : &l:textwidth
    substitute/\s*$//g
    let lo = getline('.')
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

" Zen {{{1 
function! s:zenmodeinsert() abort
    let ww = winwidth(0)
    let b:zen_oriwin = { 'zenmode': 1,
                       \ 'foldcolumn': &foldcolumn,
                       \ 'number': &number,
                       \ 'relativenumber': &relativenumber,
                       \ 'foldenable': &foldenable,
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
    set laststatus=2
    set noshowcmd
    if !exists('b:zen_oriwin')
        return
    endif
    for attr in keys(b:zen_oriwin)
        if attr ==# 'zenmode'
            let b:zen_oriwin[attr] = 0
        elseif attr ==# 'foldcolumn'
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
        call utils#Load_Plug_Conf(a:plugname)
        call plug#load(a:plugname)
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
        let cmd = "trans -b --no-ansi %s '%s'"
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
function! utils#Preview_data(fname, globalvar)
    if !has_key(g:, a:globalvar)
        let bufnr = bufadd(a:fname)
        let g:[a:globalvar] = bufnr
    else
        let bufnr = get(g:, a:globalvar)
    endif
    let l:winlist = win_findbuf(bufnr)
    if empty(l:winlist)
        tabnew | exec "buffer" . bufnr
    else
        call win_gotoid(l:winlist[0])
        edit
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
function! utils#MdPreview(view = 0) range  abort
    if (a:view == 0 && (exists("b:mdviewer_open") && b:mdviewer_open == '1'))
        let command = "mdviewer -q"
    else
        let command = "mdviewer"
    endif
    call asyncrun#run("", {'silent': 1, 'pos': 'hide'}, command, 1, a:firstline, a:lastline)
    let b:mdviewer_open = '1'
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

" Custom fold text adapted from: ======================================== {{{1
"     https://github.com/jdhao/nvim-config/blob/master/autoload/utils.vim
function! utils#MyFoldText() abort 
    let l:line_width = &l:textwidth == 0 ? 78 : &l:textwidth
    let l:line = getline(v:foldstart)
    let l:fold_line_num = v:foldend - v:foldstart
    let l:marker = split(&l:foldmarker, ",")[0]
    let l:fold_text = substitute(l:line, '\V' . l:marker . '\[0-9]\*', '', 'g')
    let l:fold_text = substitute(l:fold_text, '\v[=\-.* ]*$', '', 'g')
    let foldlevel_num = split("    ྲྀ  ")
    let foldlevel_icon = split("├ 🌀")
    " let foldlevel_icon = split("🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘 ")
    " let foldlevel_symbol = split("⚽ ⚾ 🥎 🏀 🏐 🏈 🏉")
    if v:foldlevel >= len(foldlevel_icon)
        let l:foldicon = foldlevel_icon[0]
    else
        let l:foldicon = foldlevel_icon[v:foldlevel]
    endif
    if v:foldlevel >= len(foldlevel_num)
        let l:foldnum = foldlevel_num[0]
    else
        let l:foldnum = foldlevel_num[v:foldlevel]
    endif
    let l:foldicon = repeat("  ", v:foldlevel - 1)
                \  . l:foldicon
                \  . repeat(" ", 2 - strdisplaywidth(l:foldicon))
    let l:fill_char = "─"
    let l:fill_char_num = l:line_width - strdisplaywidth(l:fold_text) - strdisplaywidth(l:foldicon)
    return printf('%s %s %s %03dL', l:foldicon, l:fold_text,
                                   \   repeat(l:fill_char, l:fill_char_num - 7),
                                   \   l:fold_line_num
                                   \ )
endfunction
" End =================================================================== {{{1
" vim: fdm=marker:
