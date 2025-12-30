
" ==================================================
if !exists('g:ZF_Plugin_markdown')
    let g:ZF_Plugin_markdown = 1
endif
if g:ZF_Plugin_markdown
    function! ZF_Plugin_vim_markdown_init(v)
        let searchSaved = @/
        let cursorSaved = getpos('.')
        execute 'if !exists("' . a:v . '") | let ' . a:v . ' = [] | endif'
        execute 'let v = ' . a:v
        let ftMap = {}
        for t in v
            let ftMap[t] = 1
        endfor
        let tmpList = []
        silent! g/^[ \t]*```[ \t]*[a-z0-9_]\+[ \t]*$/execute 'call add(tmpList, getline("."))'
        for item in tmpList
            let t = substitute(item, '^[ \t]*```[ \t]*\([a-z0-9_]\+\)[ \t]*$', '\1', 'g')
            if !empty(t)
                let ftMap[t] = 1
            endif
        endfor
        let @/ = searchSaved
        call setpos('.', cursorSaved)
        let i = 0
        for t in keys(ftMap)
            if empty(globpath(&rtp, 'syntax/' . t . '.vim'))
                call remove(ftMap, t)
            else
                let i += 1
            endif
        endfor
        execute 'let ' . a:v . ' = keys(ftMap)'
    endfunction
    if 1
        ZFPlug 'rhysd/vim-gfm-syntax'
        let ZF_Plugin_vim_markdown_cfg = 'g:markdown_fenced_languages'
    else
        ZFPlug 'plasticboy/vim-markdown'
        let ZF_Plugin_vim_markdown_cfg = 'g:vim_markdown_fenced_languages'
    endif
    augroup ZF_Plugin_vim_markdown_augroup
        autocmd!
        autocmd FileType markdown call ZF_Plugin_vim_markdown_init(ZF_Plugin_vim_markdown_cfg)
        autocmd BufWritePost *
                    \  if &filetype == 'markdown'
                    \|     call ZF_Plugin_vim_markdown_init(ZF_Plugin_vim_markdown_cfg)
                    \|     set syntax=
                    \|     set syntax=markdown
                    \| endif
    augroup END
endif

" ==================================================
if !exists('g:ZF_Plugin_markdown_toc')
    let g:ZF_Plugin_markdown_toc = 1
endif
if g:ZF_Plugin_markdown_toc
    ZFPlug 'mzlogin/vim-markdown-toc'
    command! -nargs=0 TOCAdd :GenTocGFM
    command! -nargs=0 TOCRemove :RemoveToc
    command! -nargs=0 TOCUpdate :UpdateToc
endif

