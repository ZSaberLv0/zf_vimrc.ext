
if !exists('g:ZF_Plugin_codeium')
    let g:ZF_Plugin_codeium = 0
endif
if has('nvim')
    if !has('nvim-0.6')
        let g:ZF_Plugin_codeium = 0
    endif
else
    if v:version < 900
        let g:ZF_Plugin_codeium = 0
    endif
endif
if g:ZF_Plugin_codeium
    ZFPlug 'Exafunction/codeium.vim'
    let g:codeium_tab_fallback = ''
    let g:codeium_manual = 0
    imap <script><silent><nowait><expr> <m-l> codeium#Accept()
    imap <m-f> <Plug>(codeium-complete)
endif

