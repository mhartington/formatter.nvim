local vim = vim
local api = vim.api
local config = require "formatter.config"
local util = require "formatter.util"

local M = {}

function M.format(args, startLine, endLine, write)
  startLine = startLine - 1
  local userPassedFmt = util.split(args, " ")
  local modifiable = vim.fn.eval("&modifiable")
  local filetype = vim.fn.eval("&filetype")
  local formatters = config.values.filetype[filetype]

  if not modifiable then
    util.print("Buffer is not modifiable")
    return
  end

  -- No formatters defined for the given file type
  if util.isEmpty(formatters) then
    util.print(string.format("No formatter defined for %s files", filetype))
    return
  end
  local configsToRun = {}
  for _, val in ipairs(formatters) do
    local tmp = val()
    if userPassedFmt == nil or userPassedFmt[tmp.exe] then
      table.insert(configsToRun, {config = tmp, name = tmp.exe})
    end
  end
  M.startTask(configsToRun, startLine, endLine, write)
end

function M.startTask(configs, startLine, endLine, write)
  local F = {}
  local bufnr = api.nvim_get_current_buf()
  local input = util.getLines(bufnr, startLine, endLine)
  local output = input

  local name
  local currentOutput

  function F.on_event(_, data, event)
    if event == "stdout" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if not util.isEmpty(data) then
        currentOutput = data
      end
    end
    if event == "stderr" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if not util.isEmpty(data) then
        util.err(string.format("Error running %s", name))
      end
    end
    if event == "exit" then
      if data == 0 then
        util.print(string.format("Finished running %s", name))
        output = currentOutput
      end
      F.step()
    end
  end

  function F.run(current)
    name = current.name
    local exe = current.config.exe
    local args = table.concat(current.config.args or {}, " ")
    local cmd_str = string.format("%s %s", exe, args)
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
    vim.fn.chansend(job_id, output)
    vim.fn.chanclose(job_id, "stdin")
  end

  -- Process through each config
  -- Built in For Loops + vim/libuv
  -- do not play well together
  function F.step()
    if #configs == 0 then
      F.done()
      return
    end
    F.run(table.remove(configs, 1))
  end

  function F.done()
    if not util.isSame(input, output) then
      local view = vim.fn.winsaveview()

      util.setLines(bufnr, startLine, endLine, output)
      vim.fn.winrestview(view)

      if write and bufnr == api.nvim_get_current_buf() then
        vim.api.nvim_command("noautocmd :update")
      end
    else
      util.print(string.format("No change necessary with %s", name))
    end
    util.fireEvent("FormatterPost")
    return
  end

  -- AND start the loop
  util.fireEvent("FormatterPre")
  F.step()
end

return M
