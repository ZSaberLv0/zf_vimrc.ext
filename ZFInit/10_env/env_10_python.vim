
if !has('nvim')
    if has('python3')
        let g:python3_host_prog = ZF_exepath('python3')
        if empty(g:python3_host_prog)
            let g:python3_host_prog = ZF_exepath('python')
        endif
        if empty(g:python3_host_prog)
            unlet g:python3_host_prog
        endif
    elseif has('python')
        let g:python_host_prog = ZF_exepath('python')
        if empty(g:python_host_prog)
            unlet g:python_host_prog
        endif
    endif
endif

