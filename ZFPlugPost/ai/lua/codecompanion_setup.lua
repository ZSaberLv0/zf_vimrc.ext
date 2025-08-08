
--[[

let g:ZFLLM_ADAPTER = 'hunyuan-lite'
let g:ZFLLM_ADAPTERS = {
            \   'hunyuan-lite' : {
            \     'extend' : 'openai_compatible',
            \     'opts' : {
            \       'env' : {
            \         'api_key' : 'xxx',
            \         'url' : 'https://api.hunyuan.cloud.tencent.com',
            \         'chat_url' : '/v1/chat/completions',
            \       },
            \       'schema' : {
            \         'model' : {
            \           'default' : 'hunyuan-lite',
            \         },
            \       },
            \     },
            \   },
            \   'deepseek' : {
            \     'extend' : 'deepseek',
            \     'opts' : {
            \       'env' : {
            \         'api_key' : 'xxx',
            \       },
            \       'schema' : {
            \         'model' : {
            \           'default' : 'deepseek-chat',
            \         },
            \       },
            \     },
            \   },
            \   'githubmodels' : {
            \     'extend' : 'openai_compatible',
            \     'opts' : {
            \       'env' : {
            \         'api_key' : 'xxx',
            \         'url' : 'https://models.github.ai',
            \         'chat_url' : '/inference/chat/completions',
            \       },
            \       'schema' : {
            \         'model' : {
            \           'default' : 'openai/gpt-4.1',
            \         },
            \       },
            \     },
            \   },
            \   'tavily' : {
            \     'extend' : 'tavily',
            \     'opts' : {
            \       'env' : {
            \         'api_key' : 'xxx',
            \       },
            \     },
            \   },
            \ }

]]

local option = function(v, def)
    if v ~= nil and v ~= '' and v ~= {} then
        return v
    else
        return def
    end
end
local ZFLLM_ADAPTER = option(vim.g.ZFLLM_ADAPTER, 'openai_compatible')
local ZFLLM_ADAPTERS = option(vim.g.ZFLLM_ADAPTERS, {})

local ZFLLM_LANG = option(vim.g.ZFLLM_LANG, 'Chinese')
local ZFLLM_LOG_LEVEL = option(vim.g.ZFLLM_LOG_LEVEL, 'ERROR')


-- ============================================================
local option = {
    adapters = {
        opts = {
            allow_insecure = false,
            show_defaults = true,
        },
    },
    strategies = {
        chat = {
            adapter = ZFLLM_ADAPTER,
            keymaps = {
                completion = {modes = {
                        i = {'<c-p>'},
                }},
                send = {modes = {
                        n = {'<c-s>', '<cr>'},
                        i = {'<c-s>'},
                }},
                close = {modes = {
                        n = {'\\CodeCompanion?q'},
                }},
                stop = {modes = {
                        n = {'<c-c>'},
                        i = {'<c-c>'},
                }},
            },
            roles = {
                llm = 'AI :',
                user = 'Me :',
            },
        },
        inline = {
            adapter = ZFLLM_ADAPTER,
        },
        cmd = {
            adapter = ZFLLM_ADAPTER,
        },
    },
    display = {
        chat = {
            window = {
                layout = 'float',
                height = 0.8,
                width = 0.9,
                opts = {
                    cursorline = true,
                },
            },
            intro_message = '',
            show_header_separator = true,
            show_token_count = false,
        },
    },
    opts = {
        log_level = ZFLLM_LOG_LEVEL,
        language = ZFLLM_LANG,
        send_code = false,
    },
}

for k,v in pairs(ZFLLM_ADAPTERS) do
    option['adapters'][k] = function()
        return require('codecompanion.adapters').extend(v['extend'], v['opts'])
    end
end

require('codecompanion').setup(option)

