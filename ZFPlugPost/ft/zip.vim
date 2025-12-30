
function! ZF_Setting_zip_setupDelay(...)
    nnoremap <silent><buffer> x :bd<cr>
endfunction
function! s:setup()
    nmap <silent><buffer> o <cr>
    nnoremap <silent><buffer> x :bd<cr>
    if exists('*ZFJobTimerStart')
        call ZFJobTimerStart(0, function('ZF_Setting_zip_setupDelay'))
    endif
endfunction

augroup ZF_Setting_zip
    autocmd!
    autocmd FileType zip call s:setup()
augroup END

