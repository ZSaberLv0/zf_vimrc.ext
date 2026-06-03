
" ============================================================
if !exists('g:zflsp_go')
    let g:zflsp_go = g:zflspEnable
endif
if g:zflsp_go && executable('go')
    function! ZF_LSP_go_GOPATH()
        return CygpathFix_absPath(substitute(ZF_shellcache('go env GOPATH'), '[\r\n]', '', 'g'))
    endfunction
    function! ZF_LSP_go_checker()
        return executable('go') && executable(ZF_LSP_go_GOPATH() . '/bin/gopls')
    endfunction
    function! ZF_LSP_go_installer()
        call ZF_ModuleExecShell('go get golang.org/x/tools/gopls@latest')
    endfunction
    call ZFLSP_autoSetup(1, 'go', function('ZF_LSP_go_checker'), function('ZF_LSP_go_installer'), {
                \   'cmd' : ZF_LSP_go_GOPATH() . '/bin/gopls',
                \   'cmdargs' : [],
                \   'ft' : ['go'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

