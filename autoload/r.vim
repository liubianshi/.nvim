function! s:getwinnr_with_bufname(bufname)
    let windows = getwininfo()
    for window in windows
        let win_bufname = bufname(window.bufnr)
        if win_bufname == a:bufname
            return window.winnr
        endif
    endfor
    return v:null
endfunction

function! s:source_or_test_filepath(f = v:null) abort
    let file = (a:f == v:null ? expand('%') : a:f)
    let fname = fnamemodify(file, ":t")
    if fnamemodify(fname, ":e") !=? 'r' | return v:null | endif

    if fname =~? '\vtest[-_].*\.r$'
        let fname = substitute(fname, '\v^test[-_]', "", "")
        if filereadable(fname)
            return fname
        endif
        let source_file = "R/" . fname
        if filereadable(source_file)
            return source_file
        endif
        return v:null
    endif

    let testname = "tests/testthat/test_" . fname
    if filewritable(testname)
        return testname
    endif
    return "tests/testthat/test-" . fname
endfunction

function! s:init_test_files() abort
    call mkdir("tests/testthat", "p")
    let contents = ['require("testthat")']
    for file in glob('R/*.[Rr]', v:null, v:true)
        let contents = add(contents, 'source("' . file . '")')
    endfor
    let contents = add(contents, 'test_dir("tests/testhat")')
    call writefile(contents, "tests/testthat.R")
endfunction

function! r#EditTestFile(cmd = "split")
    let fname = expand('%')
    let isTestFile = (expand('%:t') =~? '\vtest[-_]\.r')
    let targetName = <sid>source_or_test_filepath(fname)
    if isTestFile || ! isdirectory("tests")
        call s:init_test_files()
        call writefile(['library(testthat)', 'source("../../'.fname.'")'], targetName)
    endif
    let testthat_bufnr = bufadd('tests/testthat.r')
    call bufload(testthat_bufnr)
    call utils#InsertLine('source("'. fname . '")', '\^test_dir', testthat_bufnr, '\V' . fname)
    if !filereadable(targetName)
        call writefile(['library(testthat)', 'source("../../'.fname.'")'], targetName)
        normal G
    endif
    let winnr = s:getwinnr_with_bufname(targetName)
    if winnr
        execute winnr . "wincmd w"
    else
        exec a:cmd . " " . targetName
    endif
endfunction

function! r#TestCurrentFile()
    let fname = expand('%')
    if fname !~? '\v^R\/.+\.r$'
        return
    endif
    let testfile = <sid>source_or_test_filepath(fname)
    exec 'RSend testthat::test_file("' . testfile . '")'
endfunction

function! r#TestWholeProgram()
    if filereadable("NAMESPACE")
        RSend devtools::test()
    else
        RSend system2("Rscript", "tests/testthat.r", wait = FALSE)
    endif
endfunction

