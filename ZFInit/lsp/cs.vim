
" ============================================================
if !exists('g:zflsp_cs')
    let g:zflsp_cs = g:zflspEnable
endif
if has('nvim')
    if !(exists('*jobstart') && has('lambda'))
        let g:zflsp_cs = 0
    endif
else
    if !(has('job') && has('channel') && has('lambda'))
        let g:zflsp_cs = 0
    endif
endif
if g:zflsp_cs
    augroup ZF_LSP_cs_install_augroup
        autocmd!
        autocmd User ZFVimrcPlug ZFPlug 'OmniSharp/omnisharp-vim'
    augroup END
    let g:OmniSharp_server_install = g:zf_vim_cache_path . '/ZFLSP_omnisharp-vim'
    let g:OmniSharp_server_stdio = 1

    if !filereadable(g:OmniSharp_server_install . '/run')
                \ && !filereadable(g:OmniSharp_server_install . '/OmniSharp.exe')
        let g:OmniSharp_start_server = 0

        function! ZF_LSP_cs_install()
            call OmniSharp#Install()
        endfunction
        call ZF_ModuleInstaller('ZF_LSP_cs', 'call ZF_LSP_cs_install()')
    endif
endif

