local config = require "formatter.config"
local loggingEnabled = config.values.logging
local log_level = config.values.log_level
local util = {}
util.mods = nil

local notify_opts = { title = "Formatter" }

-- vim.log = {
--   levels = {
--     TRACE = 0;
--     DEBUG = 1;
--     INFO  = 2;
--     WARN  = 3;
--     ERROR = 4;
--   }
-- }

function util.debug(txt)
  if log_level == vim.log.levels.DEBUG then
    vim.notify(txt, vim.log.levels.DEBUG, notify_opts)
  end
end
function util.info(txt)
  if log_level == vim.log.levels.INFO then
    vim.notify(txt, vim.log.levels.INFO, notify_opts)
  end
end
function util.warn(txt)
  if log_level == vim.log.levels.WARN then
    vim.notify(txt, vim.log.levels.WARN, notify_opts)
  end
end
function util.error(...)
  if log_level == vim.log.levels.WARN then
    vim.notify(
      table.concat(vim.tbl_flatten { ... }),
      vim.log.levels.WARN,
      notify_opts
    )
  end
end

local pathSeparator = (function()
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

-- Print to cmd line, always
function util.print(msg)
  if util.mods ~= "silent" then
    local txt = string.format("Formatter: %s", msg)
    vim.notify(txt, vim.log.levels.INFO, notify_opts)
  end
end

-- Generic logging
function util.log(...)
  if loggingEnabled then
    vim.api.nvim_out_write(table.concat(vim.tbl_flatten { ... }) .. "\n")
  end
end

function util.inspect(val)
  if loggingEnabled then
    print(vim.inspect(val))
  end
end

function util.setLines(bufnr, startLine, endLine, lines)
  return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, false, lines)
end

function util.getLines(bufnr, startLine, endLine)
  return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
end

function util.isEmpty(s)
  if type(s) == "table" then
    for _, v in pairs(s) do
      if not util.isEmpty(v) then
        return false
      end
    end
    return true
  end
  return s == nil or s == ""
end

function util.split(s, sep, plain)
  if s ~= "" then
    local t = {}
    for c in vim.gsplit(s, sep, plain) do
      t[c] = true
    end
    return t
  end
end

function util.to_table(b)
  if type(b) ~= "table" then
    if not b then
      return {}
    end

    return { b }
  end

  return b
end

function util.append(a, b)
  a = util.to_table(a)
  b = util.to_table(b)

  for _, v in ipairs(b) do
    table.insert(a, v)
  end

  return a
end

function util.isSame(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) == "table" then
    if #a ~= #b then
      return false
    end
    for k, v in pairs(a) do
      if not util.isSame(b[k], v) then
        return false
      end
    end
    return true
  else
    return a == b
  end
end

function util.fireEvent(event)
  local cmd = string.format("silent doautocmd <nomodeline> User %s", event)
  vim.api.nvim_command(cmd)
end

function util.getBufVar(buf, var)
  local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
  if status then
    return result
  end
  return nil
end

function util.create_temp_file(bufname, input, opts)
  local split_bufname = vim.split(bufname, pathSeparator)
  local tempfile_prefix = opts.tempfile_prefix or "~formatting"
  local tempfile_postfix = opts.tempfile_postfix or ""
  local filename = ("%s_%d_%s%s"):format(
    tempfile_prefix,
    math.random(1, 1000000),
    split_bufname[#split_bufname],
    tempfile_postfix
  )

  split_bufname[#split_bufname] = nil
  local tempfile_dir = table.concat(split_bufname, pathSeparator)
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

function util.read_temp_file(tempfile_name)
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

function util.get_cwd()
  return vim.fn.getcwd()
end

function util.get_current_buffer_file_path()
  return vim.api.nvim_buf_get_name(0)
end

function util.get_current_buffer_file_name()
  return vim.fn.fnamemodify(util.get_current_buffer_file_path(), ":t")
end

function util.get_current_buffer_file_dir()
  return vim.fn.fnamemodify(util.get_current_buffer_file_path(), ":h")
end

function util.quote_cmd_arg(arg)
  return string.format("'%s'", arg)
end

function util.wrap_sed_replace(pattern, replacement, flags)
  return string.format("s/%s/%s/%s", pattern, replacement or "", flags or "")
end

-- TODO: check fnameescape or shellescape?
function util.escape_path(arg)
  return vim.fn.fnameescape(arg)
end

-- TODO: check that this is okay for paths and ordinary strings
function util.format_prettydiff_arg(name, value)
  return string.format('%s:"%s"', name, value)
end

function util.withl(f, ...)
  local argsl = { ... }
  return function(...)
    local argsr = { ... }
    return f(unpack(argsl), unpack(argsr))
  end
end

function util.withr(f, ...)
  local argsr = { ... }
  return function(...)
    local argsl = { ... }
    return f(unpack(argsl), unpack(argsr))
  end
end

function util.copyf(f)
  return function(...)
    return f(...)
  end
end

return util
