
" ==================================================
if !exists('g:ZF_Plugin_xmledit')
    let g:ZF_Plugin_xmledit = 1
endif
if g:ZF_Plugin_xmledit
    ZFPlug 'sukima/xmledit'
    let g:xml_tag_completion_map = '>'
endif

