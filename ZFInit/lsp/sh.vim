
" ============================================================
if !exists('g:zflsp_sh')
    let g:zflsp_sh = g:zflspEnable
endif
if g:zflsp_sh && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_sh_checker()
        return executable('bash-language-server')
    endfunction
    function! ZF_LSP_sh_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'bash-language-server')
    endfunction
    call ZFLSP_autoSetup(1, 'sh', function('ZF_LSP_sh_checker'), function('ZF_LSP_sh_installer'), {
                \   'cmd' : 'bash-language-server',
                \   'cmdargs' : ['start'],
                \   'ft' : ['sh'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

