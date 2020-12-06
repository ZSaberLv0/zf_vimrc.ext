
function! ZF_pynvim_check()
    if exists('s:pynvim')
        return s:pynvim
    endif

    if has('pythonx')
        let py = 'pythonx'
    elseif has('python3')
        let py = 'python3'
    elseif has('python')
        let py = 'python'
    else
        return 0
    endif
    try
        execute py . ' import neovim'
    catch
        try
            execute py . ' import pynvim'
        catch
            return 0
        endtry
    endtry
    let s:pynvim = 1
    return 1
endfunction

if !has('nvim')
    function! s:exepath(prog)
        if exists('*exepath')
            return exepath(a:prog)
        else
            return get(split(globpath(join(split($PATH, ':'), ','), a:prog), "\n"), 0, '')
        endif
    endfunction
    if has('python3')
        let g:python3_host_prog = s:exepath('python3')
        if empty(g:python3_host_prog)
            let g:python3_host_prog = s:exepath('python')
        endif
        if empty(g:python3_host_prog)
            unlet g:python3_host_prog
        endif
    elseif has('python')
        let g:python_host_prog = s:exepath('python')
        if empty(g:python_host_prog)
            unlet g:python_host_prog
        endif
    endif
endif

