" Function Definition --------------------------------------------------- {{{1
function! s:get_link_under_cursur_line()
    let content = utils#GetContentBetween('[', ']')
    if content =~? '\v^[0-9]+$'
        return b:newsboat_url_dict[content]
    elseif content =~? '\v\(link #[0-9]+\)'
        let content = substitute(content, '\v.*\(link #([0-9]+)\).*$', '\1', '')
        return b:newsboat_url_dict[content]
    else
        ImageClear
        return {}
    endif
endfunction

function! s:open_link(count)
    if has('mac')
        let open = "open"
    else
        let open = "xdg-open"
    endif
    echom(open . " '" . b:newsboat_url_dict[a:count]['url'] . "'")
    call system(open . " '" . b:newsboat_url_dict[a:count]['url'] . "'")
endfunction


function! s:get_link_citation_under_cursor(ft = "org")
    let link = s:get_link_under_cursur_line()
    if len(link) == 0 | return | endif

    Mylib note quiet
    let note_file_ext = fnamemodify(b:mylib_note, ":e")

    if link['type'] == "image"
        let image_path = system("linkhandler -t image -V '" . link['url'] . "'")
        let imagename = v:lua.vim.fs.basename(image_path)
        let subdir = v:lua.vim.fs.basename(v:lua.vim.fs.dirname(image_path))
        " let rootdir = luaeval('require("util").get_root(vim.b.mylib_note)')
        " if isdirectory(rootdir . "/.obsidian")
        "     let target_dir = rootdir . "/img/" . subdir
        " else
        "     let target_dir = v:lua.vim.fs.dirname(b:mylib_note) . "/img/" . subdir
        " endif
        let target_dir = v:lua.vim.fs.dirname(b:mylib_note) . "/img/" . subdir
        let target_path = target_dir . "/" . imagename

        if ! filereadable(target_path)
            call mkdir(target_dir, "p")
            call system("link '" . image_path . "' '" . target_path . "'") 
        endif
        let label = input("Please Input image title: ")

        if note_file_ext ==? "org" 
            if label != ""
                let label = "[" . label . "]"
            endif
            let content = "[[./img/" . subdir . "/" . imagename . "]" . label ."]"
        elseif note_file_ext ==? "md"
            let path = "img/" . subdir . "/" . imagename
            if label != ""
                let content = "![[" . path . "|" . label . "]]"
            else
                let content = "![[" . path . "]]"
            endif
        endif
    else
        if note_file_ext ==? "org"
            let content = system("url_cite org '" . link['url'] . "'")
        elseif note_file_ext ==? "md"
            let content = system("url_cite markdown '" . link['url'] . "'")
        endif
    endif
    
    return content
endfunction

function! s:generate_url_dict() " --------------------------------------- {{{1
    if has_key(b:, "newsboat_url_dict") | return | end
    let perl_commands = 'say "$1\t$2\t$3" if m/^\s* \[(\d+)\] :\s+ ([^\s]+) \s \(([^)]+)\) \s*$/x'
    let urls = systemlist("perl -nlE '" . perl_commands . "'", getline(1, '$'))
    let url_dict = {}
    for url in urls
        let info = split(url, '\t')
        let url_dict[info[0]] = { 'url': info[1], 'type': info[2]}
    endfo
    if len(url_dict) != 0
        let b:newsboat_url_dict= url_dict
    endif
endfunction

function! s:mylib_send_content_to_note(content, line = -1, method = "") abort
    if ! has_key(b:, "mylib_key")
        lua vim.notify("Need save html file to lib first")
        return
    endif

    if a:content !~ '\S' | return | endif
    let content = a:content
    let content = "\n" . trim(content)

    let curbufnr = bufnr('%')
    Mylib note quiet
    let notebufnr = bufnr(b:mylib_note)

    if a:method ==? "quiet" 
        if notebufnr == 0 | return 0 | endif
        call appendbufline(b:mylib_note, "$", split(content, "\n", 1))
        exec notebufnr . "," . notebufnr . "bufdo write"
        exec "buf " . curbufnr
        return v:true
    endif

    let current_wnr = bufwinid(@%)
    call mylib#run("note", a:method)

    if a:line == -1
        normal! Gzt
    else
        exec "normal! " . a:line . 'Gzt'
    endif

    let ori = @+
    let @+ = "\n" . content 
    normal! $"+p
    if match(@+, '\v\s*#\+begin_') != -1
        call search('\v^\s*#\+begin_')
        call text_obj#OrgCodeBlock('i')
        normal! gvgq
        normal! 2j
    else
        exec "normal! " . len(split(@+, "\n")) . "j"
    endif
    let @+ = ori

    exec notebufnr . "," . notebufnr . "bufdo write"
    " call win_gotoid(current_wnr)
    return v:true
