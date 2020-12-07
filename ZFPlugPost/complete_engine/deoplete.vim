
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

    ZFPlug 'Shougo/context_filetype.vim'
endif

" ==================================================
if !exists('g:ZF_Plugin_deoplete_vim_lsp')
    let g:ZF_Plugin_deoplete_vim_lsp = g:ZF_Plugin_deoplete
endif
if g:ZF_Plugin_deoplete_vim_lsp && g:ZF_Plugin_deoplete
    ZFPlug 'prabirshrestha/async.vim'
    ZFPlug 'prabirshrestha/vim-lsp'
    ZFPlug 'lighttiger2505/deoplete-vim-lsp'

    let g:lsp_signature_help_enabled = 0

    nnoremap zj :LspDefinition<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :LspRename<cr>
    nnoremap zu :LspDocumentDiagnostics<cr>
    nnoremap zi :LspCodeAction<cr>

    function! s:deoplete_vim_lsp()
        if get(g:, 'lsp_loaded', 0)
            for lsp in keys(g:zflsp)
                call lsp#register_server({
                            \   'name' : lsp,
                            \   'cmd' : [&shell, &shellcmdflag, ZFLSP_getFullCmd(g:zflsp[lsp])],
                            \   'whitelist' : g:zflsp[lsp].ft,
                            \   'initialization_options': ZFLSP_get(g:zflsp[lsp].options),
                            \ })
            endfor
        endif
    endfunction
    function! s:deoplete_vim_lsp_restart()
        if get(g:, 'lsp_loaded', 0)
            call s:deoplete_vim_lsp()
            silent! LspStopServer
        endif
    endfunction
    augroup ZF_Plugin_deoplete_vim_lsp_augroup
        autocmd!
        autocmd User ZFLSP_setup call s:deoplete_vim_lsp()
        autocmd User ZFLSP_restart call s:deoplete_vim_lsp_restart()
    augroup END
endif

