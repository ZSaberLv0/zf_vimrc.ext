
if !exists('s:autoClean')
    let s:autoClean = {}
endif

function! ZFCache_autoClean(path)
    let s:autoClean[a:path] = 1
endfunction

function! s:check()
    let timestampPath = g:zf_vim_cache_path . '/ZFCache_autoClean.time'
    let time = 0
    if filereadable(timestampPath)
        for line in readfile(timestampPath)
            let line = substitute(line, '[ \t]', '', 'g')
            if !empty(line)
                let time = str2nr(line)
                if time > 0
                    break
                endif
            endif
        endfor
    endif
    if time + get(g:, 'ZFCache_interval', 7*24*60*60) > localtime()
        return
    endif
    for path in keys(s:autoClean)
        call ZF_rm(path)
    endfor
    call writefile([localtime()], timestampPath)
endfunction

augroup ZFClean_augroup
    autocmd!
    autocmd VimLeavePre * call s:check()
augroup END

