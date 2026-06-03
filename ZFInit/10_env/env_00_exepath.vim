
function! ZF_exepath(prog)
    if exists('*exepath')
        return exepath(a:prog)
    else
        return get(split(globpath(join(split($PATH, ':'), ','), a:prog), "\n"), 0, '')
    endif
endfunction

