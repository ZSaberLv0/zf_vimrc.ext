
" ============================================================
if !exists('g:zflsp_kotlin')
    let g:zflsp_kotlin = g:zflspEnable
endif
if g:zflsp_kotlin
    function! ZF_LSP_kotlin_archiveFile()
        return g:zf_vim_cache_path . '/ZFLSP_kotlin/server.zip'
    endfunction
    function! ZF_LSP_kotlin_contentsPath()
        return g:zf_vim_cache_path . '/ZFLSP_kotlin/contents'
    endfunction

    function! ZF_LSP_kotlin_checker()
        return filereadable(ZF_LSP_kotlin_archiveFile())
    endfunction
    function! ZF_LSP_kotlin_installer()
        let fileUrl = ''
        for fileUrlTmp in ZF_ModuleGetGithubRelease('fwcd', 'kotlin-language-server')
            if match(fileUrlTmp, 'server\.zip') >= 0
                let fileUrl = fileUrlTmp
            endif
        endfor
        if empty(fileUrl)
            echo 'ERROR: unable to obtain release'
            return
        endif
        call ZF_ModuleDownloadFile(ZF_LSP_kotlin_archiveFile(), fileUrl)
        if filereadable(ZF_LSP_kotlin_archiveFile())
            call ZF_system('mkdir "' . ZF_LSP_kotlin_contentsPath() . '"')
            call ZF_unzip(ZF_LSP_kotlin_contentsPath(), ZF_LSP_kotlin_archiveFile())
        endif
    endfunction
    call ZFLSP_autoSetup(1, 'kotlin', function('ZF_LSP_kotlin_checker'), function('ZF_LSP_kotlin_installer'), {
                \   'cmd' : ZF_LSP_kotlin_contentsPath() . '/server/bin/kotlin-language-server',
                \   'cmdargs' : [],
                \   'ft' : ['kotlin'],
                \   'initOption' : {
                \   },
                \   'workspaceOption' : {
                \   },
                \ })
endif

