
" ============================================================
if !exists('g:zflsp_python')
    let g:zflsp_python = g:zflspEnable
endif
if g:zflsp_python && !empty(ZF_ModuleGetPip())
    function! ZF_LSP_python_checker()
        return executable('jedi-language-server')
    endfunction
    function! ZF_LSP_python_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'jedi-language-server')
    endfunction
    call ZFLSP_autoSetup(1, 'python', function('ZF_LSP_python_checker'), function('ZF_LSP_python_installer'), {
                \   'cmd' : 'jedi-language-server',
                \   'cmdargs' : [],
                \   'ft' : ['python'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

