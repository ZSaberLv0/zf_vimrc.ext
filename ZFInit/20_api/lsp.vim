
" ============================================================
" {
"   'lsp name' : {
"     'cmd' : '(string) or (func ref) to get lsp command',
"     'cmdargs' : '(List of string) or (func ref) to get lsp command args',
"     'ft' : ['filetype list'],
"     'initOption' : '(Dictionary) or (func ref) to get lsp initializationOptions',
"     'workspaceOption' : '(Dictionary) or (func ref) to get lsp workspace settings',
"   },
"   ...
" }
if !exists('g:zflsp')
    let g:zflsp = {}
endif

if !exists('g:zflspEnable')
    if !empty(g:ZF_Plugin_complete_engine)
                \ && has('timers')
                \ && exists('*json_decode')
        let g:zflspEnable = 1
    else
        let g:zflspEnable = 0
    endif
endif

" ============================================================
" util
function! ZFLSP_get(cmd)
    if type(a:cmd) == type(function('type'))
        let Fn_cmd = a:cmd
        return Fn_cmd()
    else
        return a:cmd
    endif
endfunction
function! ZFLSP_getFullCmd(item)
    let cmd = ZFLSP_get(a:item.cmd)
    let cmdargs = ZFLSP_get(a:item.cmdargs)
    if empty(cmdargs)
        return cmd
    else
        return cmd . ' ' . join(cmdargs)
    endif
endfunction

" ============================================================
" utils to setup g:zflsp
" usage:
"   call ZFLSP_autoSetup('name', function('s:checker'), function('s:installer'), {
"           \   'cmd' : 'xxx',
"           \   'cmdargs' : [],
"           \   'ft' : ['xxx'],
"           \   'initOption' : {},
"           \   'workspaceOption' : {},
"           \ })
function! ZFLSP_autoSetup(installByDefault, name, checker, installer, lsp)
    if get(g:, 'zflspAutoInstall_' . a:name, a:installByDefault)
        call ZF_ModuleInstaller('ZF_LSP_' . a:name, a:installer)
    endif
    if get(g:_ZFLSP_autoSetup_doNotUpdateMap, a:name, 0)
        return
    endif
    if a:checker()
        let g:zflsp[a:name] = ZFLSP_get(a:lsp)
        return
    endif

    let g:_ZFLSP_autoSetup_taskMap[a:name] = {
                \   'checker' : a:checker,
                \   'installer' : a:installer,
                \   'lsp' : a:lsp,
                \   'timerId' : -1,
                \ }

    execute 'augroup ZFLSP_AUTOINSTALL_' . a:name
    autocmd!
    execute 'autocmd FileType ' . join(ZFLSP_get(a:lsp)['ft'], ',') . ' call _ZFLSP_autoSetup_checker("' . a:name . '")'
    execute 'augroup END'
endfunction
if !g:zflspEnable
    function! ZFLSP_autoSetup(name, checker, installer, lsp)
    endfunction
endif

if !exists('g:_ZFLSP_autoSetup_taskMap')
    let g:_ZFLSP_autoSetup_taskMap = {}
endif
if !exists('g:_ZFLSP_autoSetup_timerMap')
    let g:_ZFLSP_autoSetup_timerMap = {}
endif
if !exists('g:_ZFLSP_autoSetup_doNotUpdateMap')
    if g:zflspEnable && filereadable(g:zf_vim_cache_path . '/ZFLSP_doNotUpdateMap')
        let g:_ZFLSP_autoSetup_doNotUpdateMap = json_decode(
                    \ readfile(g:zf_vim_cache_path . '/ZFLSP_doNotUpdateMap')[0])
    else
        let g:_ZFLSP_autoSetup_doNotUpdateMap = {}
    endif
endif
function! _ZFLSP_autoSetup_checker(name)
    let data = g:_ZFLSP_autoSetup_taskMap[a:name]
    if data['timerId'] != -1
        return
    endif
    let timerId = timer_start(0, function('_ZFLSP_autoSetup_checker_timerCallback'))
    let data['timerId'] = timerId
    let g:_ZFLSP_autoSetup_timerMap[timerId] = a:name
