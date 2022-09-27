
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
        let s:versionMap = {}
    endif
    if !exists('s:versionMap[a:exe]')
        if !executable(a:exe)
            let s:versionMap[a:exe] = ''
        else
            let s:versionMap[a:exe] = ZF_versionParse(system(a:exe . ' ' . args))
        endif
    endif
    return s:versionMap[a:exe]
endfunction

function! ZF_versionParse(text)
    for line in split(a:text, "\n")
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

