
" ==================================================
if !exists('g:ZF_Plugin_tldr')
    let g:ZF_Plugin_tldr = 1
endif
if g:ZF_Plugin_tldr
    if !executable('tldr')
        let g:ZF_Plugin_tldr = 0
    endif

    " install
    function! ZF_Plugin_tldr_install()
        if !empty(ZF_ModuleGetPip())
            call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'tldr')
        elseif ZF_ModuleGetNpm()
            call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'tldr')
        endif
    endfunction
    call ZF_ModuleInstaller('ZF_Plugin_tldr', 'call ZF_Plugin_tldr_install()')
endif

if g:ZF_Plugin_tldr
    function! ZF_Plugin_tldr_run(cmd)
        if exists('*ZFAsyncRun')
            call ZFAsyncRun('tldr ' . a:cmd)
        else
            let result = ZF_system('tldr ' . a:cmd)
            " \x1b\[[0-9]+m
            let result = substitute(result, nr2char(27) . '\[[0-9]\+m', '', 'g')
            echo result
            let @t = result
        endif
    endfunction
    command! -nargs=+ -complete=shellcmd HelpTldr :call ZF_Plugin_tldr_run(<q-args>)
endif

