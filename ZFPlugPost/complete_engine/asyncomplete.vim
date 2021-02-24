
" ==================================================
if !exists('g:ZF_Plugin_asyncomplete')
    let g:ZF_Plugin_asyncomplete = (get(g:, 'ZF_Plugin_complete_engine', '') == 'asyncomplete')
endif
if v:version < 800
    let g:ZF_Plugin_asyncomplete = 0
endif
if g:ZF_Plugin_asyncomplete
    ZFPlug 'prabirshrestha/asyncomplete.vim'
    ZFPlug 'thomasfaingnaert/vim-lsp-ultisnips'
endif

" ==================================================
if !exists('g:ZF_Plugin_asyncomplete_vim_lsp')
    let g:ZF_Plugin_asyncomplete_vim_lsp = g:ZF_Plugin_asyncomplete
endif
if g:ZF_Plugin_asyncomplete_vim_lsp && g:ZF_Plugin_asyncomplete
    ZFPlug 'prabirshrestha/vim-lsp'
    ZFPlug 'prabirshrestha/asyncomplete-lsp.vim'
    call ZF_Plugin_vimlsp_setup()
endif

