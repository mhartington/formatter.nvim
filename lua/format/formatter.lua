local vim = vim
local api = vim.api
local config = require "format.config"
local runner = require "format.runner"
local util = require "format.util"
local formatter = {}

function formatter.format(args, startLine, endLine)
  local s
  local e
  if startLine ~= nil then
    s = startLine - 1
  else
    s = 0
  end
  e = endLine or -1
  -- table of user passed formatters to run, if any
  local userPassedFmtr = nil
  if not util.isEmpty(args) then
    userPassedFmtr = vim.split(args, " ")
  end
  local view = vim.fn.winsaveview()
  -- Format stuff
  formatter.internalFormatter(userPassedFmtr, s, e)
  vim.fn.winrestview(view)
end

function formatter.internalFormatter(userPassedFmt, startLine, endLine)
  local filetype = vim.fn.eval "&filetype"
  local formatters = config.values[filetype]
  -- No formatters defined for the given file type
  if util.isEmpty(formatters) then
    print(string.format("Format: no formatter defined for %s files", filetype))
    return
  end

  -- User passed a formatter as an arg
  -- Only run this one formatter if it's valid
  if not util.isEmpty(userPassedFmt) then
    for _, userFmt in ipairs(userPassedFmt) do
      if not util.isEmpty(formatters[userFmt]) then
        formatter.startTask(userFmt, formatters[userFmt], startLine, endLine)
      end
    end
  else
    print(type(formatters))
    -- User did not pass an arg, run them all
    for fmt, conf in pairs(formatters)
    do
      formatter.startTask(fmt, conf, startLine, endLine)
    end
  end
end

function formatter.startTask(name, conf, startLine, endLine)
    local o = conf()
    local bufnr = api.nvim_get_current_buf()
    local lines = util.getLines(bufnr, startLine, endLine)
    local exe = o.exe
    local exe_args = table.concat(o.args, " ")
    local stdin = o.stdin or false
    local output = nil

    local function onStderr(_, data, _)
      if data then
        util.log(string.format("Format: failed to run %s", name))
      end
    end
    local function onStdout(_, data, _)
      if data then
        output = data
      end
    end
    local function onExit()
      util.setLines(bufnr, startLine, endLine, output)
      util.log(string.format("Format: finished running %s", name))
    end
    if stdin == true then
      local job = runner:new({
          cmd = exe,
          args = exe_args,
          on_stdout = onStdout,
          on_stderr = onStderr,
          on_exit = onExit
        })
      job.send(lines)

    else
      print "todo: handle non-stdin"
    end

end

return formatter
