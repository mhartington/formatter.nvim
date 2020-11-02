local vim = vim
local api = vim.api
local config = require "format.config"
local util = require "format.util"

local M = {}

function M.format(bang, args, startLine, endLine, write)
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

  M.startTask(configsToRun, startLine, endLine, force, write)
end

function M.startTask(configs, startLine, endLine, force, write)
  local F = {}
  local bufnr = api.nvim_get_current_buf()
  local input = util.getLines(bufnr, startLine, endLine)
  local output = input
  local name

  local currentOutput
  function F.on_event(_, data, event)
    if event == "stdout" then
      data[#data] = nil
      if not util.isEmpty(data) then
        currentOutput = data
      end
    end
    if event == "stderr" then
      data[#data] = nil
      if not util.isEmpty(data) then
        util.log(string.format("Format: error running %s, %s", name, vim.inspect(data)))
      end
    end
    if event == "exit" then
      if data == 0 then
        util.log(string.format("Format: finished running %s", name))
        output = currentOutput
      end
      F.step()
    end
  end

  function F.run(current)
    name = current.name
    local exe = current.config.exe
    local args = table.concat(current.config.args, " ")
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
      if (not api.nvim_buf_get_option(bufnr, "modified") or force) and not util.isSame(input, output) then
        local view = vim.fn.winsaveview()
        util.setLines(bufnr, startLine, endLine, output)
        vim.fn.winrestview(view)
        if write and bufnr == api.nvim_get_current_buf() then
          vim.api.nvim_command("noautocmd :update")
        end
      end
      vim.api.nvim_command("silent doautocmd <nomodeline> User FormatterPost")
      return
    end
    F.run(table.remove(configs, 1))
  end

  -- ANND start the loop
  vim.api.nvim_command("silent doautocmd <nomodeline> User FormatterPre")
  F.step()
end

return M
