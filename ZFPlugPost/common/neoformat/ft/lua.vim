
if !get(g:, 'ZF_Plugin_neoformat', 0)
    finish
endif

function! ZF_Plugin_neoformat_lua_install()
    let urls = ZF_ModuleGetGithubRelease('JohnnyMorganz', 'StyLua')
    if empty(urls)
        echo 'ERROR: unable to obtain release files'
        return
    endif

    if g:zf_windows || g:zf_cygwin
        let platform = 'windows'
    elseif g:zf_mac
        let platform = 'macos'
    else
        let platform = 'linux'
    endif
    if g:zf_windows || g:zf_cygwin
        let arch = 'x86_64'
    else
        let arch = join(split(ZF_system('uname -m')))
    endif
    let fileName = printf('stylua-%s-%s.zip', platform, arch)
    let url = ''
    for f in urls
        if match(f, fileName) >= 0
            let url = f
            break
        endif
    endfor
    if empty(url)
        echo 'ERROR: unable to obtain proper release file from: ' . join(urls, ',')
        return
    endif

    if !ZF_ModuleDownloadFile(g:zf_vim_cache_path . '/neoformat/lua/' . fileName, url)
        echo 'ERROR: unable to download: ' . url
        return
    endif

    call mkdir(printf('%s/neoformat/lua/bin', g:zf_vim_cache_path), 'p')
    if !ZF_unzip(printf('%s/neoformat/lua/bin', g:zf_vim_cache_path)
                \ , printf('%s/neoformat/lua/%s', g:zf_vim_cache_path, fileName)
                \ )
        return
    endif
    call ZF_ModuleExecShell(printf('chmod +x "%s/neoformat/lua/bin/stylua"', g:zf_vim_cache_path))

    call writefile([
                \   'indent_type="Spaces"',
                \   'quote_style="AutoPreferSingle"',
                \ ], printf('%s/neoformat/lua/stylua.toml', g:zf_vim_cache_path))
    call ZF_ModuleInstallerPermissionFix(printf('%s/neoformat', g:zf_vim_cache_path))
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

