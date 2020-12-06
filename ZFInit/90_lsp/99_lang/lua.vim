
" ============================================================
if !exists('g:zflsp_lua')
    let g:zflsp_lua = g:zflspEnable
endif
if g:zflsp_lua && executable('java')
    function! ZF_LSP_lua_archiveFile()
        return g:zf_vim_cache_path . '/ZFLSP_EmmyLua/EmmyLua-LS-all.jar'
    endfunction

    function! ZF_LSP_lua_checker()
        return filereadable(ZF_LSP_lua_archiveFile())
    endfunction
    function! ZF_LSP_lua_installer()
        let fileUrl = ZF_ModuleGetGithubRelease('EmmyLua', 'EmmyLua-LanguageServer')
        if empty(fileUrl) || match(fileUrl[0], 'EmmyLua-LS-all\.jar') < 0
            return
        endif
        if !ZF_LSP_lua_checker()
            call ZF_ModuleDownloadFile(ZF_LSP_lua_archiveFile(), fileUrl[0])
        endif
    endfunction
    call ZFLSP_autoSetup(1, 'lua', function('ZF_LSP_lua_checker'), function('ZF_LSP_lua_installer'), {
                \   'cmd' : 'java',
                \   'cmdargs' : ['-cp', ZF_LSP_lua_archiveFile(), 'com.tang.vscode.MainKt'],
                \   'ft' : ['lua'],
                \   'options' : {
                \   },
                \ })
endif

