local fmt = string.format

---@class CodeCompanion.Adapter
return {
  name = "langsearch",
  formatted_name = "LangSearch",
  roles = {
    llm = "assistant",
    user = "user",
  },
  opts = {},
  url = "https://api.langsearch.com/v1/web-search",
  env = {
    api_key = "LANGSEARCH_API_KEY",
  },
  headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer ${api_key}",
  },
  schema = {
    model = {
      default = "langsearch",
    },
  },
  handlers = {},
  methods = {
    tools = {
      search_web = {
        ---Setup the adapter for the fetch webpage tool
        ---@param self CodeCompanion.Adapter
        ---@param opts table Tool options
        ---@param data table The data from the LLM's tool call
        ---@return nil
        setup = function(self, opts, data)
          self.handlers.set_body = function()
            local body = {
              query = data.query,
            }
            return body
          end
        end,

        ---Process the output from the fetch webpage tool
        ---@param self CodeCompanion.Adapter
        ---@param data table The data returned from the fetch
        ---@return table{status: string, content: string}|nil
        callback = function(self, data)
          local ok, body = pcall(vim.json.decode, data.body)
          if not ok then
            return {
              status = "error",
              content = "Could not parse JSON response",
            }
          end

          if data.status ~= 200 then
            return {
              status = "error",
              content = fmt("Error %s - %s", data.status, body),
            }
          end

          if body.data.webPages.value == nil or #body.data.webPages.value == 0 then
            return {
              status = "error",
              content = "No results found",
            }
          end

          local output = vim
            .iter(body.data.webPages.value)
            :map(function(result)
              return {
                content = result.summary or "",
                title = result.name or "",
                url = result.url or "",
              }
            end)
            :totable()

          return {
            status = "success",
            content = output,
          }
        end,
      },
    },
  },
}
