
" ============================================================
if !exists('g:zflsp_lua')
    let g:zflsp_lua = g:zflspEnable
endif
if g:zflsp_lua && executable('java')
    function! ZF_LSP_lua_archiveFile()
        return g:zf_vim_cache_path . '/ZFLSP_EmmyLua/EmmyLua-LS-all.jar'
    endfunction
    function! ZF_LSP_lua_stdPath()
        return g:zf_vim_cache_path . '/ZFLSP_EmmyLua/EmmyLua_stdFolder'
    endfunction

    function! ZF_LSP_lua_checker()
        return filereadable(ZF_LSP_lua_archiveFile())
                    \ && filereadable(ZF_LSP_lua_stdPath() . '/README.md')
    endfunction
    function! ZF_LSP_lua_installer()
        if !filereadable(ZF_LSP_lua_archiveFile())
            let fileUrl = ''
            for fileUrlTmp in ZF_ModuleGetGithubRelease('EmmyLua', 'EmmyLua-LanguageServer')
                if match(fileUrlTmp, 'EmmyLua-LS-all\.jar') >= 0
                    let fileUrl = fileUrlTmp
                endif
            endfor
            if empty(fileUrl)
                echo 'ERROR: unable to obtain release'
                return
            endif
        endif

        call ZF_ModuleGitClone(get(g:, 'zf_githost', 'https://github.com') . '/ZSaberLv0/EmmyLua_stdFolder', ZF_LSP_lua_stdPath())
    endfunction
    call ZFLSP_autoSetup(1, 'lua', function('ZF_LSP_lua_checker'), function('ZF_LSP_lua_installer'), {
                \   'cmd' : 'java',
                \   'cmdargs' : ['-cp', ZF_LSP_lua_archiveFile(), 'com.tang.vscode.MainKt'],
                \   'ft' : ['lua'],
                \   'initOption' : {
                \     'stdFolder' : 'file://' . ZF_LSP_lua_stdPath() . '/std/Lua54',
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

