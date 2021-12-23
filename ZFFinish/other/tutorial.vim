
" ==================================================
" tutorial
if 1
    nnoremap z? :call ZFVimrcGuide()<cr>
    function! ZFVimrcGuide()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader> is single quote', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vimru to update this vimrc with github repo', 'command':'call ZF_VimrcUpdate()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'key mappings', 'command':'call ZFVimrcGuide_keymap()', 'itemType':'subMenu'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'window and buffer management', 'command':'call ZFVimrcGuide_window()', 'itemType':'subMenu'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'tools', 'command':'call ZFVimrcGuide_tools()', 'itemType':'subMenu'})
        call ZF_VimCmdMenuShow({'headerText':'zf_vimrc quick tutorial:'})
    endfunction

    function! ZFVimrcGuide_keymap()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'? for search with perl regexp syntax', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'s/S for quick cursor jump', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'Q to record macro and M to replay macro', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':':: or // to open command/search history, q to exit', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'EH/EL/EJ/EK/EI for cursor jump by indent', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'z)/z]/z} for cursor jump by brace', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'t/T for select within quotes', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'ZB to open fold utility', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'Z)/Z]/Z}/Z> to fold by brace', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'ZH/ZL/ZI/ZO/ZU for manual fold', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'zn/zm/<leader>vr/<leader>zr for quick search and replace', 'itemType':'keep'})
        call ZF_VimCmdMenuShow({'headerText':'key mappings:'})
    endfunction

    function! ZFVimrcGuide_window()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<c-o> to open files by file name (fuzzy search)', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'H/L to switch to prev/next buffer', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'WH/WL/WJ/WK to jump between windows', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'Wh/Wl/Wj/Wk/WM/WN to resize windows', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'x to close current buffer, and X to close all except current', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>ve to open file explorer', 'command':'NERDTreeToggle'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vt to open TOC list', 'itemType':'keep'})
        call ZF_VimCmdMenuShow({'headerText':'window and buffer management:'})
    endfunction

    function! ZFVimrcGuide_tools()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vgf / <leader>vgr to grep/replace (with perl regexp syntax)', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>zs to open interactive shell within vim', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vs / <leader>vc to run shell/vim command and copy result to clipboard', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vvs / <leader>vvc to run shell/vim command in clipboard and copy result to clipboard', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vvo to open all file in clipboard', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vdb / <leader>vdd to diff two buffer/file/dir', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vy to open translate util', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cc to open convert utility', 'command':'call ZF_Convert()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>ce to open escape utility', 'command':'call ZF_VimEscape()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cf to open formater utility', 'command':'call ZF_Formater()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cm to open toggle utility', 'command':'call ZF_Toggle()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cth toggle plain txt highlight', 'command':'call ZF_VimTxtHighlightToggle()'})
        call ZF_VimCmdMenuShow({'headerText':'tools:'})
    endfunction
endif

