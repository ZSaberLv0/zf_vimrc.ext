
local host = 'https://spark-api-open.xf-yun.com'
local api = '/v1/chat/completions'
local key = vim.api.nvim_get_var('ZFLLM_API_KEY')
local model = 'lite'

require('codecompanion').setup({
        adapters = {
            ZFLLM = function()
                return require('codecompanion.adapters').extend('openai_compatible', {
                        env = {
                            url = host,
                            api_key = key,
                            chat_url = api,
                            models_endpoint = '/v1/models',
                        },
                        schema = {
                            model = {
                                default = model,
                            },
                        },
                    })
            end,
            opts = {
                show_defaults = false,
            },
        },
        strategies = {
            chat = {
                adapter = 'ZFLLM',
                keymaps = {
                    send = {modes = {
                            n = {'<c-s>', '<cr>'},
                            i = {'<c-s>'},
                    }},
                    close = {modes = {
                            n = {'q'},
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
                adapter = 'ZFLLM',
            },
        },
        display = {
            chat = {
                window = {
                    layout = 'buffer',
                    opts = {
                        cursorline = true,
                    },
                },
                intro_message = '',
                show_header_separator = true,
                show_token_count = false,
                start_in_insert_mode = true,
            },
        },
        opts = {
            send_code = false,
        },
    })

