local M = {}

local config = require "formatter.config"
local log = require "formatter.log"
local tempfile = require "formatter.tempfile"
local util = require "formatter.util"

function M.format(args, mods, start_line, end_line, opts)
  if M.saving_currently then
    return
  end

  local modifiable = vim.bo.modifiable
  if not modifiable then
    log.info "Buffer is not modifiable"
    return
  end

  log.current_format_mods = mods
  start_line = start_line - 1
  local user_passed_formatters = util.split(args, " ")
  local filetype = vim.bo.filetype
  local formatters = config.formatters_for_filetype(filetype)

  local configs_to_run = {}
  -- No formatters defined for the given file type
  if util.is_empty(formatters) then
    log.info(string.format("No formatter defined for %s files", filetype))
    return
  end
  for _, formatter_config in ipairs(formatters) do
    local formatter
    if type(formatter_config) == "table" then
      formatter = formatter_config
    else
      formatter = formatter_config()
    end
    if
      formatter
      and formatter.exe
      and (
        user_passed_formatters == nil or user_passed_formatters[formatter.exe]
      )
    then
      table.insert(configs_to_run, { config = formatter, name = formatter.exe })
    end
  end

  M.start_task(configs_to_run, start_line, end_line, opts)
end

function M.start_task(configs, start_line, end_line, opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, {
    lock = false,
    write = false,
  })

  local F = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local input = util.get_lines(bufnr, start_line, end_line)
  local inital_changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
  local output = input
  local error_output = nil
  local name
  local ignore_exitcode
  local current_output
  local buf_skip_format = util.get_buffer_variable(bufnr, "formatter_skip_buf")
    or false
  local tempfiles = {}

  if buf_skip_format then
    log.info "Formatting turned off for buffer"
    return
  end

  function F.on_event(transform, job_id, data, event)
    if event == "stdout" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if tempfiles[job_id] ~= nil then
        data = tempfile.read(tempfiles[job_id])
      end
      if not util.is_empty(data) then
        current_output = data
      end
    end

    if event == "stderr" then
      if data[#data] == "" then
        data[#data] = nil
      end
      if not util.is_empty(data) then
        error_output = data
      end
    end

    if event == "exit" then
      if tempfiles[job_id] ~= nil then
        os.remove(tempfiles[job_id])
      end
      -- Data is exit code here
      -- Failed to run, stop the loop
      if not ignore_exitcode and data > 0 then
        if error_output then
          log.error(
            string.format(
              "Failed to run formatter %s",
              name .. ". " .. table.concat(error_output)
            )
          )
        end
      end

      -- Success
      if ignore_exitcode or data == 0 then
        log.info(string.format("Finished running %s", name))
        output = transform and transform(current_output) or current_output
      end
      F.step()
    end
  end

  function F.run(current)
    if inital_changedtick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
      log.info "Buffer changed while formatting, skipping"
      return
    end

    if opts.lock then
      vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    end

    name = current.name
    ignore_exitcode = current.config.ignore_exitcode
    local cmd = { current.config.exe }
    if current.config.args ~= nil then
      for _, arg in ipairs(current.config.args) do
        table.insert(cmd, arg)
      end
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
      local tempfile_name = tempfile.create(bufname, output, current.config)
      log.debug(string.format("Formatting temporary file at %s", tempfile_name))

      if not current.config.no_append then
        table.insert(cmd, util.escape_path(tempfile_name))
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
    if not vim.api.nvim_buf_is_valid(bufnr) then
      log.info "Buffer become invalid while formatting, not applying formatting"
      return
    end

    if inital_changedtick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
      log.warn "Buffer changed while formatting, not applying formatting"
      return
    end

    if opts.lock then
      vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    end

    if not util.is_same(input, output) then
      local window_to_view = util.get_views_for_this_buffer()
      if not output then
        log.error(
          string.format(
            "Formatted code not found. "
              .. "You may need to change the stdin setting of %s.",
            name
          )
        )
        return
      end
      util.set_lines(bufnr, start_line, end_line, output)
      util.restore_view_per_window(window_to_view)

      if opts.write and bufnr == vim.api.nvim_get_current_buf() then
        M.saving_currently = true
        vim.api.nvim_command "update"
        M.saving_currently = false
      end
    else
      log.info(string.format("No change necessary with %s", name))
    end

    local silent = config.values.log_level > vim.log.levels.DEBUG
    util.fire_event("FormatterPost", silent)
  end

  local silent = config.values.log_level > vim.log.levels.DEBUG
  util.fire_event("FormatterPre", silent)
  F.step()
end

return M
