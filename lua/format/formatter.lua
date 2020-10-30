local vim = vim
local api = vim.api
local config = require "format.config"
local util = require "format.util"

local M = {}

function M.getRange(startLine, endLine)
  local starting
  local ending
  if startLine ~= nil then
    starting = startLine - 1
  else
    starting = 0
  end
  ending = endLine or -1
  return starting, ending
end

function M.format(args, startLine, endLine)
  local starting, ending = M.getRange(startLine, endLine)
  local userPassedFmtr = util.split(args, " ")
  local view = vim.fn.winsaveview()
  M.internalFormatter(userPassedFmtr, starting, ending)
  vim.fn.winrestview(view)
end

function M.internalFormatter(userPassedFmt, startLine, endLine)
  local filetype = vim.fn.eval "&filetype"
  local formatters = config.values[filetype]

  -- No formatters defined for the given file type
  if util.isEmpty(formatters) then
    print(string.format("Format: no formatter defined for %s files", filetype))
    return
  end

  local fmtsToRun = {}

  if userPassedFmt == nil then
    fmtsToRun = formatters
  else
    for name, conf in pairs(formatters) do
      if userPassedFmt[name] then
        fmtsToRun[name] = conf
      end
    end
  end

  local confTmp = {}
  for _, conf in pairs(fmtsToRun) do
    table.insert(confTmp, conf)
  end
  M.startTask(confTmp, startLine, endLine)
end

function M.startTask(confs, startLine, endLine)

  local F = {}

  F.output = ""
  F.err = ""

  function F.on_event(_, data, event)
    if event == "stdout" then
      if data then
        F.output = data
      end
    end
    if event == "stderr" then
      if data then
        F.err = data
      end
    end
    if event == "exit" then
      util.setLines(F.bufnr, startLine, endLine, F.output)
      util.log(string.format("Format: finished running %s", F.exe))
      F.step()
    end
  end

  function F.run(conf)
    local o = conf()
    F.exe = o.exe
    F.args = table.concat(o.args, " ")
    F.bufnr = api.nvim_get_current_buf()
    F.lines = util.getLines(F.bufnr, startLine, endLine)
    local cmd_str = string.format("%s %s", F.exe, F.args)
    local job_id =
      vim.fn.jobstart(
      cmd_str,
      {
        on_stderr = F.on_event,
        on_stdout = F.on_event,
        on_exit = F.on_event,
        stdout_buffered = true,
        stderr_buffered = true
      }
    )
    vim.fn.chansend(job_id, F.lines)
    vim.fn.chanclose(job_id, "stdin")
  end

  -- Process through each config
  -- Built in For Loops + vim/libuv
  -- do not play well together
  function F.step()
    if #confs == 0 then
      return
    end
    local current = table.remove(confs, 1)
    F.run(current)
  end

  -- ANND start the loop
  F.step()

end

return M

