
function! ZF_node_modues_path()
    if !exists('s:ZF_node_modues_path')
        let s:ZF_node_modues_path = ''
        if executable('npm')
            let t = ZF_system('npm root -g')
            if v:shell_error == 0 && !empty(t)
                let s:ZF_node_modues_path = substitute(t, '[\r\n]', '', 'g')
            endif
        endif
    endif
    return s:ZF_node_modues_path
endfunction

