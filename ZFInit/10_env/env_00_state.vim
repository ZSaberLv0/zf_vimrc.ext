
function! ZF_stateGet(key, ...)
    return get(get(s:state, a:key, {}), 'value', get(a:, 1, ''))
endfunction

function! ZF_stateSet(key, value)
    if empty(a:key)
        return
    endif
    if empty(a:value)
        if exists('s:state[a:key]')
            unlet s:state[a:key]
        endif
    else
        let s:state[a:key] = {
                    \   'value' : a:value,
                    \   'time' : localtime(),
                    \ }
    endif
    call s:stateSave()
endfunction

function! s:stateFile()
    return g:zf_vim_cache_path . '/ZF_state'
endfunction
function! s:cacheTime()
    return get(g:, 'ZF_state_cacheTime', 3 * 24 * 60 * 60)
endfunction

" state: {
"   'xxx key' : {
"     'value' : 'xxx value',
"     'time' : 'timestamp',
"   },
" }
if !exists('s:state')
    let s:state = {}
endif

function! s:stateSave()
    let curTime = localtime()
    let cacheTime = s:cacheTime()
    let contents = []
    for key in keys(s:state)
        let item = s:state[key]
        if curTime - item['time'] < cacheTime
            call add(contents, printf("%s\t%s\t%s"
                        \ , item['time']
                        \ , substitute(key, '\t', '\\t', 'g')
                        \ , substitute(item['value'], '\t', '\\t', 'g')
                        \ ))
        endif
    endfor
    call writefile(contents, s:stateFile())
endfunction

function! s:stateLoad()
    let s:state = {}
    if !filereadable(s:stateFile())
        return
    endif
    let curTime = localtime()
    let cacheTime = s:cacheTime()
    for line in readfile(s:stateFile())
        let data = split(line, "\t")
        if len(data) != 3
            continue
        endif
        let time = str2nr(data[0])
        if curTime - time >= s:cacheTime()
            continue
        endif
        let s:state[substitute(data[1], '\\t', '\t', 'g')] = {
                    \   'value' : substitute(data[2], '\\t', '\t', 'g'),
                    \   'time' : time,
                    \ }
    endfor
endfunction
call s:stateLoad()

