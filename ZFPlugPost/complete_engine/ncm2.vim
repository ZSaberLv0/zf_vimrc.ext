
" ==================================================
if !exists('g:ZF_Plugin_ncm2')
    let g:ZF_Plugin_ncm2 = (get(g:, 'ZF_Plugin_complete_engine', '') == 'ncm2')
endif
if v:version < 800 || !has('python3')
    let g:ZF_Plugin_ncm2 = 0
endif
if g:ZF_Plugin_ncm2 && !has('nvim')
    function! ZF_Plugin_ncm2_install()
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'pynvim')
    endfunction
    call ZF_ModuleInstaller('ncm2', 'call ZF_Plugin_ncm2_install()')

    if !ZF_pynvim_check()
        let g:ZF_Plugin_ncm2 = 0
    endif
endif

if g:ZF_Plugin_ncm2
    ZFPlug 'ncm2/ncm2'
    ZFPlug 'roxma/nvim-yarp'
    if !has('nvim')
        ZFPlug 'roxma/vim-hug-neovim-rpc'
    endif

    inoremap <c-c> <esc>

    augroup ZF_Plugin_ncm2_augroup
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
        autocmd User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
        autocmd User Ncm2PopupClose set completeopt=menuone
    augroup END

    ZFPlug 'ncm2/ncm2-bufword'
    ZFPlug 'ncm2/ncm2-path'
    ZFPlug 'yuki-ycino/ncm2-dictionary'
    ZFPlug 'ncm2/ncm2-markdown-subscope'
endif

" ==================================================
if !exists('g:ZF_Plugin_ncm2_vim_lsp')
    let g:ZF_Plugin_ncm2_vim_lsp = g:ZF_Plugin_ncm2
endif
if g:ZF_Plugin_ncm2_vim_lsp && g:ZF_Plugin_ncm2
    ZFPlug 'prabirshrestha/async.vim'
    ZFPlug 'prabirshrestha/vim-lsp'
    ZFPlug 'ncm2/ncm2-vim-lsp'
    call ZF_Plugin_vimlsp_setup()
endif

