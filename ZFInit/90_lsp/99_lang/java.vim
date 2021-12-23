
" ============================================================
if !exists('g:zflsp_java')
    let g:zflsp_java = g:zflspEnable
endif
if g:zflsp_java && executable('java')
    function! ZF_LSP_java_archiveFile()
        return g:zf_vim_cache_path . '/ZFLSP_jdt/jdt-language-server-latest.tar.gz'
    endfunction
    function! ZF_LSP_java_contentsPath()
        return g:zf_vim_cache_path . '/ZFLSP_jdt/contents'
    endfunction
    function! ZF_LSP_java_cachePath()
        return g:zf_vim_cache_path . '/ZFLSP_jdt/cache'
    endfunction

    function! ZF_LSP_java_checker()
        return executable('tar') && filereadable(ZF_LSP_java_archiveFile())
    endfunction
    function! ZF_LSP_java_installer()
        if !executable('tar')
            echo 'ERROR: no tar available'
            return
        endif
        if !filereadable(ZF_LSP_java_archiveFile())
            call ZF_ModuleDownloadFile(ZF_LSP_java_archiveFile(), 'http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz')
        endif
        if filereadable(ZF_LSP_java_archiveFile())
            call system('mkdir "' . ZF_LSP_java_contentsPath() . '"')
            call system('tar zxf "' . ZF_LSP_java_archiveFile() . '" -C "' . ZF_LSP_java_contentsPath() . '/."')
        endif
    endfunction
    function! ZF_LSP_java_cmdargs()
        if g:zf_windows
            let config = 'config_win'
        elseif g:zf_mac
            let config = 'config_mac'
        else
            let config = 'config_linux'
        endif

        " try to get rid of build files
        let dataPath = ZF_LSP_java_cachePath()
        let projRoot = getcwd()
        while 1
            if 0
                        \ || filereadable(projRoot . '/build.gradle')
                        \ || filereadable(projRoot . '/pom.xml')
                let dataPath = projRoot . '/build/.jdt'
                break
            endif
            let projRootOld = projRoot
            let projRoot = fnamemodify(projRoot, ':h')
            if projRoot == projRootOld
                break
            endif
        endwhile

        return [
                    \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                    \     '-Dosgi.bundles.defaultStartLevel=4',
                    \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
                    \     '-Dlog.level=NONE',
                    \     '-noverify',
                    \     '-Xmx1G',
                    \     '--add-modules=ALL-SYSTEM',
                    \     '--add-opens',
                    \     'java.base/java.util=ALL-UNNAMED',
                    \     '--add-opens',
                    \     'java.base/java.lang=ALL-UNNAMED',
                    \     '-jar',
                    \     glob(ZF_LSP_java_contentsPath() . '/plugins/org.eclipse.equinox.launcher_*.jar', 1),
                    \     '-configuration',
                    \     ZF_LSP_java_contentsPath() . '/' . config,
                    \     '-data',
                    \     dataPath,
                    \   ]
    endfunction
    call ZFLSP_autoSetup(1, 'java', function('ZF_LSP_java_checker'), function('ZF_LSP_java_installer'), {
                \   'cmd' : 'java',
                \   'cmdargs' : function('ZF_LSP_java_cmdargs'),
                \   'ft' : ['java'],
                \   'options' : {
                \   },
                \   'settings' : {
                \   },
                \ })
endif

