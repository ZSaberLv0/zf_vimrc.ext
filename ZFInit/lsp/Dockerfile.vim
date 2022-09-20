
" ============================================================
if !exists('g:zflsp_Dockerfile')
    let g:zflsp_Dockerfile = g:zflspEnable
endif
if g:zflsp_Dockerfile && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_Dockerfile_checker()
        return executable('docker-langserver')
    endfunction
    function! ZF_LSP_Dockerfile_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'dockerfile-language-server-nodejs')
    endfunction
    call ZFLSP_autoSetup(1, 'Dockerfile', function('ZF_LSP_Dockerfile_checker'), function('ZF_LSP_Dockerfile_installer'), {
                \   'cmd' : 'docker-langserver',
                \   'cmdargs' : ['--stdio'],
                \   'ft' : ['Dockerfile', 'dockerfile'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

