
" ==================================================
if !exists('g:ZF_Plugin_deoplete')
    let g:ZF_Plugin_deoplete = (get(g:, 'ZF_Plugin_complete_engine', '') == 'deoplete')
endif
if v:version < 800 || (!has('python') && !has('python3'))
    let g:ZF_Plugin_deoplete = 0
endif
if g:ZF_Plugin_deoplete && !has('nvim')
    function! ZF_Plugin_deoplete_install()
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'pynvim')
    endfunction
    call ZF_ModuleInstaller('deoplete', 'call ZF_Plugin_deoplete_install()')

    if !ZF_pynvim_check()
        let g:ZF_Plugin_deoplete = 0
    endif
endif

if g:ZF_Plugin_deoplete
    if has('nvim')
        ZFPlug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        ZFPlug 'Shougo/deoplete.nvim'
        ZFPlug 'roxma/nvim-yarp'
        ZFPlug 'roxma/vim-hug-neovim-rpc'
    endif
    let g:deoplete#enable_at_startup = 1
    function! ZF_Plugin_deoplete_setup()
        if !exists('*deoplete#custom#option')
            return
        endif
        call deoplete#custom#option('min_pattern_length', 1)
        call deoplete#custom#source('buffer', 'require_same_filetype', v:false)
    endfunction
    augroup ZF_Plugin_deoplete_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal call ZF_Plugin_deoplete_setup()
    augroup END
endif

" ==================================================
if !exists('g:ZF_Plugin_deoplete_vim_lsp')
    let g:ZF_Plugin_deoplete_vim_lsp = g:ZF_Plugin_deoplete
endif
if g:ZF_Plugin_deoplete_vim_lsp && g:ZF_Plugin_deoplete
    ZFPlug 'prabirshrestha/async.vim'
    ZFPlug 'prabirshrestha/vim-lsp'
    ZFPlug 'lighttiger2505/deoplete-vim-lsp'
    call ZF_Plugin_vimlsp_setup()
endif

