local api = vim.api
local config = require "formatter.config"
local util = require "formatter.util"

local M = {}

function M.format(args, startLine, endLine, write)
  startLine = startLine - 1
  local userPassedFmt = util.split(args, " ")
  local modifiable = vim.bo.modifiable
  local filetype = vim.bo.filetype
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
  local configsToRun = util.getConfigsToRun(userPassedFmt, formatters)
  M.startTask(configsToRun, startLine, endLine, write)
end

function M.startTask(configs, startLine, endLine, write, cb)
  local F = {}
  local bufnr = api.nvim_get_current_buf()
  local bufname = vim.fn.bufname(bufnr)
  local input = util.getLines(bufnr, startLine, endLine)
  local output = input
  local errOutput = nil
  local name
  local currentOutput
  local tempfiles = {}

  function F.on_event(job_id, data, event)
    if event == "stdout" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if tempfiles[job_id] ~= nil then
        data = util.read_temp_file(tempfiles[job_id])
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
        errOutput = data
      end
    end

    if event == "exit" then
      if tempfiles[job_id] ~= nil then
        os.remove(tempfiles[job_id])
      end

      -- Data is exit code here
      -- Failed to run, stop the loop
      if data > 0 then
        if errOutput then
          util.err(string.format("failed to run formatter %s", name))
        end
      end

      -- Success
      if data == 0 then
        util.print(string.format("Finished running %s", name))
        output = currentOutput
        F.step()
      end
    end
  end

  function F.run(current)
    name = current.name
    local exe = current.config.exe
    local args = table.concat(current.config.args or {}, " ")
    local cmd_str = string.format("%s %s", exe, args)
    if current.config.stdin then
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
    else
      local tempfile_name = util.create_temp_file(bufname, output, current.config)
      cmd_str = string.format("%s %s", cmd_str, tempfile_name)
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
      tempfiles[job_id] = tempfile_name
    end
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
    if cb ~= nil then
      cb()
    end
  end

  -- AND start the loop
  util.fireEvent("FormatterPre")
  F.step()
end

return M
