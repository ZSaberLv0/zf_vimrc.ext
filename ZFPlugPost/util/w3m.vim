
" ==================================================
if !exists('g:ZF_Plugin_w3m')
    let g:ZF_Plugin_w3m = 1
endif
if g:ZF_Plugin_w3m
    if !executable('w3m')
        let g:ZF_Plugin_w3m = 0
    endif

    " install
    function! ZF_Plugin_w3m_install()
        call ZF_ModulePackAdd(ZF_ModuleGetApt(), 'w3m')
    endfunction
    call ZF_ModuleInstaller('ZF_Plugin_w3m', 'call ZF_Plugin_w3m_install()')
endif

if g:ZF_Plugin_w3m
    ZFPlug 'yuratomo/w3m.vim'
    let g:w3m#search_engine = 'https://www.bing.com/search?q=%s'
    let g:w3m#history#save_file = g:zf_vim_cache_path . '/w3m_history'
    let g:w3m#option_use_cookie = 1
    let g:w3m#option_accept_cookie = 1
    let g:w3m#user_agent = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.187 Safari/535.1'
    let g:user_agent = g:w3m#user_agent
    let g:w3m#download_ext = [
                \   '7z',
                \   'dll',
                \   'dmg',
                \   'exe',
                \   'gz',
                \   'iso',
                \   'msi',
                \   'rar',
                \   'tar',
                \   'z',
                \   'zip',
                \ ]

    " keymap
    let g:w3m#disable_default_keymap = 1
    function! ZF_Plugin_w3m_getCurUrl()
        let url = ''
        try
            redir => url
            silent call w3m#CheckUnderCursor()
        finally
            redir END
        endtry
        let url = substitute(url, '[\r\n]\+', '', 'g')
        return url
    endfunction
    function! ZF_Plugin_w3m_printUrl()
        let url = ZF_Plugin_w3m_getCurUrl()
        echo url
        if has('clipboard')
            let @* = url
        endif
        let @" = url
    endfunction
    function! ZF_Plugin_w3m_openInTab()
        let url = ZF_Plugin_w3m_getCurUrl()
        if !empty(url)
            call ZF_Plugin_w3m(url, {
                        \   'tab' : 1,
                        \ })
        endif
    endfunction
    function! ZF_Plugin_w3m_checkUpdateSyntax()
        if &filetype == 'w3m'
            call w3m#BufWinEnter()
        endif
    endfunction
    function! ZF_Plugin_w3m_keymap()
        nmap <buffer> <cr> <Plug>(w3m-click)
        nmap <buffer> o <Plug>(w3m-click)
        nnoremap <buffer> O :call ZF_Plugin_w3m_openInTab()<cr>
        nnoremap <silent><buffer> q :bd<cr>:call ZF_Plugin_w3m_checkUpdateSyntax()<cr>
        nmap <buffer> <tab> <Plug>(w3m-next-link)
        nmap <buffer> <s-tab> <Plug>(w3m-prev-link)
        nmap <buffer> <bs> <Plug>(w3m-back)
        nmap <buffer> zk <Plug>(w3m-back)
        nmap <buffer> zj <Plug>(w3m-forward)
        nnoremap <buffer><silent> = :call ZF_Plugin_w3m_printUrl()<cr>
        nnoremap <buffer><silent> p :call ZF_Plugin_w3m_printUrl()<cr>
    endfunction
    augroup ZF_Plugin_w3m_augroup
        autocmd!
        autocmd FileType w3m call ZF_Plugin_w3m_keymap()
    augroup END

    " command
    function! ZF_Plugin_w3m(arg, ...)
        let option = get(a:, 1, {})
        let cmd = get(option, 'tab', 0) ? 'W3mTab' : 'W3m'
        let arg = substitute(a:arg, '^ \+', '', 'g')
        let arg = substitute(arg, ' \+$', '', 'g')
        if match(arg, '^[a-z]\+://') >= 0
            " ^[a-z]+://
            execute cmd . ' ' . a:arg
        elseif match(arg, '^[a-z0-9_]\+\(\.[a-z0-9_]\+\)\+') >= 0
                    \ && match(arg, ' ') < 0
            " ^[a-z0-9_]+(\.[a-z0-9_]+)+
            execute cmd . ' http://' . arg
        elseif a:arg == ''
            let file = expand('%')
            if filereadable(file) && !&modified
                execute cmd . ' local ' . file
            else
                let tmp_file = CygpathFix_absPath(tempname()) . '.html'
                let content = getline(1, '$')
                call writefile(content, tmp_file)
                execute cmd . ' local ' . tmp_file
                call delete(tmp_file)
            endif
        elseif filereadable(a:arg)
            execute cmd . ' local ' . a:arg
        else
            execute cmd . ' ' . a:arg
        endif
    endfunction
    command! -nargs=* -complete=file ZFWeb :call ZF_Plugin_w3m(<q-args>)
    nnoremap <leader>vw :ZFWeb<space>
endif

