local util = require "formatter.util"
local config = require "formatter.config"
local format = require "formatter.format"

local M = {}

function M.format(args, startLine, endLine, write)
  local userPassedFmt = util.split(args, " ")
  local modifiable = vim.bo.modifiable
  if not modifiable then
    util.print("Buffer is not modifiable")
    return
  end

  local F = {}
  local configs = {}

  function F.run(current)
    M.startTask(current, startLine, endLine, write, F.step)
  end

  function F.step()
    if #configs == 0 then
      return
    end
    F.run(table.remove(configs, 1))
  end

  for _, embedded in pairs(config.values.embedded or {}) do
    local formatters = config.values.filetype[embedded.filetype]
    if not util.isEmpty(formatters) then
      local configsToRun = util.getConfigsToRun(userPassedFmt, formatters)

      table.insert(
        configs,
        {
          start_pattern = embedded.start_pattern,
          end_pattern = embedded.end_pattern,
          configs = configsToRun
        }
      )
    end
  end

  F.step()
end

function M.startTask(opts, firstLine, lastLine, write, cb)
  local view = vim.fn.winsaveview()

  vim.fn.cursor(firstLine, 1)
  local startLine = vim.fn.search(opts.start_pattern, "Wc")
  if startLine == 0 then
    vim.fn.winrestview(view)
    cb()
    return
  end
  local endLine = vim.fn.search(opts.end_pattern, "W")
  if endLine == 0 or endLine > lastLine then
    vim.fn.winrestview(view)
    cb()
    return
  end

  startLine = startLine
  endLine = endLine - 1

  local callback = function()
    M.startTask(opts, startLine + 1, lastLine, write, cb)
  end

  format.startTask(vim.deepcopy(opts.configs), startLine, endLine, write, callback)

  vim.fn.winrestview(view)
end

return M
