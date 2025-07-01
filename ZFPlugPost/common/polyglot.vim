
" ==================================================
if !exists('g:ZF_Plugin_a')
    let g:ZF_Plugin_a = 1
endif
if g:ZF_Plugin_a
    ZFPlug 'taxilian/a.vim'
    augroup ZF_Plugin_a_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal
                    \  silent! iunmap <Leader>ih
                    \| silent! nunmap <Leader>ih
                    \| silent! iunmap <Leader>is
                    \| silent! nunmap <Leader>is
                    \| silent! iunmap <Leader>ihn
                    \| silent! nunmap <Leader>ihn
    augroup END
endif

" ==================================================
if !exists('g:ZF_Plugin_caw')
    let g:ZF_Plugin_caw = 1
endif
if v:version < 800
    let g:ZF_Plugin_caw = 0
endif
if g:ZF_Plugin_caw
    ZFPlug 'tyru/caw.vim'
    let g:caw_no_default_keymappings = 1
    nmap CC <Plug>(caw:hatpos:toggle)
    xmap CC <Plug>(caw:hatpos:toggle)
    nmap C? <Plug>(caw:wrap:comment)
    xmap C? <Plug>(caw:wrap:comment)
    nmap C/ <Plug>(caw:wrap:uncomment)
    xmap C/ <Plug>(caw:wrap:uncomment)
endif
if !exists('g:ZF_Plugin_nerdcommenter')
    let g:ZF_Plugin_nerdcommenter = 1
endif
if g:ZF_Plugin_caw
    let g:ZF_Plugin_nerdcommenter = 0
endif
if g:ZF_Plugin_nerdcommenter
    ZFPlug 'preservim/nerdcommenter'
    let g:NERDCreateDefaultMappings = 0
    let g:NERDCommentEmptyLines = 1
    let g:NERDSpaceDelims = 1
    map CC <plug>NERDCommenterToggle
    map C? <plug>NERDCommenterMinimal
    map C/ <plug>NERDCommenterUncomment
endif

