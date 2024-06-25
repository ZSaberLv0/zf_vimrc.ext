
if !exists('g:ZF_Plugin_vimspector')
    let g:ZF_Plugin_vimspector = 1
endif
if v:version < 800 || !has('python3')
    let g:ZF_Plugin_vimspector = 0
endif
if g:ZF_Plugin_vimspector
    ZFPlug 'puremourning/vimspector'

    if get(g:, 'zf_vimspector_keymap', 1)
        nmap DB <Plug>VimspectorToggleBreakpoint
        nmap DC :call vimspector#ClearBreakpoints()<cr>
        nmap DI <Plug>VimspectorBalloonEval
        nmap <f4> :call ZFDebugStop()<cr>
        nmap <f5> :call ZFDebugRestart()<cr>
        nmap <f6> :call vimspector#DownFrame()<cr>
        nmap <f7> :call vimspector#UpFrame()<cr>
        nmap <f8> <Plug>VimspectorContinue
        nmap z<f8> <Plug>VimspectorRunToCursor
        nmap <f9> <Plug>VimspectorPause
        nmap <f10> <Plug>VimspectorStepOver
        nmap <f11> <Plug>VimspectorStepInto
        nmap z<f11> <Plug>VimspectorStepOut
        nmap <f12> <Plug>VimspectorStepOut

        augroup zf_vimspector_keymap_VimspectorPrompt
            autocmd!
            autocmd FileType VimspectorPrompt
                        \ nmap <buffer> dd :call vimspector#DeleteWatch()<cr>
        augroup END
    endif

    function! ZFDebugRestart()
        call ZFDebugStop()

        let Fn_l_action = get(b:, 'ZFDebug_action', '')
        if !empty(Fn_l_action)
            call Fn_l_action()
        endif
        let l_program = get(b:, 'ZFDebug_program', '')
        let l_adapter = get(b:, 'ZFDebug_adapter', '')
        if !empty(l_program)
            if empty(l_adapter)
                let l_adapter = ZFDebug_adapterChoose()
                if empty(l_adapter)
                    return 0
                endif
                let b:ZFDebug_adapter = l_adapter
            endif
            call timer_start(500, function('s:ZFDebugRestartDelay', [l_program, l_adapter, {'saveState':0}]))
            return 1
        endif

        let program = ZF_stateGet('ZFDebug_program')
        let adapter = ZF_stateGet('ZFDebug_adapter')
        if !empty(program) && !empty(adapter)
            call timer_start(500, function('s:ZFDebugRestartDelay', [json_decode(program), adapter, {}]))
            return 1
        endif

        redraw
        echo 'no debug session, use `:ZFDebug program [adapter]` to start new one'
        return 0
    endfunction
    function! s:ZFDebugRestartDelay(program, adapter, option, ...)
        call ZFDebug(a:program, a:adapter, a:option)
    endfunction

    function! ZFDebugStop()
        silent! call vimspector#Stop()
        silent! call vimspector#Reset()
    endfunction

    command! -nargs=+ -bang -complete=file ZFDebug :call s:ZFDebug({'saveState':(<q-bang>=='!'?0:1)}, <f-args>)
    " params:
    " * program:
    "     * program path
    "     * {
    "         'path' : 'program path',
    "         'args' : [...],
    "       }
    " * [adapter]
    " * [option]: {
    "     'saveState' : '1/0, whether to save last debug config',
    "   }
    "
    " you may also set buffer local vars to override config for local file:
    "     let b:ZFDebug_program = xxx
    "     let b:ZFDebug_adapter = xxx
    function! ZFDebug(program, ...)
        return s:ZFDebug(get(a:, 2, {}), a:program, get(a:, 1, ''))
    endfunction

    function! s:ZFDebug(option, program, ...)
        let adapter = get(a:, 1, '')
        let option = a:option

        if type(a:program) == type('')
            let program = {
                        \   'path' : fnamemodify(a:program, ':p'),
                        \   'args' : [],
                        \ }
        else
            let path = get(a:program, 'path', '')
            if empty(path)
                echo 'invalid program'
                return 0
            endif
            let argsTmp = get(a:program, 'args', [])
            if type(argsTmp) == type('')
                if argsTmp != ''
                    let args = [argsTmp]
                else
                    let args = []
                endif
            elseif type(argsTmp) == type([])
                let args = argsTmp
            else
                let args = []
            endif
            let program = {
                        \   'path' : fnamemodify(path, ':p'),
                        \   'args' : args,
                        \ }
        endif

        if empty(adapter)
            let adapter = ZFDebug_adapterChoose()
            if empty(adapter)
                return 0
            endif
        endif

        if get(option, 'saveState', 1)
            call ZF_stateSet('ZFDebug_program', json_encode(program))
            call ZF_stateSet('ZFDebug_adapter', adapter)
        endif

        call vimspector#LaunchWithConfigurations({
                    \   'ZFDebug' : {
                    \     'adapter' : adapter,
                    \     'configuration' : {
                    \       'request' : 'launch',
                    \       'program' : program['path'],
                    \       'args' : program['args'],
                    \       'stopOnEntry#json' : 'false',
                    \       'expressions' : 'native',
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
        return 1
    endfunction
    function! ZFDebug_adapterChoose()
        let candidates = split(vimspector#CompleteInstall('', '', 0), "\n")
        let hints = ['choose adapter:']
        for i in range(len(candidates))
            call add(hints, printf('    %2d : %s', i + 1, candidates[i]))
        endfor
        let choice = inputlist(hints) - 1
        redraw
        if choice < 0 || choice >= len(candidates)
            echo 'canceled'
            return ''
        endif
        return candidates[choice]
    endfunction
endif

