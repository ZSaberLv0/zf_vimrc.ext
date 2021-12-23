
" ============================================================
if !exists('g:zflsp_php')
    let g:zflsp_php = g:zflspEnable
endif
if g:zflsp_php && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_php_storagePath()
        return g:zf_vim_cache_path . '/ZFLSP_intelephense'
    endfunction

    function! ZF_LSP_php_checker()
        return executable('node')
    endfunction
    function! ZF_LSP_php_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'intelephense')
    endfunction
    call ZFLSP_autoSetup(1, 'php', function('ZF_LSP_php_checker'), function('ZF_LSP_php_installer'), {
                \   'cmd' : 'intelephense',
                \   'cmdargs' : ['--stdio'],
                \   'ft' : ['php'],
                \   'options' : {
                \     'storagePath' : ZF_LSP_php_storagePath() . '/storage',
                \     'globalStoragePath' : ZF_LSP_php_storagePath() . '/globalStorage',
                \     'clearCache' : 1,
                \   },
                \   'settings' : {
                \   },
                \ })
endif

