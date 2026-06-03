
" ============================================================
if !exists('g:zflsp_vim')
    let g:zflsp_vim = g:zflspEnable
endif
if g:zflsp_vim && !empty(ZF_ModuleGetNpm())
    function! ZF_LSP_vim_checker()
        return executable('vim-language-server')
    endfunction
    function! ZF_LSP_vim_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'vim-language-server')
    endfunction
    call ZFLSP_autoSetup(1, 'vim', function('ZF_LSP_vim_checker'), function('ZF_LSP_vim_installer'), {
                \   'cmd' : 'vim-language-server',
                \   'cmdargs' : ['--stdio'],
                \   'ft' : ['vim'],
                \   'initOption' : {
                \     'iskeyword' : &iskeyword,
                \     'vimruntime' : $VIMRUNTIME,
                \     'runtimepath' : &rtp,
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

