
local adapters = require('codecompanion.adapters')
local config = require('codecompanion.config')
local util = require('codecompanion.utils')

local M = {}
function M.changeAdapter(adapter_name, model_name)
    local chat = require('codecompanion.strategies.chat').last_chat()
    if not chat then
        util.notify('no chat window', vim.log.levels.WARN)
        return
    end
    local available_adapters = vim.tbl_deep_extend(
        'force',
        {},
        vim.deepcopy(config.adapters.acp or {}),
        vim.deepcopy(config.adapters.http or {})
    )
    if not available_adapters[adapter_name] then
        util.notify('adapter not exist: ' .. adapter_name, vim.log.levels.ERROR)
        return
    end
    chat:change_adapter(adapter_name, model_name)
end

return M

