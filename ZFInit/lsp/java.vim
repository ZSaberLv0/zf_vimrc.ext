
" ============================================================
if !exists('g:zflsp_java')
    let g:zflsp_java = g:zflspEnable
endif
if g:zflsp_java && executable('java')
    function! ZF_LSP_java_remoteFile()
        if ZF_versionCompare(ZF_versionGet('java'), '21') >= 0
            return 'http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz'
        else
            return 'https://download.eclipse.org/jdtls/milestones/1.43.0/jdt-language-server-1.43.0-202412191447.tar.gz'
        endif
    endfunction
    function! ZF_LSP_java_archiveFile()
        if ZF_versionCompare(ZF_versionGet('java'), '21') >= 0
            return g:zf_vim_cache_path . '/ZFLSP_jdt/jdt-language-server-latest.tar.gz'
        else
            return g:zf_vim_cache_path . '/ZFLSP_jdt/old/jdt-language-server-latest.tar.gz'
        endif
    endfunction
    function! ZF_LSP_java_contentsPath()
        if ZF_versionCompare(ZF_versionGet('java'), '21') >= 0
            return g:zf_vim_cache_path . '/ZFLSP_jdt/contents'
        else
            return g:zf_vim_cache_path . '/ZFLSP_jdt/old/contents'
        endif
    endfunction
    function! ZF_LSP_java_cachePath()
        if ZF_versionCompare(ZF_versionGet('java'), '21') >= 0
            return g:zf_vim_cache_path . '/ZFLSP_jdt/cache'
        else
            return g:zf_vim_cache_path . '/ZFLSP_jdt/old/cache'
        endif
    endfunction

    function! ZF_LSP_java_checker()
        return executable('tar') && filereadable(ZF_LSP_java_archiveFile())
    endfunction
    function! ZF_LSP_java_installer()
        if !executable('tar')
            echo 'ERROR: no tar available'
            return
        endif
        call ZF_ModuleDownloadFile(ZF_LSP_java_archiveFile(), ZF_LSP_java_remoteFile())
        if filereadable(ZF_LSP_java_archiveFile())
            call ZF_rm(ZF_LSP_java_cachePath())
            call ZF_rm(ZF_LSP_java_contentsPath())
            call ZF_system('mkdir "' . ZF_LSP_java_contentsPath() . '"')
            call ZF_system('tar zxf "' . ZF_LSP_java_archiveFile() . '" -C "' . ZF_LSP_java_contentsPath() . '/."')
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
                    \     '-Djava.import.generatesMetadataFilesAtProjectRoot=false',
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
                \   'initOption' : {
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

