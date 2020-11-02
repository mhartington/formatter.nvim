local vim = vim
local api = vim.api
local config = require "format.config"
local util = require "format.util"

local M = {}

function M.format(bang, args, startLine, endLine)
  startLine = startLine - 1
  local force = bang == "!"
  local userPassedFmt = util.split(args, " ")
  local filetype = vim.fn.eval("&filetype")
  local formatters = config.values[filetype]

  -- No formatters defined for the given file type
  if util.isEmpty(formatters) then
    util.log(string.format("Format: no formatter defined for %s files", filetype))
    return
  end

  local configsToRun = {}
  for name, config in pairs(formatters) do
    if userPassedFmt == nil or userPassedFmt[name] then
      table.insert(
        configsToRun,
        {
          config = config(),
          name = name
        }
      )
    end
  end

  M.startTask(configsToRun, startLine, endLine, force)
end

function M.startTask(configs, startLine, endLine, force)
  local F = {}
  F.err = ""
  F.bufnr = api.nvim_get_current_buf()
  F.output = util.getLines(F.bufnr, startLine, endLine)

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
      util.log(string.format("Format: finished running %s", F.name))
      F.step()
    end
  end

  function F.run(current)
    F.exe = current.config.exe
    F.args = table.concat(current.config.args, " ")
    F.name = current.name
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
    vim.fn.chansend(job_id, F.output)
    vim.fn.chanclose(job_id, "stdin")
  end

  -- Process through each config
  -- Built in For Loops + vim/libuv
  -- do not play well together
  function F.step()
    if #configs == 0 then
      if not api.nvim_buf_get_option(F.bufnr, "modified") or force then
        local view = vim.fn.winsaveview()
        util.setLines(F.bufnr, startLine, endLine, F.output)
        vim.fn.winrestview(view)
      end
      return
    end
    F.run(table.remove(configs, 1))
  end

  -- ANND start the loop
  F.step()
end

return M
