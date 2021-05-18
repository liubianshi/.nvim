" 个人全局变量
let g:plugs_lbs_conf = {}               " 用于记录插件个人配置文件的载入情况

" 代码格式化 {{{1
function Lbs_RFormat() range
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
command! -range=% LbsRF <line1>,<line2>:call Lbs_RFormat()

"   来自 Lilydjwg 的函数 {{{1
"   删除所有未显示且无修改的缓冲区以减少内存占用{{{2
function Lilydjwg_cleanbufs()
  for bufNr in filter(range(1, bufnr('$')), 'buflisted(v:val) && bufwinnr(v:val) == -1')
    if getbufinfo(bufNr)[0]['changed'] == 0
        execute bufNr . 'bdelete'
    endif
  endfor
endfunction
"   将当前窗口置于屏幕中间（全屏时用）{{{2
function Lilydjwg_CenterFull()
  only
  vsplit
  enew
  setl nocul
  setl nonu
  40winc |
  winc l
  vs
  winc l
  ene
  setl nocul
  setl nonu
  40winc |
  winc h
  redr!
endfunction
"  切换 ambiwidth {{{2
function Lilydjwg_toggle_ambiwidth()
  if &ambiwidth == 'double'
    let &ambiwidth = 'single'
  else
    let &ambiwidth = 'double'
  endif
endfunction
"   关闭某个窗口{{{2
function Lilydjwg_close(winnr)
  let winnum = bufwinnr(a:winnr)
  if winnum == -1
    return 0
  endif
  " Goto the workspace window, close it and then come back to the
  " original window
  let curbufnr = bufnr('%')
  exe winnum . 'wincmd w'
  close
  " Need to jump back to the original window only if we are not
  " already in that window
  let winnum = bufwinnr(curbufnr)
  if winnr() != winnum
    exe winnum . 'wincmd w'
  endif
  return 1
endfunction
"   复制缓冲区到新标签页{{{2
function Lilydjwg_copy_to_newtab()
  let temp = tempname()
  try
    let nr = bufnr('%')
    exec "mkview" temp
    tabnew
    exec "buffer" nr
    exec "source" temp
  finally
    call delete(temp)
  endtry
endfunction
" 使用 colorpicker 程序获取颜色值(hex/rgba){{{2
function Lilydjwg_colorpicker()
  if exists("g:last_color")
    let color = substitute(system("colorpicker ".shellescape(g:last_color)), '\n', '', '')
  else
    let color = substitute(system("colorpicker"), '\n', '', '')
  endif
  if v:shell_error == 1
    return ''
  elseif v:shell_error == 2
    " g:last_color 值不对
    unlet g:last_color
    return Lilydjwg_colorpicker()
  else
    let g:last_color = color
    return color
  endif
endfunction

" 更改光标下的颜色值(hex/rgba/rgb){{{2
function Lilydjwg_changeColor()
  let color = Lilydjwg_get_pattern_at_cursor('\v\#[[:xdigit:]]{6}(\D|$)@=|<rgba\((\d{1,3},\s*){3}[.0-9]+\)|<rgb\((\d{1,3},\s*){2}\d{1,3}\)')
  if color == ""
    echohl WarningMsg
    echo "No color string found."
    echohl NONE
    return
  endif
  let g:last_color = color
  call Lilydjwg_colorpicker()
  exe 'normal! eF'.color[0]
  call setline('.', substitute(getline('.'), '\%'.col('.').'c\V'.color, g:last_color, ''))
endfunction

" insert rmd-style picture {{{1
function! RmdClipBoardImage()
    execute "normal! i```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
    call mdip#MarkdownClipboardImage()
    execute "normal! \<esc>g_\"iyi)VCknitr::include_graphics(\"\")\<esc>F\"\"iPo```\n" 
endfunction

" 选择光标下文字 Super useful! From an idea by Michael Naumann {{{1
function! VisualSelection(direction, extra_filter) range
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

