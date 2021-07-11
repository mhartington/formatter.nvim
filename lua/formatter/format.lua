local api = vim.api
local config = require "formatter.config"
local util = require "formatter.util"

local M = {}

function M.format(args, mods, startLine, endLine, write)
  util.mods = mods
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
  local configsToRun = {}
  for _, val in ipairs(formatters) do
    local tmp = val()
    if userPassedFmt == nil or userPassedFmt[tmp.exe] then
      table.insert(configsToRun, {config = tmp, name = tmp.exe})
    end
  end
  M.startTask(configsToRun, startLine, endLine, write)
end

function M.startTask(configs, startLine, endLine, format_then_write)
  local F = {}
  local bufnr = api.nvim_get_current_buf()
  local bufname = vim.fn.bufname(bufnr)
  local input = util.getLines(bufnr, startLine, endLine)
  local output = input
  local errOutput = nil
  local name
  local currentOutput
  local buf_skip_format = util.getBufVar(bufnr, "formatter_skip_buf") or false
  local tempfiles = {}
  if buf_skip_format then
    util.print("Formatting turn off for buffer")
    return
  end
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
          util.err(string.format("failed to run formatter %s", name .. ". " .. table.concat(errOutput)))
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
    local cmd = {current.config.exe}
    if current.config.args ~= nil then
      for _, arg in ipairs(current.config.args) do
        table.insert(cmd, arg)
      end
    end

    if current.config.stdin == nil then
      util.print(string.format("Stdin option is not set for %s. Please set stdin to either true or false", name))
      return
    end

    local cwd = nil
    if current.config.cwd ~= nil then
      cwd = current.config.cwd()
    end

    local job_options = {
        on_stderr = F.on_event,
        on_stdout = F.on_event,
        on_exit = F.on_event,
        stdout_buffered = true,
        stderr_buffered = true,
        cwd = cwd
    }
    if current.config.stdin then
      local job_id =
        vim.fn.jobstart(
        table.concat(cmd, " "),
        job_options
      )
      vim.fn.chansend(job_id, output)
      vim.fn.chanclose(job_id, "stdin")
    else
      local tempfile_name = util.create_temp_file(bufname, output, current.config)
      table.insert(cmd, tempfile_name)
      local job_id =
        vim.fn.jobstart(
        table.concat(cmd, " "),
        job_options
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
      -- print('check values here', bufnr, startLine, endLine, output)
      if not output then
        util.err(
          string.format("Formatter: Formatted code not found. You may need to change the stdin setting of %s.", name)
        )
        return
      end
      util.setLines(bufnr, startLine, endLine, output)
      vim.fn.winrestview(view)

      if format_then_write and bufnr == api.nvim_get_current_buf() then
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