endfunction

function! s:mylib_send_clipboard_to_note(method = "quiet")
    if ! has_key(b:, "mylib_key")
        lua vim.notify("Need save html file to lib first")
        return
    endif

    if @+ == "" | return | end
    let content = trim(@+)
    if has_key(b:, "mylib_note") && b:mylib_note =~? '\.org$'
        let content = "#+begin_quote\n" . content. "\n#+end_quote\n"
    elseif b:mylib_note =~? '\v\.(md|norg)$'
        let content = join(map(split(content, "\n"), '"> " . v:val'), "\n")
    endif

    let @+ = "〚" . @+ . "〛"
    let @+ = substitute(@+, '\v([\n\s]+)〛$', '〛\1', "")
    normal! gv"+p

    let result  = s:mylib_send_content_to_note(content, -1, a:method)
    if result != v:true
        normal! u
    endif
endfunction

function! s:mylib_send_link_citation_to_note(line = -1) abort
    if ! has_key(b:, "mylib_key")
        echo "Need save html file to lib first"
        return
    endif
    let content = s:get_link_citation_under_cursor()
    call s:mylib_send_content_to_note(content, a:line, "quiet")
endfunction

function! s:cache_link_snapshot()
    if has_key(b:, "newsboat_link_cached") | return | end
    if !has_key(b:, "newsboat_url_dict") | return | end
    let tmpfile = tempname()
    let url_list = []
    for i in keys(b:newsboat_url_dict)
        let url = b:newsboat_url_dict[i]
        call insert(url_list, url['url'] . "\t" . url['type'])
    endfor
    call system("cat >" . tmpfile, url_list)
    call jobstart("cache_url_snapshot " . tmpfile, {'on_exit': {j,d,e->luaeval('vim.notify("Link snapshot cached")')}})
    let b:newsboat_link_cached = v:true
endfunction

function! s:pangu()
    if has_key(b:, "formated") && b:formated == v:true
        return
    endif
    silent %s/\v\n(\s*\n)+/\r\r/g
    " silent %s/\v^　+//g
    normal! m'

    normal! gg
    let start = search('\v^\s*$', 'W')
    let start = start == 0 ? 1 : start

    normal! G
    let end = search('\v^Links:\s*$', 'bW')
    let end = end == 0 ? line('$') : end

    lua require("lazy").load({plugins = "pangu.vim", wait = true})
    exec start . "," . end . "Pangu"
    " exec "normal! " . start . "GV" . end . "Ggq"
    let b:formated = v:true

    normal! ''
endfunction

" set options ----------------------------------------------------------- {{{1
set nocindent nosmartindent nowrap nonumber norelativenumber
let &l:formatprg = "text_wrap -tonewsboat"
set fo-=q
setlocal scrolloff=10

call s:generate_url_dict()
call utils#Fetch_urls()
call s:cache_link_snapshot()
" call s:pangu()
:%s/\v^(　+|\s+$)//e
call utils#ToggleZenMode()

" Keymap ---------------------------------------------------------------- {{{1
" unmap <silent><buffer> q
nnoremap <silent><buffer> q :wq<cr>

nnoremap <silent><buffer> <localleader>s :Mylib new<cr>
nnoremap <silent><buffer> <localleader>e :Mylib edit<cr>
nnoremap <silent><buffer> <localleader>n :Mylib note<cr>
nnoremap <silent><buffer> <localleader>O :Urlopen<cr>
nnoremap <silent><buffer> <localleader>o "+yiu:call utils#OpenUrl(@+, "in")<cr>
vnoremap <silent><buffer> <localleader>y "+y:<c-u>call <sid>mylib_send_clipboard_to_note()<cr>
vnoremap <silent><buffer> N "+y:<c-u>call <sid>mylib_send_clipboard_to_note("split")<cr>
nnoremap <silent><buffer> <localleader>y vip"+y:<c-u>call <sid>mylib_send_clipboard_to_note()<cr>
nnoremap <silent><buffer> <localleader>q :Bclose<cr>
nnoremap <silent><buffer> <enter> :<c-u>call utils#OpenUrl(<sid>get_link_under_cursur_line(), "in")<cr>
nnoremap <silent><buffer> <s-enter> :<c-u>call <sid>mylib_send_link_citation_to_note()<cr>
nnoremap <silent><buffer> <localleader>t :<c-u>lua require("util.ui").mylib_tag()<cr>
nnoremap <silent><buffer> # :<C-u>call <sid>open_link(v:count1)<cr>
