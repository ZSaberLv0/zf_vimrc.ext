
" ==================================================
if !exists('g:ZF_Plugin_coc')
    let g:ZF_Plugin_coc = (get(g:, 'ZF_Plugin_complete_engine', '') == 'coc')
endif
if v:version < 800 || !executable('node')
    let g:ZF_Plugin_coc = 0
endif
if g:ZF_Plugin_coc
    ZFPlug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_disable_startup_warning = 1
    let g:coc_data_home = g:zf_vim_cache_path . '/ZFLSP_coc'
    if !exists('g:coc_global_extensions')
        let g:coc_global_extensions = []
    endif
    call add(g:coc_global_extensions, 'coc-json')
    call add(g:coc_global_extensions, 'coc-tag')
    call add(g:coc_global_extensions, 'coc-dictionary')
    let g:coc_user_config = {
                \   'coc' : {
                \     'preferences' : {
                \       'maxFileSize' : '1MB',
                \     },
                \   },
                \ }
    augroup ZF_Plugin_coc_largefile_augroup
        autocmd!
        autocmd User ZFVimLargeFile let b:coc_enabled=!b:zf_vim_largefile
    augroup END

    nnoremap zj :call CocAction('jumpDefinition')<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :call CocActionAsync('rename')<cr>
    nnoremap zu :CocDiagnostics<cr>
    nnoremap zi :CocFix<cr>
endif

" ==================================================
if !exists('g:ZF_Plugin_coc_lsp')
    let g:ZF_Plugin_coc_lsp = g:ZF_Plugin_coc
    " coc's extersion may be better than external LSP
    " let g:ZF_Plugin_coc_lsp = 0
endif
if g:ZF_Plugin_coc_lsp && g:ZF_Plugin_coc
    function! s:coc_lsp()
        if exists('*CocAction')
            for lsp in keys(g:zflsp)
                call coc#config('languageserver.' . lsp, {
                            \   'command': &shell,
                            \   'args': [&shellcmdflag, ZFLSP_getFullCmd(g:zflsp[lsp])],
                            \   'filetypes': g:zflsp[lsp].ft,
                            \   'initializationOptions': ZFLSP_get(g:zflsp[lsp].options),
                            \ })
            endfor
        endif
    endfunction
    function! s:coc_lsp_restart()
        if exists('*CocAction')
            call s:coc_lsp()
            silent! CocRestart
        endif
    endfunction
    augroup ZF_Plugin_coc_lsp_augroup
        autocmd!
        autocmd User ZFLSP_setup call s:coc_lsp()
        autocmd User ZFLSP_restart call s:coc_lsp_restart()
    augroup END
endif

" ==================================================
if !exists('g:ZF_Plugin_coc_lang')
    let g:ZF_Plugin_coc_lang = g:ZF_Plugin_coc && !g:ZF_Plugin_coc_lsp
endif
if g:ZF_Plugin_coc_lang && g:ZF_Plugin_coc
    call add(g:coc_global_extensions, 'coc-ccls')
    call add(g:coc_global_extensions, 'coc-css')
    call add(g:coc_global_extensions, 'coc-html')
    call add(g:coc_global_extensions, 'coc-java')
    call add(g:coc_global_extensions, 'coc-phpls')
    call add(g:coc_global_extensions, 'coc-python')
    call add(g:coc_global_extensions, 'coc-tsserver')
    call add(g:coc_global_extensions, 'coc-vimlsp')
endif

