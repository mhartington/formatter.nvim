local vim = vim
local api = vim.api
local config = require("format.config")
local runner = require("format.runner")
local util = require("format.util")
local formatter = {
  format = function(args, startLine, endLine)
    -- table of user passed formatters to run, if any
    userPassedFmtr = nil
    if not util.isEmpty(args) then
      userPassedFmtr = vim.split(args, " ")
    end
    view = vim.fn.winsaveview()

    -- Format stuff
    internalFormatter(userPassedFmtr, startLine, endLine)
    vim.fn.winrestview(view)
  end
}

function internalFormatter(userFmtTable, startLine, endLine)
  filetype = vim.fn.eval("&filetype")
  formatters = config.values[filetype]
  -- No formatters defined for the given file type
  if (util.isEmpty(formatters)) then
    print(string.format("Format: no formatter defined for %s files", filetype))
    return
  end

  if not util.isEmpty(userFmtTable) then
    for _, userFmt in ipairs(userFmtTable) do
      if not util.isEmpty(formatters[userFmt]) then
        startTask(userFmt, formatters[userFmt], startLine, endLine)
      end
    end
  else
    for fmt, config in pairs(formatters) do
      startTask(fmt, config, startLine, endLine)
    end
  end
end

function startTask(name, config, startLine, endLine)
  bufnr = api.nvim_get_current_buf()
  lines = util.getLines(bufnr, startLine, endLine)

  cmd = config.exe
  args = table.concat(config.args, " ")
  stdin = config.stdin or false

  if (stdin == true) then
    output = runner.createJob(cmd, args, lines)
    if (api.nvim_get_vvar("shell_error") == 0) then
      util.setLines(bufnr, startLine, endLine, output)
      util.log(string.format("Format: finished running %s", name))
    else
      util.log(output)
      util.log(string.format("Format: failed to run %s", name))
      return
    end
  else
    print("todo: handle non-stdin")
  end
end

return formatter
