
" ============================================================
if !exists('g:zflsp_rust')
    let g:zflsp_rust = g:zflspEnable
endif
if g:zflsp_rust
    let s:globalConfigPath = g:zf_vim_cache_path . '/ZFLSP_rust_analyzer/Cargo.toml'
    function! ZF_LSP_rust_checker()
        return executable('rust-analyzer')
    endfunction
    function! ZF_LSP_rust_installer()
        if !executable('rustup')
            call ZF_ModuleInstallFail('rustup not available')
            return
        endif
        call ZF_ModuleExec('rustup component add rust-src')
        call ZF_ModuleExec('rustup component add rust-analyzer')
        call s:updateConfig()
    endfunction
    function! ZF_LSP_rust_initOption()
        let defConfig = {
                    \   'linkedProjects' : [
                    \   ],
                    \ }
        if filereadable('rust-project.json') || filereadable('Cargo.toml')
            call s:augroupStop()
            return defConfig
        endif

        let sysroot = trim(ZF_shellcache('rustc --print sysroot'))
        if !executable('rustc') || empty(sysroot)
            call s:augroupStop()
            return defConfig
        endif

        call s:augroupStart()
        return {
                    \   'linkedProjects' : [
                    \     s:globalConfigPath,
                    \   ],
                    \ }
    endfunction
    call ZFLSP_autoSetup(1, 'rust', function('ZF_LSP_rust_checker'), function('ZF_LSP_rust_installer'), {
                \   'cmd' : 'rust-analyzer',
                \   'cmdargs' : [],
                \   'ft' : ['rust'],
                \   'initOption' : function('ZF_LSP_rust_initOption'),
                \   'workspaceOption' : {
                \   },
                \ })

    function! s:updateConfig(...)
        let filePath = get(a:, 1, '')
        let contents = [
                    \   '[package]',
                    \   'name = "zflsp_tmp"',
                    \   'version = "0.1.0"',
                    \   'edition = "2021"',
                    \   '',
                    \   '[dependencies]',
                    \ ]
        if !empty(filePath) && filereadable(filePath)
            call extend(contents, [
                        \   '[[bin]]',
                        \   'name = "zflsp_tmp"',
                        \   'path = "' . fnamemodify(filePath, ':p') . '"',
                        \ ])
        endif
        call mkdir(fnamemodify(s:globalConfigPath, ':h'), 'p')
        call writefile(contents, s:globalConfigPath)
        if filePath != get(s:, 'filePathLast', '')
            let s:filePathLast = filePath
            call ZFLSP_restart()
        endif
    endfunction
    function! s:augroupStart()
        if !has('timers')
            return
        endif

        augroup ZF_LSP_rust_augroup
            autocmd!
            autocmd BufWinEnter,FileType * call s:bufEnter()
        augroup END
    endfunction
    function! s:augroupStop()
        augroup ZF_LSP_rust_augroup
            autocmd!
        augroup END
        let s:filePath = ''
        if get(s:, 'updateConfigDelayId', -1) != -1
            call timer_stop(s:updateConfigDelayId)
        endif
        let s:updateConfigDelayId = timer_start(200, function('s:updateConfigDelay'))
    endfunction
    function! s:bufEnter()
        if &filetype == 'rust'
            let s:filePath = expand('<afile>')
            if get(s:, 'updateConfigDelayId', -1) != -1
                call timer_stop(s:updateConfigDelayId)
            endif
            let s:updateConfigDelayId = timer_start(200, function('s:updateConfigDelay'))
        endif
    endfunction
    function! s:updateConfigDelay(...)
        let s:updateConfigDelayId = -1
        call s:updateConfig(s:filePath)
    endfunction
endif

