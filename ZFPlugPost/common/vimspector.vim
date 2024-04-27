
if !exists('g:ZF_Plugin_vimspector')
    let g:ZF_Plugin_vimspector = 1
endif
if v:version < 800
    let g:ZF_Plugin_vimspector = 0
endif
if g:ZF_Plugin_vimspector
    ZFPlug 'puremourning/vimspector'

    if get(g:, 'zf_vimspector_keymap', 1)
        nmap <f4> :VimspectorReset<cr>
        nmap <f5> :call ZFDebugRestart()<cr>
        nmap DB <Plug>VimspectorToggleBreakpoint
        nmap DC :call vimspector#ClearBreakpoints()<cr>
        nmap <f6> :call vimspector#DownFrame()<cr>
        nmap <f7> :call vimspector#UpFrame()<cr>
        nmap <f8> <Plug>VimspectorRunToCursor
        nmap DI <Plug>VimspectorBalloonEval
        nmap <f10> <Plug>VimspectorStepOver
        nmap <f11> <Plug>VimspectorStepInto
        nmap <f12> <Plug>VimspectorStepOut
    endif

    function! ZFDebugRestart()
        let path = ZF_stateGet('ZFDebug_path')
        let adapter = ZF_stateGet('ZFDebug_adapter')
        if !empty(path) && !empty(adapter)
            call ZFDebug(path, adapter)
            return
        endif

        redraw
        echo 'no debug session, use `:ZFDebug path [adapter]` to start new one'
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
                    \     },
                    \     'breakpoints' : {
                    \       'exception' : {
                    \         'raised' : 'N',
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

