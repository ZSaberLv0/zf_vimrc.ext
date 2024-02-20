
function! ZF_node_modues_path()
    if executable('npm')
        let t = ZF_shellcache('npm root -g')
        if !empty(t)
            return substitute(t, '[\r\n]', '', 'g')
        endif
    endif
    return ''
endfunction

