
" ==================================================
if !exists('g:ZF_Plugin_tldr')
    let g:ZF_Plugin_tldr = 1
endif
if g:ZF_Plugin_tldr
    if !executable('tldr')
        let g:ZF_Plugin_tldr = 0
    endif

    function! ZF_Plugin_tldr_cachePath()
        return g:zf_vim_cache_path . '/tldr'
    endfunction
    function! ZF_Plugin_tldr_config()
        return {
                    \     'TLDR_PAGES_SOURCE_LOCATION' : 'file:///Users/mac/Desktop/cache/tldr/pages',
                    \     'TLDR_CACHE_MAX_AGE' : 20*365*24,
                    \ }
    endfunction
    function! ZF_Plugin_tldr_install()
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'tldr')
        call ZF_ModuleExec('git clone --single-branch --depth=1 https://github.com/tldr-pages/tldr "%s"'
                    \ , ZF_Plugin_tldr_cachePath()
                    \ )
        call ZF_ModuleExec('cd "%s" && git pull'
                    \ , ZF_Plugin_tldr_cachePath()
                    \ )
    endfunction
    call ZF_ModuleInstaller('ZF_Plugin_tldr', 'call ZF_Plugin_tldr_install()')
endif

if g:ZF_Plugin_tldr
    function! ZF_Plugin_tldr_run(cmd)
        if exists('*ZFAsyncRun')
            call ZFAsyncRun({
                        \   'jobCmd' : 'tldr ' . a:cmd,
                        \   'jobEnv' : ZF_Plugin_tldr_config(),
                        \ })
        else
            let env = ''
            let config = ZF_Plugin_tldr_config()
            for key in keys(config)
                let env .= printf('%s=%s ', key, config[key])
            endfor
            let result = ZF_system(env . 'tldr ' . a:cmd)
            " \x1b\[[0-9]+m
            let result = substitute(result, nr2char(27) . '\[[0-9]\+m', '', 'g')
            echo result
            let @t = result
        endif
    endfunction
    command! -nargs=+ -complete=shellcmd HelpTldr :call ZF_Plugin_tldr_run(<q-args>)
endif

