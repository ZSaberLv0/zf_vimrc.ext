
function! ZF_node_version()
    if !exists('s:node_version')
        if !executable('node')
            let s:node_version = '0'
        else
            let s:node_version = ZF_versionGet(system('node --version'))
        endif
    endif
    return s:node_version
endfunction

