
" ==================================================
" https://github.com/ZSaberLv0/zf_vimrc.ext/tree/master/ZFPlugPost/complete_engine
if !exists('g:ZF_Plugin_complete_engine')
    if v:version < 800
                \ || (has('nvim') && !has('nvim-0.4'))
        let g:ZF_Plugin_complete_engine = ''
    elseif executable('node')
        let g:ZF_Plugin_complete_engine = 'coc'
    elseif has('python3')
        let g:ZF_Plugin_complete_engine = 'ncm2'
    else
        let g:ZF_Plugin_complete_engine = 'asyncomplete'
    endif
endif

