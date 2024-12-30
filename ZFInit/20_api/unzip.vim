
let s:scriptPath = expand('<sfile>:p:h:h:h') . '/misc'

function! ZF_unzipAvailable()
    return g:zf_windows || executable('unzip')
endfunction

function! ZF_unzip(dstDir, zipFile)
    if !filereadable(a:zipFile)
        echo 'ERROR: zip file not exist: ' . a:zipFile
        return 0
    elseif g:zf_windows && 0
        call ZF_rm(a:dstDir)
        echo ZF_system(printf('call "%s/unzip.bat" "%s" "%s"'
                    \ , s:scriptPath
                    \ , a:zipFile
                    \ , a:dstDir
                    \ ))
        return v:shell_error == '0' ? 1 : 0
    elseif executable('unzip')
        call ZF_rm(a:dstDir)
        call mkdir(a:dstDir, 'p')
        call ZF_system(printf('yes | unzip "%s" -d "%s/."'
                        \ , a:zipFile
                        \ , a:dstDir
                        \ ))
        return v:shell_error == '0' ? 1 : 0
    else
        echo 'ERROR: unzip not available'
        return 0
    endif
endfunction

