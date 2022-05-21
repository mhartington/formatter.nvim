local M = {}

local util = require "formatter.util"

function M.format(args, mods, startLine, endLine, opts)
  if M.saving then
    return
  end

  local modifiable = vim.bo.modifiable
  if not modifiable then
    util.info "Buffer is not modifiable"
    return
  end

  util.mods = mods
  startLine = startLine - 1
  local userPassedFmt = util.split(args, " ")
  local filetype = vim.bo.filetype
  local formatters = util.formatters_for_filetype(filetype)

  local configsToRun = {}
  -- No formatters defined for the given file type
  if util.is_empty(formatters) then
    util.error(string.format("No formatter defined for %s files", filetype))
    return
  end
  for _, val in ipairs(formatters) do
    local tmp = val()
    if tmp and tmp.exe and (userPassedFmt == nil or userPassedFmt[tmp.exe]) then
      table.insert(configsToRun, { config = tmp, name = tmp.exe })
    end
  end

  M.start_task(configsToRun, startLine, endLine, opts)
end

function M.start_task(configs, startLine, endLine, opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, {
    write = false,
  })

  local F = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local input = util.get_lines(bufnr, startLine, endLine)
  local inital_changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
  local output = input
  local errOutput = nil
  local name
  local ignore_exitcode
  local currentOutput
  local buf_skip_format = util.get_buffer_variable(bufnr, "formatter_skip_buf")
    or false
  local tempfiles = {}

  if buf_skip_format then
    util.info "Formatting turn off for buffer"
    return
  end

  function F.on_event(transform, job_id, data, event)
    if event == "stdout" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if tempfiles[job_id] ~= nil then
        data = util.read_temp_file(tempfiles[job_id])
      end
      if not util.is_empty(data) then
        currentOutput = data
      end
    end

    if event == "stderr" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if not util.is_empty(data) then
        errOutput = data
      end
    end

    if event == "exit" then
      if tempfiles[job_id] ~= nil then
        os.remove(tempfiles[job_id])
      end
      -- Data is exit code here
      -- Failed to run, stop the loop
      if not ignore_exitcode and data > 0 then
        if errOutput then
          util.error(
            string.format(
              "failed to run formatter %s",
              name .. ". " .. table.concat(errOutput)
            )
          )
        end
      end

      -- Success
      if ignore_exitcode or data == 0 then
        util.info(string.format("Finished running %s", name))
        output = transform and transform(currentOutput) or currentOutput
      end
      F.step()
    end
  end

  function F.run(current)
    if inital_changedtick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
      util.debug "Buffer changed while formatting, skipping"
      return
    end

    name = current.name
    ignore_exitcode = current.config.ignore_exitcode
    local cmd = { current.config.exe }
    if current.config.args ~= nil then
      for _, arg in ipairs(current.config.args) do
        table.insert(cmd, arg)
      end
    end

    if current.config.stdin == nil then
      util.print(
        string.format(
          "Stdin option is not set for %s. "
            .. "Please set stdin to either true or false",
          name
        )
      )
      return
    end

    local on_event = function(...)
      F.on_event(current.config.transform, ...)
    end
    local job_options = {
      on_stderr = on_event,
      on_stdout = on_event,
      on_exit = on_event,
      stdout_buffered = true,
      stderr_buffered = true,
      cwd = current.config.cwd or vim.fn.getcwd(),
    }

    if current.config.stdin then
      local job_id = vim.fn.jobstart(table.concat(cmd, " "), job_options)
      vim.fn.chansend(job_id, output)
      vim.fn.chanclose(job_id, "stdin")
    else
      -- TODO: handle null tempfile
      local tempfile_name = util.create_temp_file(
        bufname,
        output,
        current.config
      )
      if not current.config.no_append then
        table.insert(cmd, tempfile_name)
      end
      local job_id = vim.fn.jobstart(table.concat(cmd, " "), job_options)
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
    if inital_changedtick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
      util.print "Buffer changed while formatting, not applying formatting"
      return
    end

    if not util.is_same(input, output) then
      local view = vim.fn.winsaveview()
      if not output then
        util.error(
          string.format(
            "Formatter: Formatted code not found. "
              .. "You may need to change the stdin setting of %s.",
            name
          )
        )
        return
      end
      util.set_lines(bufnr, startLine, endLine, output)
      vim.fn.winrestview(view)

      if opts.write and bufnr == vim.api.nvim_get_current_buf() then
        M.saving = true
        vim.api.nvim_command "update"
        M.saving = false
      end
    else
      util.info(string.format("No change necessary with %s", name))
    end

    util.fire_event "FormatterPost"
  end

  -- AND start the loop

  util.fire_event "FormatterPre"
  F.step()
end

return M
