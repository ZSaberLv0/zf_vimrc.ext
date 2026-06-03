
if !g:zf_windows
    finish
endif

" shellslash with `shell=cmd.exe` may break some plugin
if 0
    set shellslash
else
    if exists('&completeslash')
        set completeslash=slash
    endif
endif

" ensure cygwin at head of PATH,
" otherwise some Windows' shell function may break cygwin's command,
" such as 'find'
function! s:fixCygwinPath()
    let allPath = split($PATH, ';')
    let cygwinPath = []
    let i = len(allPath) - 1
    while i >= 0
        if empty(allPath[i])
            call remove(allPath, i)
        elseif match(tolower(allPath[i]), 'cygwin') >= 0
            call add(cygwinPath, remove(allPath, i))
        endif
        let i -= 1
    endwhile
    if empty(cygwinPath)
        let cygwinPath = ['C:\cygwin\bin', 'C:\cygwin64\bin;']
    endif
    let $PATH = join(extend(cygwinPath, allPath), ';')
endfunction
call s:fixCygwinPath()

" add `.py` to `PATHEXT`
if match($PATHEXT, '\.PY') < 0
    let $PATHEXT.=';.PY'
endif

function! ZF_Windows_WindowCenterInScreen()
    set lines=9999 columns=9999
    let linesTmp = &lines
    let columnsTmp = &columns
    let sizeFixX = 58
    let sizeFixY = 118
    let scaleX = 7.75
    let scaleY = 17.0
    let screenWidth = float2nr(winwidth(0) * scaleX) + getwinposx() + sizeFixX
    let screenHeight = float2nr(winheight(0) * scaleY) + getwinposy() + sizeFixY
    if linesTmp <= 45 || columnsTmp <= 160
        set lines=35 columns=120
    else
        set lines=45 columns=160
    endif
    let sizeWidth = float2nr(winwidth(0) * scaleX) + sizeFixX
    let sizeHeight = float2nr(winheight(0) * scaleY) + sizeFixY
    let posX = ((screenWidth - sizeWidth) / 2)
    let posY = ((screenHeight - sizeHeight) / 2)
    execute ':winpos ' . posX . ' ' . posY
endfunction
augroup ZF_Windows_WindowCenterInScreen_augroup
    autocmd!
    autocmd GUIEnter * call ZF_Windows_WindowCenterInScreen()
augroup END

