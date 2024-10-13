
" ============================================================
if !exists('g:zflsp_lua')
    let g:zflsp_lua = g:zflspEnable
endif
if g:zflsp_lua
    function! ZF_LSP_lua_checker()
        return executable('lua-language-server')
    endfunction
    function! ZF_LSP_lua_installer()
        call ZF_ModulePackAdd(ZF_ModuleGetApt(), 'lua-language-server')
        call ZF_LSP_lua_configUpdate()
    endfunction
    function! ZF_LSP_lua_config(...)
        let ignore = ['.vscode']
        if !ZF_LSP_lua_isValidWorkspace()
            for f in glob('./*', 1, 1)
                if isdirectory(f)
                    call add(ignore, fnamemodify(f, ':t'))
                endif
            endfor
        endif
        return {
                    \   'Lua' : {
                    \     'completion.autoRequire' : v:false,
                    \     'completion.callSnippet' : 'Replace',
                    \     'diagnostics.disable' : [
                    \       'assign-type-mismatch',
                    \       'cast-local-type',
                    \       'lowercase-global',
                    \       'missing-parameter',
                    \       'need-check-nil',
                    \       'param-type-mismatch',
                    \       'redefined-local',
                    \       'unused-local',
                    \     ],
                    \     'workspace.preloadFileSize' : 10240,
                    \     'workspace.useGitIgnore' : v:false,
                    \     'workspace.ignoreDir' : ignore,
                    \   },
                    \ }
    endfunction
    function! ZF_LSP_lua_configUpdate()
        call writefile([json_encode(ZF_LSP_lua_config())], printf('%s/config.json', ZF_LSP_lua_cachePath()))
    endfunction
    function! ZF_LSP_lua_cachePath()
        return g:zf_vim_cache_path . '/ZFLSP_lua'
    endfunction
    function! ZF_LSP_lua_isValidWorkspace()
        let Fn = get(g:, 'ZFLSP_lua_workspaceChecker', '')
        if !empty(Fn)
            return Fn()
        else
            return 0
                        \ || isdirectory('.git')
                        \ || filereadable('.gitignore')
                        \ || filereadable('.gitattributes')
                        \ || isdirectory('.svn')
                        \ || !empty(glob('./*.lua'))
        endif
    endfunction
    call ZFLSP_autoSetup(1, 'lua', function('ZF_LSP_lua_checker'), function('ZF_LSP_lua_installer'), {
                \   'cmd' : 'lua-language-server',
                \   'cmdargs' : [
                \     printf('--logpath="%s/logs"', ZF_LSP_lua_cachePath()),
                \     printf('--metapath="%s/meta"', ZF_LSP_lua_cachePath()),
                \   ],
                \   'ft' : ['lua'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : function('ZF_LSP_lua_config'),
                \ })
endif

