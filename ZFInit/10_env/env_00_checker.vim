
function! ZF_exepath(prog)
    if exists('*exepath')
        return exepath(a:prog)
    else
        return get(split(globpath(join(split($PATH, ':'), ','), a:prog), "\n"), 0, '')
    endif
endfunction

function! ZF_versionGet(text)
    for line in split(a:text, "\n")
        let v = substitute(line, '.\{-}[ \t]*[vV]\([0-9]\+\(\.[0-9]\)\+\)\>.\{-}', '\1', '')
        if !empty(v)
            return v
        endif
    endfor
    return ''
endfunction

function! ZF_versionCompare(v0, v1)
    " .*?[ \t]*[vV]([0-9]+(\.[0-9])+)\>.*?
    let v0 = substitute(a:v0, '.\{-}[ \t]*[vV]\([0-9]\+\(\.[0-9]\)\+\)\>.\{-}', '\1', '')
    let v1 = substitute(a:v1, '.\{-}[ \t]*[vV]\([0-9]\+\(\.[0-9]\)\+\)\>.\{-}', '\1', '')
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

