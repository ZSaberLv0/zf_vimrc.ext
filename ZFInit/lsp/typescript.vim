
" ============================================================
if !exists('g:zflsp_typescript')
    let g:zflsp_typescript = g:zflspEnable
endif
if g:zflsp_typescript && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_typescript_checker()
        return executable('typescript-language-server')
    endfunction
    function! ZF_LSP_typescript_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'typescript typescript-language-server')
    endfunction
    call ZFLSP_autoSetup(1, 'typescript', function('ZF_LSP_typescript_checker'), function('ZF_LSP_typescript_installer'), {
                \   'cmd' : 'typescript-language-server',
                \   'cmdargs' : ['--stdio'],
                \   'ft' : ['typescript', 'typescript.tsx', 'javascript', 'javascript.jsx'],
                \   'options' : {
                \   },
                \   'settings' : {
                \   },
                \ })
endif

