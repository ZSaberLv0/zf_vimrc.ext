
" ============================================================
if !exists('g:zflsp_cmake')
    let g:zflsp_cmake = g:zflspEnable
endif
if g:zflsp_cmake && !empty(ZF_ModuleGetPip())
    function! ZF_LSP_cmake_checker()
        return executable('cmake-language-server')
    endfunction
    function! ZF_LSP_cmake_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'cmake-language-server')
    endfunction
    call ZFLSP_autoSetup(1, 'cmake', function('ZF_LSP_cmake_checker'), function('ZF_LSP_cmake_installer'), {
                \   'cmd' : 'cmake-language-server',
                \   'cmdargs' : [],
                \   'ft' : ['cmake'],
                \   'initOption' : {
                \     'buildDirectory' : 'build',
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

