
" ==================================================
if !exists('g:ZF_Plugin_YouCompleteMe')
    let g:ZF_Plugin_YouCompleteMe = (get(g:, 'ZF_Plugin_complete_engine', '') == 'ycm')
endif
if v:version < 800 || (!has('python') && !has('python3'))
    let g:ZF_Plugin_YouCompleteMe = 0
endif
if g:ZF_Plugin_YouCompleteMe
    let g:ZF_Plugin_YouCompleteMe_install_cmd = ''
    if get(g:, 'ZF_Plugin_YouCompleteMe_lang_c', 1) == 1
        let g:ZF_Plugin_YouCompleteMe_install_cmd .= ' --clang-completer'
    endif

    if get(g:, 'ZF_Plugin_YouCompleteMe_lang_cs') == 1
        let g:ZF_Plugin_YouCompleteMe_install_cmd .= ' --cs-completer'
    endif

    if get(g:, 'ZF_Plugin_YouCompleteMe_lang_go') == 1
        let g:ZF_Plugin_YouCompleteMe_install_cmd .= ' --go-completer'
    endif

    if get(g:, 'ZF_Plugin_YouCompleteMe_lang_ts') == 1
        let g:ZF_Plugin_YouCompleteMe_install_cmd .= ' --ts-completer'
    endif

    if get(g:, 'ZF_Plugin_YouCompleteMe_lang_rust') == 1
        let g:ZF_Plugin_YouCompleteMe_install_cmd .= ' --rust-completer'
    endif

    if get(g:, 'ZF_Plugin_YouCompleteMe_lang_java') == 1
        let g:ZF_Plugin_YouCompleteMe_install_cmd .= ' --java-completer'
    endif

    function! ZF_Plugin_YouCompleteMe_install()
        call ZF_ModulePackAdd(ZF_ModuleGetPip(), 'jedi')

        let path = CygpathFix_absPath(globpath('*/YouCompleteMe', 'install.py'), ':p')
        if empty(path)
            echomsg 'unable to find YCM install.py'
            return
        endif
        call ZF_ModulePackAddShell('"' . path . '" ' . g:ZF_Plugin_YouCompleteMe_install_cmd)
    endfunction
    call ZF_ModuleInstaller('YouCompleteMe', 'call ZF_Plugin_YouCompleteMe_install()')

    ZFPlug 'Valloric/YouCompleteMe', {'do' : './install.py' . g:ZF_Plugin_YouCompleteMe_install_cmd}
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_key_invoke_completion = '<c-x><c-u>'
    let g:ycm_key_list_select_completion = ['<Down>']
    let g:ycm_key_list_previous_completion = ['<Up>']
    let g:ycm_semantic_triggers = {
                \     'c,cpp,objcpp' : 're![a-zA-Z_]',
                \ }
    nnoremap zj :YcmCompleter GoTo<cr>
    nnoremap zk <c-o>

    ZFPlug 'ZSaberLv0/ycm_conf_default'
    let g:ycm_global_ycm_extra_conf = g:zf_vim_data_path . '/bundle/ycm_conf_default/ycm_extra_conf.py'
endif

