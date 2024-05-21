
if !exists('g:ZF_Plugin_vimspector')
    let g:ZF_Plugin_vimspector = 1
endif
if v:version < 800
    let g:ZF_Plugin_vimspector = 0
endif
if g:ZF_Plugin_vimspector
    ZFPlug 'puremourning/vimspector'

    if get(g:, 'zf_vimspector_keymap', 1)
        nmap <f4> :silent! call vimspector#Stop()<cr>:silent! call vimspector#Reset()<cr>
        nmap <f5> :call ZFDebugRestart()<cr>
        nmap DB <Plug>VimspectorToggleBreakpoint
        nmap DC :call vimspector#ClearBreakpoints()<cr>
        nmap <f6> :call vimspector#DownFrame()<cr>
        nmap <f7> :call vimspector#UpFrame()<cr>
        nmap <f8> <Plug>VimspectorRunToCursor
        nmap DI <Plug>VimspectorBalloonEval
        nmap <f9> <Plug>VimspectorStepOut
        nmap <f10> <Plug>VimspectorStepOver
        nmap <f11> <Plug>VimspectorStepInto
    endif

    function! ZFDebugRestart()
        silent! call vimspector#Stop()
        silent! call vimspector#Reset()

        let path = ZF_stateGet('ZFDebug_path')
        let adapter = ZF_stateGet('ZFDebug_adapter')
        if !empty(path) && !empty(adapter)
            call timer_start(500, function('s:ZFDebugRestartDelay', [path, adapter]))
            return
        endif

        redraw
        echo 'no debug session, use `:ZFDebug path [adapter]` to start new one'
    endfunction
    function! s:ZFDebugRestartDelay(path, adapter, ...)
        call ZFDebug(a:path, a:adapter)
    endfunction

    command! -nargs=+ -complete=file ZFDebug :call ZFDebug(<f-args>)
    function! ZFDebug(path, ...)
        let adapter = get(a:, 1, '')
        if empty(adapter)
            let candidates = split(vimspector#CompleteInstall('', '', 0), "\n")
            let hints = ['choose adapter:']
            for i in range(len(candidates))
                call add(hints, printf('    %2d : %s', i + 1, candidates[i]))
            endfor
            let choice = inputlist(hints) - 1
            redraw
            if choice < 0 || choice >= len(candidates)
                echo 'canceled'
                return
            endif
            let adapter = candidates[choice]
        endif

        call ZF_stateSet('ZFDebug_path', a:path)
        call ZF_stateSet('ZFDebug_adapter', adapter)

        call vimspector#LaunchWithConfigurations({
                    \   'ZFDebug' : {
                    \     'adapter' : adapter,
                    \     'configuration' : {
                    \       'request' : 'launch',
                    \       'program' : fnamemodify(a:path, ':p'),
                    \       'stopOnEntry#json' : 'false',
                    \     },
                    \     'breakpoints' : {
                    \       'exception' : {
                    \         'raised' : '',
                    \         'caught' : '',
                    \         'uncaught' : '',
                    \         'userUnhandled' : '',
                    \         'all' : '',
                    \         'cpp_catch' : '',
                    \         'cpp_throw' : '',
                    \       },
                    \     },
                    \   },
                    \ })
    endfunction
endif

