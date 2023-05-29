
function! ZF_exepath(prog)
    if exists('*exepath')
        return exepath(a:prog)
    else
        return get(split(globpath(join(split($PATH, ':'), ','), a:prog), "\n"), 0, '')
    endif
endfunction

function! ZF_versionGet(exe, ...)
    let args = get(a:, 1, '--version')
    if !exists('s:versionMap')
        " s:versionMap : {
        "   'some exe' : {
        "     'args' : '--version',
        "     'v' : '1.2.3',
        "   },
        " }
        let s:versionMap = {}
        call s:versionMapCacheInit()
    endif

    if !exists('s:versionMap[a:exe]')
        if !executable(a:exe)
            let v = ''
        else
            let v = ZF_versionParse(ZF_system(a:exe . ' ' . args))
        endif
        call s:versionMapCacheSave(a:exe, args, v)
    endif
    return s:versionMap[a:exe]['v']
endfunction

function! s:versionMapCacheInit()
    if !exists('*json_decode')
        return
    endif
    let versionMapCachePath = get(g:, 'ZF_versionGetCachePath', g:zf_vim_cache_path . '/ZF_versionMapCache.json')
    try
        let s:versionMap = json_decode(readfile(versionMapCachePath))
    catch
        let s:versionMap = {}
    endtry
    if exists('*timer_start')
        call timer_start(1000, function('s:versionMapCacheUpdate'))
    endif
endfunction
function! s:versionMapCacheSave(exe, args, v)
    let old = get(s:versionMap, a:exe, {})
    if !empty(old) && old['args'] == a:args && old['v'] == a:v
        return
    endif
    let s:versionMap[a:exe] = {
                \   'args' : a:args,
                \   'v' : a:v,
                \ }

    if !exists('*json_encode')
        return
    endif
    if exists('s:versionMapCacheSaveTaskId') || !exists('*timer_start')
        call ZF_versionMapCacheSaveAction()
        return
    endif
    let s:versionMapCacheSaveTaskId = timer_start(100, function('ZF_versionMapCacheSaveAction'))
endfunction
function! ZF_versionMapCacheSaveAction(...)
    if exists('s:versionMapCacheSaveTaskId')
        unlet s:versionMapCacheSaveTaskId
    endif
    let versionMapCachePath = get(g:, 'ZF_versionGetCachePath', g:zf_vim_cache_path . '/ZF_versionMapCache.json')
    call writefile([json_encode(s:versionMap)], versionMapCachePath)
endfunction
function! s:versionMapCacheUpdate(...)
    if exists('s:versionMapCacheUpdateTaskId') || !exists('*ZFJobAvailable') || !ZFJobAvailable()
        return
    endif
    let jobGroup = []
    for exe in keys(s:versionMap)
        call add(jobGroup, {
                    \   'jobCmd' : exe . ' ' . s:versionMap[exe]['args'],
                    \   'onOutput' : ZFJobFunc(function('s:versionMapCacheUpdateOnOutput'), [exe]),
                    \ })
    endfor
    let s:versionMapCacheUpdateTaskId = ZFGroupJobStart({
                \   'jobList' : [jobGroup],
                \   'onExit' : function('s:versionMapCacheUpdateOnExit'),
                \ })
endfunction
function! s:versionMapCacheUpdateOnOutput(exe, jobStatus, textList, type)
    if !exists('s:versionMap[a:exe]')
        return
    endif
    call s:versionMapCacheSave(a:exe, s:versionMap[a:exe]['args'], ZF_versionParse(a:textList))
endfunction
function! s:versionMapCacheUpdateOnExit(...)
    unlet s:versionMapCacheUpdateTaskId
endfunction

function! ZF_versionParse(text)
    if type(a:text) == type('')
        let lines = split(a:text, "\n")
    else
        let lines = a:text
    endif
    for line in lines
        " ([0-9]+(\.[0-9]+)+)
        let v = matchstr(line, '\([0-9]\+\(\.[0-9]\+\)\+\)')
        if !empty(v)
            return v
        endif
    endfor
    return ''
endfunction

function! ZF_versionCompare(v0, v1)
    let v0 = ZF_versionParse(a:v0)
    let v1 = ZF_versionParse(a:v1)
    let l0 = split(v0, '\.')
    let l1 = split(v1, '\.')

    let i = 0
    let iEnd0 = len(l0)
    let iEnd1 = len(l1)
    while i < iEnd0 && i < iEnd1
        let n0 = str2nr(l0[i])
        let n1 = str2nr(l1[i])
        if n0 > n1
            return 1
        elseif n0 < n1
            return -1
        endif
        let i += 1
    endwhile

    if iEnd0 < iEnd1
        return -1
    elseif iEnd0 > iEnd1
        return 1
    else
        return 0
    endif
endfunction

