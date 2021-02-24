
function! ZF_Plugin_vimlsp_setup()
    " disable for performance
    let g:lsp_diagnostics_highlights_enabled = 0
    let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
    let g:lsp_document_highlight_enabled = 0
    let g:lsp_signature_help_enabled = 0
    let g:lsp_fold_enabled = 0
    let g:lsp_semantic_enabled = 0

    nnoremap zj :LspDefinition<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :LspRename<cr>
    nnoremap zu :LspDocumentDiagnostics<cr>
    nnoremap zi :LspCodeAction<cr>

    function! s:vimlsp()
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
    function! s:vimlsp_restart()
        if get(g:, 'lsp_loaded', 0)
            call s:vimlsp()
            silent! LspStopServer
        endif
    endfunction
    augroup ZF_Plugin_vimlsp_setup_augroup
        autocmd!
        autocmd User ZFLSP_setup call s:vimlsp()
        autocmd User ZFLSP_restart call s:vimlsp_restart()
    augroup END
endfunction

