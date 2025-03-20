
" ==================================================
if !exists('g:ZF_Plugin_codecompanion')
    let g:ZF_Plugin_codecompanion = 1
endif
if !has('nvim-0.10.0')
    let g:ZF_Plugin_codecompanion = 0
endif
if g:ZF_Plugin_codecompanion
    ZFPlug 'nvim-lua/plenary.nvim'
    ZFPlug 'nvim-treesitter/nvim-treesitter'
    ZFPlug 'olimorris/codecompanion.nvim'

    nnoremap <silent> <c-q> :CodeCompanionChat Toggle<cr>
    inoremap <silent> <c-q> <esc>:CodeCompanionChat Toggle<cr>

    function! ZF_Plugin_codecompanion_quitAction(...)
        normal \CodeCompanion?q
    endfunction
    function! ZF_Plugin_codecompanion_quit()
        let hint = "reset and close chat?"
        let hint .= "\n"
        let hint .= "\n(y)es / (n)o : "
        redraw
        echo hint
        let confirm = nr2char(getchar())
        redraw
        if confirm == 'y'
            silent! execute "silent! normal \<c-c>"
            call timer_start(100, function('ZF_Plugin_codecompanion_quitAction'))
        else
            execute "normal \<c-q>"
        endif
    endfunction

    function s:updateIME(enter)
        if &filetype == 'codecompanion' && exists('*ZFVimIME_start')
            if a:enter
                call ZFVimIME_start()
            else
                call ZFVimIME_stop()
            endif
        endif
    endfunction

    if !exists('g:ZF_Plugin_codecompanion_scriptPath')
        let g:ZF_Plugin_codecompanion_scriptPath = expand('<sfile>:p:h')
        execute 'set rtp+=' . g:ZF_Plugin_codecompanion_scriptPath
    endif
    augroup ZF_Plugin_codecompanion_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal call s:setup()
        autocmd FileType codecompanion set syntax=zftxt
        autocmd BufEnter * call s:updateIME(1)
        autocmd BufLeave * call s:updateIME(0)
        autocmd FileType codecompanion nnoremap <buffer><silent> q :call ZF_Plugin_codecompanion_quit()<cr>
        autocmd User CodeCompanionChatCreated call feedkeys('i', 'nt')
    augroup END
    function! s:setup()
lua << EOF
        require('codecompanion_setup')
EOF
    endfunction
endif

" ==================================================
if !exists('g:ZF_Plugin_markview')
    let g:ZF_Plugin_markview = g:ZF_Plugin_codecompanion
endif
if g:ZF_Plugin_markview
    ZFPlug 'OXY2DEV/markview.nvim'

    augroup ZF_Plugin_markview_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal call ZF_Plugin_markview_setup()
    augroup END
    function! ZF_Plugin_markview_setup()
lua << EOF
    require('markview').setup({
            preview = {
                filetypes = {'codecompanion'},
                ignore_buftypes = {},
                condition = function(buffer)
                    local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;
                    if bt == "nofile" and ft == "codecompanion" then
                        return true;
                    elseif bt == "nofile" then
                        return false;
                    else
                        return true;
                    end
                end,
            },
        })
EOF
    endfunction
endif

