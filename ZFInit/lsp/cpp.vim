
" ============================================================
if !exists('g:zflsp_cpp')
    let g:zflsp_cpp = g:zflspEnable
endif
if g:zflsp_cpp
    " prefer order:
    "   clangd
    "     compile_flags.txt
    "     .clang_complete
    "   ccls
    "     compile_flags.txt
    "     .clang_complete
    "
    " you may also supply functions or flags to detect extra compile flags:
    "   function! YourCppFlagsFunc()
    "     return [
    "         \   '-DDEBUG',
    "         \   '-Ipath1',
    "         \   '-Ipath2',
    "         \ ]
    "   endfunction
    "   if !exists('g:zflsp_cpp_extraFlags')
    "       let g:zflsp_cpp_extraFlags = {}
    "   endif
    "   let g:zflsp_cpp_extraFlags['YourModule1'] = 'YourCppFlagsFunc'
    "   let g:zflsp_cpp_extraFlags['YourModule2'] = ['-DDEBUG', '-Ipath1', '-Ipath2']
    if !exists('g:zflsp_cpp_config_file')
        let g:zflsp_cpp_config_file = ['compile_flags.txt', '.clang_complete']
    endif
    if !exists('g:zflsp_cpp_extraFlags')
        let g:zflsp_cpp_extraFlags = {}
    endif
endif

" ============================================================
if g:zflsp_cpp && !empty(ZF_ModuleGetApt())
    function! ZF_LSP_cpp_checker()
        return 0
                    \ || executable('clangd') || executable('/usr/local/opt/llvm/bin/clangd')
                    \ || executable('ccls')
    endfunction

    function! ZF_LSP_cpp_installer()
        if !executable('clangd') && !executable('/usr/local/opt/llvm/bin/clangd')
            call ZF_ModulePackAdd(ZF_ModuleGetApt(), 'clangd clang-tools llvm')
        endif
        if !executable('ccls')
            call ZF_ModulePackAdd(ZF_ModuleGetApt(), 'ccls')
        endif
    endfunction

    function! ZF_LSP_cpp_lsp()
        let ft = ['c', 'cpp', 'objc', 'objcpp']
        if 0
        elseif executable('clangd') || executable('/usr/local/opt/llvm/bin/clangd')
            function! s:options_clangd()
                return {
                            \   'fallbackFlags' : ZF_LSP_cpp_detectFlag(),
                            \ }
            endfunction
            let clangd_path = executable('clangd') ? 'clangd' : '/usr/local/opt/llvm/bin/clangd'
            let cmdargs = ['--completion-style=detailed']
            if ZF_versionCompare(ZF_versionGet('clangd'), '10.0') >= 0
                call add(cmdargs, '-header-insertion=never')
            endif
            return {
                        \   'cmd' : clangd_path,
                        \   'cmdargs' : cmdargs,
                        \   'ft' : ft,
                        \   'initOption' : function('s:options_clangd'),
                        \   'workspaceOption' : {
                        \   },
                        \ }
        elseif executable('ccls')
            function! s:options_ccls()
                return {
                            \   'cache' : {
                            \     'directory' : g:zf_vim_cache_path . '/ZFLSP_ccls',
                            \   },
                            \   'clang' : {
                            \     'extraArgs' : ZF_LSP_cpp_detectFlag(),
                            \   },
                            \ }
            endfunction
            return {
                        \   'cmd' : 'ccls',
                        \   'cmdargs' : [],
                        \   'ft' : ft,
                        \   'initOption' : function('s:options_ccls'),
                        \   'workspaceOption' : {
                        \   },
                        \ }
        else
            return {
                        \   'ft' : ft,
                        \ }
        endif
    endfunction

    call ZFLSP_autoSetup(1, 'cpp', function('ZF_LSP_cpp_checker'), function('ZF_LSP_cpp_installer'), function('ZF_LSP_cpp_lsp'))
endif

" ============================================================
if g:zflsp_cpp
    function! ZF_LSP_cpp_detectFlag()
        let flags = {}
        for f in values(get(g:, 'zflsp_cpp_extraFlags', {}))
            if type(f) == type('')
                try
                    let Fn = function(f)
                catch
                    continue
                endtry
                let tmpFlags = Fn()
            elseif type(f) == type([])
                let tmpFlags = f
            else
                continue
            endif
            for flag in tmpFlags
                let flags[flag] = 1
            endfor
        endfor
        for configFile in g:zflsp_cpp_config_file
            let file = findfile(configFile, getcwd() . ';')
            if !empty(file)
                break
            endif
        endfor
        if !empty(file)
            let path = fnamemodify(CygpathFix_absPath(file), ':h')
            for t in readfile(file)
                " (^[ \t]+)|([ \t]+$)
                let line = substitute(t, '\(^[ \t]\+\)\|\([ \t]\+$\)', '', 'g')
                if empty(line)
                    continue
                endif
                " ^-[a-zA-Z]\.+[\/\\]
                if match(line, '^-[a-zA-Z]\.\+[\/\\]') >= 0
                    let line = strpart(line, 0, 2) . CygpathFix_absPath(path . '/' . strpart(line, 2))
                endif
                let flags[line] = 1
            endfor
        endif
        return keys(flags)
    endfunction
endif

