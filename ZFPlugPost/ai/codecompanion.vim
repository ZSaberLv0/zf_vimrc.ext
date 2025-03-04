
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

    if !exists('g:ZF_Plugin_codecompanion_scriptPath')
        let g:ZF_Plugin_codecompanion_scriptPath = expand('<sfile>:p:h')
        execute 'set rtp+=' . g:ZF_Plugin_codecompanion_scriptPath
    endif
    augroup ZF_Plugin_codecompanion_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal call ZF_Plugin_codecompanion_setup()
        autocmd FileType codecompanion call ZF_Plugin_codecompanion_buf_setup()
    augroup END
    function! ZF_Plugin_codecompanion_buf_setup()
        set syntax=zftxt
    endfunction
    function! ZF_Plugin_codecompanion_setup()
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

