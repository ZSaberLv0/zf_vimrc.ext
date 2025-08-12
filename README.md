extra bundles for [zf_vimrc.vim](https://github.com/ZSaberLv0/zf_vimrc.vim)

this repo holds some plugins that are useful but hard to config or has heavy dependency,
typically LSPs and AI Agents

note: this repo requires zf_vimrc.vim, to install, follow
[zf_vimrc.vim's install guide](https://github.com/ZSaberLv0/zf_vimrc.vim#quick-install)


# Minimal Recommend Config

* if you have `vim8` or `neovim`,
    you may use this repo to setup LSP quickly:

    1. have `git` and `curl` installed
    1. have any of these package manager available:
        * `apt-get`
        * `apt-cyg`
        * `yum`
        * `brew`
    1. we would automatically install complete engine according to your env in this order:
        * `coc.nvim` if `node` available
            * on Windows, this check is disabled by default,
                since the required node version is pretty high for coc.nvim,
                which is not so easy to install on old Windows
        * `asyncomplete` if none of above available
        * if you want to use specified complete engine:
            (see [complete_engine](https://github.com/ZSaberLv0/zf_vimrc.ext/tree/master/ZFPlugPost/complete_engine)
            for possible values)

            ```
            let g:ZF_Plugin_complete_engine = 'coc'
            ```

    1. use `curl zsaber.com/vim | sh` to install,
        this may take a long time,
        but required for only once
    1. if some external command line tools install failed,
        or if your env changed,
        you may use `:ZFModuleInstall` to manually update these tools

* if you have no `vim8` or `neovim`,
    do not waste your life on LSP,
    just use `<c-p>` or `<tab>`


# LSPs

see also:

* [complete_engine](https://github.com/ZSaberLv0/zf_vimrc.ext/tree/master/ZFPlugPost/complete_engine)
* [lsp](https://github.com/ZSaberLv0/zf_vimrc.ext/tree/master/ZFInit/lsp)


## C/C++

yeah, C/C++ is the most difficult LSP to config
because there's no standard way to config it

we're trying hard to make it simple stupid, the minimal config is:

* supply a file named `.clang_complete` or `compile_flags.txt`,
    which contains compile flags like `-Ipath/to/header`,
    each one by line

    * if you don't like the `.clang_complete` or `compile_flags.txt` file, you may:

        ```
        function! YourCppFlagsFunc()
          return [
              \   '-DDEBUG',
              \   '-Ipath1',
              \   '-Ipath2',
              \ ]
        endfunction
        if !exists('g:zflsp_cpp_extraFlags')
            let g:zflsp_cpp_extraFlags = {}
        endif
        let g:zflsp_cpp_extraFlags['YourModule1'] = 'YourCppFlagsFunc'
        let g:zflsp_cpp_extraFlags['YourModule2'] = ['-DDEBUG', '-Ipath1', '-Ipath2']
        ```

* additional installation

    * on Windows, install `llvm` and `VisualStudio`
        * the `VisualStudio` is required only for its builtin C++ header,
            for Windows, there seems no simple way to get proper C++ header without the huge IDE
    * on unix like systems, install `gcc-c++` or `libstdc++`


# AI Agents (neovim only)

see [codecompanion_setup.lua](https://github.com/ZSaberLv0/zf_vimrc.ext/tree/master/ZFPlugPost/ai/lua/codecompanion_setup.lua)

