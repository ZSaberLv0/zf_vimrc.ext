
" ==================================================
if !exists('g:ZF_Plugin_asyncomplete')
    let g:ZF_Plugin_asyncomplete = (get(g:, 'ZF_Plugin_complete_engine', '') == 'asyncomplete')
endif
if v:version < 800
    let g:ZF_Plugin_asyncomplete = 0
endif

" ==================================================
if !exists('g:ZF_Plugin_asyncomplete_vim_lsp')
    let g:ZF_Plugin_asyncomplete_vim_lsp = g:ZF_Plugin_asyncomplete
endif
if g:ZF_Plugin_asyncomplete_vim_lsp && g:ZF_Plugin_asyncomplete
    ZFPlug 'prabirshrestha/asyncomplete.vim'
    ZFPlug 'prabirshrestha/vim-lsp'
    ZFPlug 'prabirshrestha/asyncomplete-lsp.vim'

    let g:lsp_signature_help_enabled = 0

    nnoremap zj :LspDefinition<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :LspRename<cr>
    nnoremap zu :LspDocumentDiagnostics<cr>
    nnoremap zi :LspCodeAction<cr>

    function! s:asyncomplete_vim_lsp()
        if get(g:, 'lsp_loaded', 0)
            for lsp in keys(g:zflsp)
                call lsp#register_server({
                            \   'name' : lsp,
                            \   'cmd' : [&shell, &shellcmdflag, ZFLSP_getFullCmd(g:zflsp[lsp])],
                            \   'whitelist' : g:zflsp[lsp].ft,
                            \   'initialization_options': ZFLSP_get(g:zflsp[lsp].options),
                            \ })
            endfor
        endif
    endfunction
    function! s:asyncomplete_vim_lsp_restart()
        if get(g:, 'lsp_loaded', 0)
            call s:asyncomplete_vim_lsp()
            silent! LspStopServer
        endif
    endfunction
    augroup ZF_Plugin_asyncomplete_vim_lsp_augroup
        autocmd!
        autocmd User ZFLSP_setup call s:asyncomplete_vim_lsp()
        autocmd User ZFLSP_restart call s:asyncomplete_vim_lsp_restart()
    augroup END
endif

