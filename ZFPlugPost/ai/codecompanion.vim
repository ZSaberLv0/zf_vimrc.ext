
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

    let g:codecompanion_yolo_mode = 1

    xnoremap <c-q> :CodeCompanion<space>

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
        if confirm == 'y' || confirm == 'q'
            silent! execute "silent! normal \<c-c>"
            call timer_start(300, function('ZF_Plugin_codecompanion_quitAction'))
        else
            execute "normal \<c-q>"
        endif
    endfunction

    function s:bufUpdate(enter)
        if &filetype == 'codecompanion'
            if exists('*ZFVimIME_start')
                if a:enter
                    call ZFVimIME_start()
                else
                    call ZFVimIME_stop()
                endif
            endif
            if exists(':RenderMarkdown')
                if a:enter
                    RenderMarkdown enable
                else
                    RenderMarkdown disable
                endif
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
        autocmd BufEnter * call s:bufUpdate(1)
        autocmd BufLeave * call s:bufUpdate(0)
        autocmd FileType codecompanion nnoremap <buffer><silent> q :call ZF_Plugin_codecompanion_quit()<cr>
        autocmd FileType codecompanion inoremap <buffer><silent> @@ @{full_stack_dev}<space>
        autocmd FileType codecompanion inoremap <buffer><silent> @# #{buffer}<space>
        autocmd FileType codecompanion nnoremap <buffer><silent> <c-a> :call feedkeys('ga', 't')<cr>
        autocmd FileType codecompanion inoremap <buffer><silent> <c-a> <esc>:call feedkeys('ga', 't')<cr>
        autocmd User CodeCompanionChatCreated call feedkeys('a', 'nt')
    augroup END
    function! s:setup()
        try
lua << EOF
        require('codecompanion_setup')
EOF
        catch
        endtry
    endfunction
endif

" ==================================================
if !exists('g:ZF_Plugin_codecompanion_history')
    let g:ZF_Plugin_codecompanion_history = g:ZF_Plugin_codecompanion
endif
if !has('nvim-0.8.0')
    let g:ZF_Plugin_codecompanion_history = 0
endif
if g:ZF_Plugin_codecompanion_history
    ZFPlug 'ravitemer/codecompanion-history.nvim'
endif

" ==================================================
if !exists('g:ZF_Plugin_codecompanion_spinner')
    let g:ZF_Plugin_codecompanion_spinner = g:ZF_Plugin_codecompanion
endif
if g:ZF_Plugin_codecompanion_spinner
    ZFPlug 'franco-ruggeri/codecompanion-spinner.nvim'
endif

" ==================================================
if !exists('g:ZF_Plugin_markview')
    let g:ZF_Plugin_markview = g:ZF_Plugin_codecompanion && 0
endif
if !has('nvim-0.10.0')
    let g:ZF_Plugin_markview = 0
endif
if g:ZF_Plugin_markview
    ZFPlug 'OXY2DEV/markview.nvim'

    augroup ZF_Plugin_markview_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal call ZF_Plugin_markview_setup()
    augroup END
    function! ZF_Plugin_markview_setup()
        try
lua << EOF
        require('markview').setup({
                preview = {
                    filetypes = {
                        'markdown',
                        'codecompanion',
                    },
                    ignore_buftypes = {},
                },
            })
EOF
        catch
        endtry
    endfunction
endif

" ==================================================
if !exists('g:ZF_Plugin_render_markdown')
    let g:ZF_Plugin_render_markdown = g:ZF_Plugin_codecompanion
endif
if !has('nvim-0.10.0')
    let g:ZF_Plugin_render_markdown = 0
endif
if g:ZF_Plugin_render_markdown
    ZFPlug 'MeanderingProgrammer/render-markdown.nvim'

    augroup ZF_Plugin_render_markdown_augroup
        autocmd!
        autocmd User ZFVimrcPostNormal call ZF_Plugin_render_markdown_setup()
    augroup END
    function! ZF_Plugin_render_markdown_setup()
        try
lua << EOF
        require('render-markdown').setup({
                enabled = false,
                file_types = {
                    'markdown',
                    'codecompanion',
                },
                injections = {
                    gitcommit = {
                        enabled = false,
                    },
                },
                anti_conceal = {
                    enabled = false,
                },
                win_options = {
                    concealcursor = {
                        rendered = 'nc',
                    },
                },
                heading = {
                    sign = false,
                    icons = function(...) return '' end,
                    position = 'inline',
                    width = 'block',
                    left_margin = {0,4,8,12,16,20,24},
                    left_pad = 1,
                    right_pad = 1,
                },
                code = {
                    sign = false,
                    position = 'right',
                    width = 'block',
                },
                checkbox = {
                    unchecked = {
                        icon = '[ ]',
                    },
                    checked = {
                        icon = '[x]',
                    },
                },
                link = {
                    enabled = false,
                },
            })
EOF
        catch
        endtry
    endfunction
endif

