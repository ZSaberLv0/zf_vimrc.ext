
" ============================================================
if !exists('g:zflsp_lua')
    let g:zflsp_lua = g:zflspEnable
endif
if g:zflsp_lua && executable('cargo') && get(g:, 'zflsp_lua_impl', '') == 'emmylua_ls'
    function! ZF_LSP_lua_checker()
        return executable('emmylua_ls')
    endfunction
    function! ZF_LSP_lua_installer()
        call ZF_ModuleExecShell(printf('cargo install emmylua_ls'))
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
    call ZFLSP_autoSetup(1, 'lua', function('ZF_LSP_lua_checker'), function('ZF_LSP_lua_installer'), {
                \   'cmd' : 'emmylua_ls',
                \   'cmdargs' : [
                \   ],
                \   'ft' : ['lua'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : function('ZF_LSP_lua_config'),
                \ })
endif

