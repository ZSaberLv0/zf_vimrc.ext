
function! ZF_versionGet(exe, ...)
    let cmd = a:exe . ' ' . get(a:, 1, '--version')
    let result = ZF_shellcache(cmd)
    return ZF_versionParse(result)
endfunction

function! ZF_versionParse(text)
    if type(a:text) == type('')
        let lines = split(a:text, "\n")
    else
        let lines = a:text
    endif
    for line in lines
        " ([0-9]+(\.[0-9]+)*)
        let v = matchstr(line, '\([0-9]\+\(\.[0-9]\+\)*\)')
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

