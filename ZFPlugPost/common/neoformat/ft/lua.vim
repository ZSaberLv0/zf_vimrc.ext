
if !get(g:, 'ZF_Plugin_neoformat', 0)
    finish
endif

function! ZF_Plugin_neoformat_lua_install()
    if !executable('unzip')
        call ZF_ModulePackAdd(ZF_ModuleGetApt(), 'unzip')
        if !executable('unzip')
            echo 'ERROR: no unzip available'
            return
        endif
    endif

    let urls = ZF_ModuleGetGithubRelease('JohnnyMorganz', 'StyLua')
    if empty(urls)
        echo 'ERROR: unable to obtain release files'
        return
    endif

    if g:zf_windows || g:zf_cygwin
        let platform = 'win64'
    elseif g:zf_mac
        let platform = 'macos'
    else
        let platform = 'linux'
    endif
    let url = ''
    for f in urls
        if match(f, 'stylua-' . platform . '.zip') >= 0
            let url = f
            break
        endif
    endfor
    if empty(url)
        echo 'ERROR: unable to obtain proper release file from: ' . join(urls, ',')
        return
    endif

    let fileName = 'stylua-' . platform . '.zip'
    if !ZF_ModuleDownloadFile(g:zf_vim_cache_path . '/neoformat/lua/' . fileName, url)
        echo 'ERROR: unable to download: ' . url
        return
    endif

    call mkdir(printf('%s/neoformat/lua/bin', g:zf_vim_cache_path), 'p')
    call ZF_ModuleExecShell(printf('yes | unzip "%s/neoformat/lua/%s" -d "%s/neoformat/lua/bin/."'
                \ , g:zf_vim_cache_path, fileName
                \ , g:zf_vim_cache_path
                \ ))
    call ZF_ModuleExecShell(printf('chmod +x "%s/neoformat/lua/bin/stylua"', g:zf_vim_cache_path))

    call writefile([
                \   'indent_type="Spaces"',
                \   'quote_style="AutoPreferSingle"',
                \ ], printf('%s/neoformat/lua/stylua.toml', g:zf_vim_cache_path))
endfunction
call ZF_ModuleInstaller('neoformat_lua', 'call ZF_Plugin_neoformat_lua_install()')

let exe = printf('%s/neoformat/lua/bin/stylua%s', g:zf_vim_cache_path, (g:zf_windows || g:zf_cygwin) ? '.exe' : '')
if executable(exe)
            \ && filereadable(printf('%s/neoformat/lua/stylua.toml', g:zf_vim_cache_path))
    let g:neoformat_lua_stylua = {
                \   'exe': exe,
                \   'args': [
                \     '--search-parent-directories',
                \     '--config-path',
                \     printf('"%s/neoformat/lua/stylua.toml"', g:zf_vim_cache_path),
                \     '--stdin-filepath',
                \     '"%:p"',
                \     '--',
                \     '-',
                \   ],
                \   'stdin': 1,
                \ }
    let g:neoformat_enabled_lua = ['stylua']
endif

