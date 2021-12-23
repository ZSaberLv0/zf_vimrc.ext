
" ==================================================
if !exists('g:ZF_Plugin_CompleteParameter')
    let g:ZF_Plugin_CompleteParameter = g:zflspEnable
endif
if !exists('v:completed_item')
    let g:ZF_Plugin_CompleteParameter = 0
endif
if g:ZF_Plugin_CompleteParameter
    ZFPlug 'tenfyzhong/CompleteParameter.vim'
    if get(g:, 'ZF_Plugin_CompleteParameter_generic', 1)
        ZFPlug 'ZSaberLv0/CompleteParameter_generic.vim'
    endif

    let g:complete_parameter_use_ultisnips_mappings = 0
    function! ZF_Plugin_CompleteParameter_tab(forward)
        if pumvisible()
            return a:forward ? "\<c-n>" : "\<c-p>"
        endif
        if cmp#jumpable(a:forward)
            if a:forward
                return "\<Plug>(complete_parameter#goto_next_parameter)"
            else
                return "\<Plug>(complete_parameter#goto_previous_parameter)"
            endif
        endif
        if a:forward
            let line = getline('.')
            let col = col('.')
            if col <= 1 || len(line) < col - 2 || line[col - 2] == ' ' || line[col - 2] == "\<tab>"
                return "\<tab>"
            endif
            return "\<c-x>\<c-u>"
        endif
        return ''
    endfunction
    function! ZF_Plugin_CompleteParameter_tab_n()
        return ZF_Plugin_CompleteParameter_tab(1)
    endfunction
    function! ZF_Plugin_CompleteParameter_tab_p()
        return ZF_Plugin_CompleteParameter_tab(0)
    endfunction
    function! ZF_Plugin_CompleteParameter_setting()
        inoremap <silent><expr> <cr> pumvisible() ? "\<c-y>" . complete_parameter#pre_complete('') : "\<c-g>u\<cr>"

        nmap <tab> <Plug>(complete_parameter#goto_next_parameter)
        smap <tab> <Plug>(complete_parameter#goto_next_parameter)
        imap <silent><expr> <tab> ZF_Plugin_CompleteParameter_tab_n()

        nmap <s-tab> <Plug>(complete_parameter#goto_previous_parameter)
        smap <s-tab> <Plug>(complete_parameter#goto_previous_parameter)
        imap <silent><expr> <s-tab> ZF_Plugin_CompleteParameter_tab_p()

        nmap <c-tab> <Plug>(complete_parameter#overload_down)
        smap <c-tab> <Plug>(complete_parameter#overload_down)
        imap <c-tab> <Plug>(complete_parameter#overload_down)
    endfunction
    augroup ZF_Plugin_CompleteParameter_augroup
        autocmd!
        autocmd FileType * call ZF_Plugin_CompleteParameter_setting()
    augroup END
endif

