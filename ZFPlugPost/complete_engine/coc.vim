
" ==================================================
if !exists('g:ZF_Plugin_coc')
    let g:ZF_Plugin_coc = (get(g:, 'ZF_Plugin_complete_engine', '') == 'coc')
endif
if !(executable('node') && (1
                \   || (has('nvim') && has('nvim-0.4.0'))
                \   || (!has('nvim') && has('patch-8.1.1719'))
                \ ))
    let g:ZF_Plugin_coc = 0
endif
if g:ZF_Plugin_coc
    ZFPlug 'neoclide/coc.nvim', {'branch': 'release'}

    inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<cr>"
    inoremap <silent><expr> <tab> coc#pum#visible() ? coc#pum#next(1): "\<tab>"
    inoremap <expr><s-tab> coc#pum#visible() ? coc#pum#prev(1) : "\<nop>"

    let g:coc_disable_startup_warning = 1
    let g:coc_data_home = g:zf_vim_cache_path . '/ZFLSP_coc'
    if !isdirectory(g:coc_data_home)
        call mkdir(g:coc_data_home, 'p', 0755)
    endif
    if !exists('g:coc_global_extensions')
        let g:coc_global_extensions = []
    endif
    call add(g:coc_global_extensions, 'coc-json')
    call add(g:coc_global_extensions, 'coc-tag')
    call add(g:coc_global_extensions, 'coc-dictionary')
    let s:floatConfig = {
                \   'border' : 0,
                \   'highlight' : 'Pmenu',
                \   'close' : 0,
                \   'focusable' : 0,
                \   'shadow' : 0,
                \ }
    let g:coc_user_config = {
                \   'coc' : {
                \     'preferences' : {
                \       'maxFileSize' : '1MB',
                \       'rootPatterns' : [],
                \       'silentAutoupdate' : 1,
                \     },
                \   },
                \   'inlayHint' : {
                \     'enable' : 0,
                \   },
                \   'suggest' : {
                \     'noselect' : 1,
                \     'selection' : 'none',
                \     'enablePreselect' : 0,
                \     'floatConfig' : s:floatConfig,
                \   },
                \   'diagnostic' : {
                \     'messageTarget' : 'echo',
                \     'floatConfig' : s:floatConfig,
                \   },
                \   'signature' : {
                \     'floatConfig' : s:floatConfig,
                \   },
                \   'hover' : {
                \     'floatConfig' : s:floatConfig,
                \   },
                \   'floatFactory' : {
                \     'floatConfig' : s:floatConfig,
                \   },
                \ }
    augroup ZF_Plugin_coc_largefile_augroup
        autocmd!
        autocmd User ZFVimLargeFile let b:coc_enabled=!b:zf_vim_largefile
    augroup END

    nnoremap zj :call CocAction('jumpDefinition')<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :call CocActionAsync('rename')<cr>
    nnoremap <f3> :call CocAction('jumpReferences')<cr>
    nnoremap zu :CocDiagnostics<cr>
    nmap zi <plug>(coc-fix-current)
endif

" ==================================================
if !exists('g:ZF_Plugin_coc_lsp')
    let g:ZF_Plugin_coc_lsp = g:ZF_Plugin_coc
    " coc's extersion may be better than external LSP
    " let g:ZF_Plugin_coc_lsp = 0
endif
if g:ZF_Plugin_coc_lsp && g:ZF_Plugin_coc
    function! s:coc_lsp_restart()
        if !exists('*CocAction')
            return
        endif
        for lsp in keys(g:zflsp)
            call coc#config('languageserver.' . lsp, {
                        \   'command': &shell,
                        \   'args': [&shellcmdflag, ZFLSP_getFullCmd(g:zflsp[lsp])],
                        \   'filetypes': ZFLSP_get(get(g:zflsp[lsp], 'ft', [])),
                        \   'initializationOptions': ZFLSP_get(get(g:zflsp[lsp], 'initOption', {})),
                        \   'settings': ZFLSP_get(get(g:zflsp[lsp], 'workspaceOption', {})),
                        \ })
        endfor
        silent! CocRestart
    endfunction
    augroup ZF_Plugin_coc_lsp_augroup
        autocmd!
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

