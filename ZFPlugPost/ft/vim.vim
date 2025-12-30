
" ==================================================
if !exists('g:ZF_Plugin_vim_lookup')
    let g:ZF_Plugin_vim_lookup = 1
endif
if g:ZF_Plugin_vim_lookup
    ZFPlug 'mhinz/vim-lookup'
    augroup ZF_Plugin_vim_lookup_augroup
        autocmd!
        autocmd FileType vim nnoremap <buffer><silent> zj :call lookup#lookup()<cr>
        autocmd FileType vim nnoremap <buffer><silent> zk :call lookup#pop()<cr>
    augroup END
endif

