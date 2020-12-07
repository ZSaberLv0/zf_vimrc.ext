
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

    let g:lsp_signature_help_enabled = 0

    nnoremap zj :LspDefinition<cr>
    nnoremap zk <c-o>
    nnoremap <f2> :LspRename<cr>
    nnoremap zu :LspDocumentDiagnostics<cr>
    nnoremap zi :LspCodeAction<cr>

    function! s:ncm2_vim_lsp()
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
    function! s:ncm2_vim_lsp_restart()
        if get(g:, 'lsp_loaded', 0)
            call s:ncm2_vim_lsp()
            silent! LspStopServer
        endif
    endfunction
    augroup ZF_Plugin_ncm2_vim_lsp_augroup
        autocmd!
        autocmd User ZFLSP_setup call s:ncm2_vim_lsp()
        autocmd User ZFLSP_restart call s:ncm2_vim_lsp_restart()
    augroup END
endif

