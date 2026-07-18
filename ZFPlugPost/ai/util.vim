
" params: {
"   'prompt' : 'You are a helpful assistant.',
"   'text' : 'output `OK` immediately, do not output anything else',
"   'msg' : [
"     {
"       'role' : 'system',
"       'content' : 'You are a helpful assistant.',
"     },
"     {
"       'role' : 'user',
"       'content' : 'output `OK` immediately, do not output anything else',
"     },
"   ],
"   'url' : 'https://api-inference.modelscope.cn',
"   'chat_url' : '/v1/chat/completions',
"   'key' : 'xxx',
"   'model' : 'Qwen/Qwen3.5-27B',
"   'verbose' : '1/0',
" }
function! ZFLLM_test(params)
    if type(a:params) == type('')
        let params = {
                    \   'msg' : [
                    \     {
                    \       'role' : 'system',
                    \       'content' : 'You are a helpful assistant.',
                    \     },
                    \     {
                    \       'role' : 'user',
                    \       'content' : a:params,
                    \     },
                    \   ],
                    \ }
    else
        let params = a:params
    endif

    let verbose = get(params, 'verbose', '') != '0'

    let cfg = ZF_get({}, g:, 'ZFLLM_ADAPTERS', get(g:, 'ZFLLM_ADAPTER', ''))

    let url = get(params, 'url', ZF_get('', cfg, 'opts', 'env', 'url'))
    if empty(url)
        echo 'url is required'
        return
    endif

    let chat_url = get(params, 'chat_url', ZF_get('', cfg, 'opts', 'env', 'chat_url'))
    if empty(chat_url)
        echo 'chat_url is required'
        return
    endif

    let key = get(params, 'key', ZF_get('', cfg, 'opts', 'env', 'api_key'))
    if empty(key)
        echo 'key is required'
        return
    endif

    let model = get(params, 'model', ZF_get('', cfg, 'opts', 'schema', 'model', 'default'))
    if empty(model)
        echo 'model is required'
        return
    endif

    let msg = get(params, 'msg', [])
    if empty(msg)
        let prompt = get(params, 'prompt', '')
        if empty(prompt)
            let prompt = 'You are a helpful assistant.'
        endif
        let text = get(params, 'text', '')
        if empty(text)
            let text = 'output `OK` immediately, do not output anything else'
        endif
        let msg = [
                    \   {
                    \     'role' : 'system',
                    \     'content' : prompt,
                    \   },
                    \   {
                    \     'role' : 'user',
                    \     'content' : text,
                    \   },
                    \ ]
    endif

    let cmd = 'curl --request POST -s'
    let cmd .= ' --url ' . url . chat_url
    let cmd .= ' -H "Content-Type: application/json"'
    let cmd .= printf(' -H "Authorization: Bearer %s"', key)
    if verbose
        let cmd .= ' -i'
    endif
    let cmd .= " -d '" . printf('{"model":"%s","messages":%s}', model, json_encode(msg)) . "'"
    let result = system(cmd)
    let @t = result
    if verbose
        echo cmd
        echo "\n"
        echo '------------------------------------------------------------'
        echo "\n"
    endif
    echo result
endfunction

