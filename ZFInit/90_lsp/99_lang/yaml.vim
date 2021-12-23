
" ============================================================
if !exists('g:zflsp_yaml')
    let g:zflsp_yaml = g:zflspEnable
endif
if g:zflsp_yaml && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_yaml_checker()
        return executable('yaml-language-server')
    endfunction
    function! ZF_LSP_yaml_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'yaml-language-server')
    endfunction
    call ZFLSP_autoSetup(1, 'yaml', function('ZF_LSP_yaml_checker'), function('ZF_LSP_yaml_installer'), {
                \   'cmd' : 'yaml-language-server',
                \   'cmdargs' : ['--stdio'],
                \   'ft' : ['yaml'],
                \   'options' : {
                \   },
                \   'settings' : {
                \   },
                \ })
endif

