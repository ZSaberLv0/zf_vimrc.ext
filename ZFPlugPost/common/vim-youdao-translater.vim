
" ==================================================
if !exists('g:ZF_Plugin_youdao_translater')
    let g:ZF_Plugin_youdao_translater = 1
endif
if v:version <= 704 || (!has('python') && !has('python3'))
    let g:ZF_Plugin_youdao_translater = 0
endif
if g:ZF_Plugin_youdao_translater
    ZFPlug 'ianva/vim-youdao-translater'

    function! ZF_Plugin_youdao_translater(lines)
        if has('python3')
            let py = 'python3'
            let pyBegin = 'python3 << EOF'
        elseif has('python')
            let py = 'python'
            let pyBegin = 'python << EOF'
        else
            echoerr "[YouDaoTranslator] [Error]: Python package neeeds to be installed!"
            return ''
        endif

        let modulePath = fnamemodify(CygpathFix_absPath(globpath(&rtp, 'youdao.py')), ':h')

execute pyBegin
import vim,sys
sys.path.append(vim.eval("modulePath"))
import youdao
def ZFYD(lines):
    info = youdao.get_word_info(youdao.str_decode(lines))
    vim.command('let g:zfyd = "'+ info +'"')
EOF

        let g:zfyd = ''
        execute py 'ZFYD(vim.eval("a:lines"))'
        return g:zfyd
    endfunction

    function! ZF_Plugin_youdao(word)
        let g:zfyd = ZF_Plugin_youdao_translater(a:word)
        if !empty(g:zfyd)
            call setqflist([{'text' : g:zfyd}], 'r')
            if !exists('g:zfyd_autopopup') || g:zfyd_autopopup
                copen
                normal! w
            endif
        endif
    endfunction

    if !exists('g:ZF_Plugin_youdao_translater_keymap') || g:ZF_Plugin_youdao_translater_keymap != 0
        command! -nargs=+ ZFYD :call ZF_Plugin_youdao(<q-args>)
        xnoremap <leader>vy "zy:ZFYD <c-r>z<cr>
        xmap <leader>zy <leader>vy
        nnoremap <leader>vy :ZFYD<space>
        nnoremap <leader>zy :ZFYD <c-r><c-w><cr>
    endif
endif

