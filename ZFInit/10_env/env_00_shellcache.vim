
function! ZF_shellcache(cmd, ...)
    if exists('*ZFShellCache')
        return ZFShellCache(a:cmd, get(a:, 1, ''))
    else
        return ZF_system(a:cmd)
    endif
endfunction

