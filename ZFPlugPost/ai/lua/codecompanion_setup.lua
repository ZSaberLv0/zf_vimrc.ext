
local option = function(v, def)
    if v ~= nil and v ~= '' and v ~= {} then
        return v
    else
        return def
    end
end
local host = option(vim.g.ZFLLM_API_HOST, 'https://api.hunyuan.cloud.tencent.com')
local key = option(vim.g.ZFLLM_API_KEY, '')
local model = option(vim.g.ZFLLM_API_MODEL, 'hunyuan-lite')
local language = option(vim.g.ZFLLM_LANG, 'Chinese')
local adapter = option(vim.g.ZFLLM_API_ADAPTER, 'ZFLLM')
local adapter_opts = option(vim.g.ZFLLM_API_ADAPTER_OPTS, {})


-- ============================================================
local merge = nil
merge = function(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k]) == "table" then
                merge(t1[k], v)
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

-- ============================================================
local option = {
    adapters = {
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
            adapter = 'ZFLLM',
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
        send_code = false,
        language = language,
    },
}

if adapter ~= 'ZFLLM' then
    option['adapters']['ZFLLM'] = function()
        return require('codecompanion.adapters').extend(adapter, merge({
            env = {
                url = host,
                api_key = key,
            },
            schema = {
                model = {
                    default = model,
                },
            },
        }, adapter_opts))
    end
else
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
    option['adapters']['ZFLLM'] = function()
        return require('codecompanion.adapters').extend('openai_compatible', merge({
            env = {
                url = host,
                api_key = key,
            },
            schema = {
                model = {
                    default = model,
                },
            },
            handlers = {
                form_messages = form_messages,
            },
        }, adapter_opts))
    end
end

require('codecompanion').setup(option)

