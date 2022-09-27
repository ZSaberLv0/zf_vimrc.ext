
" ==================================================
" https://github.com/ZSaberLv0/zf_vimrc.ext/tree/master/ZFPlugPost/complete_engine
if !exists('g:ZF_Plugin_complete_engine')
    if v:version < 800
                \ || (has('nvim') && !has('nvim-0.4'))
        let g:ZF_Plugin_complete_engine = ''
    elseif executable('node') && !g:zf_windows && (1
                \   || (has('nvim') && has('nvim-0.4.0'))
                \   || (!has('nvim') && has('patch-8.1.1719'))
                \ )
                \ && ZF_versionCompare(ZF_node_version(), '14.14.0') >= 0
        let g:ZF_Plugin_complete_engine = 'coc'
    elseif has('python3') && (has('nvim') || ZF_pynvim_check())
        let g:ZF_Plugin_complete_engine = 'ncm2'
    else
        let g:ZF_Plugin_complete_engine = 'asyncomplete'
    endif
endif

