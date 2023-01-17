
function! ZF_LSP_objcpp_setup(...)
    if !g:zf_mac
        return 0
    endif

    let xcodePath = get(a:, 1, '/Applications/Xcode.app')
    let platform = get(a:, 2, 'iPhoneSimulator')
    let cachePath = get(a:, 3, g:zf_vim_cache_path . '/ZFLSP_objcpp/iOS')

    if !isdirectory(xcodePath)
        echo 'xcode path not exist: ' . xcodePath
        return 0
    endif

    " /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/Foundation.framework/Headers
    let frameworkPath = xcodePath . '/Contents/Developer/Platforms/' . platform . '.platform/Developer/SDKs/' . platform . '.sdk/System/Library/Frameworks'
    let frameworks = split(system(printf('ls "%s/."', frameworkPath)), "\n")

    if !isdirectory(frameworkPath)
        echo 'framework path not exist: ' . frameworkPath
        return 0
    endif

    if empty(frameworks)
        echo 'no framework found in framework path: ' . frameworkPath
        return 0
    endif

    call system('rm -rf "' . cachePath . '"')
    call mkdir(cachePath, 'p')

    for framework in frameworks
        if framework[0] == '_'
            continue
        endif
        let frameworkName = substitute(framework, '\.framework', '', '')
        call system('ln -s "' . frameworkPath . '/' . framework . '/Headers" "' . cachePath . '/' . frameworkName . '"')
    endfor

    return 1
endfunction

if isdirectory(g:zf_vim_cache_path . '/ZFLSP_objcpp/iOS')
    let g:zflsp_cpp_extraFlags['objcpp_iOS'] = [
                \   '-I' . g:zf_vim_cache_path . '/ZFLSP_objcpp/iOS',
                \ ]
endif
function! ZF_LSP_objcpp_iOS_install()
    call ZF_LSP_objcpp_setup()
endfunction
call ZF_ModuleInstaller('ZF_LSP_objcpp_iOS', 'call ZF_LSP_objcpp_iOS_install()')

augroup ZF_LSP_objcpp_iOS_augroup
    autocmd!
    autocmd! BufNewFile,BufRead,BufWritePost *.m set filetype=objc
    autocmd! BufNewFile,BufRead,BufWritePost *.mm set filetype=objcpp
augroup END