" quickfix managing {{{1
let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" Zen {{{1 
function ToggleZenMode()
    if &number == 1
        setlocal nonumber
        setlocal norelativenumber
        setlocal foldcolumn=4
        highlight FoldColumn guifg=bg
        return 0
    endif
    if &number == 0
        highlight FoldColumn guifg=grey
        setlocal foldcolumn=2
        setlocal number
        setlocal relativenumber
        return 0
    endif
endfunction

" R 语言函数定义 {{{1
function! R_view_df(dfname, row, method, max_width)
    call g:SendCmdToR('fViewDFonVim("' . a:dfname . '", ' . a:row . ', "' . a:method . '", ' . a:max_width . ')')
endfunction
function! R_view_df_sample(method)
    let dfname = @"
    let row = 40
    let max_width = 30
    return R_view_df(dfname, row, a:method, max_width)
endfunction
function! R_view_df_full(max_width)
    let dfname = @"
    let row = 0 
    let method = 'ht'
    return R_view_df(dfname, row, method, a:max_width)
endfunction
function! R_view_srdm_table()
    let dfname = "srdm_tables"
    let row = 0 
    let method = 'ht'
    let max_width = 40
    return R_view_df(dfname, row, method, max_width)
endfunction
function! R_view_srdm_var()
    let dfname = "srdm_vars"
    let row = 0 
    let method = 'ht'
    let max_width = 40
    return R_view_df(dfname, row, method, max_width)
endfunction

" Stata dolines {{{1
function! RunDoLines()
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

" 状态栏{{{1
function! Status()
    if &laststatus == 0
        call plug#load('vim-airline', 'vim-airline-themes')
        let &laststatus = 2
    else
        let &laststatus = 0
    endif
endfunction

" 切换补全工具{{{1
function! CocCompleteEngine()
    if exists("*ncm2#disable_for_buffer")
        call ncm2#disable_for_buffer()
    endif
    let b:coc_suggest_disable = 0
endfunction
function! Ncm2CompleteEngine()
    let b:coc_suggest_disable = 1
    call ncm2#enable_for_buffer()
    call ncm2#register_source(g:ncm2_r_source)
    call ncm2#register_source(g:ncm2_raku_source)
endfunction
function! ChangeCompleteEngine()
    if !exists("b:coc_suggest_disable") || b:coc_suggest_disable == 0
        call Ncm2CompleteEngine() 
    else
        call CocCompleteEngine()
    endif
endfunction


function! Lbs_PlugHasLoaded(plugName) abort     " 插件是否已经载入 {{{1
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

function! Lbs_PlugConfHasLoaded(plugName) abort     " 是否已经载入插件的个人配置文件 {{{1
    return(
        \ has_key(g:plugs_lbs_conf, a:plugName) &&
        \ g:plugs_lbs_conf[a:plugName] > 0
        \ )
endfunction

function! Lbs_Load_Plug_Conf(plugName) abort " 载入插件对应的配置文档 {{{1
    if Lbs_PlugConfHasLoaded(a:plugName) == 0
        let plug_config_file = glob("~/.config/nvim/Plugins/" . a:plugName . ".vim")
        if plug_config_file != ''
            exec "source " . fnameescape(plug_config_file)
            let g:plugs_lbs_conf[a:plugName] = 1
        endif
    endif
endfunction

function! Lbs_Load_Plug(plugname) " 手动加载特定插件 {{{1
    if Lbs_PlugHasLoaded(a:plugname) == 0
        call Lbs_Load_Plug_Conf(a:plugname)
        call plug#load(a:plugname)
    endif
endfunction

function! Lbs_Load_Plug_Confs(plugNames) abort    " load config file for loaded plug {{{1
    for plugname in a:plugNames
        if Lbs_PlugHasLoaded(plugname) == 1
            call Lbs_Load_Plug_Conf(plugname)
        endif
    endfor
endfunction

" 输入法切换
let g:input_toggle = 1
function! FcitxToggle()
    let s:input_status = system("fcitx5-remote")
    if s:input_status == 2
        let g:input_toggle = 1
        let l:a = system("fcitx5-remote -c")
    elseif s:input_status != 2 && g:input_toggle == 1
        let l:a = system("fcitx5-remote -o")
        let g:input_toggle = 0
    endif
    return("")
endfunction

