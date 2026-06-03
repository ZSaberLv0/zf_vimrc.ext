
if !exists('g:ZF_Plugin_neoformat')
    let g:ZF_Plugin_neoformat = 1
endif
if g:ZF_Plugin_neoformat
    ZFPlug 'sbdchd/neoformat'

    nnoremap <leader>cf :call ZF_Formater()<cr>
    " note, for Windows python users, you may want to:
    " -  add `.py` to `PATHEXT`
    function! ZF_Plugin_neoformat_install()
        call ZF_ModulePackAdd(ZF_ModuleGetApt(), 'astyle clang-format shfmt swiftformat tidy uncrustify')
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'cmake_format jsbeautifier sqlparse yapf')
        call ZF_ModulePackAdd(ZF_ModuleGetNpm(), 'eslint lua-fmt prettier typescript typescript-formatter')
    endfunction
    call ZF_ModuleInstaller('neoformat', 'call ZF_Plugin_neoformat_install()')
endif