endfunction
function! _ZFLSP_autoSetup_checker_timerCallback(timerId)
    let name = get(g:_ZFLSP_autoSetup_timerMap, a:timerId, '')
    if empty(name)
        return
    endif
    let g:_ZFLSP_autoSetup_taskMap[name]['timerId'] = -1
    unlet g:_ZFLSP_autoSetup_timerMap[a:timerId]
    call _ZFLSP_autoSetup_checker_action(name)
endfunction

function! _ZFLSP_autoSetup_checker_action(name)
    let data = g:_ZFLSP_autoSetup_taskMap[a:name]

    if !data['checker']()
        redraw!
        call inputsave()
        let choice = input(join([
                    \   '[ZFLSP] lsp for <' . a:name . '> not installed, install now?',
                    \   '  (y)es',
                    \   '  (n)o',
                    \   '  (d)o not ask again',
                    \   '',
                    \   'choice: ',
                    \ ], "\n"))
        call inputrestore()
        redraw
        if choice != 'y'
            if choice == 'n' || choice == 'd'
                " do not ask again for current instance
                execute 'augroup ZFLSP_AUTOINSTALL_' . a:name
                autocmd!
                execute 'augroup END'

                if choice == 'd'
                    let g:_ZFLSP_autoSetup_doNotUpdateMap[a:name] = 1
                    call writefile(
                                \ [json_encode(g:_ZFLSP_autoSetup_doNotUpdateMap)],
                                \ g:zf_vim_cache_path . '/ZFLSP_doNotUpdateMap')
                endif
            endif
            return
        endif

        echo '[ZFLSP] installing lsp for <' . a:name . '>'
        call data['installer']()
        if !data['checker']()
            return
        else
            echo '[ZFLSP] lsp installed for <' . a:name . '>'
        endif
    endif

    if data['checker']()
        let g:zflsp[a:name] = ZFLSP_get(data['lsp'])
        execute 'augroup ZFLSP_AUTOINSTALL_' . a:name
        autocmd!
        execute 'augroup END'
        call ZFLSP_restart()
    endif
endfunction

" add a install task to reset `do not ask again`
function! _ZFLSP_autoSetup_doNotUpdate_reset()
    let g:_ZFLSP_autoSetup_doNotUpdateMap = {}
    if filereadable(g:zf_vim_cache_path . '/ZFLSP_doNotUpdateMap')
        call delete(g:zf_vim_cache_path . '/ZFLSP_doNotUpdateMap')
    endif
endfunction
call ZF_ModuleInstaller('_ZFLSP_autoSetup_doNotUpdate_reset', 'call _ZFLSP_autoSetup_doNotUpdate_reset()')

" ============================================================
augroup ZFLSP_augroup
    autocmd!
    autocmd User ZFLSP_restartBegin silent
    autocmd User ZFLSP_restart silent
    autocmd User ZFLSP_restartEnd silent
    autocmd User ZFVimrcPostNormal call ZFLSP_restart(0)
    if exists('##DirChanged')
        autocmd DirChanged * call ZFLSP_restart()
    endif
augroup END
function! ZFLSP_restart(...)
    let delay = get(a:, 1, 3000)
    if exists('s:restart_delayTimerId')
        call timer_stop(s:restart_delayTimerId)
        unlet s:restart_delayTimerId
    endif
    if has('timers') && delay > 0
        let s:restart_delayTimerId = timer_start(get(a:, 1, 3000), function('s:restart_delay'))
    else
        call s:restart_delay()
    endif
endfunction
function! s:restart_delay(...)
    if exists('s:restart_delayTimerId')
        unlet s:restart_delayTimerId
    endif
    doautocmd User ZFLSP_restartBegin
    doautocmd User ZFLSP_restart
    doautocmd User ZFLSP_restartEnd
endfunction

