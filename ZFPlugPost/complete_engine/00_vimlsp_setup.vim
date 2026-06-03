
function! ZF_Plugin_vimlsp_setup()
    " disable for performance
    let g:lsp_document_code_action_signs_enabled = 0
    let g:lsp_diagnostics_highlights_enabled = 0
    let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
    let g:lsp_diagnostics_virtual_text_enabled = 0
    let g:lsp_document_highlight_enabled = 0
    let g:lsp_signature_help_enabled = 0
    let g:lsp_fold_enabled = 0
    let g:lsp_semantic_enabled = 0

    nnoremap zj :LspDefinition<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :LspRename<cr>
    nnoremap <f3> :LspReferences<cr>
    nnoremap zu :LspDocumentDiagnostics<cr>
    nnoremap zi :LspCodeAction<cr>
    nnoremap zo :LspCodeAction source.organizeImports<cr>

    function! s:vimlsp_setupSetver(server_info)
        let lsp = a:server_info['name']
        call extend(a:server_info, {
                    \   'name' : lsp,
                    \   'cmd' : [&shell, &shellcmdflag, ZFLSP_getFullCmd(g:zflsp[lsp])],
                    \   'whitelist' : get(g:zflsp[lsp], 'ft', []),
                    \   'root_uri': function('s:vimlsp_root_uri'),
                    \   'initialization_options': ZFLSP_get(get(g:zflsp[lsp], 'initOption', {})),
                    \   'workspace_config': ZFLSP_get(get(g:zflsp[lsp], 'workspaceOption', {})),
                    \ })
    endfunction
    function! s:vimlsp_root_uri(server_info)
        let lsp = a:server_info['name']
        let path = ZFLSP_get(get(g:zflsp[lsp], 'rootUri', ''))
        return lsp#utils#path_to_uri(path)
    endfunction
    function! s:vimlsp_restart()
        if !get(g:, 'lsp_loaded', 0)
            return
        endif
        silent! LspStopServer
        for lsp in keys(g:zflsp)
            let server_info = {
                        \   'name' : lsp,
                        \ }
            call s:vimlsp_setupSetver(server_info)
            call lsp#register_server(server_info)
        endfor
        silent! LspStopServer
    endfunction
    augroup ZF_Plugin_vimlsp_setup_augroup
        autocmd!
        autocmd User ZFLSP_restart call s:vimlsp_restart()
    augroup END
endfunction

