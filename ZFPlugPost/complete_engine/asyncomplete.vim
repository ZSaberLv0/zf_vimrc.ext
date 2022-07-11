
" ==================================================
if !exists('g:ZF_Plugin_asyncomplete')
    let g:ZF_Plugin_asyncomplete = (get(g:, 'ZF_Plugin_complete_engine', '') == 'asyncomplete')
endif
if v:version < 800
    let g:ZF_Plugin_asyncomplete = 0
endif
if g:ZF_Plugin_asyncomplete
    ZFPlug 'prabirshrestha/asyncomplete.vim'

    ZFPlug 'prabirshrestha/asyncomplete-buffer.vim'
    " https://github.com/prabirshrestha/asyncomplete-file.vim/issues/4
    " ZFPlug 'prabirshrestha/asyncomplete-file.vim'
    ZFPlug 'prabirshrestha/asyncomplete-ultisnips.vim'
    function! s:source()
        let maxSize = 2*1024*1024
        call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                    \   'name': 'buffer',
                    \   'allowlist': ['*'],
                    \   'completor': function('asyncomplete#sources#buffer#completor'),
                    \   'config': {
                    \      'max_buffer_size': maxSize,
                    \   },
                    \ }))
        " call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
        "            \   'name': 'file',
        "            \   'allowlist': ['*'],
        "            \   'priority': 10,
        "            \   'completor': function('asyncomplete#sources#file#completor')
        "            \ }))
        call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
                    \ 'name': 'ultisnips',
                    \ 'allowlist': ['*'],
                    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
                    \ }))
    endfunction
    augroup ZF_Plugin_asyncomplete_source
        autocmd!
        autocmd User asyncomplete_setup call s:source()
    augroup END
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

