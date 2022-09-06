local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.remove_trailing_whitespace = util.withl(defaults.sed, "[ \t]*$")

M.lsp_formatting = function()
  return {
    name = "lsp-format",
    exe = function(opts)
      local clients = vim.lsp.buf_get_clients()
      local bufnr = vim.api.nvim_get_current_buf()

      for client_id, client in pairs(clients) do
        local method = "textDocument/formatting"
        local timeout_ms = 2000
        local res = client.request_sync(method, {}, timeout_ms, bufnr) or {}

        -- This is a caught by the caller
        assert(
          res.err == nil,
          string.format("LSP %s returned an error %s", client.name or string.format("client_id=%d", client_id), tostring(res.err))
        )

        if res == nil then
          -- No formatting applied
          return
        end

        -- Success, we had formatting to apply, apply it to the buffer
        vim.lsp.util.apply_text_edits(res.result, bufnr, "utf-16")

        if opts.write then
          -- :update is like :w but only if there's changes present
          vim.cmd [[ update ]]
        end
      end
    end,
  }
end

return M
