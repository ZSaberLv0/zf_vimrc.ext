
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
        nmap z<f8> <Plug>VimspectorPause
        nmap <f9> <Plug>VimspectorStepOut
        nmap <f10> <Plug>VimspectorStepOver
        nmap <f11> <Plug>VimspectorStepInto
        nmap z<f10> :call vimspector#DownFrame()<cr>
        nmap z<f11> :call vimspector#UpFrame()<cr>

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
        let l_path = get(b:, 'ZFDebug_path', '')
        let l_args = get(b:, 'ZFDebug_args', '')
        let l_adapter = get(b:, 'ZFDebug_adapter', '')
        if !empty(l_path)
            if empty(l_adapter)
                let l_adapter = ZFDebug_adapterChoose()
                if empty(l_adapter)
                    return 0
                endif
                let b:ZFDebug_adapter = l_adapter
            endif
            call timer_start(500, function('s:ZFDebugRestartDelay', [{
                        \   'path' : l_path,
                        \   'args' : l_args,
                        \   'adapter' : l_adapter,
                        \   'saveState' : 0,
                        \ }]))
            return 1
        endif

        let path = ZF_stateGet('ZFDebug_path')
        let args = !empty(ZF_stateGet('ZFDebug_args')) ? json_decode(ZF_stateGet('ZFDebug_args')) : []
        let adapter = ZF_stateGet('ZFDebug_adapter')
        if !empty(path) && !empty(adapter)
            call timer_start(500, function('s:ZFDebugRestartDelay', [{
                        \   'path' : path,
                        \   'args' : args,
                        \   'adapter' : adapter,
                        \   'saveState' : 1,
                        \ }]))
            return 1
        endif

        if !empty(ZFDebugSessionChoose())
            return 1
        endif

        redraw
        echo 'no debug session, start new one:'
        echo '    ZFDebug path [args]'
        echo '    ZFDebug! adapter path [args]'
        return 0
    endfunction
    function! s:ZFDebugRestartDelay(params, ...)
        call ZFDebug(a:params)
    endfunction

    function! ZFDebugStop()
        silent! call vimspector#Stop()
        silent! call vimspector#Reset()
    endfunction

    command! -nargs=0 ZFDebugSessionChoose :call ZFDebugSessionChoose()
    function! ZFDebugSessionChoose()
        let sessions = get(g:, 'ZFDebug_sessions', {})
        if len(sessions) == 0
            echo 'no session configured, use g:ZFDebug_sessions to config'
            return {}
        elseif len(sessions) == 1
            return ZFDebug(values(sessions)[0])
        endif
        let hints = ['choose session:']
        let names = keys(sessions)
        for i in range(len(names))
            let name = names[i]
            let param = sessions[name]
            call add(hints, printf('    %2d %s : [%s] %s %s'
                        \ , i + 1
                        \ , name
                        \ , get(param, 'adapter', '')
                        \ , get(param, 'path', '')
                        \ , join(get(param, 'args', []), ' ')
                        \ ))
        endfor
        let choice = inputlist(hints) - 1
        redraw
        if choice < 0 || choice >= len(sessions)
            echo 'canceled'
            return {}
        endif
        return ZFDebug(sessions[names[choice]])
    endfunction

    command! -nargs=0 ZFDebugSessionClear :call ZFDebugSessionClear()
    function! ZFDebugSessionClear()
        call ZF_stateSet('ZFDebug_path', '')
        call ZF_stateSet('ZFDebug_args', '')
        call ZF_stateSet('ZFDebug_adapter', '')
        echo 'cleared, use :ZFDebug to start new one'
    endfunction

    command! -nargs=* -bang -complete=file ZFDebug :call ZFDebug(s:parseArgs(<q-bang>, <q-args>))
    function! s:parseArgs(bang, args)
        let args = split(substitute(a:args, '\\ ', '_zf_space_', 'g'), ' ')
        if len(args) <= 0
            return ZFDebugSessionChoose()
        endif
        if a:bang == '!'
            let adapter = args[0]
            call remove(args, 0)
            if len(args) <= 0
                return {}
            endif
        else
            let adapter = ''
        endif

        let path = substitute(args[0], '_zf_space_', ' ', 'g')
        call remove(args, 0)
        let i = 0
        while i < len(args)
            let args[i] = substitute(args[i], '_zf_space_', ' ', 'g')
        endwhile
        return {
                    \   'path' : path,
                    \   'args' : args,
                    \   'adapter' : adapter,
                    \   'saveState' : 1,
                    \ }
    endfunction

    " params: {
    "   'path' : 'program path',
    "   'args' : [...],
    "   'adapter' : '',
    "   'saveState' : '1/0, whether to save last debug config',
    " }
    "
    " you may also set buffer local vars to override config for local file:
    "     let b:ZFDebug_path = xxx
    "     let b:ZFDebug_args = xxx
    "     let b:ZFDebug_adapter = xxx
    function! ZFDebug(params)
        let g:zfzfzf = copy(a:params)
        let path = get(a:params, 'path', '')
        let args = get(a:params, 'args', [])
        let adapter = get(a:params, 'adapter', '')
        let saveState = get(a:params, 'saveState', 1)

        if empty(path)
            echo 'invalid program path'
            return 0
        endif
        let program = {
                    \   'path' : fnamemodify(path, ':p'),
                    \   'args' : args,
                    \ }

        if empty(adapter)
            let adapter = ZFDebug_adapterChoose()
            if empty(adapter)
                return 0
            endif
        endif

        if saveState
            call ZF_stateSet('ZFDebug_path', path)
            call ZF_stateSet('ZFDebug_args', json_encode(args))
            call ZF_stateSet('ZFDebug_adapter', adapter)
        endif

        call vimspector#LaunchWithConfigurations({
                    \   'ZFDebug' : {
                    \     'adapter' : adapter,
                    \     'configuration' : {
                    \       'request' : 'launch',
                    \       'program' : path,
                    \       'args' : args,
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

