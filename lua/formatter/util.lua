local config = require "formatter.config"
local logging_enabled = config.values.logging
local log_level = config.values.log_level

local M = {}

-----------------------------------------------------------------------------
-- Logging

M.notify_opts = { title = "Formatter" }

function M.debug(txt)
  if log_level == vim.log.levels.DEBUG then
    vim.notify(txt, vim.log.levels.DEBUG, M.notify_opts)
  end
end

function M.info(txt)
  if log_level == vim.log.levels.INFO then
    vim.notify(txt, vim.log.levels.INFO, M.notify_opts)
  end
end

function M.warn(txt)
  if log_level == vim.log.levels.WARN then
    vim.notify(txt, vim.log.levels.WARN, M.notify_opts)
  end
end

function M.error(...)
  if log_level == vim.log.levels.WARN then
    vim.notify(
      table.concat(vim.tbl_flatten { ... }),
      vim.log.levels.WARN,
      M.notify_opts
    )
  end
end

M.mods = nil
function M.print(msg)
  if M.mods ~= "silent" then
    local txt = string.format("Formatter: %s", msg)
    vim.notify(txt, vim.log.levels.INFO, M.notify_opts)
  end
end

function M.log(...)
  if logging_enabled then
    vim.api.nvim_out_write(table.concat(vim.tbl_flatten { ... }) .. "\n")
  end
end

function M.inspect(val)
  if logging_enabled then
    print(vim.inspect(val))
  end
end

-----------------------------------------------------------------------------
-- Tables

function M.is_empty(s)
  if type(s) == "table" then
    for _, v in pairs(s) do
      if not M.is_empty(v) then
        return false
      end
    end
    return true
  end
  return s == nil or s == ""
end

function M.split(s, sep, plain)
  if s ~= "" then
    local t = {}
    for c in vim.gsplit(s, sep, plain) do
      t[c] = true
    end
    return t
  end
end

function M.to_table(b)
  if type(b) ~= "table" then
    if not b then
      return {}
    end

    return { b }
  end

  return b
end

function M.append(a, b)
  a = M.to_table(a)
  b = M.to_table(b)

  for _, v in ipairs(b) do
    table.insert(a, v)
  end

  return a
end

function M.is_same(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) == "table" then
    if #a ~= #b then
      return false
    end
    for k, v in pairs(a) do
      if not M.is_same(b[k], v) then
        return false
      end
    end
    return true
  else
    return a == b
  end
end

-----------------------------------------------------------------------------
-- Functions

function M.withl(f, ...)
  local argsl = { ... }
  return function(...)
    local argsr = { ... }
    return f(unpack(argsl), unpack(argsr))
  end
end

function M.withr(f, ...)
  local argsr = { ... }
  return function(...)
    local argsl = { ... }
    return f(unpack(argsl), unpack(argsr))
  end
end

function M.copyf(f)
  return function(...)
    return f(...)
  end
end

-----------------------------------------------------------------------------
-- Vim

function M.set_lines(bufnr, startLine, endLine, lines)
  return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, false, lines)
end

function M.get_lines(bufnr, startLine, endLine)
  return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
end

function M.fire_event(event)
  local cmd = string.format("silent doautocmd <nomodeline> User %s", event)
  vim.api.nvim_command(cmd)
end

function M.get_buffer_variable(buf, var)
  local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
  if status then
    return result
  end
  return nil
end

-----------------------------------------------------------------------------
-- Formatter configurations

function M.get_cwd()
  return vim.fn.getcwd()
end

function M.get_current_buffer_file_path()
  return vim.api.nvim_buf_get_name(0)
end

function M.get_current_buffer_file_name()
  return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":t")
end

function M.get_current_buffer_file_dir()
  return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":h")
end

function M.quote_cmd_arg(arg)
  return string.format("'%s'", arg)
end

function M.wrap_sed_replace(pattern, replacement, flags)
  return string.format("s/%s/%s/%s", pattern, replacement or "", flags or "")
end

-- TODO: check fnameescape or shellescape?
function M.escape_path(arg)
  return vim.fn.fnameescape(arg)
end

-- TODO: check that this is okay for paths and ordinary strings
function M.format_prettydiff_arg(name, value)
  return string.format('%s:"%s"', name, value)
end

-----------------------------------------------------------------------------
-- Temporary files

M.path_separator = (function()
  local jit = require "jit"
  if jit then
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

function M.create_temp_file(bufname, input, opts)
  local split_bufname = vim.split(bufname, M.path_separator)
  local tempfile_prefix = opts.tempfile_prefix or "~formatting"
  local tempfile_postfix = opts.tempfile_postfix or ""
  local filename = ("%s_%d_%s%s"):format(
    tempfile_prefix,
    math.random(1, 1000000),
    split_bufname[#split_bufname],
    tempfile_postfix
  )

  split_bufname[#split_bufname] = nil
  local tempfile_dir = table.concat(split_bufname, M.path_separator)
  if tempfile_dir == "" then
    tempfile_dir = "."
  end
  local tempfile_name = ("%s/%s"):format(
    (opts.tempfile_dir or tempfile_dir),
    filename
  )

  local tempfile = io.open(tempfile_name, "w+")
  if not tempfile then
    return nil
  end

  for _, line in pairs(input) do
    tempfile:write(line .. "\n")
  end
  tempfile:flush()
  tempfile:close()

  return tempfile_name
end

function M.read_temp_file(tempfile_name)
  local tempfile = io.open(tempfile_name, "r")
  if tempfile == nil then
    return
  end
  local lines = {}
  for line in tempfile:lines() do
    lines[#lines + 1] = line
  end
  tempfile:close()

  return lines
end

return M
