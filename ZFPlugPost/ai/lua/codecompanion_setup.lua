
local host = vim.g.ZFLLM_API_HOST or 'https://api.hunyuan.cloud.tencent.com'
local addr_chat = vim.g.ZFLLM_API_ADDR_CHAT or '/v1/chat/completions'
local key = vim.g.ZFLLM_API_KEY or ''
local model = vim.g.ZFLLM_API_MODEL or 'hunyuan-lite'
local language = vim.g.ZFLLM_LANG or 'Chinese'

local openai = require("codecompanion.adapters.openai")
local utils = require("codecompanion.utils.adapters")
local form_messages = function(self, messages)
    messages = openai.handlers.form_messages(self, messages).messages
    local system_messages = vim
        .iter(messages)
        :filter(function(msg)
            return msg.role == "system"
        end)
        :totable()
    system_messages = utils.merge_messages(system_messages)

    messages = vim
        .iter(messages)
        :filter(function(msg)
            return msg.role ~= "system"
        end)
        :map(function(msg)
            return {
                role = msg.role,
                content = msg.content,
            }
        end)
        :totable()
    messages = utils.merge_messages(messages)

    return { messages = vim.list_extend(system_messages, messages) }
end

local option = {
    adapters = {
        ZFLLM = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
                    env = {
                        url = host,
                        api_key = key,
                        chat_url = addr_chat,
                    },
                    schema = {
                        model = {
                            default = model,
                        },
                    },
                    handlers = {
                        form_messages = form_messages,
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
                completion = {modes = {
                        i = {'<c-p>'},
                }},
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
        language = language,
    },
}

require('codecompanion').setup(option)

