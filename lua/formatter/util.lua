local config = require("formatter.config")
local loggingEnabled = config.values.logging

local util = {}

-- Print to cmd line, always
function util.print(msg)
  local txt = string.format("Formatter: %s", msg)
  vim.api.nvim_out_write(txt .. "\n")
end

-- Always print error message to cmd line
function util.err(msg)
  local txt = string.format("Formatter: %s", msg)
  vim.api.nvim_err_writeln(txt)
end

-- Generic logging
function util.log(...)
  if loggingEnabled then
    vim.api.nvim_out_write(table.concat(vim.tbl_flatten {...}) .. "\n")
  end
end

function util.inspect(val)
  if loggingEnabled then
    print(vim.inspect(val))
  end
end

function util.error(...)
  if loggingEnabled then
    print(table.concat(...))
    vim.api.nvim_error_write(table.concat(vim.tbl_flatten {...}) .. "\n")
  end
end

function util.setLines(bufnr, startLine, endLine, lines)
  return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, true, lines)
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
return util
