
" ============================================================
if !exists('g:zflsp_vue')
    let g:zflsp_vue = g:zflspEnable
endif
if g:zflsp_vue && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_vue_checker()
        return executable('vls')
    endfunction
    function! ZF_LSP_vue_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'vls')
    endfunction
    call ZFLSP_autoSetup(1, 'vue', function('ZF_LSP_vue_checker'), function('ZF_LSP_vue_installer'), {
                \   'cmd' : 'vls',
                \   'cmdargs' : [],
                \   'ft' : ['vue'],
                \   'options' : {
                \     'config' : {
                \       'vetur' : {
                \         'ignoreProjectWarning' : 1,
                \       },
                \     },
                \   },
                \   'settings' : {
                \   },
                \ })
endif

