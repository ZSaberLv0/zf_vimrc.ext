
" call ZFLLM_test('Qwen/Qwen3.5-27B', 'https://api-inference.modelscope.cn/v1/chat/completions', 'xxx')
function! ZFLLM_test(model, api, key)
    let msg = get(g:, 'ZFLLM_test_msg', [])
    if empty(msg)
        let msg = [
                    \   {
                    \     'role' : 'system',
                    \     'content' : 'you are AI assistant',
                    \   },
                    \   {
                    \     'role' : 'user',
                    \     'content' : 'output `OK` immediately, do not output anything else',
                    \   },
                    \ ]
    endif

    let cmd = 'curl --request POST'
    let cmd .= ' --url ' . a:api
    let cmd .= ' -H "Content-Type: application/json"'
    let cmd .= printf(' -H "Authorization: Bearer %s"', a:key)
    let cmd .= ' -i'
    let cmd .= " -d '" . printf('{"model":"%s","messages":%s}', a:model, json_encode(msg)) . "'"
    let result = system(cmd)
    let @t = result
    echo result
endfunction

