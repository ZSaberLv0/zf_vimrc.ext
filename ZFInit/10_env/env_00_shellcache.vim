
" util to cache shell results
"
" function! OnGetNodeVersion(cmd, result, exitCode)
" endfunction
" let result = ZF_shellcache('node --version', function('OnGetNodeVersion'))
"
" if cache exists or job not available, the function return the result immediately
" otherwise, return an empty string, and call the callback on the future
function! ZF_shellcache(cmd, ...)
    let Fn_callback = get(a:, 1, '')
    call s:cacheLoad()

    if exists('s:cache[a:cmd]')
        if exists('*ZFJobAvailable') && ZFJobAvailable()
            if s:cache[a:cmd]['jobId'] == -1
                        \ && localtime() - s:cache[a:cmd]['cacheTime'] >= get(g:, 'ZF_shellcache_updateTime', 60*60)
                call s:updateAsync(a:cmd, Fn_callback)
            endif
        elseif exists('v:vim_did_enter') && !v:vim_did_enter
            if !exists('s:autoUpdate')
                let s:autoUpdate = [
                            \   {
                            \     'cmd' : a:cmd,
                            \     'callback' : Fn_callback,
                            \   },
                            \ ]
            endif
        endif
        return s:cache[a:cmd]['result']
    endif

    if exists('*ZFJobAvailable') && ZFJobAvailable()
        let s:cache[a:cmd] = {
                    \   'result' : '',
                    \   'jobId' : -1,
                    \   'cacheTime' : localtime(),
                    \ }
        call s:updateAsync(a:cmd, Fn_callback)
        return ''
    else
        return s:updateSync(a:cmd)
    endif
endfunction

function! s:cacheFile()
    return get(g:, 'ZF_shellcache_cacheFile',
                \   get(g:, 'zf_vim_cache_path', get(g:, 'zf_vim_home_path', CygpathFix_absPath($HOME)) . '/.vim_cache') . '/ZF_shellcache_cache'
                \ )
endfunction

function! s:encode(item)
    return substitute(
                \ substitute(
                \ substitute(a:item,
                \ '\t', '\\t', 'g'),
                \ '\r', '\\r', 'g'),
                \ '\n', '\\n', 'g')
endfunction

function! s:decode(item)
    return substitute(
                \ substitute(
                \ substitute(a:item,
                \ '\\t', '\t', 'g'),
                \ '\\r', '\r', 'g'),
                \ '\\n', '\n', 'g')
endfunction

function! _ZF_shellcache_onExit(cmd, callback, jobStatus, exitCode)
    let result = join(a:jobStatus['jobOutput'], "\n")
    let resultPrev = s:cache[a:cmd]['result']

    let s:cache[a:cmd]['jobId'] = -1
    let s:cache[a:cmd]['result'] = a:exitCode == '0' ? result : ''
    let s:cache[a:cmd]['cacheTime'] = localtime()
    call s:cacheSave()

    if result != resultPrev || a:exitCode != '0'
        call ZFJobFuncCall(a:callback, [a:cmd, result, a:exitCode])
    endif
endfunction
function! s:updateAsync(cmd, callback)
    let s:cache[a:cmd]['jobId'] = ZFGroupJobStart({
                \   'jobCmd' : a:cmd,
                \   'onExit' : ZFJobFunc(function('_ZF_shellcache_onExit'), [a:cmd, a:callback]),
                \ })
endfunction

function! s:updateSync(cmd)
    let result = ZF_system(a:cmd)
    let s:cache[a:cmd] = {
                \   'result' : result,
                \   'jobId' : -1,
                \   'cacheTime' : localtime(),
                \ }
    call s:cacheSave()
    return result
endfunction

" file format:
"     cmd\tresult\cacheTime
"
" cmd and result are escaped with `\t \r \n`
function! s:cacheLoad()
    if exists('s:cache')
        return
    endif
    " cache: {
    "   'cmd' : {
    "     'result' : 'xxx',
    "     'jobId' : -1,
    "     'cacheTime' : xxx,
    "   },
    " }
    let s:cache = {}

    let cacheFile = s:cacheFile()
    if filereadable(cacheFile)
        for line in readfile(cacheFile)
            let items = split(line, "\t")
            if len(items) != 3 || empty(items[0])
                continue
            endif
            let cacheTime = str2nr(items[2])
            if cacheTime <= 0
                continue
            endif
            let cmd = s:decode(items[0])
            if !exists('s:cache[cmd]')
                let s:cache[cmd] = {
                            \   'result' : s:decode(items[1]),
                            \   'jobId' : -1,
                            \   'cacheTime' : cacheTime,
                            \ }
            endif
        endfor
    endif
endfunction

function! s:cacheSave()
    if exists('*ZFJobTimerStart')
        if get(s:, 'cacheSaveTaskId', -1) >= 0
            call ZFJobTimerStop(s:cacheSaveTaskId)
        endif
        let s:cacheSaveTaskId = ZFJobTimerStart(1000, function('_ZF_shellcache_cacheSaveAction'))
    else
        call _ZF_shellcache_cacheSaveAction()
    endif
endfunction
function! _ZF_shellcache_cacheSaveAction(...)
    let s:cacheSaveTaskId = -1

    let contents = []
    let curTime = localtime()
    for cmd in keys(s:cache)
        if curTime - s:cache[cmd]['cacheTime'] < get(g:, 'ZF_shellcache_cacheTime', 24*60*60)
            call add(contents,
                        \          s:encode(cmd)
                        \ . "\t" . s:encode(s:cache[cmd]['result'])
                        \ . "\t" . s:cache[cmd]['cacheTime']
                        \ )
        endif
    endfor
    call writefile(contents, s:cacheFile())
endfunction

function! s:autoUpdateAction()
    if !exists('s:autoUpdate')
        return
    endif
    let autoUpdate = s:autoUpdate
    unlet s:autoUpdate
    if exists('*ZFJobAvailable') && ZFJobAvailable()
        for item in autoUpdate
            call s:updateAsync(item['cmd'], item['callback'])
        endfor
    else
        if exists('*ZFJobFuncCall')
            for item in autoUpdate
                let result = s:updateSync(item['cmd'])
                call ZFJobFuncCall(item['callback'], [item['cmd'], result, v:shell_error])
            endfor
        else
            for item in autoUpdate
                let result = s:updateSync(item['cmd'])
                if type(item['callback']) == type(function('type'))
                    call call(item['callback'], [item['cmd'], result, v:shell_error])
                endif
            endfor
        endif
    endif
endfunction
augroup _ZF_shellcache_autoUpdate_augroup
    autocmd!
    autocmd VimEnter * call s:autoUpdateAction()
augroup END

