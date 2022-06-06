
" ============================================================
if !exists('g:zflsp_xml')
    let g:zflsp_xml = g:zflspEnable
endif
if g:zflsp_xml && executable('java')
    function! ZF_LSP_xml_archiveFile()
        return g:zf_vim_cache_path . '/ZFLSP_lemminx/org.eclipse.lemminx-uber.jar'
    endfunction

    function! ZF_LSP_xml_checker()
        return filereadable(ZF_LSP_xml_archiveFile())
    endfunction
    function! ZF_LSP_xml_installer()
        if !ZF_LSP_xml_checker()
            call ZF_ModuleDownloadFile(ZF_LSP_xml_archiveFile(), 'http://download.eclipse.org/lemminx/snapshots/org.eclipse.lemminx-uber.jar')
        endif
    endfunction
    call ZFLSP_autoSetup(1, 'xml', function('ZF_LSP_xml_checker'), function('ZF_LSP_xml_installer'), {
                \   'cmd' : 'java',
                \   'cmdargs' : ['-cp', ZF_LSP_xml_archiveFile(), 'org.eclipse.lemminx.XMLServerLauncher'],
                \   'ft' : ['xml', 'html'],
                \   'options' : {
                \   },
                \   'settings' : {
                \   },
                \ })
endif

